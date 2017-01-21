
dialogue_quest_letter_given = Dialogue:new{}


function dqlg_Gus1()
	local sentence = DIALOGUE_GUS_LETTER_GIVEN
	next_state = DIALOGUE_STATES_LETTER_GIVEN[2]
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_NEXT, next_state
end


function dqlg_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_POSTIER_LETTER_GIVEN
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.decreaseSociability(1)
	return DIALOGUE_STOP
end

DIALOGUE_STATES_LETTER_GIVEN = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_LETTER_GIVEN[1] = {dqlg_Gus1, Gus.label}
DIALOGUE_STATES_LETTER_GIVEN[2] = {dqlg_NPC1, NPC_LABEL}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_letter_given:setInitState(DIALOGUE_STATES_LETTER_GIVEN[1])