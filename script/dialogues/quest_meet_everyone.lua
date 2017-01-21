
dialogue_quest_meet_everyone = Dialogue:new{}


function dqme_Gus1() 
	local sentence 
	if quest_meet_everyone.firstTime then
		sentence = DIALOGUE_GUS_DO_KNOW_HIM
		next_state = DIALOGUE_STATES_MEET_EVERYONE[2]
	else
		sentence = DIALOGUE_GUS_STILL_NOT_FIND
		next_state = DIALOGUE_STATES_MEET_EVERYONE[4]
	end
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_NEXT, next_state
end

function dqme_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local npc_name = npc:getLabel()
	local sentence = DIALOGUE_QUEST_MEET_EVERYONE1:format(npc_name )
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.memory.addInfo("NPCs", {npc_name , "name", npc_name })
	next_state = DIALOGUE_STATES_MEET_EVERYONE[3]
	return DIALOGUE_NEXT, next_state
end

function dqme_Gus2()
	local sentence = DIALOGUE_GUS_ACCEPT_QUEST
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.increaseSociability(1)
	return DIALOGUE_STOP
end

function dqme_NPC2()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_QUEST_MEET_EVERYONE2
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_MEET_EVERYONE[5]
	return DIALOGUE_NEXT, next_state
end

function dqme_Gus3()
	local sentence = DIALOGUE_GUS_SPEAK_FRENCH
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.decreaseSociability(1)
	return DIALOGUE_STOP
end

DIALOGUE_STATES_MEET_EVERYONE = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_MEET_EVERYONE[1] = {dqme_Gus1, Gus.label}
DIALOGUE_STATES_MEET_EVERYONE[2] = {dqme_NPC1, NPC_LABEL}
DIALOGUE_STATES_MEET_EVERYONE[3] = {dqme_Gus2, Gus.label}
DIALOGUE_STATES_MEET_EVERYONE[4] = {dqme_NPC2, NPC_LABEL}
DIALOGUE_STATES_MEET_EVERYONE[5] = {dqme_Gus3, Gus.label}


-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_meet_everyone:setInitState(DIALOGUE_STATES_MEET_EVERYONE[1])