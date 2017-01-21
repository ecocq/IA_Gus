
dialogue_ask_for_Stan = Dialogue:new{}


function dafs_Gus1()
	local sentence = DIALOGUE_GUS_DO_KNOW_HIM
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_ASK_FOR_Stan[2]
	return DIALOGUE_NEXT, next_state
end

function dafs_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local nom_npc = npc:getLabel()
	
	local sentence = DIALOGUE_NPC_DO_KNOW_HIM[npc.profile]
	next_state = DIALOGUE_STATES_ASK_FOR_Stan[3]

	if NPC_INDICES[nom_npc] then
		print( NPC_INDICES[nom_npc])
		Gus.memory.addInfo("indice", {nom_npc, NPC_INDICES[nom_npc]})
		Gus.increaseSociability(2)
	end
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_NEXT, next_state
end

function dafs_Gus2()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local gus_name = Gus.label
	local _, NPC_name = Gus.memory.retrieveInfo(Gus.memory.npcs[npc:getLabel()], "name")

	local sentence 
	if NPC_name then
		sentence = DIALOGUE_GUS_THANK_HELP_NAMED:format(NPC_name)
	else
		sentence = DIALOGUE_GUS_THANK_HELP
	end
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	return DIALOGUE_STOP
end

-- We list all the states
DIALOGUE_STATES_ASK_FOR_Stan = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_ASK_FOR_Stan[1] = {dafs_Gus1, Gus.label}
DIALOGUE_STATES_ASK_FOR_Stan[2] = {dafs_NPC1, NPC_LABEL}
DIALOGUE_STATES_ASK_FOR_Stan[3] = {dafs_Gus2, Gus.label}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_ask_for_Stan:setInitState(DIALOGUE_STATES_ASK_FOR_Stan[1])