--------------------
-- Dialogues
--------------------

------------
-- Gus
------------
DIALOGUE_GUS_WHATS_YOUR_NAME = "Comment tu t'appelles ?"
DIALOGUE_GUS_NICE_TO_MEET_YOU = "Enchanté, %s, moi c'est %s."
DIALOGUE_GUS_BYE_BYE = "Tant pis pour vous! Au revoir."
DIALOGUE_GUS_ACCEPT_QUEST = "Très bien, j'y vais de ce pas!"
DIALOGUE_GUS_ACCEPT_QUEST2 = "D'accord, je vais m'en occuper."
DIALOGUE_GUS_HOW_ARE_YOU = "Comment ça va? Quoi de neuf?"
DIALOGUE_GUS_THANK_YOU = "Merci beaucoup."
DIALOGUE_GUS_DONT_UNDERSTAND = "Pardon? Je ne comprends pas..."
DIALOGUE_GUS_DONT_UNDERSTAND2 = "Moi? Mais, je..."
DIALOGUE_GUS_DO_KNOW_HIM = "Bonjour ! Connaissez-vous un certain Stan par hasard ?"
DIALOGUE_GUS_THANK_HELP_NAMED ="Je vois. Merci de votre aide %s."
DIALOGUE_GUS_THANK_HELP ="Je vois. Merci de votre aide."
DIALOGUE_GUS_SPEAK_FRENCH = "Ce n'est pas donné à tout le monde de parler la France dis donc..."

-- quest give letter
DIALOGUE_GUS_FIND_LETTER = "Oh! Une lettre à terre... C'est curieux! Il y a une inscription dessus... \" Pour Stan \". Il faut que je me renseigne!"
DIALOGUE_GUS_TELL_POSTIER = "Bonjour ! Je viens de trouver cette lettre par terre. Vous avez du l'égarer. Tenez"
DIALOGUE_POSTIER_ANSWER = "Quoi? Qu'est ce que c'est que cette histoire? \" Pour Stan \"! D'où sort cette lettre?! Car enfin, je l'ai déjà livrée cette lettre à Stan, moi! Je m'en souviens très bien, j'ai une excellente mémoire! Je ne m'y colle pas encore, j'ai déjà donné! Débrouillez-vous avec lui maintenant."
DIALOGUE_GUS_ANSWER_POSTIER = "Quoi ? Mais vous êtes payé pour ça non?" 
DIALOGUE_POSTIER_ANSWER2 = "Je m'en fiche. Trouvez Stan et rendez-lui sa lettre."
DIALOGUE_GUS_FINAL_ANSWER_POSTIER = "Ah ces fonctionnaires..."
DIALOGUE_GUS_STILL_NOT_FIND = "Je ne l'ai toujours pas trouvé..."
DIALOGUE_GUS_UNDERSTAND_TRAP = "Il n'y a pas de John ici... Et d'après tout ce qu'on m'a dit, Stan, ça ne peut être que vous!"
DIALOGUE_Stan_EXPLAIN = "Oh mon dieu! Comment avez-vous su? Je ne voulais pas avoir davantage de problèmes avec cette lettre voyez-vous. "
DIALOGUE_GUS_GIVE_LETTER = "Je vous la rends quand même. Tenez."
DIALOGUE_GUS_EXPLAIN = "Mais qu'est ce qu'elle a de si terrible cette lettre?"
DIALOGUE_Stan_ASK = "Je ne comprends pas tout. Mais puisque vous êtes si futé, dites moi qui donc l'auteur de cette lettre!"
DIALOGUE_GUS_READ_LETTER = "Oh! Que c'est émouvant!"
DIALOGUE_GUS_READ_LETTER2 = "C'est toujours aussi émouvant."
DIALOGUE_QUEST_WHO_IS_HE1 = "Ce n'est qu'un ramassi d'absurdité! Mon fils n'aurait jamais écrit de la sorte et saurait signer une lettre! Savez-vous qui cela pourrait-il être?"
DIALOGUE_QUEST_WHO_IS_HE2 = "Arrêtez vos bêtises! Savez-vous qui cela peut-il être?"
DIALOGUE_GUS_FIND_SENDER = "Vu son contenu, je pense que c'est quelqu'un de %s. Ca ne peut être que %s."
DIALOGUE_Stan_NO = "Mais non! Ca ne peut être cette personne, réfléchissez un peu plus! Allez espionner les autres."
DIALOGUE_Stan_YES = "... Ah mais oui... Ca ne peut être que lui... Vous avez peut être raison! Laissez-moi réfléchir..."
DIALOGUE_GUS_SHOW_LETTER = "Ca y est, je pense savoir qui c'est. Remontrez-moi la lettre."
DIALOGUE_GUS_LETTER_GIVEN = "Ca y est! J'ai délivré la lettre! En fait, Stan m'avait menti vous voyez?"
DIALOGUE_POSTIER_LETTER_GIVEN = "Ah bah enfin! C'est pas trop tôt. Ce fut laborieux, ce n'est pas donné à tout le monde d'être un aussi bon postier que moi!"
DIALOGUE_THANKS_GUS = "Merci, je vais essayer de prendre contact avec lui."

-- quest get vigor
DIALOGUE_POSTIER_GIVE_VIGOR = "Par contre, je peux vous donner le fond de mon BlueCow comme vous êtes à la ramasse."

-- quest meet everyone
DIALOGUE_QUEST_MEET_EVERYONE1 = "Je ne crois pas mon petit, mon humble nom n'est autre que %s. Mais vous devriez peut-être aller voir ailleurs."
DIALOGUE_QUEST_MEET_EVERYONE2 = "Allez voir ailleurs si j'y serai."

-- quest get tired
DIALOGUE_QUEST_GET_TIRED1 = "Je... je vous trouve très agité..."
DIALOGUE_QUEST_GET_TIRED2 = "Beaucoup trop agité... selon moi..."

-- quest hit wall
DIALOGUE_QUEST_HIT_WALL1 = "Si t'es un vrai bonhomme, tu dois pouvoir survivre à des blessures!! Prouve-moi que rien ne te brise, même pas un mur plus de 50 fois!!"
DIALOGUE_QUEST_HIT_WALL2 = "Peur de 50 coups de mur?! Reviens me voir indemne après tes 50 confrontations, trouillard!!!"

-- quest impress girl
DIALOGUE_QUEST_IMPRESS_GIRL1 = "Crois-tu vraiment m'impressionner sans rien connaître de tes concurrents mon lapin?"
DIALOGUE_QUEST_IMPRESS_GIRL2 = "Non! Il faudrait aussi que tu sois prêt à me faire rire pour avoir une chance d'obtenir un rendez-vous!"
DIALOGUE_QUEST_IMPRESS_GIRL3 = "Tu n'es toujours pas prêt pour ce rencard mon lapin: file!"


----------------
-- Ask for name
----------------

-- Du plus agressive au plus amical
DIALOGUE_GUS_NEGOCIATE = {
	[GUS_SOCIABILITY_LOW] = "Allez! Dis-moi comment tu t'appelles! C'est pas si compliqué!",
	[GUS_SOCIABILITY_MEDIUM] = "J'aimerais pourtant connaître votre nom s'il vous plait.",
	[GUS_SOCIABILITY_HIGH] = "Vous avez l'air d'être quelqu'un de bien, j'aimerais pouvoir en apprendre plus sur vous. Mais comment vous appelez-vous?",
}

DIALOGUE_NPC_MY_NAME_IS = {
	[NPC_PROFILE_ARROGANT] = "Mon humble nom est forcément mieux que le vôtre puisque je m'appelle %s!",
	[NPC_PROFILE_CHARMER] = "Tu as l'air mignon toi! Si tu veux, tu peux m'appeler par mon petit prenom réservé aux intimes: %s.",
	[NPC_PROFILE_AGGRESSIVE] = "Je m'appelle %s!! Aller oust!! Du balai!!! Tu dois être au chômage vu que tu as du temps à perdre pour demander ça!!",
	[NPC_PROFILE_SHY] = "Je... Mon... Mon nom est %s.",
}

DIALOGUE_NPC_I_WONT_GIVE_MY_NAME = {
	[NPC_PROFILE_ARROGANT] = "Je ne m'abaisserai pas à donner mon nom à quelqu'un comme vous!",
	[NPC_PROFILE_CHARMER] = "Mon lapin: je ne donne pas mon nom au inconnu...",
	[NPC_PROFILE_AGGRESSIVE] = "Qu'est ce que ça peut te faire?! Vas jouer au pays de l'arc-en-ciel!!",
	[NPC_PROFILE_SHY] = "Euh... Je... ... ... ... ne préfère pas te le dire... Pardon.",
}

DIALOGUE_NPC_I_WONT_GIVE_MY_NAME_AGAIN = {
	[NPC_PROFILE_ARROGANT] = "Je ne gacherai pas ma salive pour vous le donner!",
	[NPC_PROFILE_CHARMER] = "Mon lapin, puisque je te dis que je ne te connais pas...",
	[NPC_PROFILE_AGGRESSIVE] = "Mais qu'est ce que ça peut te faire?! Laisse-moi tranquille!!",
	[NPC_PROFILE_SHY] = "Euh... Je... Non.",
}

-----------------

DIALOGUE_NPC_IDLE = {
	[NPC_PROFILE_ARROGANT] = "Personne n'est intéressant ici.",
	[NPC_PROFILE_CHARMER] = "Ah ces hommes: tous les mêmes! Tiens, j'ai encore un petit remontant à partager!",
	[NPC_PROFILE_AGGRESSIVE] = "Je cognerais bien sur quelque chose moi!!",
	[NPC_PROFILE_SHY] = "... *tousse* ...",
}

DIALOGUE_NPC_DO_KNOW_HIM = {
	[NPC_PROFILE_ARROGANT] = "Vous m'ennuyez avec vos histoires.",
	[NPC_PROFILE_CHARMER] = "Ah mon favori! Ce petit détail sur son visage le rend vraiment sexy.",
	[NPC_PROFILE_AGGRESSIVE] = "Ah lui! Je lui ferais bien bouffer ce qu'il a sur la tête.",
	[NPC_PROFILE_SHY] = "C'est curieux qu'il ne lache jamais ce qu'il a dans la main...",
}

LETTER_TEXT = "	  Cher Stan, \
Voila déjà plusieurs années que je suis à votre recherche... J'ai enfin réussi à vous trouver il y a tout juste quelques semaines. \
Je suis si près du but mais... Je ne sais toujours pas comment vous aborder...\
Je me cache depuis bien trop longtemps. Alors... je vous dois la vérité:\
je suis le fruit de votre péché avec Marie-Antoinette il y a de cela 20 ans.\
									----"
	

