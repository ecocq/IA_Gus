----------------------------------
-- Quests
----------------------------------

----------------------------------
-- Quest class
----------------------------------

Quest = {
	prompt = "";	-- the dialogue line that says what is expected of Gus
	repeatSentence = "";
	dialogue_quest = {};
	asigned = false;
	resolved = false;
	firstTime = true;
	optional = false;
	repeatable = false;
	conditions = {};	-- a list of lambda functions that represent the conditions of the quest
	rewards = {}; -- Une liste d'actions correspondant aux récompenses liées à la quête
}

function Quest:new (o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

-- Lance le dialogue associé à la quete
function Quest:startQuest(npc)
	if not resolved then
		for _, func in ipairs(self.dialogue_quest) do
			Gus.interaction.initiateDialogue(func(), npc)
			status_board.UpdateContent()
			status_board.PrintContent()
		end
	else
		-- Bravo!
		
	end

	if self.firstTime then
		Gus.increaseSociability(3)
		self.firstTime = false
	end

end

-- Checks whether Gus has completed the quest or not
-- Out: true if completed, false otherwise
function Quest:checkCompletion(npc)
	-- If the quest has already been tagged as resolved, then return true
	if self.resolved then 
		return true 
	end
	
	-- 'ok' will change to False if one of the conditions isn't met
	local ok = true
	-- For each condition of this quest
	for _, func in ipairs(self.conditions) do
		-- we run the function associated to this condition
		if not func() then
			-- if one of the conditions is false, that's over
			ok = false
			break
		end
	end
	-- If ok is still True, it means all the conditions are met
	if ok then

		if not self.repeatable then
			self.resolved = true
		end
		
		self:giveReward(npc)

		-- Update Gus memory with the info of the quest completion
		Gus.memory.addInfo("NPCs", {npc.label, "quest_complete", true})
		-- Check the progress of all the quests
		CheckOverallQuestCompletion()
		return true
	else
		return false
	end
end

function Quest:giveReward(npc) 
	for _, func in ipairs(self.rewards) do
			Gus.increaseSociability(5)
			Gus.vigor = keepBetweenMinMax(Gus.vigor + 10, 0, 100)
			Gus.interaction.initiateDialogue(func(), npc)
	end
end

-- Called when a NPC is created (in main.lua)
-- to assign this NPC this quest
-- In : a npc object
function Quest:assignQuest(npc)
	self.asigned = true
	if not npc.quest then 
		npc.quest = {}
	end
	table.insert(npc.quest, self)
	-- npc.quest = self
end

-- /!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\
-- Beware when you create new conditions:
-- Condition functions should only
-- return binary results (True/False or not-nil/nil)
-- /!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\

-- Quete: avoir rencontré tous les NPC et avoir eu tous les indices sur Stan
quest_meet_everyone = Quest:new{
	dialogue_quest = { function ()
							return dialogue_quest_meet_everyone
						end,
				    },
	conditions = {	function ()	-- you can use anonymous functions in the conditions
						local nbr = 0
						for _, npc in ipairs(NPC_group) do
							if Gus.memory.indices[npc:getLabel()] then nbr = nbr + 1 end
						end
						if nbr == 3 then
							return true
						else 
							return false
						end
					end,
				},
	rewards = { function ()
					Gus.memory.updateName(NPC1,"Stan") -- Gus comprend que c'est lui le menteur
					quest_find_sender:assignQuest(NPC1)										
					return dialogue_quest_explain_letter
				end,
	}
}

-- Quete: trouver l'auteur de la lettre
quest_find_sender = Quest:new{
	dialogue_quest = { function()
							return dialogue_quest_explain_letter
						end,
						function()
							
							success = love.window.showMessageBox(Object_group[1].label, LETTER_TEXT, "info", false )
							dialogue_Gus_read = Dialogue:new{}	
							dialogue_Gus_read:setInitState(
								{function()
									status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, "*lit*")
									return DIALOGUE_STOP
								end, Gus.label})
							return dialogue_Gus_read
						end,
						function()
							return dialogue_quest_find_sender
						end,

					},
	conditions = { function ()
						if(profile_recognized == NPC4.profile and npc_recognized == NPC4:getLabel()) then
							return true
						else
							return false
						end
						
					end,

	},

	rewards = { function()
					dialogue_thanks_Gus = Dialogue:new{}	
					dialogue_thanks_Gus:setInitState(
								{function()
									status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, DIALOGUE_THANKS_GUS)
									return DIALOGUE_STOP
								end, NPC1.label})
					return dialogue_thanks_Gus
				end,
	},
	
}

-- Quete: être à moins de 70 de vigueur
quest_get_tired = Quest:new{
	dialogue_quest = { function ()
							return dialogue_quest_get_tired
						end,
				    },
	conditions = {	function ()
						if Gus.vigor < 70 then
							return true
						else
							return false
						end
					end,
				},
	rewards = { function ()
					return dialogue_ask_for_name 
				end,
	}
}


-- Quete: Gus doit se cogner au moins 50 fois contre un mur
quest_hit_wall = Quest:new{
	dialogue_quest = { function ()
							return dialogue_quest_hit_wall
						end,
				    },
	conditions = {	function ()
						if Gus.memory.environment.wall_hit > 50 then
							return true
						else
							return false
						end
					end,
				},
	rewards = { function ()
					-- TODO
					return dialogue_ask_for_name
				end,
	}
}

-- Quete: Gus doit connaitre le profil de tous les NPC maxculins, être en pleine forme et d'humeur très sociable
quest_impress_girl = Quest:new{
	dialogue_quest = { function ()
							return dialogue_quest_impress_girl
						end,
				    },
	conditions = {	function ()
						for _, npc in ipairs(NPC_group) do
							if npc.isMan and not Gus.memory.retrieveInfo(Gus.memory.npcs[npc:getLabel()], "profile") then
								return false
							end
						end
						return true
					end,
				},
	rewards = { function ()
					return dialogue_ask_for_name
				end,
	}
}

-- Quete: En rendant la lettre au postier s'il l'a trouvé, ce dernier lui demande de s'en charger
quest_give_letter = Quest:new{
	dialogue_quest = { function ()
							return dialogue_quest_give_letter
						end,
				    },
	conditions = {	function ()
						if Gus.memory.retrieveInfo(Gus.memory.inventory[obj_label], "name") -- Gus connait l'objet
						and not Gus.memory.retrieveInfo(Gus.memory.inventory[obj_label], "hasIt") -- mais il ne l'a plus
						then
							return true -- cela veut dire qu'il a réussi à la donner
						else
							return false
						end
					end,
				},
	rewards = { function ()
					return dialogue_quest_letter_given
				end,
	}
}

-- Quete : Redonne de la vigueur à Gus s'il n'en a plus assez
quest_get_vigor = Quest:new{
	repeatable = true,
	optional = true,
	conditions = {	function ()
						if Gus.vigor < 40 then
							return true
						else
							return false
						end
					end,
				},
				
	rewards = { function ()
					Gus.vigor = 40 + Gus.vigor
					return dialogue_quest_get_vigor
				end,

	}
}


----------------------------------
-- Overall quest progress
----------------------------------

-- list all the quests that have to be resolved to meet the objective of the simulation
-- (if the objective consists in completing all the quests)
QUEST_GROUP = {quest_meet_everyone, quest_get_tired, quest_hit_wall, quest_give_letter, quest_get_vigor, quest_find_sender}

-- this function is called every time Gus completes a quest
function CheckOverallQuestCompletion()
	for _, quest in ipairs(QUEST_GROUP) do
		if not quest.resolved and not quest.optional then
			tprint(quest)
			return false
		end
	end
	-- Gus' reward
	Gus.imgfile = "assets/img/Gus_Crown.png"
	Gus.img1 = Gus.imgfile
	Gus.img2 = "assets/img/Gus_Crownbis.png"
	Gus.img = love.graphics.newImage(Gus.imgfile)
	
	return true
end