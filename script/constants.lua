----------------------------------
-- CONSTANTS
-- Constants for everything
-- (Gus, the room, the NPCs...)
----------------------------------

-- Gus: Some initial and default values
GUS_INITIAL_POSITION_X = 510
GUS_INITIAL_POSITION_Y = 530
GUS_STEP_SIZE_MAX = 200
GUS_STEP_SIZE_MIN = 0
GUS_DESIRE_TO_TURN_MAX = 20

GUS_VIGOR_STEP = 0.05 -- The added/substracted value for each change in Gus' vigor. Change it to tune the speed at which Gus'll gain/lose vigor.
GUS_VIGOR_MIN = 0		-- The minimum value of Vigor
GUS_VIGOR_MAX = 100		-- The maximum value of Vigor
GUS_VIGOR_LABEL = "vigor"

GUS_SOCIABILITY_STEP = 2	-- The added/substracted value for each change in Gus' sociability. Change it to tune the impact of each interaction on Gus' sociability.
GUS_SOCIABILITY_MIN = 0		-- The minimum value of Sociability
GUS_SOCIABILITY_MAX = 100	-- The maximum value of Sociability
GUS_SOCIABILITY_LABEL = "sociability"

GUS_PATIENCE_MIN = 0
GUS_PATIENCE_MAX = 100
GUS_PATIENCE_TIMER_MIN = 0	-- in seconds
GUS_PATIENCE_TIMER_MAX = 30	-- in seconds
GUS_PATIENCE_LABEL = "patience"

-- Niveau de sociabilité
GUS_SOCIABILITY_LOW = "agressif"
GUS_SOCIABILITY_MEDIUM = "standard"
GUS_SOCIABILITY_HIGH = "sociable"

--Directions for Gus' moving
DIRECTION_UP = "up"
DIRECTION_DOWN = "down"
DIRECTION_LEFT = "left"
DIRECTION_RIGHT = "right"

-- Keyboard shortcuts
-- You can find the list of key strings here: https://love2d.org/wiki/KeyConstant
SHORTCUT_QUIT = {"escape"}
SHORTCUT_TOGGLEMOVINGMODE = {"return", "kpenter"}	-- kpenter is the numpad enter key
SHORTCUT_MOVEUP = {"z", "up"}
SHORTCUT_MOVEDOWN = {"s", "down"}
SHORTCUT_MOVELEFT = {"q", "left"}
SHORTCUT_MOVERIGHT = {"d", "right"}
SHORTCUT_STOPINTERACTION = {"e"}

-- Gauge settings. Used to finely position the gauges on the window
GAUGE_BORDER_SIZE = 3	
GAUGE_WIDTH = 22
GAUGE_HEIGHT_MIN = 0
GAUGE_HEIGHT_MAX = 72
GAUGE_CONTAINER_WIDTH = 28
GAUGE_CONTAINER_HEIGHT = 75

-- Room's dimensions
ROOM_INNER_WIDTH = 553
ROOM_INNER_HEIGHT = 589
ROOM_OFFSET = 4

-- NPC
NPC_LABEL = "NPC"
NPC_PROFILE_ARROGANT = "Arrogant"
NPC_PROFILE_CHARMER = "Charmeur"
NPC_PROFILE_AGGRESSIVE = "Agressif"
NPC_PROFILE_SHY = "Timide"

NPC_NAMES = {"Stan", "Marie", "Raphael", "Jean","Postier",}
-- The NPC should be listed in the same order as NPC_NAMES
NPC_LIST = {
	[1] = {
		imgfile = "NPC1.png",
		img1 = "NPC1.png",
		img2 = "NPC1bis.png",
		profile = NPC_PROFILE_ARROGANT,
		x = 50,
		y = 50,
		fake_label = "John",
	},
	[2] = {
		imgfile = "NPC2.png",
		img1 = "NPC2.png",
		img2 = "NPC2bis.png",
		profile = NPC_PROFILE_CHARMER,
		x = 400,
		y = 150,
		isMan = false,
	},
	[3] = {
		imgfile = "NPC3.png",
		img1 = "NPC3.png",
		img2 = "NPC3bis.png",
		profile = NPC_PROFILE_AGGRESSIVE,
		x = 100,
		y = 400,
	},
	[4] = {
		imgfile = "NPC4.png",
		img1 = "NPC4.png",
		img2 = "NPC4bis.png",
		profile = NPC_PROFILE_SHY,
		x = 300,
		y = 350,
	},
	[5] = {
		imgfile = "NPC5.png",
		img1 = "NPC5.png",
		img2 = "NPC5bis.png",
		profile = NPC_PROFILE_ARROGANT,
		x = 350,
		y = 400,
	},
	
}

-- Lexique
NPC_LEXICON = {
	[NPC_PROFILE_ARROGANT] = {"humble", "mieux", "excellente", "très", "bien", "abaisserai","gacherai","votre", "vôtre", "vos", "vous",
	"mon", "ma", "mes", "moi", "me","je", "j", "car", "intéressant", "ennuyez", "davantage","futé", "absurdité","réfléchissez","espionner",
	"Débrouillez", "maintenant","problèmes", "fiche", "trouvez", "personne",},
	[NPC_PROFILE_CHARMER] = {"mignon", "intimes", "lapin","tu", "ton", "ta", "tes", "toi", "mon", "ma", "mes", "moi", "me", "hommes",
	"concurrents","chance","rendez-vous","rencard", "petit", "favori", "sexy","visage",},
	[NPC_PROFILE_AGGRESSIVE] = {"oust","tu", "ton", "ta", "tes", "toi","bonhomme", "brise", "blessures", "prouve", "indemne","trouillard",
	"confrontations", "coups", "perdre","cognerais", "moi","bouffer", "tête",},
	[NPC_PROFILE_SHY] = {"je", "mon", "pardon","tu", "ton", "ta", "tes", "mon", "ma", "mes", "cache", "péché", "aborder", "bien", "péché",
	"agité", "préfère", "dire", "tousse", "main", "curieux", "vous", "votre",},
}

LEX_SPECIAL_WORDS = {
	{"aujourd", "hui", "aujourd'hui"},
	{"rendez", "vous", "rendez-vous"},
	{"arc", "en", "ciel", "arc-en-ciel"},
}

NPC_PONCTUATION = {
	[NPC_PROFILE_ARROGANT] = {"?", "!", ",", ";",},
	[NPC_PROFILE_CHARMER] = {"?", "!", ":",},
	[NPC_PROFILE_AGGRESSIVE] = {"??", "???", "!!", "!!!", "?!" ,},
	[NPC_PROFILE_SHY] = {"...", "*",},
}

-- Object
OBJECT_NAMES = {"Lettre pour Stan"}

OBJECT_LIST = {
	[1] = {
		imgfile = "lettre.png",
		x = 200,
		y = 200,
	},
}


-- Indices
NPC_INDICES = {
	["Marie"] = "visage",
	["Raphael"] = "chapeau",
	["Jean"] = "main",
}

-- Status board
STATUS_BOARD_REGULAR_MODE = "regular"
STATUS_BOARD_ALERT_MODE = "alert"
STATUS_BOARD_REGULAR_COLOR = {0, 0, 0, 255}
STATUS_BOARD_ALERT_COLOR = {255, 0, 0}

	
-- Dialogue
DIALOGUE_TIMER_MIN = 0
DIALOGUE_TIMER_MAX = 100
DIALOGUE_INIT = "INIT"
DIALOGUE_NEXT = "NEXT"
DIALOGUE_STOP = "STOP"

-- Miscellaneous
DEBUG_MODE = true