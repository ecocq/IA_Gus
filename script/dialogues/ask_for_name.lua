--------------------
-- Dialogue: Ask for name
--------------------

-- Each dialogue is represented as a finite state automaton.
-- In its current state, the dialogue is extremely simple:
-- Gus asks for the NPC name (state1), the NPC gives it (state2), Gus says "nice to meet you" (state3)
-- ou juste au revoir si le PNJ n'a pas donne son nom(state 4)

-- We create a new instance of Dialogue
dialogue_ask_for_name = Dialogue:new{}

local compteur_Gus_insiste = 0; -- compteur du nombre de fois où Gus insiste

-- Faire un menteur sur le nom que Gus retient

-- Demande le nom
function state_Gus1()
	compteur_Gus_insiste = 0 -- on remet le compteur à zero à chaque nouvelle demande
	local sentence = DIALOGUE_GUS_WHATS_YOUR_NAME
	
	-- Send this sentence to the status_board dialogue section, along with the speaker's name
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	
	-- Declare what will be the next state
	next_state = DIALOGUE_STATES_ASK_FOR_NAME[2]
	
	-- Return two element (that'll be used by the dialogue manager) :
	-- that the dialogue shall continue (DIALOGUE_NEXT)
	-- and that the next state to run will be next_state
	return DIALOGUE_NEXT, next_state
end

-- Repond a la question
function state_NPC1()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local nom_npc = npc:getLabel()
	
	local sentence
	if npc:isWillingToProvidePersonalData(compteur_Gus_insiste) then
		sentence = DIALOGUE_NPC_MY_NAME_IS[npc.profile]:format(nom_npc)
		-- NPC gave its name. Add this to Gus' memory
		Gus.memory.addInfo("NPCs", {nom_npc, "name", nom_npc})
		-- nom_npc = npc.label
		next_state = DIALOGUE_STATES_ASK_FOR_NAME[3]
	else
		-- si le NPC ne donne pas son nom, la sociabilité diminue
		Gus.decreaseSociability(3)
		-- si c'est sa premiere tentative
		if(compteur_Gus_insiste==0) then
			sentence = DIALOGUE_NPC_I_WONT_GIVE_MY_NAME[npc.profile]:format()
			next_state = DIALOGUE_STATES_ASK_FOR_NAME[4]
			compteur_Gus_insiste = compteur_Gus_insiste+1
		else
			sentence = DIALOGUE_NPC_I_WONT_GIVE_MY_NAME_AGAIN[npc.profile]:format()
			if(compteur_Gus_insiste<=Gus.getNbrMaxInsiste()) then
				next_state = DIALOGUE_STATES_ASK_FOR_NAME[4] -- il va reessayer
				compteur_Gus_insiste = compteur_Gus_insiste +1;
			else
				next_state = DIALOGUE_STATES_ASK_FOR_NAME[5] -- il arrete de demander
			end	
		end
	end
		status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
		return DIALOGUE_NEXT, next_state
end

-- Fin du dialogue positif
function state_Gus2()
	local npc = Dialogue_manager.current_dialogue.interlocutor
	local gus_name = Gus.label
	local _, NPC_name = Gus.memory.retrieveInfo(Gus.memory.npcs[npc:getLabel()], "name")
	local sentence = DIALOGUE_GUS_NICE_TO_MEET_YOU:format(NPC_name, gus_name)
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	Gus.increaseSociability(2)
	-- Return only one element :
	-- that's the end of the dialogue (DIALOGUE_STOP)
	return DIALOGUE_STOP
end

-- Gus essaie de negocier
function state_Gus3()
	local sentence = DIALOGUE_GUS_NEGOCIATE[Gus.getLevelOfSociability()];
	-- Send this sentence to the status_board dialogue section, along with the speaker's name
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)
	
	-- Declare what will be the next state
	next_state = DIALOGUE_STATES_ASK_FOR_NAME[2]
	
	-- Return two element (that'll be used by the dialogue manager) :
	-- that the dialogue shall continue (DIALOGUE_NEXT)
	-- and that the next state to run will be next_state
	return DIALOGUE_NEXT, next_state
end

-- Fin du dialogue négatif
function state_Gus4()
	local sentence = DIALOGUE_GUS_BYE_BYE
	-- On diminue la sociabilité de Gus après un refus.
	-- Pourra etre reconnu plus tard tout seul par Gus si présence d'un "Non" par exemple
	Gus.decreaseSociability(4)
	status_board.dialogue.addDialogue(Dialogue_manager.current_state.speaker, sentence)

	return DIALOGUE_STOP
end

-- We list all the states
DIALOGUE_STATES_ASK_FOR_NAME = {}
-- I use numerical indexes here, but you can also use string values, up to you!
-- The table contains: the function that'll be called when we run this state and the speaker
DIALOGUE_STATES_ASK_FOR_NAME[1] = {state_Gus1, Gus.label}
DIALOGUE_STATES_ASK_FOR_NAME[2] = {state_NPC1, NPC_LABEL}
DIALOGUE_STATES_ASK_FOR_NAME[3] = {state_Gus2, Gus.label}
DIALOGUE_STATES_ASK_FOR_NAME[4] = {state_Gus3, Gus.label}
DIALOGUE_STATES_ASK_FOR_NAME[5] = {state_Gus4, Gus.label}

-- We tell what's the dialogue's initial state (i.e. in which state does the dialogue have to start)
dialogue_ask_for_name:setInitState(DIALOGUE_STATES_ASK_FOR_NAME[1])