
dialogue_quest_find_sender = Dialogue:new{}
profile_recognized, npc_recognized = Gus.interaction.recognize(LETTER_TEXT)

function dqfs_Gus1() 
	local sentence
	if quest_find_sender.firstTime then
		sentence = DIALOGUE_GUS_READ_LETTER
		next_state = DIALOGUE_FIND_SENDER[2]
	else
		sentence = DIALOGUE_GUS_READ_LETTER2
		next_state = DIALOGUE_FIND_SENDER[5]
	end
	
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_NEXT, next_state
end

function dqfs_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local npc_name = npc:getLabel()
	local sentence = DIALOGUE_QUEST_WHO_IS_HE1
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_FIND_SENDER[3]
	return DIALOGUE_NEXT, next_state
end

function dqfs_Gus2()
	profile_recognized, npc_recognized = Gus.interaction.recognize(LETTER_TEXT)
	local sentence = DIALOGUE_GUS_FIND_SENDER:format(profile_recognized,npc_recognized)
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_FIND_SENDER[4]
	return DIALOGUE_NEXT, next_state
end	

function dqfs_NPC2()
	local sentence 
	if(profile_recognized == NPC4.profile and npc_recognized == NPC4:getLabel()) then
		sentence = DIALOGUE_Stan_YES
		Gus.increaseSociability(3)
	else
		sentence = DIALOGUE_Stan_NO
		Gus.decreaseSociability(2)
	end
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_STOP
end

function dqfs_NPC3()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local npc_name = npc:getLabel()
	local sentence = DIALOGUE_QUEST_WHO_IS_HE2
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_FIND_SENDER[3]
	return DIALOGUE_NEXT, next_state
end

DIALOGUE_FIND_SENDER = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_FIND_SENDER[1] = {dqfs_Gus1, Gus.label}
DIALOGUE_FIND_SENDER[2] = {dqfs_NPC1, NPC_LABEL}
DIALOGUE_FIND_SENDER[3] = {dqfs_Gus2, Gus.label}
DIALOGUE_FIND_SENDER[4] = {dqfs_NPC2, NPC_LABEL}
DIALOGUE_FIND_SENDER[5] = {dqfs_NPC3, NPC_LABEL}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_find_sender:setInitState(DIALOGUE_FIND_SENDER[1])