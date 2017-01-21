
dialogue_quest_give_letter = Dialogue:new{}


function dqgl_Gus1()
	local sentence
	if quest_give_letter.firstTime then 
		quest_get_vigor:assignQuest(NPC5)
		quest_meet_everyone:assignQuest(NPC1)
		sentence = DIALOGUE_GUS_TELL_POSTIER
		next_state = DIALOGUE_STATES_GIVE_LETTER[2]
	else
		sentence = DIALOGUE_GUS_STILL_NOT_FIND
		next_state = DIALOGUE_STATES_GIVE_LETTER[4]
	end
	
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_NEXT, next_state
end


function dqgl_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_POSTIER_ANSWER
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_GIVE_LETTER[3]
	return DIALOGUE_NEXT, next_state
end

function dqgl_Gus2()
	local sentence = DIALOGUE_GUS_ANSWER_POSTIER
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_GIVE_LETTER[4]
	return DIALOGUE_NEXT, next_state
end

function dqgl_NPC2()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_POSTIER_ANSWER2
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_GIVE_LETTER[5]
	return DIALOGUE_NEXT, next_state
end

function dqgl_Gus3()
	local sentence = DIALOGUE_GUS_FINAL_ANSWER_POSTIER
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.decreaseSociability(1)
	return DIALOGUE_STOP
end



DIALOGUE_STATES_GIVE_LETTER = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_GIVE_LETTER[1] = {dqgl_Gus1, Gus.label}
DIALOGUE_STATES_GIVE_LETTER[2] = {dqgl_NPC1, NPC_LABEL}
DIALOGUE_STATES_GIVE_LETTER[3] = {dqgl_Gus2, Gus.label}
DIALOGUE_STATES_GIVE_LETTER[4] = {dqgl_NPC2, NPC_LABEL}
DIALOGUE_STATES_GIVE_LETTER[5] = {dqgl_Gus3, Gus.label}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_give_letter:setInitState(DIALOGUE_STATES_GIVE_LETTER[1])