dialogue_quest_hit_wall = Dialogue:new{}


function dqhw_Gus1()
	local sentence = DIALOGUE_GUS_HOW_ARE_YOU
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	if quest_hit_wall.firstTime then
		-- si pas encore eu la quete
		next_state = DIALOGUE_STATES_HIT_WALL[2]
	else
		next_state = DIALOGUE_STATES_HIT_WALL[4]
	end
	return DIALOGUE_NEXT, next_state
end

function dqhw_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_QUEST_HIT_WALL1
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_HIT_WALL[3]
	return DIALOGUE_NEXT, next_state
end

function dqhw_Gus2()
	local sentence = DIALOGUE_GUS_DONT_UNDERSTAND
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	next_state = DIALOGUE_STATES_HIT_WALL[4]
	return DIALOGUE_NEXT, next_state
end

function dqhw_NPC2()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local sentence = DIALOGUE_QUEST_HIT_WALL2
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.decreaseSociability(3)
	return DIALOGUE_STOP
end

DIALOGUE_STATES_HIT_WALL = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_HIT_WALL[1] = {dqhw_Gus1, Gus.label}
DIALOGUE_STATES_HIT_WALL[2] = {dqhw_NPC1, NPC_LABEL}
DIALOGUE_STATES_HIT_WALL[3] = {dqhw_Gus2, Gus.label}
DIALOGUE_STATES_HIT_WALL[4] = {dqhw_NPC2, NPC_LABEL}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_quest_hit_wall:setInitState(DIALOGUE_STATES_HIT_WALL[1])