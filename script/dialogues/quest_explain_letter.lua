
dialogue_quest_explain_letter = Dialogue:new{}


function dqel_Gus1() 
	local sentence
	

	if not quest_find_sender.assigned then
		sentence = DIALOGUE_GUS_UNDERSTAND_TRAP
		next_state = DIALOGUE_EXPLAIN_LETTER[2]
	else
		if quest_find_sender.firstTime then
			sentence = DIALOGUE_GUS_EXPLAIN
			next_state = DIALOGUE_EXPLAIN_LETTER[4]
			return DIALOGUE_NEXT, next_state
		else
			sentence = DIALOGUE_GUS_SHOW_LETTER
			status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
			return DIALOGUE_STOP
		end
	end

	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_NEXT, next_state
end

function dqel_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local npc_name = npc:getLabel()
	local sentence = DIALOGUE_Stan_EXPLAIN
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.increaseSociability(1)
	next_state = DIALOGUE_EXPLAIN_LETTER[3]
	return DIALOGUE_NEXT, next_state
end

function dqel_Gus2()
	local sentence = DIALOGUE_GUS_GIVE_LETTER
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)

	Gus.memory.inventory[Object_group[1].label].hasIt = false
	Gus.img1 = "assets/img/Gus1.png";
	Gus.img2 = "assets/img/Gus2.png";
	
	return DIALOGUE_STOP
end	

function dqel_NPC2()
	local sentence = DIALOGUE_Stan_ASK
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_STOP
end



DIALOGUE_EXPLAIN_LETTER = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_EXPLAIN_LETTER[1] = {dqel_Gus1, Gus.label}
DIALOGUE_EXPLAIN_LETTER[2] = {dqel_NPC1, NPC_LABEL}
DIALOGUE_EXPLAIN_LETTER[3] = {dqel_Gus2, Gus.label}
DIALOGUE_EXPLAIN_LETTER[4] = {dqel_NPC2, NPC_LABEL}


-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_explain_letter:setInitState(DIALOGUE_EXPLAIN_LETTER[1])