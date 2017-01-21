----------------------------------
-- GUS
-- That's the main character.
----------------------------------

Gus = {
	imgfile = "assets/img/Gus1.png",
	img1 = "assets/img/Gus1.png";
	img2 = "assets/img/Gus2.png";
	x = GUS_INITIAL_POSITION_X,	-- Gus' position on x-axis (initial position. Will be updated in the course of the game)
	y = GUS_INITIAL_POSITION_Y,	-- Gus' position on y-axis.
	step_size = GUS_STEP_SIZE_MAX,	-- Gus' step size. By default, max size. Will be updated.
	moveRandomly = false,	-- Is Gus moving randomly?
	vigor = GUS_VIGOR_MAX,	-- Initial value of Gus' vigor (by default, it's max)
	sociability = 50, --GUS_SOCIABILITY_MAX,		-- Initial value of Gus' sociability
	patience = GUS_PATIENCE_MAX,
	dead = false,
	movement = {		-- Will store all the methods/variables dedicated to movement.
		currentDirection = nil,
		nearWall = false,
	},
	memory = {		-- All the relevant information retrieved by Gus
		npcs = {},
		environment = {
			step_taken = 0,
			wall_hit = 0,
		},
		inventory = {},
		indices = {}
	},
	interaction = {			-- Everything related to interactions that Gus can start with NPCs
		state = false,			-- Is Gus currently interacting with an NPC?
		identity = nil,			-- Identity of the NPC he's interacting with (the NPC instance)
	},
	label = "Gus",		-- String representation of Gus's name

	-- Animation de gus
	lastAnimation = love.timer.getTime(),
	timeWaitAnimation = 10,

}

Gus.movement.randomMoving = {
	desireToTurn = 0,
	maxDesireToTurn = GUS_DESIRE_TO_TURN_MAX,	-- Maximum number of steps before Gus wants to select a new direction (in random move mode)
	directions = {DIRECTION_LEFT, DIRECTION_RIGHT, DIRECTION_UP, DIRECTION_DOWN},
	journeyLength = 0,	-- Every time Gus takes a step, it'll increment by 1.
	currentdirection = nil,
}

function Gus.movement:selectNewDirection()
	-- Select the new direction randomly and return it
	rand = math.random(1,4)
	direction = Gus.movement.randomMoving.directions[rand]
	Gus.movement.randomMoving.currentdirection = direction
	return direction
end

function Gus.movement.randomMoving.resetDesireToTurn()
	-- Gus has turned, reset the desire to turn
	Gus.movement.randomMoving.desireToTurn = 0
	Gus.movement.randomMoving.currentdirection = nil
end

function Gus.movement.randomMoving.setDesireToTurn()
	-- Increase the desire to turn by a random value [0-1]
	Gus.movement.randomMoving.desireToTurn = Gus.movement.randomMoving.desireToTurn + math.random()
	if Gus.movement.randomMoving.desireToTurn > Gus.movement.randomMoving.maxDesireToTurn then
		Gus.movement.randomMoving.resetDesireToTurn()
	end
end

-- Gus tries to move to the next (x,y) position.
-- Out: true if Gus has successfully moved, false otherwise
function Gus.movement.move(next_x, next_y)
	
	-- Reset any previous interaction info
	Gus.interaction.identity = nil

   
	
	-- Check if Gus will still be inside the room if he takes this next step:
	if inner_room:IsPositionInside(Gus.img:getHeight(), Gus.img:getWidth(), next_x, next_y) then
		nearWall = false
		-- If Gus is close to any of the NPCs, it'll set Gus in Interaction mode.
		for _, npc in ipairs(NPC_group) do
			if npc.area:IsAreaTouched(Gus.img:getHeight(), Gus.img:getWidth(), next_x, next_y) then
				-- Setting this variable to true will impact love.update() (in main.lua)
				-- Gus isn't allowed to move as long as it's set to true
				Gus.interaction.state = true
				Gus.interaction.identity = npc
				-- Manage the interaction: some information may be added to Gus' memory in the course of the interaction
				Gus.manageInteraction()
				return false
			end
		end
		
		for _, obj in ipairs(Object_group) do
			if not obj.grabbed then
				if obj.area:IsAreaTouched(Gus.img:getHeight(), Gus.img:getWidth(), next_x, next_y) then
					-- Gus.interaction.state = true --pour test menteur
					Gus.interaction.identity = obj
					Gus.manageObjInteraction()
					return false
				end
			end
		end
		
		-- Meme si on ne peut a priori pas aller en diagonale, on fait le cas général si jamais on change plus tard
		distance = math.sqrt( (next_x-Gus.x)*(next_x-Gus.x) + (next_y-Gus.y)*(next_y-Gus.y) )
		Gus.memory.addInfo("environment", {"step_taken",distance})
		Gus.x = next_x
		Gus.y = next_y
		Gus.updateGauges()
		status_board.UpdateContent()
		return true
	elseif(not nearWall) then
		nearWall = true
		Gus.memory.addInfo("environment", {"wall_hit", 1})
	end
	return false
end

function Gus.movement.random(dt)
-- Each time it's called, Gus will make a random move.

	local r
	
	-- If Gus' desire to turn is below a certain threshold, Gus will move forward.
	if Gus.movement.randomMoving.desireToTurn <= Gus.movement.randomMoving.maxDesireToTurn then
		-- If there's no current direction set, select a new one.
		if Gus.movement.randomMoving.currentdirection == nil then
			Gus.movement.currentDirection = Gus.movement.selectNewDirection()
		else
			-- Move forward according to the current direction, taking into account the room's walls.
			if Gus.movement.currentDirection == DIRECTION_LEFT then
				r = Gus.movement.move(Gus.x - (Gus.step_size*dt), Gus.y)
			elseif Gus.movement.currentDirection == DIRECTION_RIGHT then
				r = Gus.movement.move(Gus.x + Gus.step_size*dt, Gus.y)
			elseif Gus.movement.currentDirection == DIRECTION_UP then
				r = Gus.movement.move(Gus.x, Gus.y - (Gus.step_size*dt))
			elseif Gus.movement.currentDirection == DIRECTION_DOWN then
				r = Gus.movement.move(Gus.x, Gus.y + (Gus.step_size*dt))
			end
			-- If Gus has successfully moved (i.e. the step he wanted to take didn't take him
			-- through the room's walls), then we update his desire to turn, else we make him select a new direction.
			if r then Gus.movement.randomMoving.setDesireToTurn() else Gus.movement.randomMoving.resetDesireToTurn() end
		end
	end
end

function Gus.movement.keyboard(dt)
-- Selects the correct parameters for Gus' moves according to
-- the key that's being pressed.

	if love.keyboard.isDown(unpack(SHORTCUT_MOVEUP)) then
		Gus.movement.move(Gus.x, Gus.y - (Gus.step_size*dt))
	elseif love.keyboard.isDown(unpack(SHORTCUT_MOVEDOWN)) then
		Gus.movement.move(Gus.x, Gus.y + (Gus.step_size*dt))
	end
	if love.keyboard.isDown(unpack(SHORTCUT_MOVERIGHT)) then
		Gus.movement.move(Gus.x + Gus.step_size*dt, Gus.y)
	elseif love.keyboard.isDown(unpack(SHORTCUT_MOVELEFT)) then
		Gus.movement.move(Gus.x - (Gus.step_size*dt), Gus.y)
	end
end

-- Update the Vigor, sociability and patience of Gus
-- May have to be generalized to deal with different dimensions
function Gus.updateGauges()
	-- Constrain the value between the min and max
	Gus.vigor = keepBetweenMinMax(round(Gus.vigor,3) - GUS_VIGOR_STEP, GUS_VIGOR_MIN, GUS_VIGOR_MAX)
	if Gus.vigor<=0 then
		Gus.die()
	else
		-- Update Gus' speed accordingly
		Gus.updateStepSize()
		-- On considère que moins il est en interaction, et plus sa sociabilité diminue
		Gus.decreaseSociability(0.01)
		-- Des qu'il bouge, sa patience se remplit
		Gus.resetPatience()
		Gus.patienceTimer.waitingTime = FL_patienceUpdate:makeDecision(_,{0, 1, GUS_PATIENCE_TIMER_MIN, GUS_PATIENCE_TIMER_MAX})

		
	end
end

-- Updates the size of the steps Gus takes (representation of his speed)
function Gus.updateStepSize()
	Gus.step_size = norm(Gus.vigor, GUS_VIGOR_MIN, GUS_VIGOR_MAX, GUS_STEP_SIZE_MIN, GUS_STEP_SIZE_MAX)
end

-- Increase the Sociability of Gus
function Gus.increaseSociability(coef)
	-- Constrain the value between the min and max
	Gus.sociability = keepBetweenMinMax(round(Gus.sociability,3) + coef*GUS_SOCIABILITY_STEP, GUS_SOCIABILITY_MIN, GUS_SOCIABILITY_MAX)
	-- Update Gus' speed accordingly
end

-- Decrease the Sociability of Gus
function Gus.decreaseSociability(coef)
	-- Constrain the value between the min and max
	Gus.sociability = keepBetweenMinMax(round(Gus.sociability,3) - coef*GUS_SOCIABILITY_STEP, GUS_SOCIABILITY_MIN, GUS_SOCIABILITY_MAX)
	-- Update Gus' speed accordingly
end

function Gus.getLevelOfSociability()
	if Gus.sociability < 33 then
		return GUS_SOCIABILITY_LOW
	elseif Gus.sociability > 66 then
		return GUS_SOCIABILITY_HIGH
	end
	return GUS_SOCIABILITY_MEDIUM
end

-- Selon la sociabilité de Gus, il va plus ou moins insister pour obtenir une réponse
function Gus.getNbrMaxInsiste()
	sociab = Gus.getLevelOfSociability()
	if sociab == GUS_SOCIABILITY_LOW then
		return 1
	elseif sociab == GUS_SOCIABILITY_HIGH then
		return 5
	else
		return 3
	end
end

-- Gus essaie de deviner le profil du NPC
function Gus.interaction.guessProfile(message, label)
	tab = parseSentence(message)
	--tprint(tab)
	-- on considère que Gus recommence ses tests du début à chaque fois
	-- il ne se laisse pas influencé par ce qu'il a deja entendu du NPC ici
	NPC_score = {
		[NPC_PROFILE_ARROGANT] = 0,
		[NPC_PROFILE_CHARMER] = 0,
		[NPC_PROFILE_AGGRESSIVE] = 0,
		[NPC_PROFILE_SHY] = 0,
	}
	
	-- Gus est plus ou moins attentif
	local canMemorise = false
	if(Gus.sociability>80 or Gus.vigor > 80) then
		canMemorise = true
	end
	
	-- on va compter pour chaque profil le nombre de mots qui correspondraient
	for i, word in ipairs(tab) do 
		if(canMemorise or math.random(0,100)>60) then
			for profile, liste in pairs(NPC_LEXICON) do
				if table.contains(liste, word) then
					-- print("Le mot "..word.." est dans la liste de "..profile) 
					NPC_score[profile] = NPC_score[profile] + 1
				end
			end
		end
	end
	
	tab = parsePonctuation(message)
	-- on va compter pour chaque profil le nombre de ponctuation qui correspondraient
	for i, word in ipairs(tab) do 
		if(canMemorise or math.random(0,100)>60) then
			for profile, liste in pairs(NPC_PONCTUATION) do
				if table.contains(liste, word) then
					-- print("Le mot "..word.." est dans la liste de "..profile) 
					NPC_score[profile] = NPC_score[profile] + 1
				end
			end
		end
	end
	--tprint(NPC_score)
	
	-- Gus se rappellera seulement du profil avec le plus grand score
	NPC_guessed = Gus.findBestProfile(NPC_score)
	-- si on a un profil deviné, on va l'ajouter à la liste des prédictions
	if(NPC_guessed) then
		Gus.memory.addInfo("NPCs", {label,"profile", NPC_guessed})
	end
end

-- Gus renvoit le nom et le profil qu'il pense avoir reconnu
function Gus.interaction.recognize(message)
	-- Gus est plus ou moins attentif
	local canMemorise = false
	if(Gus.sociability>80 or Gus.vigor > 80) then
		canMemorise = true
	end
	
	tab = parseSentence(message)
	--tprint(tab)
	-- on considère que Gus recommence ses tests du début à chaque fois
	-- il ne se laisse pas influencé par ce qu'il a deja entendu du NPC ici
	NPC_score = {
		[NPC_PROFILE_ARROGANT] = 0,
		[NPC_PROFILE_CHARMER] = 0,
		[NPC_PROFILE_AGGRESSIVE] = 0,
		[NPC_PROFILE_SHY] = 0,
	}
	-- on va compter pour chaque profil le nombre de mots qui correspondraient
	for _, word in ipairs(tab) do 
		if(canMemorise or math.random(0,100)>60) then
			for profile, liste in pairs(NPC_LEXICON) do
				if table.contains(liste, word) then
					NPC_score[profile] = NPC_score[profile] + 1
				end
			end
		end
	end
	
	tab = parsePonctuation(message)
	-- on va compter pour chaque profil le nombre de ponctuation qui correspondraient
	for i, word in ipairs(tab) do 
		if(canMemorise or math.random(0,100)>60) then
			for profile, liste in pairs(NPC_PONCTUATION) do
				if table.contains(liste, word) then
					NPC_score[profile] = NPC_score[profile] + 1
				end
			end
		end
	end
	
	-- Gus se rappellera seulement du profil avec le plus grand score
	NPC_profile = Gus.findBestProfile(NPC_score)
	if NPC_profile then
		for _, npc in ipairs(NPC_NAMES) do
			if Gus.memory.npcs[npc] then
				if Gus.memory.npcs[npc]["profile"] then
					if Gus.memory.npcs[npc]["profile"] == NPC_profile then
						return NPC_profile, npc
					end
				end
			end
		end
	end
	-- il n'a pas trouvé de profil, renvoie n'importe quoi, il n'a rien compris
	return NPC_PROFILE_ARROGANT, "John"
end

function Gus.manageInteraction()
	npc = Gus.interaction.identity
	
	-- If an entry exists for this NPC, it means Gus has already met it
	if Gus.memory.npcs[npc:getLabel()] then
		-- This isn't the first interaction anymore
		Gus.memory.npcs[npc:getLabel()]["first_met"] = false
		-- Gus doesn't do anything special...

	else
		-- Creation of an array for this NPC is Gus' memory:
		Gus.memory.npcs[npc:getLabel()] = {}
		-- This is the first interaction:
		Gus.memory.npcs[npc:getLabel()]["first_met"] = true
		-- Gus tries to get the NPC name through a dialogue:
		-- Gus.interaction.initiateDialogue(dialogue_ask_for_name, npc)
		-- Si Gus n'a pas eu le nom de la personne, il tente de negocier
	end
	-- ajout quete
	if npc.quest ~= nil then
		for _, quest in ipairs(npc.quest) do
			if not quest:checkCompletion(npc) then
				quest:startQuest(npc)
			elseif quest_meet_everyone.asigned and not quest_meet_everyone.resolved then -- Actuellement à la recherche de Stan
				Gus.interaction.initiateDialogue(dialogue_ask_for_Stan, npc)
			else
				if (npc.label == NPC2.label) then --si c'est Marie, elle lui donne un remontant
					Gus.vigor = keepBetweenMinMax(Gus.vigor + 10, 0, 100)
				end
				status_board.dialogue.addDialogue(npc.label, DIALOGUE_NPC_IDLE[npc.profile])
			end
		end
	else
		status_board.dialogue.addDialogue(npc.label, DIALOGUE_NPC_IDLE[npc.profile])
		if (npc.label == NPC2.label) then --si c'est Marie, elle lui donne un remontant
			Gus.vigor = keepBetweenMinMax(Gus.vigor + 10, 0, 100)
		end
		Gus.increaseSociability(1)
	end
	
	-- Update the content of the status board (so that any new change will be reflected)
	status_board.UpdateContent()
end

function Gus.manageObjInteraction()
	obj = Gus.interaction.identity
	obj.grabbed = true
	obj.area = nil
	-- Gus.memory.objects
	Gus.memory.addInfo("inventory", {obj.label, "name", obj.label})
	Gus.memory.addInfo("inventory", {obj.label, "hasIt", true})
	-- faire un dialogue alone Gus.interaction.initiateDialogue(dialogue_ask_for_name, npc)
	status_board.dialogue.addDialogue(Gus.label, DIALOGUE_GUS_FIND_LETTER)
	quest_give_letter:assignQuest(NPC5)
	Gus.interaction.state = false
	-- mise à jour de l'image de Gus
	Gus.imgfile = "assets/img/Gus_letter1.png"
	Gus.img1 = "assets/img/Gus_letter1.png"
	Gus.img2 = "assets/img/Gus_letter2.png"

	Gus.img = love.graphics.newImage(Gus.imgfile)
	
end

-- Start the given dialogue with the given npc.
-- Start a dialogue with this function, rather than directly with Dialogue_manager.startDialogue,
-- because in the initiateDialogue function you will manage Gus' desire to truly start the dialogue.
function Gus.interaction.initiateDialogue(dialogue, npc)
	npc = Gus.interaction.identity
	Dialogue_manager.startDialogue(dialogue, npc)
end

-- Add data to Gus' memory. Call this any time Gus has learnt something, otherwise it'll be lost!
-- In: a domain (string) which represents the area of knowledge, and some data (table, string, number...)
function Gus.memory.addInfo(domain, data)
	-- Add a case for each domain (data won't always be represented in a same structure type)
	if domain == "NPCs" then
		-- data should be something like {"NPC4", "name", "NPC4"}
		npc_label, tag, value = unpack(data)
		-- si il n'existe pas encore dans sa memoire, on va indiquer qu'on n'a pas encore determiné son profil
		if not Gus.memory.npcs[npc_label] then
			Gus.memory.npcs[npc_label] = {}
			Gus.memory.npcs[npc_label]["guessProfile"] = {
				[NPC_PROFILE_ARROGANT] = 0,
				[NPC_PROFILE_CHARMER] = 0,
				[NPC_PROFILE_AGGRESSIVE] = 0,
				[NPC_PROFILE_SHY] = 0,
			}
		end
		-- pour guessProfile, value est le profil determiné
		if(tag == "guessProfile") then
			Gus.memory.npcs[npc_label][tag][value] = Gus.memory.npcs[npc_label][tag][value] + 1
			Gus.memory.npcs[npc_label]["profile"] = Gus.findBestProfile(Gus.memory.npcs[npc_label][tag])
		else
			-- pour le reste
			Gus.memory.npcs[npc_label][tag] = value
		end
	elseif domain == "environment" then
		-- data doit etre de la forme {tag, value}
		tag, value = unpack(data)
		Gus.memory.environment[tag] = Gus.memory.environment[tag] + value
	elseif domain == "inventory" then
		obj_label, tag, value = unpack(data)
		if not Gus.memory.inventory[obj_label] then
			Gus.memory.inventory[obj_label] = {}
		end
		Gus.memory.inventory[obj_label][tag] = value
	elseif domain == "indice" then
		npc_label, info = unpack(data)
		if not Gus.memory.indices[npc_label] then
			print(info)
			Gus.memory.indices[npc_label] = info
		end	
		print(Gus.memory.indices[npc_label])
	end

	-- Always update the status board to possibly reflect the new changes
	status_board.UpdateContent()
end

-- Retrieve an information from Gus' memory. The content of this function may have to be changed in the future.
-- In: an object from Gus' memory, and its tag
-- Out: true & value of the element (if the element is present in memory), or false & nil
function Gus.memory.retrieveInfo(object, tag)
	if not object then
		return false, nil
	elseif object[tag] then
		return true, object[tag]
	else
		return false, nil
	end
end

-- Permet de mettre à jour le nom des personnes lorsqu'elles ont menti
function Gus.memory.updateName(npc, newName)
	if Gus.memory.npcs[npc:getLabel()] then
		Gus.memory.npcs[npc:getLabel()]["name"] = newName
	end
end

function Gus.findBestProfile(tabScores)
	NPC_guessed = nil
	max = -1
	for profile, score in pairs(tabScores) do
		if(score>max) then
			NPC_guessed = profile
			max = score
		end
	end
	return NPC_guessed
end

function Gus.die()
	if (Gus.imgfile == "assets/img/Gus.png") then
			Gus.imgfile = "assets/img/Gus_dead.png"
	else	
		Gus.imgfile = "assets/img/Gus_letter_dead.png"
	end
	Gus.dead = true
	Gus.img = love.graphics.newImage(Gus.imgfile)
	Gus.sociability = 0
	Gus.patience  = 0
	status_board.UpdateContent()
end

function Gus.updateAnimation() 
	-- print ("Decision COG ([0-1]) : ", FL_animGus:makeDecision(_, _))
	Gus.timeWaitAnimation = 1 - FL_animGus:makeDecision(_, _)


    local time = love.timer.getTime()
    local diff = time - Gus.lastAnimation

    -- print(diff)

    if diff > Gus.timeWaitAnimation then 
    	-- Changer d'image
    	if (Gus.imgfile == Gus.img1) then
			Gus.imgfile = Gus.img2
		else
			Gus.imgfile = Gus.img1
		end
		Gus.img = love.graphics.newImage(Gus.imgfile)
    	Gus.lastAnimation = time
    end


end

-----------------------------------
-- Partie relative à la patience --
-----------------------------------

Gus.patienceTimer = {
	value = 0,		-- amount of time (in seconds) normalized between 0 and 1
	waitingTime = GUS_PATIENCE_TIMER_MAX,	-- the maximum time Gus will wait before becoming completely impatient
	lastTime = love.timer.getTime(),	-- used to compute the delta time between each tick (in seconds)
	elapsed = 0,	-- in seconds
	active = true,	-- sometimes you may want Gus' patience not to decrease
}

-- Call this function each time Gus starts an activity (e.g. when he moves)
-- It'll set his patience level back to the maximal value and reset the timer
function Gus.resetPatience()
	Gus.patience = GUS_PATIENCE_MAX
	Gus.patienceTimer.value = GUS_PATIENCE_TIMER_MIN
	Gus.patienceTimer.elapsed = 0
end

-- Set Gus' level of patience, according to the amount of time he's been waiting.
-- The more he waits without doing anything,
-- the less patient he is.
-- Beware: Gus.patienceTimer.value is not expressed in seconds (normalized between 0 and 1)
function Gus.updatePatience()
	local patience = norm((1-math.tanh((Gus.patienceTimer.value-1)/0.2)-1), 0, 1, GUS_PATIENCE_MIN, GUS_PATIENCE_MAX)
	patience = keepBetweenMinMax(patience, GUS_PATIENCE_MIN, GUS_PATIENCE_MAX)
	Gus.patience = patience
end

-- Computes the time elapsed since the last tick, normalizes
-- it between 0 and 1, and calls the update of Gus' patience.
function Gus.setPatienceTimer()

	if not Gus.patienceTimer.active then 
		return 
	end
	
	-- If there's no lastTime saved (this can happen when you load the game),
	-- get the current time
	if not Gus.patienceTimer.lastTime then Gus.patienceTimer.lastTime = love.timer.getTime() end
	
	-- Capture the current time for each tick of the game, and add
	-- to the elapsed time the delta value between two ticks
	local newTime = love.timer.getTime()
	local etime = newTime - Gus.patienceTimer.lastTime
	-- The variable Gus.patienceTimer.elapsed is thus a value in seconds
	Gus.patienceTimer.elapsed = Gus.patienceTimer.elapsed + etime
	Gus.patienceTimer.lastTime = newTime
	
	-- Normalise the elapsed time between 0 and 1, and store it in Gus.patienceTimer.value
	Gus.patienceTimer.value = norm(Gus.patienceTimer.elapsed, GUS_PATIENCE_TIMER_MIN, Gus.patienceTimer.waitingTime, 0, 1)
	
	-- Update Gus' level of patience
	Gus.updatePatience()
end