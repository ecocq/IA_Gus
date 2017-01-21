dialogue_quest_impress_girl = Dialogue:new{}


function dqig_Gus1()
	local sentence = DIALOGUE_GUS_HOW_ARE_YOU
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	if quest_impress_girl.firstTime then
		-- si pas encore eu la quete
		next_state = DIALOGUE_STATES_IMPRESS_GIRL[2]
	else
		next_state = DIALOGUE_STATES_IMPRESS_GIRL[6]
	end
	return DIALOGUE_NEXT, next_state
end

function dqig_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_QUEST_IMPRESS_GIRL1
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_IMPRESS_GIRL[3]
	return DIALOGUE_NEXT, next_state
end

function dqig_Gus2()
	local sentence = DIALOGUE_GUS_DONT_UNDERSTAND2
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_IMPRESS_GIRL[4]
	return DIALOGUE_NEXT, next_state
end

function dqig_NPC2()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_QUEST_IMPRESS_GIRL2
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_IMPRESS_GIRL[5]
	return DIALOGUE_NEXT, next_state
end

function dqig_Gus3()
	local sentence = DIALOGUE_GUS_ACCEPT_QUEST2
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_STOP
end

function dqig_NPC3()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_QUEST_IMPRESS_GIRL3
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_IMPRESS_GIRL[5]
	Gus.increaseSociability(2)
	return DIALOGUE_NEXT, next_state
end

DIALOGUE_STATES_IMPRESS_GIRL = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_IMPRESS_GIRL[1] = {dqig_Gus1, Gus.label}
DIALOGUE_STATES_IMPRESS_GIRL[2] = {dqig_NPC1, NPC_LABEL}
DIALOGUE_STATES_IMPRESS_GIRL[3] = {dqig_Gus2, Gus.label}
DIALOGUE_STATES_IMPRESS_GIRL[4] = {dqig_NPC2, NPC_LABEL}
DIALOGUE_STATES_IMPRESS_GIRL[5] = {dqig_Gus3, Gus.label}
DIALOGUE_STATES_IMPRESS_GIRL[6] = {dqig_NPC3, NPC_LABEL}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_impress_girl:setInitState(DIALOGUE_STATES_IMPRESS_GIRL[1])