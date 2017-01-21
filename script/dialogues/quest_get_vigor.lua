
dialogue_quest_get_vigor = Dialogue:new{}


function dqgv_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_POSTIER_GIVE_VIGOR
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_GET_VIGOR[2]
	return DIALOGUE_NEXT, next_state
end

function dqgv_Gus1()
	local sentence = DIALOGUE_GUS_THANK_YOU
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.increaseSociability(3)
	return DIALOGUE_STOP
end



DIALOGUE_STATES_GET_VIGOR = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_GET_VIGOR[1] = {dqgv_NPC1, NPC_LABEL}
DIALOGUE_STATES_GET_VIGOR[2] = {dqgv_Gus1, Gus.label}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_get_vigor:setInitState(DIALOGUE_STATES_GET_VIGOR[1])