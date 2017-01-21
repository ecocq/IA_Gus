----------------------------------
-- Fuzzy logic module
----------------------------------

FuzzyLogic = {
	membershipFunctions = {},
	decisionRules = {},
	npc = nil,
}

function FuzzyLogic:new (o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

----------------------------------
-- Méthode de calcul
-- Centre de gravité (COG)
----------------------------------
local function COG_1(func, maxValue)
	local a, delta = 0, 1e-4
	for x = 0, 1, delta do
		y = func(x)
		if y > maxValue then y = maxValue end
		a = a + y*x*delta
	end
	return a
end
local function COG_2(func, maxValue)
	local a, delta = 0, 1e-4
	for x = 0, 1, delta do
		y = func(x)
		if y > maxValue then y = maxValue end
		a = a + y*delta
	end
	return a
end

----------------------------------
-- Méthode de calcul
-- Moyenne des maxima (MM)
----------------------------------
local function MM(func, maxy)
	local a, c, delta = 0, 0, 0.001
	for x = 0, 1, delta do
		y = func(x)
		if y >= maxy then
			a = a + x
			c = c + 1
		end
	end
	return a,c
end

-- On appelle cette fonction à chaque fois que vous voulez mettre à jour
-- une valeur soumise à un système flou
-- In : méthode de defuzzification ("COG" [défaut] ou "MM"), liste pour normaliser contenant OriginMin, OriginMax, TargetMin, TargetMax
-- Les deux paramètres d'entrée sont optionnels. S'il n'y a pas de liste pour la normalisation, la sortie sera comprise entre 0 et 1.
-- Out : une valeur calculée en fonction du système flou, et défuzzifiée
function FuzzyLogic:makeDecision(defuzzificationMethod, normValues)

	-- Par défaut, on défuzzifie par la méthode du centre de gravité (COG)
	if not defuzzificationMethod then defuzzificationMethod = "COG" end
	
	local decision
	local a, b = 0, 0
	local scores = {list = {},maxscore = 0,}
	
	for _, rule in pairs(self.decisionRules) do
		-- On calcule et stocke le degré de validité de chaque règle
		rule.score = rule.func(self)
		if defuzzificationMethod == "COG" then
			-- On calcule le COG en deux passes
			a = a + COG_1(self.membershipFunctions.output[rule.targetSubset], rule.score)
			b = b + COG_2(self.membershipFunctions.output[rule.targetSubset], rule.score)
		elseif defuzzificationMethod == "MM" then
			-- On stocke les scores et le target associé
			table.insert(scores.list, {rule.score, rule.targetSubset})
			-- On détermine par la même occasion la valeur max
			if rule.score > scores.maxscore then
				scores.maxscore = rule.score
			end
		end
	end
	
	if defuzzificationMethod == "MM" then
		for _, v in ipairs(scores.list) do
		-- Cette itération est nécessaire: il peut être imaginable que plusieurs sous-ensembles aient renvoyé le même score max
			local score, target = v[1], v[2]
			if score == scores.maxscore then
				local i, j = MM(self.membershipFunctions.output[target], score)
				a = a + i
				b = b + j
			end
		end
	end
	
	-- Calcul final de la décision. Attention, selon la méthode
	-- de défuzzification, a et b ne contiennent pas du tout le
	-- même genre d'information !
	if b == 0 then	-- la valeur ne correspond à aucun set
		decision = 0
	else
		decision = a/b
	end
	
	-- Si des informations pour la normalisation ont été transmises,
	-- alors on change d'intervalle (Rappel: jusqu'ici
	-- la decision est une valeur entre 0 et 1)
	if normValues then
		decision = round(norm(decision, unpack(normValues)),1)
	end
	
	return decision
end

FL_patienceUpdate = FuzzyLogic:new{
	membershipFunctions = {
		input = {
			-- Définition des fonctions d'appartenance de chaque sous-ensemble de l'ensemble vigor (input)
			[GUS_VIGOR_LABEL] = {
				["faible"] = function(x) return keepBetweenMinMax(1-math.tanh((x/GUS_VIGOR_MAX-0.45)/0.1)-1, 0, 1) end,
				["moyen"] = function(x) return keepBetweenMinMax(math.sin(x/GUS_VIGOR_MAX*math.pi), 0, 1) end,
				["fort"] = function(x) return keepBetweenMinMax(math.tanh((x/GUS_VIGOR_MAX-0.55)/0.1), 0, 1) end,
			},
			-- Définition des fonctions d'appartenance de chaque sous-ensemble de l'ensemble sociability (input)
			[GUS_SOCIABILITY_LABEL] = {
				["asocial"] = function(x) return keepBetweenMinMax(1-math.tanh((x/GUS_SOCIABILITY_MAX-0.45)/0.1)-1, 0, 1) end,
				["social"] = function(x) return keepBetweenMinMax(math.tanh((x/GUS_SOCIABILITY_MAX-0.55)/0.1), 0, 1) end,
			},
		},
		output = {
			-- Définition des fonctions d'appartenance de chaque sous-ensemble de l'ensemble waiting_time (output)
			["court"] = function (x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
			["moyen"] = function (x) return keepBetweenMinMax((-(( (6*x) - 3) ^2) + 1), 0, 1) end,
			["long"] = function (x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
		},
	},
	decisionRules = {
		[1] = {
			["tooltip"] = "Si Gus est faible...	ou s’il est asocial... alors il attendra très peu de temps.",
			-- La fonction permettant de calculer le degré de validité de la prémisse :
			["func"] = function(self)
							-- Degré de validité de la première proposition de la prémisse :
							local degreeA = self.membershipFunctions.input[GUS_VIGOR_LABEL]["faible"](Gus.vigor)
							-- Degré de validité de la seconde proposition de la prémisse :
							local degreeB = self.membershipFunctions.input[GUS_SOCIABILITY_LABEL]["asocial"](Gus.sociability)
							-- PROBOR (l'opérateur "ou" flou) μA∪B(x): μA(x)+μB(x)−μA(x)×μB(x)
							-- où μA est la fonction d'appartenance au sous-ensemble A, et μB la fonction d'appartenance au sous-ensemble B
							return degreeA + degreeB - degreeA * degreeB
						end,
			-- Le sous-ensemble de l'ensemble output qui est visé par cette règle :
			["targetSubset"] = "court",
			-- Le score sera calculé à chaque fois que l'on doit prendre une décision
			["score"] = nil,
		},
		[2] = {
			["tooltip"] = "Si Gus est en moyenne forme... alors il attendra moyennement longtemps.",
			-- La fonction permettant de calculer le degré de validité de la prémisse :
			["func"] = function(self)
							-- Degré de validité de la prémisse (qui ne comporte qu'une proposition) :
							local degree = self.membershipFunctions.input[GUS_VIGOR_LABEL]["moyen"](Gus.vigor)
							-- Pas d'opérateur flou ici, il n'y a qu'une seule proposition :
							return degree
						end,
			-- Le sous-ensemble de l'ensemble output qui est visé par cette règle :
			["targetSubset"] = "moyen",
			-- Le score sera calculé à chaque fois que l'on doit prendre une décision
			["score"] = nil,
		},
		[3] = {
			["tooltip"] = "Si Gus est vigoureux...	et s’il est sociable... alors il attendra longtemps.",
			-- La fonction permettant de calculer le degré de validité de la prémisse :
			["func"] = function(self)
							-- Degré de validité de la première proposition de la prémisse :
							local degreeA = self.membershipFunctions.input[GUS_VIGOR_LABEL]["fort"](Gus.vigor)
							-- Degré de validité de la seconde proposition de la prémisse :
							local degreeB = self.membershipFunctions.input[GUS_SOCIABILITY_LABEL]["social"](Gus.sociability)
							-- PROD (l'opérateur "et" flou) μA∩B(x) : μA(x)×μB(x)
							-- où μA est la fonction d'appartenance au sous-ensemble A, et μB la fonction d'appartenance au sous-ensemble B
							return degreeA * degreeB
						end,
			-- Le sous-ensemble de l'ensemble output qui est visé par cette règle :
			["targetSubset"] = "long",
			-- Le score sera calculé à chaque fois que l'on doit prendre une décision
			["score"] = nil,
		},
	}
}


-- Ajouts 
FL_animGus= FuzzyLogic:new{
	membershipFunctions = {
		input = {
	
			[GUS_VIGOR_LABEL] = {
				["faible"] = function(x) return keepBetweenMinMax(1-math.tanh((x/GUS_VIGOR_MAX-0.45)/0.1)-1, 0, 1) end,
				["moyen"] = function(x) return keepBetweenMinMax(math.sin(x/GUS_VIGOR_MAX*math.pi), 0, 1) end,
				["fort"] = function(x) return keepBetweenMinMax(math.tanh((x/GUS_VIGOR_MAX-0.55)/0.1), 0, 1) end,
			},
		
			[GUS_PATIENCE_LABEL] = {
				["impatient"] = function(x) return keepBetweenMinMax(1-math.tanh((x/GUS_SOCIABILITY_MAX-0.45)/0.1)-1, 0, 1) end,
				["patient"] = function(x) return keepBetweenMinMax(math.tanh((x/GUS_SOCIABILITY_MAX-0.55)/0.1), 0, 1) end,
			},
		},
		output = {
			["long"] = function (x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
			["moyen"] = function (x) return keepBetweenMinMax((-(( (6*x) - 3) ^2) + 1), 0, 1) end,
			["court"] = function (x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
		},
	},
	decisionRules = { -- TODO à modifier
		[1] = {
			["tooltip"] = "Si Gus a une vigueur élevée...	et s’il est impatient... alors l'intervalle sera très court",
			["func"] = function(self)
							local degreeA = self.membershipFunctions.input[GUS_VIGOR_LABEL]["fort"](Gus.vigor)
							local degreeB = self.membershipFunctions.input[GUS_PATIENCE_LABEL]["impatient"](Gus.patience)
							return degreeA * degreeB
						end,
			["targetSubset"] = "court",
			["score"] = nil,
		},
		[2] = {
			["tooltip"] = "Si Gus a une vigueur élevée... alors l'intervalle sera moyen",
			["func"] = function(self)
							local degree = self.membershipFunctions.input[GUS_VIGOR_LABEL]["moyen"](Gus.vigor)
							return degree
						end,
			["targetSubset"] = "moyen",
			["score"] = nil,
		},
		[3] = {
			["tooltip"] = "Si Gus est vigoureux...	ou s'il est patient ... alors l'intervalle de temps sera long.",
			["func"] = function(self)
							local degreeA = self.membershipFunctions.input[GUS_VIGOR_LABEL]["faible"](Gus.vigor)
							local degreeB = self.membershipFunctions.input[GUS_PATIENCE_LABEL]["patient"](Gus.patience)
							return degreeA + degreeB - degreeA * degreeB
						end,
			["targetSubset"] = "long",
			["score"] = nil,
		},
	}
}

-- Logics des NPC's
FL_animNpc1 = FuzzyLogic:new{
		membershipFunctions = {
			input = {
				["profile"] = {
					["patient"] = function(x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
					["moyen"] = function(x) return keepBetweenMinMax(math.sin(x*math.pi), 0, 1) end,
					["impatient"] = function(x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
				},
			
				["completion"] = {
					["incomplete"] = function(x) return keepBetweenMinMax(1-x, 0, 1) end,
					["complete"] = function(x) return keepBetweenMinMax(x, 0, 1) end,
				},
			},
			output = {
				["calme"] = function (x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
				["moyen"] = function (x) return keepBetweenMinMax((-(( (6*x) - 3) ^2) + 1), 0, 1) end,
				["enerve"] = function (x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
			},
		},
		decisionRules = { -- TODO à modifier
			[1] = {
				["tooltip"] = "Si le NPC est impatient ... et ses quêtes sont incompletes .. alors l'intervalle sera très court",
				["func"] = function(self)
								local degreeA = self.membershipFunctions.input["profile"]["impatient"](NPC1:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["incomplete"](NPC1:getCompletion())
								return degreeA * degreeB
							end,
				["targetSubset"] = "enerve",
				["score"] = nil,
			},
			[2] = {
				["tooltip"] = "Si le NPC est moyennement patient... alors l'intervalle sera moyen",
				["func"] = function(self)
								local degree = self.membershipFunctions.input["profile"]["moyen"](NPC1:getPatience())
								return degree
							end,
		
				["targetSubset"] = "moyen",

				["score"] = nil,
			},
			[3] = {
				["tooltip"] = "Si le NPC est patient.. ou que toutes ses quêtes sont complètes.. alors l'intervalle de temps sera long.",
				["func"] = function(self)
							
								local degreeA = self.membershipFunctions.input["profile"]["patient"](NPC1:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["complete"](NPC1:getCompletion())
								return degreeA + degreeB - degreeA * degreeB
							end,
				["targetSubset"] = "calme",
				["score"] = nil,
			},	
		}
	}
 
  FL_animNpc2 = FuzzyLogic:new{
		membershipFunctions = {
			input = {
				["profile"] = {
					["patient"] = function(x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
					["moyen"] = function(x) return keepBetweenMinMax(math.sin(x*math.pi), 0, 1) end,
					["impatient"] = function(x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
				},
			
				["completion"] = {
					["incomplete"] = function(x) return keepBetweenMinMax(1-x, 0, 1) end,
					["complete"] = function(x) return keepBetweenMinMax(x, 0, 1) end,
				},
			},
			output = {
				["calme"] = function (x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
				["moyen"] = function (x) return keepBetweenMinMax((-(( (6*x) - 3) ^2) + 1), 0, 1) end,
				["enerve"] = function (x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
			},
		},
		decisionRules = { -- TODO à modifier
			[1] = {
				["tooltip"] = "Si le NPC est impatient ... et ses quêtes sont incompletes .. alors l'intervalle sera très court",
				["func"] = function(self)
								local degreeA = self.membershipFunctions.input["profile"]["impatient"](NPC2:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["incomplete"](NPC2:getCompletion())
								return degreeA * degreeB
							end,
				["targetSubset"] = "enerve",
				["score"] = nil,
			},
			[2] = {
				["tooltip"] = "Si le NPC est moyennement patient... alors l'intervalle sera moyen",
				["func"] = function(self)
								local degree = self.membershipFunctions.input["profile"]["moyen"](NPC2:getPatience())
								return degree
							end,
		
				["targetSubset"] = "moyen",

				["score"] = nil,
			},
			[3] = {
				["tooltip"] = "Si le NPC est patient.. ou que toutes ses quêtes sont complètes.. alors l'intervalle de temps sera long.",
				["func"] = function(self)
							
								local degreeA = self.membershipFunctions.input["profile"]["patient"](NPC2:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["complete"](NPC2:getCompletion())
								return degreeA + degreeB - degreeA * degreeB
							end,
				["targetSubset"] = "calme",
				["score"] = nil,
			},	
		}
	}
 
 FL_animNpc3 = FuzzyLogic:new{
		membershipFunctions = {
			input = {
				["profile"] = {
					["patient"] = function(x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
					["moyen"] = function(x) return keepBetweenMinMax(math.sin(x*math.pi), 0, 1) end,
					["impatient"] = function(x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
				},
			
				["completion"] = {
					["incomplete"] = function(x) return keepBetweenMinMax(1-x, 0, 1) end,
					["complete"] = function(x) return keepBetweenMinMax(x, 0, 1) end,
				},
			},
			output = {
				["calme"] = function (x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
				["moyen"] = function (x) return keepBetweenMinMax((-(( (6*x) - 3) ^2) + 1), 0, 1) end,
				["enerve"] = function (x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
			},
		},
		decisionRules = { -- TODO à modifier
			[1] = {
				["tooltip"] = "Si le NPC est impatient ... et ses quêtes sont incompletes .. alors l'intervalle sera très court",
				["func"] = function(self)
								local degreeA = self.membershipFunctions.input["profile"]["impatient"](NPC3:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["incomplete"](NPC3:getCompletion())
								return degreeA * degreeB
							end,
				["targetSubset"] = "enerve",
				["score"] = nil,
			},
			[2] = {
				["tooltip"] = "Si le NPC est moyennement patient... alors l'intervalle sera moyen",
				["func"] = function(self)
								local degree = self.membershipFunctions.input["profile"]["moyen"](NPC3:getPatience())
								return degree
							end,
		
				["targetSubset"] = "moyen",

				["score"] = nil,
			},
			[3] = {
				["tooltip"] = "Si le NPC est patient.. ou que toutes ses quêtes sont complètes.. alors l'intervalle de temps sera long.",
				["func"] = function(self)
							
								local degreeA = self.membershipFunctions.input["profile"]["patient"](NPC3:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["complete"](NPC3:getCompletion())
								return degreeA + degreeB - degreeA * degreeB
							end,
				["targetSubset"] = "calme",
				["score"] = nil,
			},	
		}
	}
	
 FL_animNpc4 = FuzzyLogic:new{
		membershipFunctions = {
			input = {
				["profile"] = {
					["patient"] = function(x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
					["moyen"] = function(x) return keepBetweenMinMax(math.sin(x*math.pi), 0, 1) end,
					["impatient"] = function(x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
				},
			
				["completion"] = {
					["incomplete"] = function(x) return keepBetweenMinMax(1-x, 0, 1) end,
					["complete"] = function(x) return keepBetweenMinMax(x, 0, 1) end,
				},
			},
			output = {
				["calme"] = function (x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
				["moyen"] = function (x) return keepBetweenMinMax((-(( (6*x) - 3) ^2) + 1), 0, 1) end,
				["enerve"] = function (x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
			},
		},
		decisionRules = { -- TODO à modifier
			[1] = {
				["tooltip"] = "Si le NPC est impatient ... et ses quêtes sont incompletes .. alors l'intervalle sera très court",
				["func"] = function(self)
								local degreeA = self.membershipFunctions.input["profile"]["impatient"](NPC4:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["incomplete"](NPC4:getCompletion())
								return degreeA * degreeB
							end,
				["targetSubset"] = "enerve",
				["score"] = nil,
			},
			[2] = {
				["tooltip"] = "Si le NPC est moyennement patient... alors l'intervalle sera moyen",
				["func"] = function(self)
								local degree = self.membershipFunctions.input["profile"]["moyen"](NPC4:getPatience())
								return degree
							end,
		
				["targetSubset"] = "moyen",

				["score"] = nil,
			},
			[3] = {
				["tooltip"] = "Si le NPC est patient.. ou que toutes ses quêtes sont complètes.. alors l'intervalle de temps sera long.",
				["func"] = function(self)
							
								local degreeA = self.membershipFunctions.input["profile"]["patient"](NPC4:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["complete"](NPC4:getCompletion())
								return degreeA + degreeB - degreeA * degreeB
							end,
				["targetSubset"] = "calme",
				["score"] = nil,
			},	
		}
	}

 FL_animNpc5 = FuzzyLogic:new{
		membershipFunctions = {
			input = {
				["profile"] = {
					["patient"] = function(x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
					["moyen"] = function(x) return keepBetweenMinMax(math.sin(x*math.pi), 0, 1) end,
					["impatient"] = function(x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
				},
			
				["completion"] = {
					["incomplete"] = function(x) return keepBetweenMinMax(1-x, 0, 1) end,
					["complete"] = function(x) return keepBetweenMinMax(x, 0, 1) end,
				},
			},
			output = {
				["calme"] = function (x) return keepBetweenMinMax(1-math.tanh((x-0.45)/0.1)-1, 0, 1) end,
				["moyen"] = function (x) return keepBetweenMinMax((-(( (6*x) - 3) ^2) + 1), 0, 1) end,
				["enerve"] = function (x) return keepBetweenMinMax(math.tanh((x-0.55)/0.1), 0, 1) end,
			},
		},
		decisionRules = { -- TODO à modifier
			[1] = {
				["tooltip"] = "Si le NPC est impatient ... et ses quêtes sont incompletes .. alors l'intervalle sera très court",
				["func"] = function(self)
								local degreeA = self.membershipFunctions.input["profile"]["impatient"](NPC5:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["incomplete"](NPC5:getCompletion())
								return degreeA * degreeB
							end,
				["targetSubset"] = "enerve",
				["score"] = nil,
			},
			[2] = {
				["tooltip"] = "Si le NPC est moyennement patient... alors l'intervalle sera moyen",
				["func"] = function(self)
								local degree = self.membershipFunctions.input["profile"]["moyen"](NPC5:getPatience())
								return degree
							end,
		
				["targetSubset"] = "moyen",

				["score"] = nil,
			},
			[3] = {
				["tooltip"] = "Si le NPC est patient.. ou que toutes ses quêtes sont complètes.. alors l'intervalle de temps sera long.",
				["func"] = function(self)
							
								local degreeA = self.membershipFunctions.input["profile"]["patient"](NPC5:getPatience())
								local degreeB = self.membershipFunctions.input["completion"]["complete"](NPC5:getCompletion())
								return degreeA + degreeB - degreeA * degreeB
							end,
				["targetSubset"] = "calme",
				["score"] = nil,
			},	
		}
	}

FL_animNPC_group = {FL_animNpc1, FL_animNpc2, FL_animNpc3, FL_animNpc4, FL_animNpc5}
	
--=======================================
-- Décommentez toutes les lignes ci-après pour faire vos tests directement au chargement de la simulation
-- N'oubliez pas de commenter/supprimer ces lignes après vos tests!
--=======================================
-- Gus.vigor = 50
-- Gus.sociability = 0
-- local norm = {0, 1, GUS_PATIENCE_TIMER_MIN, GUS_PATIENCE_TIMER_MAX}

-- Gus.patienceTimer.waitingTime = FL_patienceUpdate:makeDecision(_, _)	-- valeur entre 0 et 1
-- print ("Decision COG ([0-1]) : ", Gus.patienceTimer.waitingTime)
-- Gus.patienceTimer.waitingTime = FL_patienceUpdate:makeDecision(_, norm)	-- valeur entre timer_min et timer_max
-- print ("Decision COG (secondes) : ", Gus.patienceTimer.waitingTime)
-- Gus.patienceTimer.waitingTime = FL_patienceUpdate:makeDecision("MM", _)	-- valeur entre 0 et 1
-- print ("Decision MM ([0-1]) : ", Gus.patienceTimer.waitingTime)
-- Gus.patienceTimer.waitingTime = FL_patienceUpdate:makeDecision("MM", norm)	-- valeur entre timer_min et timer_max
-- print ("Decision MM (secondes) : ", Gus.patienceTimer.waitingTime)

