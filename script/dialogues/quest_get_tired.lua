dialogue_quest_get_tired = Dialogue:new{}


function dqgt_Gus1()
	local sentence = DIALOGUE_GUS_HOW_ARE_YOU
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	if quest_get_tired.firstTime then
		-- si pas encore eu la quete
		next_state = DIALOGUE_STATES_GET_TIRED[2]
	else
		next_state = DIALOGUE_STATES_GET_TIRED[4]
	end
	return DIALOGUE_NEXT, next_state
end

function dqgt_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_QUEST_GET_TIRED1
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_GET_TIRED[3]
	return DIALOGUE_NEXT, next_state
end

function dqgt_Gus2()
	local sentence = DIALOGUE_GUS_DONT_UNDERSTAND
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_GET_TIRED[4]
	Gus.decreaseSociability(3)
	return DIALOGUE_NEXT, next_state
end

function dqgt_NPC2()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_QUEST_GET_TIRED2
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_STOP
end

DIALOGUE_STATES_GET_TIRED = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_GET_TIRED[1] = {dqgt_Gus1, Gus.label}
DIALOGUE_STATES_GET_TIRED[2] = {dqgt_NPC1, NPC_LABEL}
DIALOGUE_STATES_GET_TIRED[3] = {dqgt_Gus2, Gus.label}
DIALOGUE_STATES_GET_TIRED[4] = {dqgt_NPC2, NPC_LABEL}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_get_tired:setInitState(DIALOGUE_STATES_GET_TIRED[1])