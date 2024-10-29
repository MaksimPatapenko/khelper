script_name("Khelper")
script_version('1.0.1')
--								____ ____ ____ _  _ ____ ____ ____
--								|__/ |___ |  | |  | |___ |__/ |___
--								|  \ |___ |_\| |__| |___ |  \ |___

require 'lib.moonloader'

local font = renderCreateFont("Tahoma", 9, 8)
local sampev = require ('lib.samp.events')
local isTryingPasswords = false  -- ‘лаг дл€ предотвращени€ повторного запуска
local isCorrectCodeEntered = false  -- ‘лаг дл€ отслеживани€ правильного кода
local isFullHp = false -- ‘лаг дл€ отслеживани€ 100 хп
local isProcessMedKit = false -- ‘лаг дл€ передачи сигнала, что нужно дать паузу на восполнение хп
local imgui = require 'imgui'
local inicfg = require 'inicfg'
local encoding = require 'encoding'
local key = require 'vkeys'
local memory = require "memory"
encoding.default = 'CP1251'
u8 = encoding.UTF8
samp = require 'samp.events'
--								___  ____ ___ ____    ___ ____ ___  _    ____
--								|  \ |__|  |  |__|     |  |__| |__] |    |___
--								|__/ |  |  |  |  |     |  |  | |__] |___ |___
local simpleExperience = {}
local artifacts = {}
local zombies = {}
local ria = {}
local data = {}
local usedDecoders = ""
local all_ids = { 
    2216,
}
local textkapt = ""
local object_visible = {}
local iskl = {3131}
local dist_visible = 1

local artprise = {
	{name = " ость", priseforlvl = 156},
	{name = "ядро", priseforlvl = 156},
	{name = "Ћуч", priseforlvl = 125},
	{name = "«еркало", priseforlvl = 156},
	{name = "янтарь", priseforlvl = 171},
	{name = "√ильза", priseforlvl = 156},
	{name = "ƒуша", priseforlvl = 140},
	{name = "ќсколок", priseforlvl = 156},
	{name = "√лаз", priseforlvl = 140},
	{name = "Ѕатарейка", priseforlvl = 156},
	{name = " ровь", priseforlvl = 140},
	{name = "ѕанаце€", priseforlvl = 203},
	{name = "Ћинза", priseforlvl = 140},
	{name = "ѕандора", priseforlvl = 171},
	{name = "Ќота", priseforlvl = 140},
}

local coeficentart = {
	{D = 100, C = 2.00},
	{D = 99, C = 1.99},
	{D = 98, C = 1.98},
	{D = 97, C = 1.97},
	{D = 96, C = 1.96},
	{D = 95, C = 1.95},
	{D = 94, C = 1.94},
	{D = 93, C = 1.93},
	{D = 92, C = 1.92},
	{D = 91, C = 1.91},
	{D = 90, C = 1.90},
	{D = 89, C = 1.89},
	{D = 88, C = 1.88},
	{D = 87, C = 1.87},
	{D = 86, C = 1.86},
	{D = 85, C = 1.85},
	{D = 84, C = 1.84},
	{D = 83, C = 1.83},
	{D = 82, C = 1.82},
	{D = 81, C = 1.81},
	{D = 80, C = 1.80},
	{D = 79, C = 1.79},
	{D = 78, C = 1.78},
	{D = 77, C = 1.77},
	{D = 76, C = 1.76},
	{D = 75, C = 1.75},
	{D = 74, C = 1.74},
	{D = 73, C = 1.73},
	{D = 72, C = 1.72},
	{D = 71, C = 1.71},
	{D = 70, C = 1.70},
	{D = 69, C = 1.69},
	{D = 68, C = 1.68},
	{D = 67, C = 1.67},
	{D = 66, C = 1.66},
	{D = 65, C = 1.65},
	{D = 64, C = 1.64},
	{D = 63, C = 1.63},
	{D = 62, C = 1.62},
	{D = 61, C = 1.61},
	{D = 60, C = 1.60},
	{D = 59, C = 1.59},
	{D = 58, C = 1.58},
	{D = 57, C = 1.57},
	{D = 56, C = 1.56},
	{D = 55, C = 1.55},
	{D = 54, C = 1.54},
	{D = 53, C = 1.53},
	{D = 52, C = 1.52},
	{D = 51, C = 1.51},
	{D = 50, C = 1.50},
	{D = 49, C = 1.49},
	{D = 48, C = 1.48},
	{D = 47, C = 1.47},
	{D = 46, C = 1.46},
	{D = 45, C = 1.45},
	{D = 44, C = 1.44},
	{D = 43, C = 1.43},
	{D = 42, C = 1.42},
	{D = 41, C = 1.41},
	{D = 40, C = 1.40},
	{D = 39, C = 1.39},
	{D = 38, C = 1.38},
	{D = 37, C = 1.37},
	{D = 36, C = 1.36},
	{D = 35, C = 1.35},
	{D = 34, C = 1.34},
	{D = 33, C = 1.33},
	{D = 32, C = 1.32},
	{D = 31, C = 1.31},
	{D = 30, C = 1.30},
	{D = 29, C = 1.29},
	{D = 28, C = 1.28},
	{D = 27, C = 1.27},
	{D = 26, C = 1.26},
	{D = 25, C = 1.25},
	{D = 24, C = 1.24},
	{D = 23, C = 1.23},
	{D = 22, C = 1.22},
	{D = 21, C = 1.21},
	{D = 20, C = 1.20},
	{D = 19, C = 1.19},
	{D = 18, C = 1.18},
	{D = 17, C = 1.17},
	{D = 16, C = 1.16},
	{D = 15, C = 1.15},
	{D = 14, C = 1.14},
	{D = 13, C = 1.13},
	{D = 12, C = 1.12},
	{D = 11, C = 1.11},
	{D = 10, C = 1.10},
	{D = 9, C = 1.09},
	{D = 8, C = 1.08},
	{D = 7, C = 1.07},
	{D = 6, C = 1.06},
	{D = 5, C = 1.05},
	{D = 4, C = 1.04},
	{D = 3, C = 1.03},
	{D = 2, C = 1.02},
	{D = 1, C = 1.01},
	{D = 0, C = 1.00}
}

local itemchans = {
    {name = "Ѕольшой пакет с едой", chance = 2, colvo_min = 1, colvo_max = 1, cost = 280},
    {name = "ѕатроны 8.61", chance = 2.5, colvo_min = 1, colvo_max = 4, cost = 50},
    {name = "—лабый антирад", chance = 8.5, colvo_min = 3, colvo_max = 3, cost = 60},
    {name = "ѕакет с едой", chance = 3, colvo_min = 1, colvo_max = 1, cost = 310},
    {name = "ѕицца ‘ранко", chance = 1.5, colvo_min = 1, colvo_max = 1, cost = 260},
    {name = "ѕатроны 7.62", chance = 3, colvo_min = 2, colvo_max = 11, cost = 3},
    {name = "ѕатроны 12.7", chance = 2, colvo_min = 5, colvo_max = 9, cost = 5},
    {name = "јптечка", chance = 3, colvo_min = 3, colvo_max = 3, cost = 220},
    {name = "ѕицца ƒоменика", chance = 3, colvo_min = 1, colvo_max = 1, cost = 280},
    {name = "—кин", chance = 21.5, colvo_min = 1, colvo_max = 1, cost = 500},
    {name = "Ѕиг тейсти", chance = 4.5, colvo_min = 2, colvo_max = 2, cost = 200},
    {name = "ѕицца", chance = 4, colvo_min = 1, colvo_max = 1, cost = 340},
    {name = " атана", chance = 2.5, colvo_min = 1, colvo_max = 1, cost = 350},
    {name = "ѕатрон 9мм", chance = 8.5, colvo_min = 3, colvo_max = 16, cost = 5},
    {name = "Ќож", chance = 5.5, colvo_min = 1, colvo_max = 1, cost = 50},
    {name = "Berreta", chance = 2.5, colvo_min = 1, colvo_max = 1, cost = 320},
    {name = "—¬“-40", chance = 3, colvo_min = 1, colvo_max = 1, cost = 1040},
    {name = "ќбезболивающее", chance = 9, colvo_min = 3, colvo_max = 3, cost = 110},
    {name = "TEC-DC9", chance = 1, colvo_min = 1, colvo_max = 1, cost = 900},
    {name = "Ѕиг бургер", chance = 2.5, colvo_min = 2, colvo_max = 2, cost = 260},
    {name = "Glock-17", chance = 2, colvo_min = 1, colvo_max = 1, cost = 300},
    {name = "Remington", chance = 1, colvo_min = 1, colvo_max = 1, cost = 720},
    {name = "ѕатрон 18.5", chance = 3, colvo_min = 1, colvo_max = 8, cost = 8},
    {name = "Berreta-SD", chance = 0.5, colvo_min = 1, colvo_max = 1, cost = 440},
    {name = "ѕицца ‘ранческа", chance = 0.5, colvo_min = 1, colvo_max = 1, cost = 270},
    {name = "UZI", chance = 0.5, colvo_min = 1, colvo_max = 1, cost = 780}
}

local TXDID = {
	menu_ids = {
	45,
	262,
	259,
	47,
	2213,

	},
	skill_ids = {
	2238,
	2239,
	2240,
	2241,
	2242,
	2243,
	2244,
	2245,
	2246,
	2247,
	2065,
	},
	skills_laterids = {
	84,
	87,
	90,
	93,
	96,
	99,
	102,
	105,
	108,
	111,
	},
	blue_text = {
		49,
		51,
		53,
		55,
		2072,
		2076,
		2080,
		2084,
		2088,
		2092,
		2096,
		2100,
		2104,
		2108,
		2112,
		2116,
		2120,
		2124,
		2128,
		2132,
		2136,
		2140,
		85,
		88,
		91,
		94,
		97,
		100,
		103,
		106,
		109,
		112,
		390,
		391,
		392,
		393,
		394,
		395,
		396,
		397,
		398,
		400,
		401,
		402,
		405,
		408,
		412,
		415,
		418,
		421,
	},
}

local anomalylocations = { --  оординаты оазисов
	{x = -795, y = 2044, name = "ƒамба"},
	{x = -538, y = 2587, name = "“ьерра –обада"},
	{x = 201, y = 2527, name = "«аброшенный аэро"},
	{x = 0, y = 1351, name = "“аверна"},
	{x = 195, y = 1407, name = "Ќефтезавод"},
	{x = 489, y = 1393, name = "ќктан —принг"},
	{x = 596, y = 882, name = " арьер"},
	{x = 1096, y = 1072, name = " олледж"},
	{x = 1354, y = 1478, name = "јэро —‘"},
	{x = 1269, y = 2800, name = "√оль поле"},
	{x = 739, y = 52, name = "‘ерн –идж"},
	{x = 2363, y = -575, name = "√ора Ћ—"},
	{x = 1958, y = -1201, name = "√лен парк"},
	{x = 2016, y = -1513, name = "јйделвуд"},
	{x = 2572, y = -1848, name = " анализаци€"},
	{x = 1697, y = -2282, name = "јэро Ћ—"},
	{x = 1133, y = -1509, name = "ћаркет"},
	{x = 878, y = -1245, name = " иностуди€"},
	{x = 878, y = -1104, name = " ладбище"},
	{x = -493, y = -2478, name = "Ѕэк о бейонд"},
	{x = -420, y = -1444, name = "‘линтовские пол€"},
	{x = -535, y = -522, name = "—клад"},
	{x = -489, y = -105, name = "Ћесопилка"},
	{x = -1108, y = -988, name = "‘линтовский округ"},
	{x = -1052, y = -694, name = "’имзавод"},
	{x = -1504, y = -389, name = "јэро —‘"},
	{x = -1653, y = 28, name = "ƒоки —‘"},
	{x = -2060, y = -196, name = "јвтошкола"},
	{x = -2070, y = 248, name = "—тройка"},
	{x = -2322, y = 150, name = "√арси€"},
	{x = -2311, y = -1632, name = "√ора „иллиад"},
	{x = -1852, y = -1639, name = "Ўахта"},
}

local oazis = { --  оординаты оазисов
	{x = 1628, y = 600, name = "ѕристань"},
	{x = 2640, y = 2327, name = "√итара"},
	{x = 2102, y = -103, name = " ол€ска"},
	{x = 1196, y = -634, name = "ћост Ћ—"},
	{x = 1955, y = -1372, name = "—кейт парк"},
	{x = -151, y = -1038, name = "ѕригород Ћ—"},
	{x = -2156, y = -405, name = "ћ€ч"},
	{x = -2807, y = 1163, name = "‘онтан"},
	{x = -1504, y = 1375, name = "ќстров"},
	{x = -2093, y = 2312, name = "–обада"},
}

local cards = { --  оординаты игральных карт
    {x = -2374, y = 2215, name = "“уз „ервей"},
    {x = -1479, y = 2641, name = "ƒвойка „ервей"},
    {x = -1512, y = 1973, name = "“ройка „ервей"},
    {x = -1387, y = 1482, name = "ƒама Ѕубен"},
    {x = -732, y = 1539, name = "„етверка „ервей"},
    {x = -688, y = 938, name = "ѕ€терка „ервей"},
    {x = -237, y = 2664, name = "Ўестерка „ервей"},
    {x = -329, y = 1861, name = "¬осьмерка „ервей"},
    {x = 272, y = 2048, name = "—емерка „ервей"},
    {x = -346, y = 1608, name = "ƒев€тка „ервей"},
    {x = 247, y = 1386, name = "ƒес€тка „ервей"},
    {x = -102, y = 1135, name = "ƒес€тка Ѕубен"},
    {x = 312, y = 1147, name = "ƒев€тка Ѕубен"},
    {x = 711, y = 1985, name = "¬алет „ервей"},
    {x = 1064, y = 2168, name = "„етверка Ѕубен"},
    {x = 1098, y = 1686, name = "ѕ€терка Ѕубен"},
    {x = 1409, y = 2209, name = "“ройка Ѕубен"},
    {x = 1432, y = 2796, name = "ƒама „ервей"},
    {x = 1768, y = 2867, name = " ороль „ервей"},
    {x = 2199, y = 2425, name = "¬алет “реф"},
    {x = 2208, y = 2796, name = "“уз Ѕубен"},
    {x = 2544, y = 2805, name = "ƒвойка Ѕубен"},
    {x = 2517, y = 1568, name = "—емерка Ѕубен"},
    {x = 1619, y = 1158, name = "Ўестерка Ѕубен"},
    {x = 2228, y = 748, name = "¬осьмерка Ѕубен"},
    {x = 2765, y = 599, name = " ороль “реф"},
    {x = 2252, y = -71, name = "“уз “реф"},
    {x = 1316, y = 275, name = " ороль ѕик"},
    {x = 682, y = -469, name = "ƒвойка “реф"},
    {x = 200, y = -234, name = "ƒама ѕик"},
    {x = 2838, y = -2425, name = "“ройка “реф"},
    {x = 1475, y = -2287, name = "„етверка “реф"},
    {x = 1964, y = -1515, name = "ѕ€терка “реф"},
    {x = 1612, y = -1483, name = "¬осьмерка “реф"},
    {x = 681, y = -1525, name = "Ўестерка “реф"},
    {x = 1380, y = -807, name = "—емерка “реф"},
    {x = 2948, y = -1878, name = "ƒев€тка “реф"},
    {x = -1410, y = -2412, name = "¬алет ѕик"},
    {x = -1636, y = -2246, name = "¬осьмерка ѕик"},
    {x = -2035, y = -2348, name = "ƒес€тка “реф"},
    {x = -2639, y = -2184, name = "ƒама “реф(¬ текстурах)"},
    {x = -1995, y = -1552, name = "ƒев€тка ѕик"},
    {x = -2245, y = -1752, name = "—емерка ѕик"},
    {x = -2815, y = -1512, name = "ƒес€тка ѕик"},
    {x = -2482, y = -284, name = "ѕ€терка ѕик"},
    {x = -2452, y = 4, name = "„етверка ѕик"},
    {x = -2060, y = 253, name = "“ройка ѕик"},
    {x = -2947, y = 503, name = "ƒвойка ѕик"},
    {x = -2643, y = 845, name = "“уз ѕик"},
    {x = -2661, y = 1423, name = "¬алет Ѕубен"},
    {x = -2059, y = 891, name = " ороль Ѕубен"},
    {x = -1254, y = 49, name = "Ўестерка ѕик"}
}

local skin_texts = {
    "The Truth", "Big Bear fat", "Big Bear thin", "Andre", "Maccer", "Emmet",
    "Taxi Driver 1", "Janitor", "B-fori", "Casino croupier", "Rich Woman Black",
    "Street Girl", "B-mori", "Mr Whittaker", "Airport Worker", "Businessman 1",
    "Beach Visitor 1", "DJ", "Mad Doggs Manager", "B-mycr", "B-myst", "BMXer",
    "Bodyguard 1", "Bodyguard 2", "Construction Worker", "Drug Dealer 1",
    "Drug Dealer 2", "Drug Dealer 3", "Farmer 1", "Farmer 2", "Farmer 3",
    "Gardener", "Golfer 1", "Golfer 2", "H-fyri", "H-fyst", "Jethro", "H-mori",
    "H-most", "H-myri", "H-mycr", "H-myst", "Snakehead", "Mechanic", "O-fyri",
    "O-fyst", "Oriental 1", "O-myri", "O-myst", "Prostitute 1", "Kendl Johnson",
    "Scientist", "Security Guard", "Hippy 1", "Hippy 2", "Stewardess", "Black Elvis",
    "White Elvis", "Blue Elvis", "Jogger Girl", "Rich Woman White", "W-fyst",
    "W-most", "Jogger Man", "W-myri", "Biker 1", "W-myst", "Balla", "Groove",
    "LS Vagos", "Aztecas", "Da Nang White", "Da Nang Black", "The Mafia",
    "Farmer 4", "Farmer Woman", "Farmer 5", "Homeless 1", "Businesswoman",
    "Taxi Driver 2", "Pizza Worker", "Barber", "Cluckin Bell", "S-ofyri", "Rifa",
    "Ammunation", "Tattoo", "Punk", "S-wmyst", "Barbara Schternvart", "Helena Wankstein",
    "Michelle Cannes", "Katie Zhan", "Denise Robinson", "Hillbilly", "Farmer 6",
    "Cab Driver 1", "Clothes Shop staff", "Maria Latore", "Shop Staff Men",
    "Homeless 3", "The D.A", "Afro-American", "Biker 2", "Biker 3", "Pimp",
    "S-wmycr", "Biker Drug Dealer", "Cab driver 2", "Clown", "Tenpenny", "Pulaski",
    "Hernandez", "Sweet", "Ryder", "Mafia Boss", "T-Bone Mendez", "Firefighter 1",
    "Firefighter 2", "LAPD", "LVPD", "Country Sheriff", "S.W.A.T", "Army",
    "Desert Sheriff", "Zero", "Ken Rosenberg", "Kent Paul", "Cesar Vialpando",
    "OG Loc", "Woozie", "Michael Toreno", "Jizzy", "Madd Dogg", "Catalina",
    "Claude Speed", "LAPD Woman", "SFPD Woman"
}

local items = { -- —писок предметов
    [" астет"] = 60,
    ["Ћист железа"] = 1000,
    ["—ухой паек (»–ѕ)"] = 140,
    [" усок пиццы"] = 110,
	["The Truth"] = 500,
    ["Big Bear fat"] = 500,
    ["Big Bear thin"] = 500,
    ["Andre"] = 500,
	["Maccer"] = 500,
    ["Emmet"] = 500,
    ["Taxi Driver 1"] = 500,
    ["Janitor"] = 500,
	["B-fori"] = 500,
    ["Casino croupier"] = 500,
    ["Rich Woman Black"] = 500,
    ["Street Girl"] = 500,
	["B-mori"] = 500,
    ["Mr Whittaker"] = 500,
    ["Airport Worker"] = 500,
    ["Businessman 1"] = 500,
	["Beach Visitor 1"] = 500,
    ["DJ"] = 500,
    ["Mad Doggs Manager"] = 500,
    ["B-mycr"] = 500,
	["B-myst"] = 500,
    ["BMXer"] = 500,
    ["Bodyguard 1"] = 500,
    ["Bodyguard 2"] = 500,
	["Construction Worker"] = 500,
    ["Drug Dealer 1"] = 500,
    ["Drug Dealer 2"] = 500,
    ["Drug Dealer 3"] = 500,
	["Farmer 1"] = 500,
    ["Farmer 2"] = 500,
    ["Farmer 3"] = 500,
    ["Gardener"] = 500,
	["Golfer 1"] = 500,
    ["Golfer 2"] = 500,
    ["H-fyri"] = 500,
    ["H-fyst"] = 500,
	["Jethro"] = 500,
    ["H-mori"] = 500,
    ["H-most"] = 500,
    ["H-myri"] = 500,
	["H-mycr"] = 500,
    ["H-myst"] = 500,
    ["Snakehead"] = 500,
    ["Mechanic"] = 500,
	["O-fyri"] = 500,
    ["O-fyst"] = 500,
    ["Oriental 1"] = 500,
    ["O-myri"] = 500,
	["O-myst"] = 500,
    ["Prostitute 1"] = 500,
    ["Kendl Johnson"] = 500,
    ["Scientist"] = 500,
	["Security Guard"] = 500,
    ["Hippy 1"] = 500,
    ["Hippy 2"] = 500,
    ["Stewardess"] = 500,
	["Black Elvis"] = 500,
    ["White Elvis"] = 500,
    ["Blue Elvis"] = 500,
    ["Jogger Girl"] = 500,
	["Rich Woman White"] = 500,
    ["W-fyst"] = 500,
    ["W-most"] = 500,
    ["Jogger Man"] = 500,
	["W-myri"] = 500,
    ["Biker 1"] = 500,
	["W-myst"] = 500,
    ["Balla"] = 500,
    ["Groove"] = 500,
    ["LS Vagos"] = 500,
	["Aztecas"] = 500,
    ["Da Nang White"] = 500,
    ["Da Nang Black"] = 500,
    ["The Mafia"] = 500,
	["Farmer 4"] = 500,
    ["Farmer Woman"] = 500,
    ["Farmer 5"] = 500,
    ["Homeless 1"] = 500,
	["Businesswoman"] = 500,
    ["Taxi Driver 2"] = 500,
    ["Pizza Worker"] = 500,
    ["Barber"] = 500,
	["Cluckin Bell"] = 500,
    ["S-ofyri"] = 500,
    ["Rifa"] = 500,
    ["Ammunation"] = 500,
	["Tattoo"] = 500,
    ["Punk"] = 500,
    ["S-wmyst"] = 500,
    ["Barbara Schternvart"] = 500,
	["Helena Wankstein"] = 500,
    ["Michelle Cannes"] = 500,
    ["Katie Zhan"] = 500,
    ["Denise Robinson"] = 500,
	["Hillbilly"] = 500,
    ["Farmer 6"] = 500,
    ["Cab Driver 1"] = 500,
    ["Clothes Shop staff"] = 500,
	["Maria Latore"] = 500,
    ["Shop Staff Men"] = 500,
    ["Homeless 3"] = 500,
    ["The D.A"] = 500,
	["Afro-American"] = 500,
    ["Biker 2"] = 500,
    ["Biker 3"] = 500,
    ["Pimp"] = 500,
	["S-wmycr"] = 500,
    ["Biker Drug Dealer"] = 500,
    ["Cab driver 2"] = 500,
    ["Clown"] = 500,
	["Tenpenny"] = 500,
    ["Pulaski"] = 500,
    ["Hernandez"] = 500,
    ["Sweet"] = 500,
	["Ryder"] = 500,
    ["Mafia Boss"] = 500,
    ["T-Bone Mendez"] = 500,
    ["Firefighter 1"] = 500,
	["Firefighter 2"] = 500,
    ["LAPD"] = 500,
    ["LVPD"] = 500,
	["Country Sheriff"] = 500,
    ["S.W.A.T"] = 500,
    ["Army"] = 500,
    ["Desert Sheriff"] = 500,
	["Zero"] = 500,
    ["Ken Rosenberg"] = 500,
    ["Kent Paul"] = 500,
    ["Cesar Vialpando"] = 500,
	["OG Loc"] = 500,
    ["Woozie"] = 500,
    ["Michael Toreno"] = 500,
    ["Jizzy"] = 500,
	["Madd Dogg"] = 500,
    ["Catalina"] = 500,
    ["Claude Speed"] = 500,
    ["LAPD Woman"] = 500,
	["SFPD Woman"] = 500,
    ["ћинеральна€ вода"] = 80,
    ["Ѕиг бургер"] = 260,
    ["Ќож"] = 50,
	["Ѕинт"] = 40,
    ["Ѕургер"] = 125,
    ["ѕатрон 7.62мм"] = 3,
    [" люшка"] = 130,
	["ќбезболивающее"] = 160,
    ["Ёнергетик"] = 120,
    ["ѕиво"] = 110,
	["Beretta-SD-0 0%"] = 440,
    [" ий"] = 100,
    ["Ѕита"] = 125,
    ["Ћопата"] = 160,
	["ќбрез-0 0%"] = 650,
    ["јптечка"] = 240,
    ["ќтмычка"] = 170,
	["ѕицца"] = 340,
    ["TEC-DC9-0 0%"] = 900,
    ["ѕакет с едой"] = 310,
    ["“айник"] = 2500,
	["ѕатрон 8.61мм"] = 50,
    ["ƒубинка"] = 120,
    ["Remington-0 0%"] = 720,
	["UZI-0 0%"] = 780,
    ["Ѕиноколь"] = 1150,
    ["¬интовка —¬“-40-0 0%"] = 1040,
    ["ѕатрон 18.5мм"] = 8,
	["ƒрова"] = 50,
	[" атана"] = 350,
	["јрмейска€ аптечка"] = 500,
	["–аци€ (0 MHz)"] = 400,
	["»нструменты (новые)"] = 1800,
	["ѕатрон 12.7мм"] = 5,
	["ѕатрон 9мм"] = 5,
	["—лабый антирад"] = 60,
	["—ильный антирад"] = 85,
	["Glock 17-0 0%"] = 300,
	["Ѕензопила"] = 800,
	[" анистра (пуста€)"] = 1000,
	["Beretta-0 0%"] = 320,
}

local wquares = { --  оординаты квадратов в формате левый верхний - правый нижний
	C0 = {400, -3000, 2400, -2400, 3000},
	C1 = {400, -2400, 2400, -1800, 3000},
	C2 = {400, -1800, 2400, -1200, 3000},
	C3 = {400, -1200, 2400, -600, 3000},
	C4 = {400, -600, 2400, 0, 3000},
	C5 = {400, 0, 2400, 600, 3000},
	C6 = {400, 600, 2400, 1200, 3000},
	C7 = {400, 1200, 2400, 1800, 3000},
	C8 = {400, 1800, 2400, 2400, 3000},
	C9 = {400, 2400, 2400, 3000, 3000},
	E0 = {400, -3000, 1800, -2400, 2400},
	E1 = {400, -2400, 1800, -1800, 2400},
	E2 = {400, -1800, 1800, -1200, 2400},
	E3 = {400, -1200, 1800, -600, 2400},
	E4 = {400, -600, 1800, 0, 2400},
	E5 = {400, 0, 1800, 600, 2400},
	E6 = {400, 600, 1800, 1200, 2400},
	E7 = {400, 1200, 1800, 1800, 2400},
	E8 = {400, 1800, 1800, 2400, 2400},
	E9 = {400, 2400, 1800, 3000, 2400},
	F0 = {400, -3000, 1200, -2400, 1800},
	F1 = {400, -2400, 1200, -1800, 1800},
	F2 = {400, -1800, 1200, -1200, 1800},
	F3 = {400, -1200, 1200, -600, 1800},
	F4 = {400, -600, 1200, 0, 1800},
	F5 = {400, 0, 1200, 600, 1800},
	F6 = {400, 600, 1200, 1200, 1800},
	F7 = {400, 1200, 1200, 1800, 1800},
	F8 = {400, 1800, 1200, 2400, 1800},
	F9 = {400, 2400, 1200, 3000, 1800},
	H0 = {400, -3000, 600, -2400, 1200},
	H1 = {400, -2400, 600, -1800, 1200},
	H2 = {400, -1800, 600, -1200, 1200},
	H3 = {400, -1200, 600, -600, 1200},
	H4 = {400, -600, 600, 0, 1200},
	H5 = {400, 0, 600, 600, 1200},
	H6 = {400, 600, 600, 1200, 1200},
	H7 = {400, 1200, 600, 1800, 1200},
	H8 = {400, 1800, 600, 2400, 1200},
	H9 = {400, 2400, 600, 3000, 1200},
	L0 = {400, -3000, 0, -2400, 600},
	L1 = {400, -2400, 0, -1800, 600},
	L2 = {400, -1800, 0, -1200, 600},
	L3 = {400, -1200, 0, -600, 600},
	L4 = {400, -600, 0, 0, 600},
	L5 = {400, 0, 0, 600, 600},
	L6 = {400, 600, 0, 1200, 600},
	L7 = {400, 1200, 0, 1800, 600},
	L8 = {400, 1800, 0, 2400, 600},
	L9 = {400, 2400, 0, 3000, 600},
	O0 = {400, -3000, -600, -2400, 0},
	O1 = {400, -2400, -600, -1800, 0},
	O2 = {400, -1800, -600, -1200, 0},
	O3 = {400, -1200, -600, -600, 0},
	O4 = {400, -600, -600, 0, 0},
	O5 = {400, 0, -600, 600, 0},
	O6 = {400, 600, -600, 1200, 0},
	O7 = {400, 1200, -600, 1800, 0},
	O8 = {400, 1800, -600, 2400, 0},
	O9 = {400, 2400, -600, 3000, 0},
	P0 = {400, -3000, -1200, -2400, -600},
	P1 = {400, -2400, -1200, -1800, -600},
	P2 = {400, -1800, -1200, -1200, -600},
	P3 = {400, -1200, -1200, -600, -600},
	P4 = {400, -600, -1200, 0, -600},
	P5 = {400, 0, -1200, 600, -600},
	P6 = {400, 600, -1200, 1200, -600},
	P7 = {400, 1200, -1200, 1800, -600},
	P8 = {400, 1800, -1200, 2400, -600},
	P9 = {400, 2400, -1200, 3000, -600},
	S0 = {400, -3000, -1800, -2400, -1200},
	S1 = {400, -2400, -1800, -1800, -1200},
	S2 = {400, -1800, -1800, -1200, -1200},
	S3 = {400, -1200, -1800, -600, -1200},
	S4 = {400, -600, -1800, 0, -1200},
	S5 = {400, 0, -1800, 600, -1200},
	S6 = {400, 600, -1800, 1200, -1200},
	S7 = {400, 1200, -1800, 1800, -1200},
	S8 = {400, 1800, -1800, 2400, -1200},
	S9 = {400, 2400, -1800, 3000, -1200},
	T0 = {400, -3000, -2400, -2400, -1800},
	T1 = {400, -2400, -2400, -1800, -1800},
	T2 = {400, -1800, -2400, -1200, -1800},
	T3 = {400, -1200, -2400, -600, -1800},
	T4 = {400, -600, -2400, 0, -1800},
	T5 = {400, 0, -2400, 600, -1800},
	T6 = {400, 600, -2400, 1200, -1800},
	T7 = {400, 1200, -2400, 1800, -1800},
	T8 = {400, 1800, -2400, 2400, -1800},
	T9 = {400, 2400, -2400, 3000, -1800},
	U0 = {400, -3000, -3000, -2400, -2400},
	U1 = {400, -2400, -3000, -1800, -2400},
	U2 = {400, -1800, -3000, -1200, -2400},
	U3 = {400, -1200, -3000, -600, -2400},
	U4 = {400, -600, -3000, 0, -2400},
	U5 = {400, 0, -3000, 600, -2400},
	U6 = {400, 600, -3000, 1200, -2400},
	U7 = {400, 1200, -3000, 1800, -2400},
	U8 = {400, 1800, -3000, 2400, -2400},
	U9 = {400, 2400, -3000, 3000, -2400},

}

local squares = { --  оординаты квадратов в формате центр квадрата
    C0 = {-2700, 2700},
    C1 = {-2100, 2700},
    C2 = {-1500, 2700},
    C3 = {-900, 2700},
    C4 = {-300, 2700},
	C5 = {300, 2700},
	C6 = {900, 2700},
	C7 = {1500, 2700},
	C8 = {2100, 2700},
	C9 = {2700, 2700},
    E0 = {-2700, 2100},
    E1 = {-2100, 2100},
    E2 = {-1500, 2100},
    E3 = {-900, 2100},
    E4 = {-300, 2100},
	E5 = {300, 2100},
	E6 = {900, 2100},
	E7 = {1500, 2100},
	E8 = {2100, 2100},
	E9 = {2700, 2100},
	F0 = {-2700, 1500},
    F1 = {-2100, 1500},
    F2 = {-1500, 1500},
    F3 = {-900, 1500},
    F4 = {-300, 1500},
	F5 = {300, 1500},
	F6 = {900, 1500},
	F7 = {1500, 1500},
	F8 = {2100, 1500},
	F9 = {2700, 1500},
	H0 = {-2700, 900},
    H1 = {-2100, 900},
    H2 = {-1500, 900},
    H3 = {-900, 900},
    H4 = {-300, 900},
	H5 = {300, 900},
	H6 = {900, 900},
	H7 = {1500, 900},
	H8 = {2100, 900},
	H9 = {2700, 900},
	L0 = {-2700, 300},
    L1 = {-2100, 300},
    L2 = {-1500, 300},
    L3 = {-900, 300},
    L4 = {-300, 300},
	L5 = {300, 300},
	L6 = {900, 300},
	L7 = {1500, 300},
	L8 = {2100, 300},
	L9 = {2700, 300},
	O0 = {-2700, -300},
    O1 = {-2100, -300},
    O2 = {-1500, -300},
    O3 = {-900, -300},
    O4 = {-300, -300},
	O5 = {300, -300},
	O6 = {900, -300},
	O7 = {1500, -300},
	O8 = {2100, -300},
	O9 = {2700, -300},
	P0 = {-2700, -900},
    P1 = {-2100, -900},
    P2 = {-1500, -900},
    P3 = {-900, -900},
    P4 = {-300, -900},
	P5 = {300, -900},
	P6 = {900, -900},
	P7 = {1500, -900},
	P8 = {2100, -900},
	P9 = {2700, -900},
	S0 = {-2700, -1500},
    S1 = {-2100, -1500},
    S2 = {-1500, -1500},
    S3 = {-900, -1500},
    S4 = {-300, -1500},
	S5 = {300, -1500},
	S6 = {900, -1500},
	S7 = {1500, -1500},
	S8 = {2100, -1500},
	S9 = {2700, -1500},
	T0 = {-2700, -2100},
    T1 = {-2100, -2100},
    T2 = {-1500, -2100},
    T3 = {-900, -2100},
    T4 = {-300, -2100},
	T5 = {300, -2100},
	T6 = {900, -2100},
	T7 = {1500, -2100},
	T8 = {2100, -2100},
	T9 = {2700, -2100},
	U0 = {-2700, -2700},
    U1 = {-2100, -2700},
    U2 = {-1500, -2700},
    U3 = {-900, -2700},
    U4 = {-300, -2700},
	U5 = {300, -2700},
	U6 = {900, -2700},
	U7 = {1500, -2700},
	U8 = {2100, -2700},
	U9 = {2700, -2700},
}

local blockTextDrawList = { -- —писок текстдравов
    2050,
    0,
    2051,
    8,
    4,
    6,
    10,
    62,
    1,
    2,
    3,
    5,
    7,
    9,
    2052,
    2054,
    2055,
    2056,
    2057,
    2065,
    2066,
    2067,
    2058,
    2233,
    2277,
    427,
    2060,
    25,
    11,
    63,
    64,
    2237,
    2048,
    2049,
    2068
}

local RussianTextGame = { -- »ероглифы в русский
    { a = 'б', b = 'Ч' },
    { a = 'Ѕ', b = 'А' },
    { a = 'в', b = 'Ґ' },
    { a = '¬', b = 'Л' },
    { a = 'г', b = 'Щ' },
    { a = '√', b = 'В' },
    { a = 'д', b = 'Ъ' },
    { a = 'ƒ', b = 'Г' },
    { a = 'е', b = 'e' },
    { a = '≈', b = 'E' },
    { a = 'Є', b = 'e' },
    { a = '®', b = 'E' },
    { a = 'ж', b = 'Ы' },
    { a = '∆', b = 'Д' },
    { a = 'з', b = 'Я' },
    { a = '«', b = 'И' },
    { a = 'и', b = 'Ь' },
    { a = '»', b = 'Е' },
    { a = 'й', b = 'Э' },
    { a = '…', b = 'Е' },
    { a = 'к', b = 'k' },
    { a = ' ', b = 'K' },
    { a = 'л', b = 'Ю' },
    { a = 'Ћ', b = 'З' },
    { a = 'м', b = 'ѓ' },
    { a = 'ћ', b = 'M' },
    { a = 'н', b = 'Ѓ' },
    { a = 'Ќ', b = 'H' },
    { a = 'о', b = 'o' },
    { a = 'ќ', b = 'O' },
    { a = 'п', b = '£' },
    { a = 'ѕ', b = 'М' },
    { a = 'р', b = 'p' },
    { a = '–', b = 'P' },
    { a = 'с', b = 'c' },
    { a = '—', b = 'C' },
    { a = 'т', b = '¶' },
    { a = '“', b = 'П' },
    { a = 'у', b = 'y' },
    { a = '”', b = 'Y' },
    { a = 'ф', b = '?' },
    { a = '‘', b = 'Б' },
    { a = 'х', b = 'x' },
    { a = '’', b = 'X' },
    -- { a = 'ц', b = '$' },
    { a = '÷', b = 'Й' },
    { a = 'ч', b = '§' },
    { a = '„', b = 'Н' },
    { a = 'ш', b = '•' },
    { a = 'Ў', b = 'О' },
    { a = 'щ', b = '°' },
    { a = 'ў', b = 'К' },
    { a = 'ь', b = '©' },
    { a = '№', b = 'Т' },
    { a = 'ъ', b = 'Р' },
    { a = 'Џ', b = 'І' },
    { a = 'ы', b = '®' },
    { a = 'џ', b = 'С' },
    { a = 'э', b = '™' },
    { a = 'Ё', b = 'У' },
    { a = 'ю', b = 'Ђ' },
    { a = 'ё', b = 'Ф' },
    { a = '€', b = 'ђ' },
    { a = 'я', b = 'Х' }
}

local invSlotsAll = { -- —писок текстдравов инвентар€
    -- 1 строка
    { x = 137, y = 179},
    { x = 282, y = 179},
    { x = 432, y = 179},
    -- 2 строка
    { x = 137, y = 209},
    { x = 282, y = 209},
    { x = 432, y = 209},
    -- 3 строка
    { x = 137, y = 239},
    { x = 282, y = 239},
    { x = 432, y = 239},
    -- 4 строка
    { x = 137, y = 269},
    { x = 282, y = 269},
    { x = 432, y = 269},
    -- 5 строка
    { x = 137, y = 299},
    { x = 282, y = 299},
    { x = 432, y = 299},
    -- 6 строка
    { x = 137, y = 329},
    { x = 282, y = 329},
    { x = 432, y = 329},
}

local leftSlots = { -- —писок текстдравов левое меню
    { x = 36, y = 149 },
    { x = 36, y = 181 },
    { x = 39, y = 214 },
    { x = 41, y = 247 },
    { x = 42, y = 279 },
    { x = 38, y = 312 },
    { x = 36, y = 345 }
}
--								____ ____ _  _ ____    ____ _  _ ___     _    ____ ____ ___ 
--								[__  |__| |  | |___    |__| |\ | |  \    |    |  | |__| |  \
--								___] |  |  \/  |___    |  | | \| |__/    |___ |__| |  | |__/


local mainIni = inicfg.load({
    settings = {
        scriptName = u8'khelp',
		keyactiv = 'CUB',
		jetpackfast = 'VK_J',
		benzfast = 'VK_B',
		osnovnoe = 'VK_3',
		vtorostepennoe = 'VK_2',
		aptechka = 'VK_O',
		antirad = 'VK_P',
		bint = 'VK_L',
		inventar = 'VK_I',
		osnovnoeokno = 'J',
		findcub = 'cub',
		globalText = '-',
		yeban = '1',
		razdelitel = '%',
		podborpassword = u8'help',
		parolinonestroka = '10',
		kolichestvoRazdelitelnihStrok = '1',
		prozrachnost = '0x11B61E17',
		skillcolor = '0x90FF0000',
		skillcolorall = '0x20FF0000',
		textcolor = '0x90FF0000',
		anomalyzonecolor = '0x7500FF32',
    },
	checkboxs = {
		checked_test = false,
		checked_test_2 = false,
		checked_test_3 = false,
		checked_test_4 = false,
		checked_test_5 = false,
		checked_test_6 = false,
		checked_test_7 = false,
		checked_test_8 = false,
		checked_test_9 = false,
		checked_test_10 = false,
		checked_test_11 = false,
		checked_test_12 = false,
		checked_test_13 = false,
		checked_test_14 = false,
		checked_test_15 = false,
		checked_test_16 = false,
		checked_test_66 = false, -- тайник
		checked_test_17 = false,
		checked_test_18 = false,
		checked_test_19 = false,
		checked_test_20 = false,
		checked_test_21 = false,
		checked_test_22 = false,
		checked_test_23 = false,
		checked_test_24 = false,
		checked_test_25 = false,
		checked_test_26 = false,
		checked_test_27 = false,
		checked_test_28 = false,
		checked_test_29 = false,
		checked_test_30 = false,
		checked_test_31 = false,
		checked_test_32 = false,
		checked_test_33 = false,
		checked_test_34 = false,
		checked_test_35 = false,
		checked_test_36 = false,
		checked_test_37 = false,
		checked_test_38 = false,
		checked_test_39 = false,
		checked_test_40 = false,
		checked_test_41 = false,
		checked_test_42 = false,
		checked_test_43 = false,
		checked_test_44 = false, -- алко
		checked_test_45 = false, -- малый набор
		checked_test_46 = false, -- белый набор
		checked_test_47 = false,
		checked_test_48 = false,
	},
	SimulyatorOpen = {
		wallet = 0.0000, 
	},
	con4index = {
		currentIndex2 = 1, -- Ќомер оазиса в таблице anomalylocations
		currentIndex1 = 1, -- Ќомер оазиса в таблице oazis
		currentIndex = 1, -- Ќомер карты в таблице Card
	},
	selected = 1,
	textdrawslovo = {
		trunkFound = 0, -- ѕеременна€ если найдено слово "Ѕагажник"
		torgovec = 0, -- ѕеременна€ если найдено слово "“орговец"
	},
	house = {
		totalItems = 0, -- ¬сего предметов
		totalProfit = 0, -- ¬сего прибыль
		totalMoneyAdded = 0, -- ¬сего денег
	},
	jail = {
		totalSeconds = 0, -- ќсталось секунд
		result = 0, -- ќтнесено камней
		kamni = 0, -- ќсталось камней до выхода
		foodCounter = 10, -- осталось камней до поулчени€ еды
	},
	KAZIK = {
		kazinozero = 0,
		kazinofrukti = 0,
		kazinovisnya = 0,
		kazinokolokol = 0,
		kazinosemerky = 0,
		kazinodvevisni = 0,
		kazinokolokola = 0,
		totalstavok = 0,
	},
	EXP = {
		totalSum = 0,
		simpleExpSum = 0,
		artifactsSum = 0,
		zombiesSum = 0,
		riaSum = 0,
	},
	TIR = {
		currentScore = 0,
		timeLeft = 0,
		Head = 0,
		Body = 0,
		previousScore = 0,
		wins = 0,
		lose = 0,
		totalshots = 0,
		previousNumber = 0,
		miss = 0,
		money = 0,
	},
	ART = {
		totalsummart = 0,
		totalcollect = 0,
		kost = 0,
		yadro = 0,
		lych = 0,
		zerkalo = 0,
		yantar = 0,
		gilza = 0,
		dysha = 0,
		oskolok = 0,
		glaz = 0,
		batareika = 0,
		krov = 0,
		panaceya = 0,
		linza = 0,
		pandora = 0,
		nota = 0,
	},
}, 'tychagova')

local function getRandomQuantity(min, max)
    return math.random(min, max)
end

-- ‘ункци€ дл€ генерации случайного предмета на основе шансов
local function getRandomItem()
    local totalChance = 0
    for _, item in ipairs(itemchans) do
        totalChance = totalChance + item.chance
    end

    print("Total Chance: " .. totalChance)  -- ќтладочное сообщение

    local rand = math.random() * totalChance
    print("Random Number: " .. rand)  -- ќтладочное сообщение

    local cumulativeChance = 0

    for _, item in ipairs(itemchans) do
        cumulativeChance = cumulativeChance + item.chance
        if rand <= cumulativeChance then
            print("Selected Item: " .. item.name)  -- ќтладочное сообщение
            local quantity = getRandomQuantity(item.colvo_min, item.colvo_max)
            return {name = item.name, quantity = quantity, cost = item.cost}
        end
    end

    return nil -- Ќа случай, если что-то пойдет не так
end  

local image = imgui.CreateTextureFromFile(getWorkingDirectory() .. '/khelper.png') 
local image1 = imgui.CreateTextureFromFile(getWorkingDirectory() .. '/khelperback.png') 
local earnedMoney = 0  -- ѕеременна€ дл€ хранени€ заработанной суммы

--								_  _ ____ _ _  _ _ _  _ _    ____ ____ ___ ___ _ _  _ ____ ____
--								|\/| |__| | |\ | | |\ | |    [__  |___  |   |  | |\ | | __ [__ 
--								|  | |  | | | \| | | \| |    ___] |___  |   |  | | \| |__] ___]
local savesettings = {
	anomalyzonecolor = imgui.ImBuffer(''..mainIni.settings.anomalyzonecolor, 256),
	textcolor = imgui.ImBuffer(''..mainIni.settings.textcolor, 256),
	skillcolorall = imgui.ImBuffer(''..mainIni.settings.skillcolorall, 256),
	skillcolor = imgui.ImBuffer(''..mainIni.settings.skillcolor, 256),
	prozrachnost = imgui.ImBuffer(''..mainIni.settings.prozrachnost, 256), -- Ќазвание скрипта
 	kolichestvoRazdelitelnihStrok = imgui.ImBuffer(''..mainIni.settings.kolichestvoRazdelitelnihStrok, 256), -- Ќазвание скрипта
	parolinonestroka = imgui.ImBuffer(''..mainIni.settings.parolinonestroka, 256), -- Ќазвание скрипта
	podborpassword = imgui.ImBuffer(''..mainIni.settings.podborpassword, 256), -- Ќазвание скрипта
	yeban = imgui.ImBuffer(''..mainIni.settings.yeban, 5),
	razdelitel = imgui.ImBuffer(mainIni.settings.razdelitel, 5),
	findcub = imgui.ImBuffer(mainIni.settings.findcub, 5), -- ќткрыть основное окно
	osnovnoeokno = imgui.ImBuffer(mainIni.settings.osnovnoeokno, 5), -- ќткрыть основное окно
	scriptName = imgui.ImBuffer(mainIni.settings.scriptName, 256), -- Ќазвание скрипта
	keyactiv = imgui.ImBuffer(mainIni.settings.keyactiv, 256), -- —крытие квадрата
	jetpackfast = imgui.ImBuffer(mainIni.settings.jetpackfast, 5), -- »спользовать джетпак
 	benzfast = imgui.ImBuffer(mainIni.settings.benzfast, 5), -- »спользовать бензопилу
 	osnovnoe = imgui.ImBuffer(mainIni.settings.osnovnoe, 5), -- »спользовать основное 
 	vtorostepennoe = imgui.ImBuffer(mainIni.settings.vtorostepennoe, 5), -- »спользовать  второстепенное
 	aptechka = imgui.ImBuffer(mainIni.settings.aptechka, 5), -- »спользовать аптечку
 	antirad = imgui.ImBuffer(mainIni.settings.antirad, 5), -- »спользовать антирад
 	bint = imgui.ImBuffer(mainIni.settings.bint, 5), -- »спользовать бинт
 	inventar = imgui.ImBuffer(mainIni.settings.inventar, 5), -- ќткрыть инвентарь
}

savesettings.anomalyzonecolor.v = mainIni.settings.anomalyzonecolor
savesettings.textcolor.v = mainIni.settings.textcolor
savesettings.skillcolorall.v = mainIni.settings.skillcolorall
savesettings.skillcolor.v = mainIni.settings.skillcolor
savesettings.prozrachnost.v = mainIni.settings.prozrachnost
savesettings.kolichestvoRazdelitelnihStrok.v = mainIni.settings.kolichestvoRazdelitelnihStrok
savesettings.parolinonestroka.v = mainIni.settings.parolinonestroka
savesettings.yeban.v = mainIni.settings.yeban
savesettings.razdelitel.v = mainIni.settings.razdelitel
savesettings.findcub.v = mainIni.settings.findcub
savesettings.osnovnoeokno.v = mainIni.settings.osnovnoeokno
savesettings.keyactiv.v = mainIni.settings.keyactiv
savesettings.jetpackfast.v = mainIni.settings.jetpackfast
savesettings.benzfast.v = mainIni.settings.benzfast
savesettings.osnovnoe.v = mainIni.settings.osnovnoe
savesettings.vtorostepennoe.v = mainIni.settings.vtorostepennoe
savesettings.aptechka.v = mainIni.settings.aptechka
savesettings.antirad.v = mainIni.settings.antirad
savesettings.inventar.v = mainIni.settings.inventar
savesettings.bint.v = mainIni.settings.bint









--								____ _  _ ____ ____ _  _ ___  ____ _  _
--								|    |__| |___ |    |_/  |__] |  |  \/ 
--								|___ |  | |___ |___ | \_ |__] |__| _/\_

globalText = ""

local checboxingeb = {
 checked_test = imgui.ImBool(mainIni.checkboxs.checked_test), -- јвтоматический	поднимать артефакты,
 checked_test_2 = imgui.ImBool(mainIni.checkboxs.checked_test_2), -- јвтоматический использовать аптечку
 checked_test_3 = imgui.ImBool(mainIni.checkboxs.checked_test_3), -- јвтоматический использовать еду,
 checked_test_4 = imgui.ImBool(mainIni.checkboxs.checked_test_4), -- јвтоматический использовать антирад
 checked_test_5 = imgui.ImBool(mainIni.checkboxs.checked_test_5), -- јвтоматический лутание домов
 checked_test_6 = imgui.ImBool(mainIni.checkboxs.checked_test_6), -- јвтозакрытие транспорта при выходе
 checked_test_7 = imgui.ImBool(mainIni.checkboxs.checked_test_7), -- —тавить метку на квадрат аирдропа
 checked_test_8 = imgui.ImBool(mainIni.checkboxs.checked_test_8), -- “аймер до ‘ѕ
 checked_test_9 = imgui.ImBool(mainIni.checkboxs.checked_test_9), --  ¬ключить калькул€тор прибыли[ƒома]
 checked_test_10 = imgui.ImBool(mainIni.checkboxs.checked_test_10), -- ќтображать кол-во предметов
 checked_test_11 = imgui.ImBool(mainIni.checkboxs.checked_test_11), -- ќтображать прибыль
 checked_test_12 = imgui.ImBool(mainIni.checkboxs.checked_test_12), -- ќтображать подн€тых денег
 checked_test_13 = imgui.ImBool(mainIni.checkboxs.checked_test_13), --	јвтопродажа Delirium
 checked_test_14 = imgui.ImBool(mainIni.checkboxs.checked_test_14), --	јвтоперенос Delirium
 checked_test_15 = imgui.ImBool(mainIni.checkboxs.checked_test_15), -- ќтображать кол-во камней[“юрьма]
 checked_test_16 = imgui.ImBool(mainIni.checkboxs.checked_test_16), -- јвторешение уравнений[ƒома]
 checked_test_66 = imgui.ImBool(mainIni.checkboxs.checked_test_66), -- јвтоподбор цифр[“айник]
 checked_test_17 = imgui.ImBool(mainIni.checkboxs.checked_test_17), -- —татистика казино
 checked_test_24 = imgui.ImBool(mainIni.checkboxs.checked_test_24), -- ќтображать без выиграша
 checked_test_25 = imgui.ImBool(mainIni.checkboxs.checked_test_25), -- ќтображать фрукты
 checked_test_26 = imgui.ImBool(mainIni.checkboxs.checked_test_26), -- ќтображать вишн€
 checked_test_27 = imgui.ImBool(mainIni.checkboxs.checked_test_27), -- ќтображать две колокола
 checked_test_28 = imgui.ImBool(mainIni.checkboxs.checked_test_28), -- ќтображать семерки
 checked_test_29 = imgui.ImBool(mainIni.checkboxs.checked_test_29), -- ќтображать две вишни
 checked_test_30 = imgui.ImBool(mainIni.checkboxs.checked_test_30), -- ќтображать колокола
 checked_test_31 = imgui.ImBool(mainIni.checkboxs.checked_test_31), -- ќтображать всего ставок
 checked_test_18 = imgui.ImBool(mainIni.checkboxs.checked_test_18), -- —татистика опыт
 checked_test_19 = imgui.ImBool(mainIni.checkboxs.checked_test_19), -- ќтображать ѕрочий опыт
 checked_test_20 = imgui.ImBool(mainIni.checkboxs.checked_test_20), -- ќтображать опыт за артефакты
 checked_test_21 = imgui.ImBool(mainIni.checkboxs.checked_test_21), -- ќтображать опыт за зомби
 checked_test_22 = imgui.ImBool(mainIni.checkboxs.checked_test_22), -- ќтображать опыт за RIA
 checked_test_23 = imgui.ImBool(mainIni.checkboxs.checked_test_23), -- ќтображать всего опыта
 checked_test_32 = imgui.ImBool(mainIni.checkboxs.checked_test_32), -- —татистика тир
 checked_test_33 = imgui.ImBool(mainIni.checkboxs.checked_test_33), -- ÷ены в названии
 checked_test_34 = imgui.ImBool(mainIni.checkboxs.checked_test_34), -- окно подбора парол€
 checked_test_35 = imgui.ImBool(mainIni.checkboxs.checked_test_35), -- ќтображать подсказку 
 checked_test_36 = imgui.ImBool(mainIni.checkboxs.checked_test_36), -- ќтображать использованные дешифраторы 
 checked_test_37 = imgui.ImBool(mainIni.checkboxs.checked_test_37), -- ќтображать использованные дешифраторы 
 checked_test_38 = imgui.ImBool(mainIni.checkboxs.checked_test_38),
 checked_test_39 = imgui.ImBool(mainIni.checkboxs.checked_test_39),
 checked_test_40 = imgui.ImBool(mainIni.checkboxs.checked_test_40),
 checked_test_41 = imgui.ImBool(mainIni.checkboxs.checked_test_41),
 checked_test_42 = imgui.ImBool(mainIni.checkboxs.checked_test_42),
 checked_test_43 = imgui.ImBool(mainIni.checkboxs.checked_test_43),
 checked_test_44 = imgui.ImBool(mainIni.checkboxs.checked_test_44),
 checked_test_45 = imgui.ImBool(mainIni.checkboxs.checked_test_45),
 checked_test_46 = imgui.ImBool(mainIni.checkboxs.checked_test_46),
 checked_test_47 = imgui.ImBool(mainIni.checkboxs.checked_test_47),
 checked_test_48 = imgui.ImBool(mainIni.checkboxs.checked_test_48),
}
--								_ _  _ ____ _  _ _    _  _ ____ _  _ _  _
--								| |\/| | __ |  | |    |\/| |___ |\ | |  |
--								| |  | |__] |__| |    |  | |___ | \| |__|

showMainWind = imgui.ImBool(false)  -- ќсновное окно
showWind_2 = imgui.ImBool(false) --  алькул€тор прибыли[ƒома]
showWind_3 = imgui.ImBool(false) -- —татистика[тюрьма]
showWind_4 = imgui.ImBool(false) -- —татистика[ азино]
showWind_5 = imgui.ImBool(false) -- —татистика[ќпыт]
showWind_6 = imgui.ImBool(false) -- —татистика[“ир]
showWind_7 = imgui.ImBool(false)
showWind_8 = imgui.ImBool(false)
showWind_9 = imgui.ImBool(false)
showWind_10 = imgui.ImBool(false)
local sw, sh = getScreenResolution() -- ѕозици€ окна
--								____ _    ____ ___  ____ _       _    ____ ____ ____ _   
--								| __ |    |  | |__] |__| |       |    |  | |    |__| |   
--								|__] |___ |__| |__] |  | |___    |___ |__| |___ |  | |___
local output = ''
local cancel, enter = { x = 192, y = 339 }, { x = 375, y = 339 }
local exit = { x = 522, y = 149}
local opentotal = 0

--								____ ____ ____ ___    _  _ ____ ____
--								|___ |__| [__   |     |  | [__  |___
--								|    |  | ___]  |     |__| ___] |___

local keybind = {
    [mainIni.settings.jetpackfast] = function()
        invOpenAndWait()
        local txd = getTextdrawByPos(leftSlots[7].x, leftSlots[7].y)
        if txd.modelId == 370 then -- —н€ть
            af = 0
            id_7_slot = txd.textdrawId
            txd = getTextdrawByPos(cancel.x, cancel.y)
            repeat
                wait(0)
                if af == nil or os.time() - af > 3 then
                    sampSendClickTextdraw(id_7_slot)
                    af = os.time()
                end
                txd = getTextdrawByPos(cancel.x, cancel.y)
            until txd ~= nil

            sampSendClickTextdraw(txd.textdrawId)

            repeat
                wait(0)
                txd = getTextdrawByPos(cancel.x, cancel.y)
            until txd == nil

            af = nil
            repeat
                wait(0)
                txd = getTextdrawByPos(exit.x, exit.y)
                if txd ~= nil and (af == nil or os.time() - af > 3) then
                    sampSendClickTextdraw(txd.textdrawId)
                    af = os.time()
                end
            until txd == nil
        else
            wait(500)
            local jetTxdId = -1
            local jetData = {}
            for k,v in pairs(textdraw) do
                if v.text:find("Jetpack") then
                    jetTxdId = v.textdrawId
                    jetData = v
                    break
                end
            end
            if jetTxdId ~= -1 then
                af = nil
                repeat
                    wait(0)
                    if af == nil or os.time() - af > 3 then
                        sampSendClickTextdraw(jetTxdId)
                        af = os.time()
                    end
                    txd = getTextdrawByPos(cancel.x, cancel.y)
                until txd == nil
                af = nil
                repeat
                    wait(0)
                    txd = getTextdrawByPos(cancel.x, cancel.y)
                    if txd ~= nil and (af == nil or os.time() - af > 3) then
                        sampSendClickTextdraw(txd.textdrawId)
                        af = os.time()
                    end
                until txd ~= nil
            end
        end
    end,
    [mainIni.settings.benzfast] = function()
        invOpenAndWait()
        local txd = getTextdrawByPos(leftSlots[5].x, leftSlots[5].y)
        if txd.modelId == 341 then -- —н€ть пилу
            af = 0
            id_7_slot = txd.textdrawId
            txd = getTextdrawByPos(cancel.x, cancel.y)
            repeat
                wait(0)
                if af == nil or os.time() - af > 3 then
                    sampSendClickTextdraw(id_7_slot)
                    af = os.time()
                end
                txd = getTextdrawByPos(cancel.x, cancel.y)
            until txd ~= nil

            sampSendClickTextdraw(txd.textdrawId)

            repeat
                wait(0)
                txd = getTextdrawByPos(cancel.x, cancel.y)
            until txd == nil

            af = nil
            repeat
                wait(0)
                txd = getTextdrawByPos(exit.x, exit.y)
                if txd ~= nil and (af == nil or os.time() - af > 3) then
                    sampSendClickTextdraw(txd.textdrawId)
                    af = os.time()
                end
            until txd == nil
        else
            repeat 
                wait(0)
            until os.clock() * 1000 - antiflood_textdraw > 100
            local jetTxdId = -1
            local jetData = {}
            for k,v in pairs(textdraw) do
                if v.textRu:find("Ѕензопилa") then
                    jetTxdId = v.textdrawId
                    jetData = v
                    break
                end
            end
            if jetTxdId ~= -1 then
                af = nil
                repeat
                    wait(0)
                    if af == nil or os.time() - af > 3 then
                        sampSendClickTextdraw(jetTxdId)
                        af = os.time()
                    end
                    txd = getTextdrawByPos(cancel.x, cancel.y)
                until txd == nil
                af = nil
                repeat
                    wait(0)
                    txd = getTextdrawByPos(cancel.x, cancel.y)
                    if txd ~= nil and (af == nil or os.time() - af > 3) then
                        sampSendClickTextdraw(txd.textdrawId)
                        af = os.time()
                    end
                until txd ~= nil
            end
        end
    end,
    [mainIni.settings.osnovnoe] = function()
        sampSendChat(" 3")
    end,
    [mainIni.settings.vtorostepennoe] = function()
        sampSendChat(" 2")
    end,
    [mainIni.settings.aptechka] = function()
        sampSendChat(" а")
    end,
    [mainIni.settings.antirad] = function()
        sampSendChat(" р")
    end,
    [mainIni.settings.inventar] = function()
        sampSendClickTextdraw(49)
    end,
    [mainIni.settings.bint] = function()
        sampSendChat(" б")
    end,

}
--								_  _ ____ _ _  _
--								|\/| |__| | |\ |
--								|  | |  | | | \|

if not doesFileExist('moonloader/config/tychagova.ini') then inicfg.save(mainIni, 'tychagova.ini') end

function main()
if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
	textdraw = {}
    antiflood_textdraw = 0

    sampAddChatMessage('[KHelper] {D5DEDD}—крипт загружен, верси€: 1.0', 0x00befc)
	sampAddChatMessage('[KHelper] {D5DEDD}јктиваци€: кнопка ' ..mainIni.settings.osnovnoeokno .. ' или /' ..mainIni.settings.scriptName, 0x00befc)
	sampRegisterChatCommand(mainIni.settings.scriptName, function()
        showMainWind.v = not showMainWind.v
    end)
	sampRegisterChatCommand(mainIni.settings.podborpassword, handleHelpCommand)
	while true do
        wait(0)
		if checboxingeb.checked_test_35.v then
		renderFontDrawText(font, "NOT:        AND:        OR:        XOR:\n1 = 0      10 = 0     00 = 0     11 = 0\n0 = 1      11 = 1     01 = 1     00 = 0\n                                           10 = 1\n                                           01 = 1", 75, 450, -1)
		end
		if checboxingeb.checked_test_37.v then
			if testCheat('log') then
				print(data)
			end
		end
		if checboxingeb.checked_test_36.v then
			renderFontDrawText(font, "»спользованные дешифраторы: " .. usedDecoders, 75, 550, -1)
		end
		if checboxingeb.checked_test_38.v then
			if sampTextdrawIsExists(41) then
				renderFontDrawText(font, "ƒо конца капта осталось: " .. textkapt, 80, 610, -1)
			end
		end
		if checboxingeb.checked_test_41.v then
			local ammo = getAmmoInClip()
			sampTextdrawCreate(2000, "~g~" .. ammo, 505, 100)
		else
			sampTextdrawDelete(2000)
		end
		if not sampIsDialogActive() and not sampIsChatInputActive() and not sampIsCursorActive() then
            for k,v in pairs(keybind) do
                if wasKeyPressed(key[k]) then
                    v()
                end
            end
        end
		if testCheat(mainIni.settings.osnovnoeokno) then -- активаци€ по нажатию клавиши X
			showMainWind.v = not showMainWind.v -- переключаем статус активности окна, не забываем про .v
		end
		imgui.Process = showMainWind.v or showWind_2.v or showWind_3.v or showWind_4.v or showWind_5.v or showWind_6.v or showWind_7.v or showWind_8.v or showWind_9.v or showWind_10.v
		if testCheat(savesettings.keyactiv.v) then
			remGZ()
		end
		if checboxingeb.checked_test_39.v then
			for i, objid in pairs(getAllObjects()) do
				for iid = 1, #iskl do
					pX, pY, pZ = getCharCoordinates(PLAYER_PED)
					_, objX, objY, objZ = getObjectCoordinates(objid)
					local ddist = getDistanceBetweenCoords3d(pX, pY, pZ, objX, objY, objZ)
					if ddist < dist_visible and object_visible[objid] ~= false and tonumber(getObjectModel(objid)) ~= iskl[iid] then
						setObjectVisible(objid, false)
						object_visible[objid] = false
					end
				end
			end
		else
			for i, objid in pairs(getAllObjects()) do
				for iid = 1, #iskl do
					if object_visible[objid] == false then
						pX, pY, pZ = getCharCoordinates(PLAYER_PED)
						_, objX, objY, objZ = getObjectCoordinates(objid)
						local ddist = getDistanceBetweenCoords3d(pX, pY, pZ, objX, objY, objZ)
						if object_visible[objid] == false and tonumber(getObjectModel(objid)) ~= iskl[iid] then
							setObjectVisible(objid, true)
							object_visible[objid] = true
						end
					end
				end
			end
		end
	end
end

--								_ _  _ ____ _  _ _    _  _ ____ _  _ _  _
--								| |\/| | __ |  | |    |\/| |___ |\ | |  |
--								| |  | |__] |__| |    |  | |___ | \| |__|

function imgui.OnDrawFrame()
	if not showMainWind.v then 
		imgui.Process = false 
	end
	if showMainWind.v then
	imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(900, 440), imgui.Cond.FirstUseEver)
	imgui.Begin(u8'Delirium KHelper v1.0.0', showMainWind, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
	imgui.BeginChild('##osnovs', imgui.ImVec2(150, 185), true)
	imgui.CenterText(u8'ћеню')
	if imgui.Button(u8'‘ункции', imgui.ImVec2(135, 30)) then mainIni.selected = 4 end
	imgui.Separator()
	if imgui.Button(u8'Ќастройки', imgui.ImVec2(135, 30)) then mainIni.selected = 3 end
	imgui.Separator()
	if imgui.Button(u8'—имул€тор наборов', imgui.ImVec2(135, 30)) then mainIni.selected = 2 end
	imgui.Separator()
	if imgui.Button(u8'GPS', imgui.ImVec2(135, 30)) then mainIni.selected = 1 end
	imgui.EndChild()
	imgui.SetCursorPos(imgui.ImVec2(7, 375))
	imgui.BeginChild('##јвтор', imgui.ImVec2(150, 50), true)
	imgui.CenterText(u8"јвтор:")
	imgui.CenterText(u8"Cranberry")
	imgui.EndChild()
	
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	imgui.Image(image1, imgui.ImVec2(900, 440)) 
	imgui.SetCursorPos(imgui.ImVec2(0, 210))
	imgui.Image(image, imgui.ImVec2(165, 165)) -- размер X = 150, размер Y = 200
	if mainIni.selected == 1 then
--								____ ____ _    ____ ____ ___     ____ ___  ____
--								[__  |___ |    |___ |     |  .   | __ |__] [__ 
--								___] |___ |___ |___ |___  |  .   |__] |    ___]

		imgui.SetCursorPos(imgui.ImVec2(165, 26))
		imgui.BeginChild('##–емонт', imgui.ImVec2(145, 85), true)
		imgui.CenterText(u8'ѕочинка')
		if imgui.Button(u8'–емонт[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2147, -2274)
			distance()
		end
		if imgui.Button(u8'–емонт[Ѕар]', imgui.ImVec2(130,20)) then
			placeWaypoint(221, 1868)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 116))
		imgui.BeginChild('##ѕатроны', imgui.ImVec2(145, 85), true)
		imgui.CenterText(u8'ѕродавцы патрон')
		if imgui.Button(u8'ѕатроны[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2151, -2266)
			distance()
		end
		if imgui.Button(u8'ѕатроны[Ћ—]', imgui.ImVec2(130,20)) then
			placeWaypoint(2442, -1978)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 206))
		imgui.BeginChild('## лючник', imgui.ImVec2(145, 85), true)
		imgui.CenterText(u8'ѕродавцы патрон')
		if imgui.Button(u8' лючник[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2100, -2236)
			distance()
		end
		if imgui.Button(u8' лючник[Ѕар]', imgui.ImVec2(130,20)) then
			placeWaypoint(296, 2036)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 296))
		imgui.BeginChild('##артефакты', imgui.ImVec2(145, 85), true)
		imgui.CenterText(u8'ѕродавцы артефактов')
		if imgui.Button(u8'јртефакты[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2158, -2281)
			distance()
		end
		if imgui.Button(u8'јртефакты[‘ѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(413, 2537)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(465, 286))
		imgui.BeginChild('##улучшени€', imgui.ImVec2(145, 110), true)
		imgui.CenterText(u8'ѕродавцы улучшений')
		if imgui.Button(u8'Ќа оружие[ѕ ]', imgui.ImVec2(130,20)) then
			placeWaypoint(2316, 62)
			distance()
		end
		if imgui.Button(u8'Ќа броню[ѕ ]', imgui.ImVec2(130,20)) then
			placeWaypoint(2316, 67)
			distance()
		end
		if imgui.Button(u8'Ќа вышки[ѕ ]', imgui.ImVec2(130,20)) then
			placeWaypoint(2322, 67)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(315, 26))
		imgui.BeginChild('##ѕровдник', imgui.ImVec2(145, 110), true)
		imgui.CenterText(u8'ѕроводники')
		if imgui.Button(u8'ѕроводник[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2095, -2462)
			distance()
		end
		if imgui.Button(u8'ѕроводник[Ѕар]', imgui.ImVec2(130,20)) then
			placeWaypoint(216, 1874)
			distance()
		end
		if imgui.Button(u8'ѕроводник[јрена]', imgui.ImVec2(130,20)) then
			placeWaypoint(1405, 2209)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(615, 26))
		imgui.BeginChild('##хавка', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8'ѕродавец едой')
		if imgui.Button(u8'≈да[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2105, -2463)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(315, 141))
		imgui.BeginChild('##Delirium', imgui.ImVec2(145, 161), true)
		imgui.CenterText(u8'—купка Delirium')
		if imgui.Button(u8'Delirium[Ѕар]', imgui.ImVec2(130,20)) then
			placeWaypoint(205, 1872)
			distance()
		end
		if imgui.Button(u8'Delirium[ арьер]', imgui.ImVec2(130,20)) then
			placeWaypoint(-816, 856)
			distance()
		end
		if imgui.Button(u8'Delirium[«авод]', imgui.ImVec2(130,20)) then
			placeWaypoint(-154, -279)
			distance()
		end
		if imgui.Button(u8'Delirium[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2110, -2405)
			distance()
		end
		if imgui.Button(u8'Delirium[—‘]', imgui.ImVec2(130,20)) then
			placeWaypoint(-1971, 130)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(615, 222))
		imgui.BeginChild('##механик', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8'¬зломщик-механик')
		if imgui.Button(u8'ћеханик[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2097, -2469)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(315, 307))
		imgui.BeginChild('##платина', imgui.ImVec2(145, 55), true)
		imgui.CenterText(u8'ƒонат валюта')
		if imgui.Button(u8'ѕлатина[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2103, -2474)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(615, 156))
		imgui.BeginChild('##оружие', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8'ѕродавец оружи€')
		if imgui.Button(u8'ќружие[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2154, -2270)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(315, 367))
		imgui.BeginChild('##тир', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8'“ир')
		if imgui.Button(u8'“ир[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2220, -2336)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(465, 26))
		imgui.BeginChild('##сидор', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8' вестовый персонаж')
		if imgui.Button(u8'—идорович[јѕ]', imgui.ImVec2(130,20)) then
			placeWaypoint(-2181, -2432)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(615, 91))
		imgui.BeginChild('##медик', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8'ѕродавец медициной')
		if imgui.Button(u8'ћедик[—‘]', imgui.ImVec2(130,20)) then
			placeWaypoint(-1970, 132)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(465, 91))
		imgui.BeginChild('##скупщик', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8'—купщик хлама')
		if imgui.Button(u8'—купщик[Ѕар]', imgui.ImVec2(130,20)) then
			placeWaypoint(223, 1853)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(465, 156))
		imgui.BeginChild('##арена', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8'¬ход на арену')
		if imgui.Button(u8'–егистратор[јрена]', imgui.ImVec2(130,20)) then
			placeWaypoint(1399, 2205)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(465, 221))
		imgui.BeginChild('##сброс', imgui.ImVec2(145, 60), true)
		imgui.CenterText(u8'ƒиск/сброс')
		if imgui.Button(u8'—брос навыков[Ѕар]', imgui.ImVec2(130,20)) then
			placeWaypoint(216, 1853)
			distance()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(615, 287))
		imgui.BeginChild("##oazis", imgui.ImVec2(145, 55), true, imgui.WindowFlags.NoScrollbar)
    	updateOasisNameText()
    	displayCurrentIndexoas()
    	imgui.Text(u8"")
    	if imgui.ColoredButton(u8'<', '32CD32', 70, imgui.ImVec2(50,20), imgui.SameLine()) then
        	goBack1()
			distance()
   		end
    	if imgui.ColoredButton(u8'>', '32CD32', 70, imgui.ImVec2(50,20), imgui.SameLine()) then
        goForward1()
		distance()
    	end
    	imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(615, 347))
		imgui.BeginChild("##anomalylocation", imgui.ImVec2(145, 55), true, imgui.WindowFlags.NoScrollbar)
    	updateAnomalylocationsNameText()
    	displayCurrentIndexanomalylocations()
    	imgui.Text(u8"")
    	if imgui.ColoredButton(u8'<', '32CD32', 70, imgui.ImVec2(50,20), imgui.SameLine()) then
        	goBack2()
			distance()
   		end
    	if imgui.ColoredButton(u8'>', '32CD32', 70, imgui.ImVec2(50,20), imgui.SameLine()) then
        goForward2()
		distance()
    	end
    	imgui.EndChild()
    elseif mainIni.selected == 2 then
		imgui.SetCursorPos(imgui.ImVec2(165, 26))
		imgui.BeginChild('##information', imgui.ImVec2(100, 34), true)
		imgui.Text(u8('ќчки: ' .. mainIni.SimulyatorOpen.wallet))
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 65))
		imgui.BeginChild('##ћалый набор', imgui.ImVec2(100, 100), true)
		if imgui.Button(u8"ћалый набор\n\n\n\n                20", imgui.ImVec2(85, 85)) then
			local randomItem = getRandomItem()
			if randomItem then
				sampAddChatMessage("{FF0000}[SOS] {44AAFF}" .. randomItem.name .. " {ffffff}x {44AAFF}" .. randomItem.quantity .. " {FFFFFF}добавлено в инвентарь", 0xFF44AAFF)
				earnedMoney = earnedMoney + (randomItem.cost * randomItem.quantity)  -- ќбновл€ем заработанную сумму с учетом количества
				opentotal = opentotal + 1
			else
				print("ќшибка при получении предмета.")
			end
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(270, 26))
		imgui.BeginChild('##dengi', imgui.ImVec2(100, 34), true)
		imgui.TextColoredRGB(u8("{00b100}$" .. earnedMoney))  -- ќтображаем заработанную сумму
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(375, 26))
		imgui.BeginChild('##opentotal', imgui.ImVec2(100, 34), true)
		imgui.TextColoredRGB(("ќткрыто: " .. opentotal))  -- ќтображаем заработанную сумму
		imgui.EndChild()
--								____ ____ _    ____ ____ ___     ____ _ _  _ _  _ _    ____ ___ ____ ____
--								[__  |___ |    |___ |     |  .   [__  | |\/| |  | |    |__|  |  |  | |__/
--								___] |___ |___ |___ |___  |  .   ___] | |  | |__| |___ |  |  |  |__| |  \
                                                                        
--								____ ___  ____ _  _    ____ ____ ___                                     
--								|  | |__] |___ |\ |    [__  |___  |                                      
--								|__| |    |___ | \|    ___] |___  |  

	elseif mainIni.selected == 3 then
		imgui.SetCursorPos(imgui.ImVec2(165, 26))
		imgui.BeginChild('##settings', imgui.ImVec2(300, 150), true)
		imgui.CenterText(u8'ќсновное')
		imgui.Separator()
		imgui.PushItemWidth(80)
		if imgui.InputText(u8'##Ќазвание скрипта', savesettings.scriptName) then
			mainIni.settings.scriptName = savesettings.scriptName.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8" оманда дл€ открыти€ меню.", imgui.SameLine())
		if imgui.InputText(u8'##ќткрыть мейн окно', savesettings.osnovnoeokno) then
			mainIni.settings.osnovnoeokno = savesettings.osnovnoeokno.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8" нопка дл€ открыти€ меню.", imgui.SameLine())
		if imgui.InputText(u8'##¬ыделение квадрата', savesettings.findcub) then
			mainIni.settings.findcub = savesettings.findcub.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8" оманда дл€ выделени€ квадрата.", imgui.SameLine())
		if imgui.InputText(u8'##”брать выделение квадрата', savesettings.keyactiv) then
			mainIni.settings.keyactiv = savesettings.keyactiv.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"„ик-код дл€ отмены выделени€.", imgui.SameLine())
		if imgui.InputText(u8'##подбор парол€', savesettings.podborpassword) then
			mainIni.settings.podborpassword = savesettings.podborpassword.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8" оманда дл€ подбора комбинаций.", imgui.SameLine())
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 181))
		imgui.BeginChild('##colorgangzone', imgui.ImVec2(300, 34), true)
		imgui.PushItemWidth(80)
		if imgui.InputText(u8'##÷вет зон аномальных', savesettings.anomalyzonecolor) then
			mainIni.settings.anomalyzonecolor = savesettings.anomalyzonecolor.v
			inicfg.save(mainIni, "tychagova.ini")
			sampAddChatMessage("÷вет аномальных зон изменен", mainIni.settings.anomalyzonecolor)
		end
		imgui.Text(u8"÷вет аномальных зон", imgui.SameLine())
		imgui.SameLine()
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 220))
		imgui.BeginChild('##≈бобус', imgui.ImVec2(300, 200), true)
		imgui.PushItemWidth(80)
			if imgui.InputText(u8'##÷вет меню', savesettings.prozrachnost) then
				imgui.PopItemWidth()
			mainIni.settings.prozrachnost = savesettings.prozrachnost.v
			inicfg.save(mainIni, "tychagova.ini")
			end
			imgui.Text(u8"÷вет инвентар€.", imgui.SameLine())
			if imgui.InputText(u8'##÷вет меню скилы', savesettings.skillcolor) then
			mainIni.settings.skillcolor = savesettings.skillcolor.v
			inicfg.save(mainIni, "tychagova.ini")
			end
			imgui.Text(u8"÷вет полоски скилов.", imgui.SameLine())
			if imgui.InputText(u8'##÷вет меню скилы задний фон', savesettings.skillcolorall) then
			mainIni.settings.skillcolorall = savesettings.skillcolorall.v
			inicfg.save(mainIni, "tychagova.ini")
			end
			imgui.Text(u8"÷вет полоски скилов(back).", imgui.SameLine())
			if imgui.InputText(u8'##÷вет текста', savesettings.textcolor) then
			mainIni.settings.textcolor = savesettings.textcolor.v
			inicfg.save(mainIni, "tychagova.ini")
			end
			imgui.Text(u8"÷вет текста.", imgui.SameLine())
			imgui.Text(u8('\n÷вет нужно указывать в формате 0x8000b9f5\nв котором:\n"0x" - нужно указывать всегда\n"80" - прозрачность(ћожет быть от 00 до 99)\n00b9f5 - цвет в формате HEX'))
			imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(470, 26))
		imgui.BeginChild('##settings2', imgui.ImVec2(300, 220), true)
		imgui.CenterText(u8'Ѕыстрое использование')
		imgui.Separator()
		imgui.PushItemWidth(80)
		if imgui.InputText(u8'##»спользовать jetpack', savesettings.jetpackfast) then
			mainIni.settings.jetpackfast = savesettings.jetpackfast.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"»спользовать/сн€ть Jetpack.", imgui.SameLine())
		if imgui.InputText(u8'##»спользовать бензопилу', savesettings.benzfast) then
			mainIni.settings.benzfast = savesettings.benzfast.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"»спользовать бензопилу.", imgui.SameLine())
		if imgui.InputText(u8'##»спользовать основное оружие', savesettings.osnovnoe) then
			mainIni.settings.osnovnoe = savesettings.osnovnoe.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"»спользовать основное оружие.", imgui.SameLine())
		if imgui.InputText(u8'##»спользовать второстепенное оружие', savesettings.vtorostepennoe) then
			mainIni.settings.vtorostepennoe = savesettings.vtorostepennoe.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"»спользовать втор. оружие.", imgui.SameLine())
		if imgui.InputText(u8'##»спользовать аптечку', savesettings.aptechka) then
			mainIni.settings.aptechka = savesettings.aptechka.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"»спользовать аптечку.", imgui.SameLine())
		if imgui.InputText(u8'##»спользовать антирад', savesettings.antirad) then
			mainIni.settings.antirad = savesettings.antirad.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"»спользовать антирад.", imgui.SameLine())
		if imgui.InputText(u8'##»спользовать бинт', savesettings.bint) then
			mainIni.settings.bint = savesettings.bint.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"»спользовать бинт.", imgui.SameLine())
		if imgui.InputText(u8'##ќткрыть инвентарь', savesettings.inventar) then
			mainIni.settings.inventar = savesettings.inventar.v
			inicfg.save(mainIni, "tychagova.ini")
		end
		imgui.Text(u8"ќткрыть инвентарь.", imgui.SameLine())
		imgui.EndChild()
--								____ ____ _    ____ ____ ___     ____ ____ ___ ___ _ _  _ ____ ____
--								[__  |___ |    |___ |     |  .   [__  |___  |   |  | |\ | | __ [__ 
--								___] |___ |___ |___ |___  |  .   ___] |___  |   |  | | \| |__] ___]

	elseif mainIni.selected == 4 then
		imgui.SetCursorPos(imgui.ImVec2(165, 26))
		imgui.BeginChild('##левый_верх', imgui.ImVec2(120, 80), true)
		imgui.Checkbox(u8"јвтохил", checboxingeb.checked_test_2)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ автоматический использует //a если хп ниже 50%.')
			imgui.EndTooltip()
		end
		imgui.Checkbox(u8"јвтоеда", checboxingeb.checked_test_3)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ автоматический использует //e если голод ниже 50%.')
			imgui.EndTooltip()
		end
		imgui.Checkbox(u8"јвтоантирад", checboxingeb.checked_test_4)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ автоматический использует //r если радиаци€ больше 10%.')
			imgui.EndTooltip()
		end
		imgui.EndChild()
		saving()
        imgui.SetCursorPos(imgui.ImVec2(290, 26))
		imgui.BeginChild("##левыйцентр", imgui.ImVec2(178, 55), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"јвтопродажа Delirium", checboxingeb.checked_test_13)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ автоматический продает весь делириум, если открыто меню торговца и в инвентаре есть Delirium.')
			imgui.EndTooltip()
		end
		imgui.Checkbox(u8"јвтоперенос Delirium", checboxingeb.checked_test_14)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ автоматический переносит весь Delirium в транспорт/тайник/личный €щик если в инвентаре есть Delirium.')
			imgui.EndTooltip()
		end
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(290, 86))
		imgui.BeginChild("##автоподбор артов", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"јвтоподбор артефактов", checboxingeb.checked_test)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ автоматический поднимает артефакты, когда игрок наступает на них..')
			imgui.EndTooltip()
		end
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(290, 125))
		imgui.BeginChild("##автозакрытие тс", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"јвтозакрытие машины", checboxingeb.checked_test_6)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ автоматический будет закрывать дверь транспорта, после того как вы выйдите из транспорта\nЌе включайте если передвигаетесь не на личном транспорте.')
			imgui.EndTooltip()
		end
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(290, 164))
		imgui.BeginChild("##метка", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"јвтометка на ј»–", checboxingeb.checked_test_7)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ выдел€ет и ставит метку на квадрат, в который будет падать ј»–.')
			imgui.EndTooltip()
		end
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(290, 203))
		imgui.BeginChild("##таймер", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"“аймер до ‘ѕ", checboxingeb.checked_test_8)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ ставит таймер на 15 минут, если в чате было написано то что зомбиразбили ‘ѕ или ‘ѕ было отбито\nѕо истечению таймера воспроизводитьс€ звук.')
			imgui.EndTooltip()
		end
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(290, 242))
		imgui.BeginChild("##карты", imgui.ImVec2(178, 55), true, imgui.WindowFlags.NoScrollbar)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ ставит маркер на место, где находитьс€ та или ина€ карта.')
			imgui.EndTooltip()
		end
		updateCardNameText() 
		displayCurrentIndex()
		imgui.Text(u8"")
		if imgui.ColoredButton(u8'<', '32CD32', 70,imgui.ImVec2(70,20), imgui.SameLine()) then
			goBack()
			distance()
		end
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ ставит маркер на место, где находитьс€ та или ина€ карта.')
			imgui.EndTooltip()
		end
		if imgui.ColoredButton(u8'>', '32CD32', 70,imgui.ImVec2(70,20), imgui.SameLine()) then
			goForward()
			distance()
		end
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(473, 207))
		imgui.BeginChild("##—татистика тюрьма", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		if imgui.Checkbox(u8"—татистика тюрьма", checboxingeb.checked_test_15) then
			showWind_3.v = not showWind_3.v
		end
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(473, 246))
		imgui.BeginChild("##решение уравнений", imgui.ImVec2(178, 123), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"–ешение уравнений", checboxingeb.checked_test_16)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ дл€ {FF0000}автоматического {FFFFFF}решени€ уравнений и ввода ответа в диалоговое окно.')
			imgui.EndTooltip()
		end
		if imgui.Checkbox(u8"ќкно подбора", checboxingeb.checked_test_34) then
			showWind_7.v = not showWind_7.v
		end
		imgui.Checkbox(u8"ѕодсказки", checboxingeb.checked_test_35)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ дл€ отображени€ подсказки касаемо перевода {FFFF00}AND OR XOR в {FF0000}NOT')
			imgui.EndTooltip()
		end
		imgui.Checkbox(u8"ёзаные дешифраторы", checboxingeb.checked_test_36)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ дл€ отображени€ уже {FF0000}использованных {ffffff}дешифраторов.\nƒанные берутьс€ на основе проверки {FF0000}ID {FFFFFF}дешифратора. \n≈сли данный дешифратор уже {FF0000}открывалс€ в инветаре {FFFFFF}то он заноситьс€ в список\n“акже мен€ет название предмета на {FF0000}"Decoder has already been used"')
			imgui.EndTooltip()
		end
		imgui.Checkbox(u8"ѕодбор цифр", checboxingeb.checked_test_66)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ дл€ подбора кода к тайнику')
			imgui.EndTooltip()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(473, 371))
		imgui.BeginChild("##до конца капта", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"¬рем€ до конца капта", checboxingeb.checked_test_38)
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(473, 406))
		imgui.BeginChild("##удаление аксов", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"—крывать аксессуары", checboxingeb.checked_test_39)
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(165, 111))
		imgui.BeginChild("##цвет чата", imgui.ImVec2(120, 34), true, imgui.WindowFlags.NoScrollbar)
		if imgui.Checkbox(u8"—тат. тир", checboxingeb.checked_test_32) then
			showWind_6.v = not showWind_6.v
		end
		if imgui.ColoredButton(u8"X", 'F94242', 70,imgui.ImVec2(20, 20), imgui.SameLine()) then
			resettir()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 150))
		imgui.BeginChild("##логер лута с наборов", imgui.ImVec2(120, 34), true, imgui.WindowFlags.NoScrollbar)
		if imgui.Checkbox(u8"Ћог наборов", checboxingeb.checked_test_37) then
			showWind_8.v = not showWind_8.v
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 189))
		imgui.BeginChild("##—татистика обща€", imgui.ImVec2(120, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"ќбойма", checboxingeb.checked_test_41)
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 228))
		imgui.BeginChild("##статистика арты", imgui.ImVec2(120, 34), true, imgui.WindowFlags.NoScrollbar)
		if imgui.Checkbox(u8"—тат. арт", checboxingeb.checked_test_42) then
			showWind_9.v = not showWind_9.v 
		end
		if imgui.ColoredButton(u8"X", 'F94242', 70,imgui.ImVec2(20, 20), imgui.SameLine()) then
			resetstatart()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(165, 267))
		imgui.BeginChild("##маssюз", imgui.ImVec2(120, 34), true, imgui.WindowFlags.NoScrollbar)
		if imgui.Checkbox(u8"ћасс. юз", checboxingeb.checked_test_43) then
			showWind_10.v = not showWind_10.v 
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(290, 362))
		imgui.BeginChild("##отображение цены", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"÷ена покупки/продажи", checboxingeb.checked_test_33)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('ѕоказывает цену {FF0000}продажи {FFFFFF}и {39c314}покупки {Ffffff}тех или иных предметов {00befc}при нажатии на предмет в инвентаре.')
			imgui.EndTooltip()
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(290, 401))
		imgui.BeginChild("##автовзломтс", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"јвто взлом авто", checboxingeb.checked_test_40)
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(656, 155))
		imgui.BeginChild("##‘aст лутинг дмоов", imgui.ImVec2(178, 34), true, imgui.WindowFlags.NoScrollbar)
		imgui.Checkbox(u8"‘аст лутинг домов", checboxingeb.checked_test_5)
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(656, 194))
		imgui.BeginChild("##статистика казино", imgui.ImVec2(178, 240), true, imgui.WindowFlags.NoScrollbar)
		imgui.CenterText(u8'—татистика казино')	
		if imgui.Checkbox(u8"¬ключить", checboxingeb.checked_test_17) then
			showWind_4.v = not showWind_4.v
		end
		if imgui.ColoredButton(u8"ќбнулить", 'F94242', 70,imgui.ImVec2(75, 20), imgui.SameLine()) then
			resetkazino()
		end
		imgui.Checkbox(u8"¬сего ставок", checboxingeb.checked_test_24)
		imgui.Checkbox(u8"Ѕез выигрыша", checboxingeb.checked_test_25)
		imgui.Checkbox(u8"ќтображать BB", checboxingeb.checked_test_26)
		imgui.Checkbox(u8"ќтображать FFF", checboxingeb.checked_test_27)
		imgui.Checkbox(u8"ќтображать CC", checboxingeb.checked_test_28)
		imgui.Checkbox(u8"ќтображать BBB", checboxingeb.checked_test_29)
		imgui.Checkbox(u8"ќтображать CCC", checboxingeb.checked_test_30)
		imgui.Checkbox(u8"ќтображать 777", checboxingeb.checked_test_31)
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(473, 26))
		imgui.BeginChild("##правый_центр", imgui.ImVec2(178, 175), true, imgui.WindowFlags.NoScrollbar)
		imgui.CenterText(u8'—татистика опыта')
		if imgui.Checkbox(u8"¬ключить", checboxingeb.checked_test_18) then
			showWind_5.v = not showWind_5.v
		end
		if imgui.ColoredButton(u8"ќбнулить", 'F94242', 70,imgui.ImVec2(75, 20), imgui.SameLine()) then
			cmd_reset()
		end			imgui.Checkbox(u8"ѕрочий опыт", checboxingeb.checked_test_19)
		imgui.Checkbox(u8"јртефакты", checboxingeb.checked_test_20)
		imgui.Checkbox(u8"«омби", checboxingeb.checked_test_21)
		imgui.Checkbox(u8"RIA", checboxingeb.checked_test_22)
		imgui.Checkbox(u8"ќбщий опыт", checboxingeb.checked_test_23)
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(656, 26))
		imgui.BeginChild("##калькул€торприбыли дом", imgui.ImVec2(178, 125), true, imgui.WindowFlags.NoScrollbar)
		imgui.CenterText(u8' алькул€тор[ƒома]')
		if imgui.Checkbox(u8"¬ключить", checboxingeb.checked_test_9) then
			showWind_2.v = not showWind_2.v
		end
		if imgui.ColoredButton(u8"ќбнулить", 'F94242', 70,imgui.ImVec2(75, 20), imgui.SameLine()) then
			resetStats()
		end
		imgui.Checkbox(u8" ол-во предметов", checboxingeb.checked_test_10)
		imgui.Checkbox(u8"ѕрибыль", checboxingeb.checked_test_11)
		imgui.Checkbox(u8"ƒеньги", checboxingeb.checked_test_12)
		imgui.EndChild()
		saving()
		imgui.SetCursorPos(imgui.ImVec2(290, 302))
		imgui.BeginChild("##јномальные зоны", imgui.ImVec2(178, 55), true, imgui.WindowFlags.NoScrollbar)
		imgui.CenterText(u8'јномальные зоны')
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.TextColoredRGB('‘ункци€ выдел€ет аномальные зоны {FF0000}красными квадратами.')
			imgui.EndTooltip()
		end
		if imgui.ColoredButton(u8'¬ключить', '32CD32', 70,imgui.ImVec2(75,20)) then
		addGangZone(300, 43, 2382, 373, 2676, mainIni.settings.anomalyzonecolor)
		addGangZone(301, 1118, 2725, 1425, 2877, mainIni.settings.anomalyzonecolor)
		addGangZone(302, 1238, 1223, 1462, 1718, mainIni.settings.anomalyzonecolor)
		addGangZone(303, -895, 1957, -547, 2098, mainIni.settings.anomalyzonecolor)
		addGangZone(304, 87, 1322, 301, 1500, mainIni.settings.anomalyzonecolor)
		addGangZone(305, 334, 1248, 640, 1539, mainIni.settings.anomalyzonecolor)
		addGangZone(306, 404, 744, 788, 1010, mainIni.settings.anomalyzonecolor)
		addGangZone(307, 1011, 999, 1179, 1164, mainIni.settings.anomalyzonecolor)
		addGangZone(308, -57, 1306, 64, 1430, mainIni.settings.anomalyzonecolor)
		addGangZone(309, -615, 2502, -444, 2671, mainIni.settings.anomalyzonecolor)
		addGangZone(310, 535, -91, 965, 218, mainIni.settings.anomalyzonecolor)
		addGangZone(311, -635, -234.5, -341, 36, mainIni.settings.anomalyzonecolor)
		addGangZone(312, -630, -575, -459, -456, mainIni.settings.anomalyzonecolor)
		addGangZone(313, -1143, -770, -962, -571, mainIni.settings.anomalyzonecolor)
		addGangZone(314, -1200, -1075, -998, -896, mainIni.settings.anomalyzonecolor)
		addGangZone(315, -1771, -700, -1126, -180, mainIni.settings.anomalyzonecolor)
		addGangZone(316, -1757, -135, -1501, 183, mainIni.settings.anomalyzonecolor)
		addGangZone(317, -2101, -286, -2005, -104, mainIni.settings.anomalyzonecolor)
		addGangZone(318, -2146, 182, -2001, 326, mainIni.settings.anomalyzonecolor)
		addGangZone(319, -2393, 56, -2258, 246, mainIni.settings.anomalyzonecolor)
		addGangZone(320, -1940, -1721, -1745, -1528, mainIni.settings.anomalyzonecolor)
		addGangZone(321, -2718, -1956, -2068, -1247, mainIni.settings.anomalyzonecolor)
		addGangZone(322, -691, -2639, -300, -2264, mainIni.settings.anomalyzonecolor)
		addGangZone(323, -600, -1621, -237, -1297, mainIni.settings.anomalyzonecolor)
		addGangZone(324, 805, -1134, 955, -1062, mainIni.settings.anomalyzonecolor)
		addGangZone(325, 799, -1310, 932, -1157, mainIni.settings.anomalyzonecolor)
		addGangZone(326, 1066, -1573, 1198, -1413, mainIni.settings.anomalyzonecolor)
		addGangZone(327, 1569, -2368, 1819, -2208, mainIni.settings.anomalyzonecolor)
		addGangZone(328, 2538, -1921, 2623, -1735, mainIni.settings.anomalyzonecolor)
		addGangZone(329, 1840, -1581, 2532, -1487, mainIni.settings.anomalyzonecolor)
		addGangZone(330, 1856, -1259, 2057, -1137, mainIni.settings.anomalyzonecolor)
		addGangZone(331, 2004, -895, 2750, -300, mainIni.settings.anomalyzonecolor)
		sampAddChatMessage("[KHelper] {FFFFFF}ќтображение аномальных зон {00da00}включено", 0x00befc)
		end
		if imgui.ColoredButton(u8'¬ыключить', 'F94242', 70,imgui.ImVec2(75,20), imgui.SameLine()) then
			sampAddChatMessage("[KHelper] {FFFFFF}ќтображение аномальных зон {ff0000}выключено", 0x00befc)
			for i = 300, 331 do
				removeGangZone(i)
			end
		end
			imgui.EndChild()
			saving()
		end
			imgui.End()
		end
		if checboxingeb.checked_test_9.v then
			imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(200, 75), imgui.Cond.FirstUseEver)
			imgui.Begin(u8'Ebanat', showWind_2, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
			imgui.BeginChild('##widget', true)
			if checboxingeb.checked_test_10.v then
			imgui.Text(u8"—обрано " .. mainIni.house.totalItems .. u8" предметов")
			end
		if checboxingeb.checked_test_11.v then
			imgui.TextColoredRGB("{00e600}ѕрибыль: $" .. mainIni.house.totalProfit)
		end
		if checboxingeb.checked_test_12.v then
			imgui.Text(u8"ƒенег[как предмет]: $" .. (mainIni.house.totalMoneyAdded or 0))
		end
		imgui.EndChild()
		saving()
		imgui.End()
		end	
		if checboxingeb.checked_test_15.v then
			imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(200, 100), imgui.Cond.FirstUseEver)
			imgui.Begin(u8'JailHelper', showWind_3, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
			imgui.BeginChild('##jailed', true)
			imgui.Text(u8"—екунд осталось: " .. mainIni.jail.totalSeconds)
			imgui.Text(u8" амней осталось: " .. mainIni.jail.result)
			imgui.Text(u8" амней перенесено: " ..mainIni.jail.kamni)
			imgui.TextColoredRGB("{00e600}ƒо еды осталось камней: " .. mainIni.jail.foodCounter)
			imgui.EndChild()
			saving()
			imgui.End()
		end
		if checboxingeb.checked_test_17.v then
			imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(150, 175), imgui.Cond.FirstUseEver)
			imgui.Begin(u8'kazinostat', showWind_4, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
			imgui.BeginChild('##kazinoeban', true)
			if checboxingeb.checked_test_24.v then
			imgui.Text(u8"¬сего ставок: " .. mainIni.KAZIK.totalstavok)
			end
			if checboxingeb.checked_test_25.v then
			imgui.Text(u8"Ѕез выигрыша: " .. mainIni.KAZIK.kazinozero)
			end
			if checboxingeb.checked_test_26.v then
			imgui.TextColoredRGB(u8"{fafd02}BB[x1]:{FFFFFF} " .. mainIni.KAZIK.kazinokolokol)
			end
			if checboxingeb.checked_test_27.v then
			imgui.TextColoredRGB(u8"{27f80b}FFF[x2]:{FFFFFF} " .. mainIni.KAZIK.kazinofrukti)
			end
			if checboxingeb.checked_test_28.v then
			imgui.TextColoredRGB(u8"{FF0000}CC[X2]:{FFFFFF} " .. mainIni.KAZIK.kazinodvevisni)
			end
			if checboxingeb.checked_test_29.v then
			imgui.TextColoredRGB(u8"{fafd02}BBB[X4]:{FFFFFF} " .. mainIni.KAZIK.kazinokolokola)
			end
			if checboxingeb.checked_test_30.v then
			imgui.TextColoredRGB(u8"{FF0000}CCC[X8]:{FFFFFF} " .. mainIni.KAZIK.kazinovisnya)
			end
			if checboxingeb.checked_test_31.v then
			imgui.TextColoredRGB(u8"{fe00e4}777[X16]:{FFFFFF} " .. mainIni.KAZIK.kazinosemerky)
			end
			imgui.EndChild()
			saving()
			imgui.End()
		end
		if checboxingeb.checked_test_18.v then
			imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(150, 125), imgui.Cond.FirstUseEver) -- ”величиваем размер окна дл€ новой информации
			imgui.Begin(u8'expstats', showWind_5, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
			imgui.BeginChild('##expsta', true)
			if checboxingeb.checked_test_19.v then
				imgui.Text(u8"ѕрочий опыт: " .. mainIni.EXP.simpleExpSum)
			end
			if checboxingeb.checked_test_20.v then
				imgui.Text(u8"јртефакты: " .. mainIni.EXP.artifactsSum)
			end
			if checboxingeb.checked_test_21.v then
				imgui.TextColoredRGB("{00e600}«омби: " .. mainIni.EXP.zombiesSum)
			end
			if checboxingeb.checked_test_22.v then
				imgui.TextColoredRGB(u8"{FF0000}RIA: " .. mainIni.EXP.riaSum)
			end
			if checboxingeb.checked_test_23.v then
				imgui.Text(u8"¬сего опыта: " .. mainIni.EXP.totalSum)
			end
			imgui.EndChild()
			saving()
			imgui.End()
			end
			if checboxingeb.checked_test_32.v then
				imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
				imgui.SetNextWindowSize(imgui.ImVec2(200, 170), imgui.Cond.FirstUseEver + imgui.WindowFlags.AlwaysAutoResize) -- ”величиваем размер окна дл€ новой информации
				imgui.Begin(u8'x100', showWind_6, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
				imgui.BeginChild('##x100k', true)
				imgui.Text(u8("ќчков: ") .. mainIni.TIR.currentScore)
				imgui.Text(u8("ќсталось времени: ") .. mainIni.TIR.timeLeft)
				imgui.Text(u8("¬ голову: ") .. mainIni.TIR.Head)
				imgui.Text(u8("¬ тело: ") .. mainIni.TIR.Body)
				imgui.Text(u8("ѕромахов: ") .. mainIni.TIR.miss)
				imgui.Text(u8("¬сего выстрелов: ") .. mainIni.TIR.totalshots)
				imgui.TextColoredRGB(u8("{00e600}Win: ") .. mainIni.TIR.wins)
				imgui.TextColoredRGB(u8("{FF0000}Lose: ") .. mainIni.TIR.lose, imgui.SameLine())
				imgui.Text(u8("«аработано денег: ") .. mainIni.TIR.money)
				imgui.EndChild()
				saving()
--								____ ____ _    ____ ____ ___     ____ _  _ _  _ ____ ___ _ ____ _  _ ____
--								[__  |___ |    |___ |     |  .   |___ |  | |\ | |     |  | |  | |\ | [__ 
--								___] |___ |___ |___ |___  |  .   |    |__| | \| |___  |  | |__| | \| ___]

			imgui.End()
				end
				if checboxingeb.checked_test_34.v then
					imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
					imgui.SetNextWindowSize(imgui.ImVec2(540, 550), imgui.Cond.FirstUseEver) -- ”величиваем размер окна дл€ новой информации
					imgui.Begin(u8'vzlomebla', showWind_5, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
					imgui.BeginChild('##vzlomeblla', true)
					if imgui.CollapsingHeader(u8'Ќастройка') then
					imgui.Text(u8" оличество повторений разделител€:")
					if imgui.InputText(u8'##fdasdasdff', savesettings.yeban) then
						mainIni.settings.yeban = savesettings.yeban.v
						inicfg.save(mainIni, "tychagova.ini")
					end
				
					imgui.Text(u8"—лово или символ дл€ разделени€ строчек:")
					if imgui.InputText(u8'##—имвол дл€ разделени€ линий', savesettings.razdelitel) then
						mainIni.settings.razdelitel = savesettings.razdelitel.v
						inicfg.save(mainIni, "tychagova.ini")
					end
					imgui.Text(u8" оличество паролей в одной строчке:")
					if imgui.InputText(u8'## оличество паролей в одной строчке', savesettings.parolinonestroka) then
						mainIni.settings.parolinonestroka = savesettings.parolinonestroka.v
						inicfg.save(mainIni, "tychagova.ini")
					end
					imgui.Text(u8" оличество разделительных строк:")
					if imgui.InputText(u8'## оличество разделительных строк', savesettings.kolichestvoRazdelitelnihStrok) then
						mainIni.settings.kolichestvoRazdelitelnihStrok = savesettings.kolichestvoRazdelitelnihStrok.v
						inicfg.save(mainIni, "tychagova.ini")
					end
				end
						imgui.TextColoredRGB("¬ведите {ff0000}/" .. mainIni.settings.podborpassword .. " {FFFF00}*двоичный код* {ffffff}чтобы получить все возможные комбинации\n  примеру {ff0000}/" .. mainIni.settings.podborpassword .. "{FFFF00} 1-1- -00- -111 -101 ---1\n")
						imgui.NewLine()
						imgui.TextColoredRGB(output)
					imgui.EndChild()
					saving()
					imgui.End()
					end
					if checboxingeb.checked_test_37.v then
						imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
						imgui.SetNextWindowSize(imgui.ImVec2(200, 100), imgui.Cond.FirstUseEver)
						imgui.Begin(u8'логер наборов епта', showWind_8, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
						imgui.BeginChild('##лог набор', true)
						for i, v in ipairs(data) do
							imgui.Text(u8(v)) --  расный текст
						end
						imgui.EndChild()
						saving()
						imgui.End()
					end
					if checboxingeb.checked_test_42.v then
						imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
						imgui.SetNextWindowSize(imgui.ImVec2(200, 340), imgui.Cond.FirstUseEver)
						imgui.Begin(u8'—татистика артефaкты', showWind_8, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
						imgui.BeginChild('##статарт', true)
						imgui.TextColoredRGB('«аработано: {00aa00}$' ..mainIni.ART.totalsummart)
						imgui.TextColoredRGB('¬сего собрано: ' ..mainIni.ART.totalcollect)
						imgui.TextColoredRGB(' ость: ' ..mainIni.ART.kost)
						imgui.TextColoredRGB('Ћуч: ' ..mainIni.ART.lych)
						imgui.TextColoredRGB('ядро: ' ..mainIni.ART.yadro)
						imgui.TextColoredRGB('«еркало: ' ..mainIni.ART.zerkalo)
						imgui.TextColoredRGB('янтарь: ' ..mainIni.ART.yantar)
						imgui.TextColoredRGB('√ильза: ' ..mainIni.ART.gilza)
						imgui.TextColoredRGB('ƒуша: ' ..mainIni.ART.dysha)
						imgui.TextColoredRGB('ќсколок: ' ..mainIni.ART.oskolok)
						imgui.TextColoredRGB('√лаз: ' ..mainIni.ART.glaz)
						imgui.TextColoredRGB('Ѕатарейка: ' ..mainIni.ART.batareika)
						imgui.TextColoredRGB(' ровь: ' ..mainIni.ART.krov)
						imgui.TextColoredRGB('ѕанаце€: ' ..mainIni.ART.panaceya)
						imgui.TextColoredRGB('Ћинза: ' ..mainIni.ART.linza)
						imgui.TextColoredRGB('ѕандора: ' ..mainIni.ART.pandora)
						imgui.TextColoredRGB('Ќота: ' ..mainIni.ART.nota)
						imgui.EndChild()
						saving()
						imgui.End()
					end
					if checboxingeb.checked_test_43.v then
						imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
						imgui.SetNextWindowSize(imgui.ImVec2(200, 131), imgui.Cond.FirstUseEver)
						imgui.Begin(u8'massuse', showWind_10, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoTitleBar)
						imgui.BeginChild('##массюз', true)
						imgui.Checkbox(u8"јлкоголь", checboxingeb.checked_test_44)
						imgui.Checkbox(u8"ћалый набор", checboxingeb.checked_test_45)
						imgui.Checkbox(u8"Ѕелый набор", checboxingeb.checked_test_46)
						imgui.Checkbox(u8"¬аучер N опыта", checboxingeb.checked_test_47)
						imgui.Checkbox(u8"ѕодарок", checboxingeb.checked_test_48)
						imgui.EndChild()
						saving()
						imgui.End()
					end
		end
--								____ _  _ _  _ ____ ___ _ ____ _  _ ____    _ _  _ ____ _  _ _
--								|___ |  | |\ | |     |  | |  | |\ | [__     | |\/| | __ |  | |
--								|    |__| | \| |___  |  | |__| | \| ___]    | |  | |__] |__| |

function theme() -- “ема IMGUI
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowPadding = ImVec2(8, 8)
	style.WindowRounding = 5.0
	style.ChildWindowRounding = 5.0
	style.FramePadding = ImVec2(2, 2)
	style.FrameRounding = 5.0
	style.ItemSpacing = ImVec2(5, 5)
	style.ItemInnerSpacing = ImVec2(5, 5)
	style.TouchExtraPadding = ImVec2(0, 0)
	style.IndentSpacing = 5.0
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 5.0
	style.GrabMinSize = 20.0
	style.GrabRounding = 5.0
	style.WindowTitleAlign = ImVec2(0.5, 0.5)
	style.ButtonTextAlign = ImVec2(0.5, 0.5)

	colors[clr.Text]                    = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]            = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.WindowBg]                = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.ChildWindowBg]           = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.PopupBg]                 = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.Border]                  = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.BorderShadow]            = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.FrameBg]                 = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.FrameBgHovered]          = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.FrameBgActive]           = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.TitleBg]                 = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.TitleBgCollapsed]        = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.TitleBgActive]           = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.MenuBarBg]               = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ScrollbarBg]             = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.ScrollbarGrab]           = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ScrollbarGrabHovered]    = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.ScrollbarGrabActive]     = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ComboBg]                 = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.CheckMark]               = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.SliderGrab]              = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.SliderGrabActive]        = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.Button]                  = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ButtonHovered]           = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.ButtonActive]            = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.Header]                  = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.HeaderHovered]           = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.HeaderActive]            = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ResizeGrip]              = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ResizeGripHovered]       = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.ResizeGripActive]        = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.CloseButton]             = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.CloseButtonHovered]      = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.CloseButtonActive]       = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.PlotLines]               = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.PlotLinesHovered]        = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.PlotHistogram]           = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.PlotHistogramHovered]    = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.TextSelectedBg]          = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.ModalWindowDarkening]    = ImVec4(1.00, 1.00, 1.00, 1.00)
end
theme()

function imgui.CenterText(text) -- ÷ентр
	local width = imgui.GetWindowWidth()
	local size = imgui.CalcTextSize(text)
	imgui.SetCursorPosX(width/2-size.x/2)
	imgui.Text(text)
end

function imgui.Link(link,name,myfunc)  -- —сылка
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##'..link..name, size)
    if resultBtn then
        if not myfunc then
            os.execute('explorer '..link)
        end
    end
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.ImVec4(0, 0.5, 1, 1), name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.ImVec4(0, 0.5, 1, 1)))
    else
        imgui.TextColored(imgui.ImVec4(0, 0.3, 0.8, 1), name)
    end
    return resultBtn
end

function imgui.CustomButton(gg, color, colorHovered, colorActive, size) -- ÷ветна€ кнопка
    local clr = imgui.Col
    imgui.PushStyleColor(clr.Button, color)
    imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
    imgui.PushStyleColor(clr.ButtonActive, colorActive)
    if not size then size = imgui.ImVec2(0, 0) end
    local result = imgui.Button(gg, size)
    imgui.PopStyleColor(3)
    return result
end

function imgui.ColoredButton(text,hex,trans,size) -- ÷ветна€ кнопка
    local r,g,b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    if tonumber(trans) ~= nil and tonumber(trans) < 101 and tonumber(trans) > 0 then a = trans else a = 60 end
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r/255, g/255, b/255, a/100))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r/255, g/255, b/255, a/100))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r/255, g/255, b/255, a/100))
    local button = imgui.Button(text, size)
    imgui.PopStyleColor(3)
    return button
end

function imgui.TextColoredRGB(text) -- ÷ветной текст
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4
    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end
    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end
    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end
    render_text(text)
end

sampRegisterChatCommand(mainIni.settings.findcub, function(arg) -- ѕоиск квадрата по команде
    local zoneData = wquares[arg]
    local waypointData = squares[arg]
    if zoneData and waypointData then
        addGangZone(zoneData[1], zoneData[2], zoneData[3], zoneData[4], zoneData[5], 0xFF0000FF)
        placeWaypoint(waypointData[1], waypointData[2])
        sampAddChatMessage("[KHelper] {FFFFFF}„тобы убрать выделение квадрата используйте {FF0000}" .. mainIni.settings.keyactiv .. " {FFFFFF}как чит-код", 0x00befc)
    end
end)
--								____ _  _ _  _ ____ ___ _ ____ _  _ ____
--								|___ |  | |\ | |     |  | |  | |\ | [__ 
--								|    |__| | \| |___  |  | |__| | \| ___]

function getAmmoInClip()
    local pointer = getCharPointer(playerPed)
    local weapon = getCurrentCharWeapon(playerPed)
    local slot = getWeapontypeSlot(weapon)
    local cweapon = pointer + 0x5A0
    local current_cweapon = cweapon + slot * 0x1C
    local ammo = memory.getuint32(current_cweapon + 0x8)
    return ammo
end

function converGameToRussian(text) -- »з иероглифов в русский
    for k, v in pairs(RussianTextGame) do
        text = text:gsub(v.b, v.a)
    end
    return text
end

function checkTextdrawIgnore(textdrawId) -- „екер игнор текстдравов
    for k, v in ipairs(blockTextDrawList) do
        if textdrawId == v then
            return false
        end
    end
    return true
end

function invOpenAndWait() -- ќткрытие инвентар€ и задержка
    af = nil
    repeat
        wait(0)
        if af == nil or os.time() - af > 3 then
            sampSendClickTextdraw(49)
            af = os.time()
        end
    until getTextdrawByPos(leftSlots[7].x, leftSlots[7].y) ~= nil
end

function jet() -- ƒжетпак
    getJet = true
end

function sampev.onTextDrawHide(id) -- —крыть текстдрав
    textdraw[id] = nil
end
 
function getTextdrawByPos(x, y) -- ѕозици€ текстдрава
    local result = nil
    for k,v in pairs(textdraw) do
        if math.ceil(v.position.x) == x and math.ceil(v.position.y) == y then
            result = v
            break
        end
    end
    return result
end

function cmd_reset() -- ќбнуление статистики[ќпыт]
    simpleExperience = {}
    artifacts = {}
    zombies = {}
    ria = {}
    mainIni.EXP.totalSum = 0
    sampAddChatMessage("[KHelper] {FFFFFF}¬се счетчики были обнулены[ќпыт].", 0x00befc)
end

function resetstatart() -- ќбнуление статистики[ азино]
    	mainIni.ART.totalsummart = 0
		mainIni.ART.totalcollect = 0
		mainIni.ART.kost = 0
		mainIni.ART.yadro = 0
		mainIni.ART.lych = 0
		mainIni.ART.zerkalo = 0
		mainIni.ART.yantar = 0
		mainIni.ART.gilza = 0
		mainIni.ART.dysha = 0
		mainIni.ART.oskolok = 0
		mainIni.ART.glaz = 0
		mainIni.ART.batareika = 0
		mainIni.ART.krov = 0
		mainIni.ART.panaceya = 0
		mainIni.ART.linza = 0
		mainIni.ART.pandora = 0
		mainIni.ART.nota = 0
    sampAddChatMessage("[KHelper] {FFFFFF}¬се счетчики были обнулены[јртефакты]", 0x00befc)
end

function resettir() -- ќбнуление статистики[ азино]
    mainIni.TIR.Body = 0
	mainIni.TIR.Head = 0
	mainIni.TIR.lose = 0
	mainIni.TIR.wins = 0
	mainIni.TIR.miss = 0
	mainIni.TIR.money = 0
	mainIni.TIR.totalshots = 0
    sampAddChatMessage("[KHelper] {FFFFFF}¬се счетчики были обнулены[“ир]", 0x00befc)
end

function resetkazino() -- ќбнуление статистики[ азино]
    mainIni.KAZIK.kazinozero = 0
	mainIni.KAZIK.kazinofrukti = 0
	mainIni.KAZIK.kazinovisnya = 0
	mainIni.KAZIK.kazinokolokol = 0
	mainIni.KAZIK.kazinosemerky = 0
	mainIni.KAZIK.kazinodvevisni = 0
	mainIni.KAZIK.kazinokolokola = 0
	mainIni.KAZIK.totalstavok = 0
    sampAddChatMessage("[KHelper] {FFFFFF}¬се счетчики были обнулены[ азино]", 0x00befc)
end

function resetStats() -- ќбнуление статистики[ƒома]
    mainIni.house.totalItems = 0
    mainIni.house.totalProfit = 0
	mainIni.house.totalMoneyAdded = 0
    sampAddChatMessage("[KHelper] {FFFFFF}¬се счетчики были обнулены[ƒома]", 0x00befc)
end

function updateAnomalylocationsNameText() -- ќбновление информации в IMGUi
    if mainIni.con4index.currentIndex2 >= 1 and mainIni.con4index.currentIndex2 <= #anomalylocations then
        local anomalylocationz = anomalylocations[mainIni.con4index.currentIndex2]
        imgui.Text(u8(anomalylocationz.name))
    end
end

function displayCurrentIndexanomalylocations() -- ќбновление колво от/до в imgui
    if mainIni.con4index.currentIndex2 >= 1 and mainIni.con4index.currentIndex2 <= #anomalylocations then
        imgui.Text(string.format(u8'%d/%d', mainIni.con4index.currentIndex2, #anomalylocations), imgui.SameLine())
    end
end

function goBack2() -- ѕредущий пункт в списке IMGUI
    if mainIni.con4index.currentIndex2 > 1 then
        mainIni.con4index.currentIndex2 = mainIni.con4index.currentIndex2 - 1
        setMarker2(mainIni.con4index.currentIndex2)
    else
        print("Ёто первое аномальное место в списке.")
    end
end

function goForward2()  -- —ледующий пнкт в списке IMGUI
    if mainIni.con4index.currentIndex2 < #anomalylocations then
        mainIni.con4index.currentIndex2 = mainIni.con4index.currentIndex2 + 1
        setMarker2(mainIni.con4index.currentIndex2)
    else
        print("Ёто последнее аномальное место в списке.")
    end
end

function setMarker2(index)  -- ”становка метки јномальное место
    if index >= 1 and index <= #anomalylocations then
        local anom = anomalylocations[index]
        placeWaypoint(anom.x, anom.y, anom.name)
        print("ћетка установлена на: " .. anom.name)
    end
end

function updateOasisNameText() -- ќбновление информации в IMGUi
    if mainIni.con4index.currentIndex1 >= 1 and mainIni.con4index.currentIndex1 <= #oazis then
        local oasis = oazis[mainIni.con4index.currentIndex1]
        imgui.Text(u8(oasis.name))
    end
end

function displayCurrentIndexoas() -- ќбновление колво от/до в imgui
    if mainIni.con4index.currentIndex1 >= 1 and mainIni.con4index.currentIndex1 <= #oazis then
        imgui.Text(string.format(u8'%d/%d', mainIni.con4index.currentIndex1, #oazis), imgui.SameLine())
    end
end

function goBack1() -- ѕредущий пункт в списке IMGUI
    if mainIni.con4index.currentIndex1 > 1 then
        mainIni.con4index.currentIndex1 = mainIni.con4index.currentIndex1 - 1
        setMarker1(mainIni.con4index.currentIndex1)
    else
        print("Ёто первый оазис в списке.")
    end
end

function goForward1()  -- —ледующий пнкт в списке IMGUI
    if mainIni.con4index.currentIndex1 < #oazis then
        mainIni.con4index.currentIndex1 = mainIni.con4index.currentIndex1 + 1
        setMarker1(mainIni.con4index.currentIndex1)
    else
        print("Ёто последний оазис в списке.")
    end
end

function setMarker1(index)  -- ”становка метки CARDS
    if index >= 1 and index <= #oazis then
        local oas = oazis[index]
        placeWaypoint(oas.x, oas.y, oas.name)
        print("ћетка установлена на: " .. oas.name)
    end
end

function updateCardNameText() -- ќбновление информации в IMGUi
    if mainIni.con4index.currentIndex >= 1 and mainIni.con4index.currentIndex <= #cards then
        local card = cards[mainIni.con4index.currentIndex]
		imgui.Text(u8(card.name))
    end
end

function displayCurrentIndex() -- ќбновление колво от/до в imgui
    if mainIni.con4index.currentIndex >= 1 and mainIni.con4index.currentIndex <= #cards then
        imgui.Text(string.format(u8'%d/%d', mainIni.con4index.currentIndex, #cards), imgui.SameLine())
    end
end

function goBack() -- ѕредущий пункт в списке IMGUI
    if mainIni.con4index.currentIndex > 1 then
        mainIni.con4index.currentIndex = mainIni.con4index.currentIndex - 1
        setMarker(mainIni.con4index.currentIndex)
    else
        print("Ёто перва€ карта в списке.")
    end
end

function goForward()  -- —ледующий пнкт в списке IMGUI
    if mainIni.con4index.currentIndex < #cards then
        mainIni.con4index.currentIndex = mainIni.con4index.currentIndex + 1
        setMarker(mainIni.con4index.currentIndex)
    else
        print("Ёто последн€€ карта в списке.")
    end
end

function setMarker(index)  -- ”становка метки CARDS
    if index >= 1 and index <= #cards then
        local card = cards[index]
        placeWaypoint(card.x, card.y, card.name)
        print("ћетка установлена на: " .. card.name)
    end
end

function addGangZone(id, left, up, right, down, color) -- ƒобавление гангзоны
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, id)
    raknetBitStreamWriteFloat(bs, left)
    raknetBitStreamWriteFloat(bs, up)
    raknetBitStreamWriteFloat(bs, right)
    raknetBitStreamWriteFloat(bs, down)
    raknetBitStreamWriteInt32(bs, color)
    raknetEmulRpcReceiveBitStream(108, bs)
    raknetDeleteBitStream(bs)
end

function removeGangZone(id) -- ”даление гангзоны
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, id)
    raknetEmulRpcReceiveBitStream(120, bs)
    raknetDeleteBitStream(bs)
end

function remGZ() -- ”даление ганг с ID 400
	removeGangZone(400)
end

function sex() -- «адержка 6с вне бексонечно цикла
	lua_thread.create(function()
		wait(6000)
		end)
end

function sex2() -- «адержка 13с вне бексонечно цикла
	lua_thread.create(function()
		wait(13000)
		end)
end

function setMapMarker(x, y, squareName) -- ”становка маркера на аирдроп
	placeWaypoint(x, y)
	sampAddChatMessage(string.format("[KHelper]{FFFFFF} ћетка установлена на квадрате {ff0000}%s {ffffff}с координатами:{ff0000} X: %d, Y: %d", squareName, x, y), 0x00befc)
end

function distance(x2, y2, z2) -- –ассто€ние до установленного маркера
	result1, x2, y2, z2 = getTargetBlipCoordinates()
	if result1 then
		xp, yp, zp = getCharCoordinates(PLAYER_PED)
		--dismar = getDistanceBetweenCoords2d(xp, yp, x2, y2)
		dismar = getDistanceBetweenCoords3d(xp, yp, zp, x2, y2, z2)
		dismar1=string.sub(dismar,1,string.find(dismar,'.')+3)
		sampAddChatMessage("[KHelper] {FFFFFF}ћаркер установлен", 0x00befc)
		sampAddChatMessage("[KHelper] {FFFFFF}–ассто€ние до маркера: {cc0000}"..dismar1.. " {FFFFFF}метров.", 0x00befc)
	end
end

function solveEquation(a, b, c, d) -- ‘ункци€ дл€ поиска уравнени€
    local x = (-a)^2 + math.sqrt(b) - c * d
    return x
end

function solveNewEquation(a, b, c, d, e, f) -- ‘ункци€ дл€ поиска уравнени€
    local x = (a - b * (c - d)) / -math.sqrt(e + f)
    return x
end

function solveAnotherEquation(a, b, c, d, e, f, g) -- ‘ункци€ дл€ поиска уравнени€
    local x = (a + b * c) / d * (e - math.sqrt(f^g))
    return x
end

function calculateExperience() -- ‘ункци€ расчета опыта
    mainIni.EXP.simpleExpSum = 0
    for i, v in ipairs(simpleExperience) do
        mainIni.EXP.simpleExpSum = mainIni.EXP.simpleExpSum + v
    end
    mainIni.EXP.artifactsSum = 0
    for i, v in ipairs(artifacts) do
        mainIni.EXP.artifactsSum = mainIni.EXP.artifactsSum + v
    end
    mainIni.EXP.zombiesSum = 0
    for i, v in ipairs(zombies) do
        mainIni.EXP.zombiesSum = mainIni.EXP.zombiesSum + v
    end
	 mainIni.EXP.riaSum = 0
    for i, v in ipairs(ria) do
        mainIni.EXP.riaSum = mainIni.EXP.riaSum + v
    end
    mainIni.EXP.totalSum = mainIni.EXP.simpleExpSum + mainIni.EXP.artifactsSum + mainIni.EXP.zombiesSum + mainIni.EXP.riaSum
end

function GetNearestObject(modelid)  -- –ассо€ние до объекта
    local objects = {}
    local x, y, z = getCharCoordinates(playerPed)
    for i, obj in ipairs(getAllObjects()) do
        if getObjectModel(obj) == modelid then
            local result, ox, oy, oz = getObjectCoordinates(obj)
            table.insert(objects, {getDistanceBetweenCoords3d(ox, oy, oz, x, y, z), ox, oy, oz})
        end
    end
    if #objects <= 0 then return false end
    table.sort(objects, function(a, b) return a[1] < b[1] end)
    return true, unpack(objects[1])
end

function sampev.onSendExitVehicle(id) -- ‘ункци€ дл€ работы с если вышел из машины
    lua_thread.create(function()
        result  = sampGetCarHandleBySampVehicleId(id)
        if result then
			if checboxingeb.checked_test_6.v then
				wait(3000)
				if sampTextdrawIsExists(2223) and sampTextdrawGetString(2223) == 'Ma•ЬЃa' then
				setVirtualKeyDown(89, true)
				wait(30)
				setVirtualKeyDown(89, false)
				wait(100)
				sampSendClickTextdraw(210)  
				sampSendClickTextdraw(206)
			end
        end
    end
end)
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text) -- ‘ункци€ дл€ работы с диалогами
	
	if checboxingeb.checked_test_16.v then
	if dialogId == 93 then
	  local pattern = "{AAAAAA}–ешите уравнение%s*(.-)$"
	  local equation = string.match(text, pattern)
	  if equation then
		sampAddChatMessage(equation, -1)
		sampev.onServerMessage(color, equation)
	saving()
	  end
	  return false
	end
    end
	if checboxingeb.checked_test_66.v then
		if isTryingPasswords then
			return  -- ≈сли уже идет попытка, не запускаем повторно
		end
		if dialogId == 72 then -- диалоговое окно попыток ввода паролей
			-- text = ¬ведите код (3 цифры):
			local digitCount = tonumber(string.match(text, "(%d+)%s*цифры"))
			local interval = 2100 -- »нтервал в миллисекундах между вводами
			local maxAttempts = 10^digitCount - 1
			print('digitCount: ' .. digitCount)
			print('maxAttempts: ' .. maxAttempts)
			isTryingPasswords = true  -- ”станавливаем флаг
			tryPasswords(interval, maxAttempts, digitCount)
		end
	end
end

function tryPasswords(interval, maxAttempts, digitCount)
    -- —оздаем отдельный поток дл€ выполнени€ цикла с паузой
    lua_thread.create(function()
        for i = 20, 22 do -- for i = 0, maxAttempts do
			if isCorrectCodeEntered then -- ѕровер€ем, если код уже введен правильно
				print('Ќажали F8, дл€ скрина')
				setVirtualKeyDown(119, true)  -- Ќажимаем клавишу F8
				wait(100)                      -- ∆дем 100 миллисекунд
				setVirtualKeyDown(119, false) -- ќтпускаем клавишу F8
				print('Ќажали Esc, чтобы кикнуло')
				setVirtualKeyDown(27, true)  -- Ќажимаем клавишу Esc
				wait(100)  -- ∆дем 100 миллисекунд (например)
				setVirtualKeyDown(27, false)  -- ќтпускаем клавишу Esc
				break  -- ќстанавливаем цикл
			end

			while isProcessMedKit do
                wait(5000)  -- ѕровер€ем каждые 100 мс
            end

			local formatString = "%0" .. digitCount .. "d"
			local password = string.format(formatString, i)

            print('ѕопытка парол€: ' .. password)
            
            -- ќтправл€ем пароль в диалоговое окно
            local buttonId = 1  -- «амените на актуальный ID вашей кнопки (0 или 1)
			local dialogId = 72 -- «амените на актуальный ID вашего диалога
            sampSendDialogResponse(dialogId, buttonId, 0, password)

            -- ∆дем заданный интервал перед следующей попыткой
            wait(interval)
			print('---- end tryPasswords ----')
        end

		isTryingPasswords = false  -- —брасываем флаг после завершени€
    end)
end

function sampev.onShowTextDraw(id, data) -- ‘ункци€ дл€ работы с тектсдравами
	lua_thread.create(function()
		if checboxingeb.checked_test.v then
			if id == 2226 and data.text:find('L') then
				setVirtualKeyDown(89, true)
				wait(30)
				setVirtualKeyDown(89, false)
			end
		end
		if checboxingeb.checked_test_2.v then
			if id == 2057 and tonumber(data.lineWidth) <= 560 then
				sampSendChat('//a')
				sex()
			end
		end
		if checboxingeb.checked_test_66.v then
			-- 535 - 0 хп
			-- 605 - 100хп
			-- 550 и ниже - аптеку делаем			
			if not isProcessMedKit and id == 2057 and tonumber(data.lineWidth) <= 550 then
				print('»спользование MEDKIT')
				wait(100)
				sampSendChat('//a')
				print('Ќачало ожидани€ 13 сек')
				isProcessMedKit = true
				wait(13000)
				isProcessMedKit = false

				-- setVirtualKeyDown(59, true)
				-- wait(50)
				-- setVirtualKeyDown(59, false)
				print(' онец ожидани€.')
			end
		end
		if checboxingeb.checked_test_3.v then
			if id == 2054 and tonumber(data.lineWidth) <= 560 then
				sampSendChat('//e')
				sex()
			end
		end
		if checboxingeb.checked_test_4.v then
			if id == 2055 and tonumber(data.lineWidth) >= 540 then
				sampSendChat('//r')
				sex()
			end
		end
		if checboxingeb.checked_test_5.v then
			if sampTextdrawIsExists(2223) and sampTextdrawGetString(2223) == 'Гoѓ' then
			if testCheat('Z') then
				setVirtualKeyDown(89, true) -- зажатие клавиши (W)
				wait(30) -- задержка на секунду
				setVirtualKeyDown(89, false) -- отпускание клавиши (W)
			end
		end
			if id == 238 then
				if sampTextdrawIsExists(2223) and sampTextdrawGetString(2223) == 'Гoѓ' then
				sampSendClickTextdraw(238)
				wait(150)
				setVirtualKeyDown(89, true) -- зажатие клавиши (W)
				wait(30) -- задержка на секунду
				setVirtualKeyDown(89, false) -- отпускание клавиши (W)
			end
		end
			if id == 254 then
				if sampTextdrawIsExists(2223) and sampTextdrawGetString(2223) == 'Гoѓ' then
				sampSendClickTextdraw(254)
			end
		end
			if id == 81 then
				if sampTextdrawIsExists(2223) and sampTextdrawGetString(2223) == 'Гoѓ' then
				sampSendClickTextdraw(81)
				sampSendClickTextdraw(57)
		end
	end
end
end)
if checboxingeb.checked_test_13.v then
    local result, distance, x, y, z = GetNearestObject(3637)
    if distance and distance > 30 then
		if id == 70 and data.text:find('ПopЩoҐeЙ') then
			mainIni.textdrawslovo.torgovec = 1
		end
		if data.modelId == 2976 and (id == 2141 or id == 2145 or id == 2149 or id == 2153 or id == 2157 or id == 2161 or id == 2165 or id == 2169 or id == 2173 or id == 2177 or id == 2181 or id == 2185 or id == 2189 or id == 2193 or id == 2197 or id == 2201 or id == 2205 or id == 2209) then
			if mainIni.textdrawslovo.torgovec == 1 then
            	for i = 1, 8 do
            	sampSendClickTextdraw(id)
           		end
        	end
    	end
	end
end
if checboxingeb.checked_test_14.v then
	if id == 68 and data.text:find('АaЩaЫЃЬk') then
		mainIni.textdrawslovo.trunkFound = 1
	end
	if data.modelId == 2976 and (id == 2141 or id == 2145 or id == 2149 or id == 2153 or id == 2157 or id == 2161 or id == 2165 or id == 2169 or id == 2173 or id == 2177 or id == 2181 or id == 2185 or id == 2189 or id == 2193 or id == 2197 or id == 2201 or id == 2205 or id == 2209) then
		if mainIni.textdrawslovo.trunkFound == 1 then
            for i = 1, 8 do
                sampSendClickTextdraw(id)
			end
		end
	end
end
if checboxingeb.checked_test_15.v then
    if id == 2053 then
        local minutes, seconds = data.text:match('(%d+):(%d+)') -- »звлекаем минуты и секунды

        if minutes and seconds then
            minutes = tonumber(minutes)
            seconds = tonumber(seconds)
            if minutes and seconds then
                mainIni.jail.totalSeconds = minutes * 60 + seconds -- ќбновл€ем глобальную переменную
                mainIni.jail.result = mainIni.jail.totalSeconds / 5 -- ќбновл€ем глобальную переменную
            else
                sampAddChatMessage('ќшибка: Ќевозможно преобразовать врем€ в числа.', -1)
            end
        else
            sampAddChatMessage('ќшибка: ‘ормат времени не соответствует ожидаемому.', -1)
        end
    end
end
if checboxingeb.checked_test_18.v then
	calculateExperience()
	if data.text:find("+") and id == 2068 then
        for number in string.gmatch(data.text, '%d+') do
            local num = tonumber(number)
            if num then
                
                local isArtifact = num == 100
                local isRia = num == 200
                local isZombie = num == 56 or num == 28 or num == 42 or num == 112 or num == 84 or num == 168 or
                                num == 224 or num == 126 or num == 280 or num == 140 or num == 210 or num == 336 or 
                                num == 252 or num == 392 or num == 196 or num == 294 or num == 448 or num == 504 or 
                                num == 420 or num == 630 or num == 896 or num == 672 or num == 952 or num == 714 or 
                                num == 1008 or num == 756 or num == 1064 or num == 798 or num == 1120 or num == 840 or 
                                num == 1176 or num == 882 or num == 1232 or num == 924 or num == 1288 or num == 966

                if isArtifact then
                    table.insert(artifacts, num)
                elseif isRia then
                    table.insert(ria, num)
                elseif isZombie then
                    table.insert(zombies, num)
                else -- ¬се прочие числа попадут в просто опыт
                    table.insert(simpleExperience, num)
                end
					mainIni.EXP.simpleExpSum = 0
				for i, v in ipairs(simpleExperience) do
					mainIni.EXP.simpleExpSum = mainIni.EXP.simpleExpSum + v
				end
				 	mainIni.EXP.artifactsSum = 0
				for i, v in ipairs(artifacts) do
					mainIni.EXP.artifactsSum = mainIni.EXP.artifactsSum + v
				end
				 	mainIni.EXP.zombiesSum = 0
				for i, v in ipairs(zombies) do
					mainIni.EXP.zombiesSum = mainIni.EXP.zombiesSum + v
				end
				 	mainIni.EXP.riaSum = 0
				for i, v in ipairs(ria) do
					mainIni.EXP.riaSum = mainIni.EXP.riaSum + v
				end                
            end
        end
    end
end
if checboxingeb.checked_test_32.v then
    if id == 2053 then
        mainIni.TIR.currentScore = tonumber(data.text:match("(%d+)")) -- ѕреобразование строки в число
        local scoreChange = mainIni.TIR.currentScore - mainIni.TIR.previousScore -- –асчет изменени€ счета
        if scoreChange == 3 then
            mainIni.TIR.Head = mainIni.TIR.Head + 1
        elseif scoreChange == 1 then
            mainIni.TIR.Body = mainIni.TIR.Body + 1
        end
        mainIni.TIR.previousScore = mainIni.TIR.currentScore -- ќбновление предыдущего счета
        mainIni.TIR.timeLeft = data.text:match("(%d+)%sc") -- ќбновление оставшегос€ времени
    elseif sampTextdrawIsExists(2053) and id == 2061 then
        local currentNumber = tonumber(data.text:match("(%d+)"))
        if currentNumber and mainIni.TIR.previousNumber - currentNumber == 1 then
            mainIni.TIR.totalshots = mainIni.TIR.totalshots + 1
        end
        mainIni.TIR.previousNumber = currentNumber -- ќбновление предыдущего числа
    end
	mainIni.TIR.miss = mainIni.TIR.totalshots - (mainIni.TIR.Head + mainIni.TIR.Body)
end
if id == 2234 then
	if data.text:match("o?Ч? %((%d+) LVL%) 0 / %d+") then -- ≈сли убить зомби то +1
		mainIni.SimulyatorOpen.wallet = mainIni.SimulyatorOpen.wallet +1
end
end
if id == 2234 then
	if data.text:match("RIA %((%d+) LVL%) 0 / %d+") then -- ≈сли убить RIA то +2
		mainIni.SimulyatorOpen.wallet = mainIni.SimulyatorOpen.wallet +2
end
end
if id == 2223 then
	if data.text:find("Гoѓ") then
		mainIni.SimulyatorOpen.wallet = mainIni.SimulyatorOpen.wallet +0.001
	end
end
if id == 2223 then
	if data.text:find("ГЬaЮoЩ") then
		mainIni.SimulyatorOpen.wallet = mainIni.SimulyatorOpen.wallet +0.001
	end
end
if id == 2223 then
	if data.text:find("ПopЩoҐeЙ") then
		mainIni.SimulyatorOpen.wallet = mainIni.SimulyatorOpen.wallet +0.001
	end
end
if id == 2281 then
    if data.text:find("AND") then
        print(data.text)
        globalText = data.text
    end
end
if checboxingeb.checked_test_36.v then
    if id == 2218 then
        local number = data.text:match("nID.%s.y.(%d+)")
        if number then
            if not string.find(usedDecoders, "%f[%d]" .. number .. "%f[%D]") then
                usedDecoders = usedDecoders .. number .. ", "
            else
                
				for _, id in pairs(all_ids) do
					local original_text = sampTextdrawGetString(id)
					if original_text == "DexZero" or "Evixor" or "Notus" then
						sampTextdrawSetString(id, '~r~Decoder has already been used!')
					end
				end
            end
        end
    end
end
for _, id in pairs(TXDID.menu_ids) do
if sampTextdrawIsExists(id) then
	local box, color, sizeX, sizeY = sampTextdrawGetBoxEnabledColorAndSize(id)
	sampTextdrawSetBoxColorAndSize(id, box, mainIni.settings.prozrachnost, sizeX, sizeY)
end
end
for _, id in pairs(TXDID.skill_ids) do
	if sampTextdrawIsExists(id) then
		local box, color, sizeX, sizeY = sampTextdrawGetBoxEnabledColorAndSize(id)
		sampTextdrawSetBoxColorAndSize(id, box, mainIni.settings.skillcolor, sizeX, sizeY)
	end
end
for _, id in pairs(TXDID.skills_laterids) do
	if sampTextdrawIsExists(id) then
		local box, color, sizeX, sizeY = sampTextdrawGetBoxEnabledColorAndSize(id)
		sampTextdrawSetBoxColorAndSize(id, box, mainIni.settings.skillcolorall, sizeX, sizeY)
	end
end
for _, id in pairs(TXDID.blue_text) do
	if sampTextdrawIsExists(id) then
		local letSizeX, letSizeY, color = sampTextdrawGetLetterSizeAndColor(id)
		sampTextdrawSetLetterSizeAndColor(id, letSizeX, letSizeY, mainIni.settings.textcolor)
	end
end
if checboxingeb.checked_test_33.v then
    for _, id in pairs(all_ids) do
        local original_text = sampTextdrawGetString(id)
		if original_text == "Kac¶e¶" then
			sampTextdrawSetString(id, 'Kac¶e¶ (~r~70$~w~/~g~60$~w~)')
        end
		if original_text == "KЮЂ•ka" then
			sampTextdrawSetString(id, 'KЮЂ•ka ~w~(~r~N~w~/~g~130$~w~)')
		end
		if original_text == "ГyЧЬЃka" then
			sampTextdrawSetString(id, 'ГyЧЬЃka ~w~(~r~N~w~/~g~120$~w~)')
		end
		if original_text == "≠oЫ" then
			sampTextdrawSetString(id, '≠oЫ ~w~(~r~140$~w~/~g~50$~w~)')
		end
		if original_text == "АЬ¶a" then
			sampTextdrawSetString(id, 'АЬ¶a ~w~(~r~N~w~/~g~125$~w~)')
		end
		if original_text == "Зo£a¶a" then
			sampTextdrawSetString(id, 'Зo£a¶a ~w~(~r~N~w~/~g~160$~w~)')
		end
		if original_text == "KЬЭ" then
			sampTextdrawSetString(id, 'KЬЭ ~w~(~r~N~w~/~g~100$~w~)')
		end
		if original_text == "Ka¶aЃa" then
			sampTextdrawSetString(id, 'Ka¶aЃa ~w~(~r~N~w~/~g~350$~w~)')
		end
		if original_text == "АeЃЯo£ЬЮa" then
			sampTextdrawSetString(id, 'АeЃЯo£ЬЮa ~w~(~r~15 000$~w~/~g~800$~w~)')
		end
		if original_text == "ЗЬc¶ ЫeЮeЯa" then
			sampTextdrawSetString(id, 'ЗЬc¶ ЫeЮeЯa ~w~(~r~10 000$~w~/~g~1 000$~w~)')
		end
		if original_text == "ГpoҐa" then
			sampTextdrawSetString(id, 'ГpoҐa ~w~(~r~350$~w~/~g~50$~w~)')
		end
		if original_text == "Beretta-0 0%" then
			sampTextdrawSetString(id, 'Beretta-0 0% ~w~(~r~1 900$~w~/~g~320$~w~)')
		end
		if original_text == "Beretta-SD-0 0%" then
			sampTextdrawSetString(id, 'Beretta-SD-0 0% ~w~(~r~2 700$~w~/~g~440$~w~)')
		end
		if original_text == "DEagle-0 0%" then
			sampTextdrawSetString(id, 'DEagle-0 0% ~w~(~r~3 600$~w~/~g~600$~w~)')
		end
		if original_text == "Remington-0 0%" then
			sampTextdrawSetString(id, 'Remington-0 0% ~w~(~r~4 200$~w~/~g~720$~w~)')
		end
		if original_text == "OЧpeЯ-0 0%" then
			sampTextdrawSetString(id, 'OЧpeЯ-0 0% ~w~(~r~5 250$~w~/~g~650$~w~)')
		end
		if original_text == "Franchi SPAS-0 0%" then
			sampTextdrawSetString(id, 'Franchi SPAS-0 0% (~r~7 250$~w~/~g~990$~w~)')
        end
		if original_text == "UZI-0 0%" then
			sampTextdrawSetString(id, 'UZI-0 0% ~w~(~r~4 900$~w~/~g~780$~w~)')
		end
		if original_text == "HK MP5-0 0%" then
			sampTextdrawSetString(id, 'HK MP5-0 0% ~w~(~r~N~w~/~g~N~w~)')
		end
		if original_text == "AKM-0 0%" then
			sampTextdrawSetString(id, 'AKM-0 0% ~w~(~r~N~w~/~g~N~w~)')
		end
		if original_text == "M16-0 0%" then
			sampTextdrawSetString(id, 'M16-0 0% ~w~(~r~N~w~/~g~N~w~)')
		end
		if original_text == "TEC-DC9-0 0%" then
			sampTextdrawSetString(id, 'TEC-DC9-0 0% ~w~(~r~5 500$~w~/~g~900$~w~)')
		end
		if original_text == "ЛЬЃ¶oҐka CЛП-40-0 0%" then
			sampTextdrawSetString(id, 'ЛЬЃ¶oҐka CЛП-40-0 0% ~w~(~r~6 200$~w~/~g~1 040$~w~)')
		end
		if original_text == "CЛГ 6Л1-0 0%" then
			sampTextdrawSetString(id, 'CЛГ 6Л1-0 0% ~w~(~r~N~w~/~g~N~w~)')
		end
		if original_text == "ЕЃc¶pyѓeЃ¶® (ЃoҐ®e)" then
			sampTextdrawSetString(id, 'ЕЃc¶pyѓeЃ¶® (ЃoҐ®e) ~w~(~r~9 000$~w~/~g~1 800$~w~)')
		end
		if original_text == "Мa¶poЃ 12.7ѓѓ" then
			sampTextdrawSetString(id, 'Мa¶poЃ 12.7ѓѓ ~w~(~r~100$~w~/~g~35$~w~)')
		end
		if original_text == "Мa¶poЃ 18.5ѓѓ" then
			sampTextdrawSetString(id, 'Мa¶poЃ 18.5ѓѓ ~w~(~r~150$~w~/~g~70$~w~)')
		end
		if original_text == "Мa¶poЃ 9ѓѓ" then
			sampTextdrawSetString(id, 'Мa¶poЃ 9ѓѓ ~w~(~r~225$~w~/~g~80$~w~)')
		end
		if original_text == "Мa¶poЃ 7.62ѓѓ" then
			sampTextdrawSetString(id, 'Мa¶poЃ 7.62ѓѓ ~w~(~r~475$~w~/~g~125$~w~)')
		end
		if original_text == "Мa¶poЃ 8.61ѓѓ" then
			sampTextdrawSetString(id, 'Мa¶poЃ 8.61ѓѓ ~w~(~r~1 300$~w~/~g~250$~w~)')
		end
		if original_text == "O¶ѓ®§ka" then
			sampTextdrawSetString(id, 'O¶ѓ®§ka ~w~(~r~800$~w~/~g~170$~w~)')
		end
		if original_text == "АЬЃ¶" then
			sampTextdrawSetString(id, 'АЬЃ¶ ~w~(~r~125$~w~/~g~40$~w~)')
		end
		if original_text == "OЧeЯЧoЮЬҐaЂ°ee" then
			sampTextdrawSetString(id, 'OЧeЯЧoЮЬҐaЂ°ee ~w~(~r~440$~w~/~g~160$~w~)')
		end
		if original_text == "A£¶e§ka" then
			sampTextdrawSetString(id, 'A£¶e§ka ~w~(~r~720$~w~/~g~240$~w~)')
		end
		if original_text == "ApѓeЭckaђ a£¶e§ka" then
			sampTextdrawSetString(id, 'ApѓeЭckaђ a£¶e§ka ~w~(~r~1 650$~w~/~g~500$~w~)')
		end
		if original_text == "АЬЃokoЮ©" then
			sampTextdrawSetString(id, 'АЬЃokoЮ© ~w~(~r~5 500$~w~/~g~1 150$~w~)')
		end
		if original_text == "Jetpack" then
			sampTextdrawSetString(id, 'Jetpack ~w~(~p~10 000PT~w~/~p~N~w~)')
		end
		if original_text == "МЬҐo" then
			sampTextdrawSetString(id, 'МЬҐo ~w~(~r~280$~w~/~g~110$~w~)')
		end
		if original_text == "УЃepЩe¶Ьk" then
			sampTextdrawSetString(id, 'УЃepЩe¶Ьk ~w~(~r~400$~w~/~g~120$~w~)')
		end
		if original_text == "MЬЃepaЮ©Ѓaђ ҐoЪa" then
			sampTextdrawSetString(id, 'MЬЃepaЮ©Ѓaђ ҐoЪa ~w~(~r~210$~w~/~g~80$~w~)')
		end
		if original_text == "Kycok £ЬЙЙ®" then
			sampTextdrawSetString(id, 'Kycok £ЬЙЙ® ~w~(~r~350$~w~/~g~110$~w~)')
		end
		if original_text == "АypЩep" then
			sampTextdrawSetString(id, 'АypЩep ~w~(~r~410$~w~/~g~125$~w~)')
		end
		if original_text == "Мake¶ c eЪoЭ" then
			sampTextdrawSetString(id, 'Мake¶ c eЪoЭ ~w~(~r~900$~w~/~g~310$~w~)')
		end
		if original_text == "АЬЩ ЧypЩep" then
			sampTextdrawSetString(id, 'АЬЩ ЧypЩep ~w~(~r~750$~w~/~g~260$~w~)')
		end
		if original_text == "CyxoЭ £aek (ЕPМ)" then
			sampTextdrawSetString(id, 'CyxoЭ £aek (ЕPМ) ~w~(~r~500$~w~/~g~140$~w~)')
		end
		if original_text == "МЬЙЙa" then
			sampTextdrawSetString(id, 'МЬЙЙa ~w~(~r~1 100$~w~/~g~340$~w~)')
		end
		if original_text == "Нac®" then
			sampTextdrawSetString(id, 'Нac® ~w~(~r~200$~w~/~g~100$~w~)')
		end
		if original_text == "ПaЭЃЬk" then
			sampTextdrawSetString(id, 'ПaЭЃЬk ~w~(~r~N~w~/~g~2 500$~w~)')
		end
		if original_text == "KaЃЬc¶pa (£yc¶aђ)" then
			sampTextdrawSetString(id, 'KaЃЬc¶pa (£yc¶aђ) ~w~(~r~11 000$~w~/~g~2 000$~w~)')
		end
		if original_text == "MaЮ®Э Ґay§ep" then
			sampTextdrawSetString(id, 'MaЮ®Э Ґay§ep ~w~(~p~35PT~w~/~p~N~w~)')
		end
		if original_text == "CpeЪЃЬЭ Ґay§ep" then
			sampTextdrawSetString(id, 'CpeЪЃЬЭ Ґay§ep ~w~(~p~180PT~w~/~p~N~w~)')
		end
		if original_text == "АoЮ©•oЭ Ґay§ep" then
			sampTextdrawSetString(id, 'АoЮ©•oЭ Ґay§ep ~w~(~p~380PT~w~/~p~N~w~)')
		end
		if original_text == "MeЩa Ґay§ep" then
			sampTextdrawSetString(id, 'MeЩa Ґay§ep ~w~(~p~715PT~w~/~p~N~w~)')
		end
		if original_text == "PaЙЬђ (0 MHz)" then
			sampTextdrawSetString(id, 'PaЙЬђ (0 MHz) ~w~(~r~2 000$~w~/~g~400$~w~)')
		end
		if original_text == "CЮaЧ®Э aЃ¶ЬpaЪ" then
			sampTextdrawSetString(id, 'CЮaЧ®Э aЃ¶ЬpaЪ ~w~(~r~650$~w~/~g~60$~w~)')
		end
		if original_text == "CЬЮ©Ѓ®Э aЃ¶ЬpaЪ" then
			sampTextdrawSetString(id, 'CЬЮ©Ѓ®Э aЃ¶ЬpaЪ ~w~(~r~1 200$~w~/~g~85$~w~)')
		end
		if original_text == "Glock 17-0 0%" then
			sampTextdrawSetString(id, 'Glock 17-0 0% ~w~(~r~1 800$~w~/~g~300$~w~)')
		end
		if original_text == "AK47-0 0%" then
			sampTextdrawSetString(id, 'AK47-0 0% ~w~(~r~9 800$~w~/~g~1 360$~w~)')
		end
		if original_text == "RedBull" then
			sampTextdrawSetString(id, 'RedBull ~w~(~r~390$~w~/~g~110$~w~)')
		end
		if original_text == "NonStop" then
			sampTextdrawSetString(id, 'NonStop ~w~(~r~380$~w~/~g~100$~w~)')
		end
		if original_text == "МЬҐo CЮaҐy¶Ь§" then
			sampTextdrawSetString(id, 'МЬҐo CЮaҐy¶Ь§ ~w~(~r~360$~w~/~g~90$~w~)')
		end
		if original_text == "АoЮ©•oЭ kycok £ЬЙЙ®" then
			sampTextdrawSetString(id, 'АoЮ©•oЭ kycok £ЬЙЙ® ~w~(~r~420$~w~/~g~115$~w~)')
		end
		if original_text == "ГaЧЮ НЬЯЧypЩep" then
			sampTextdrawSetString(id, 'ГaЧЮ НЬЯЧypЩep ~w~(~r~580$~w~/~g~150$~w~)')
		end
		if original_text == "АЬЩMak" then
			sampTextdrawSetString(id, 'АЬЩMak ~w~(~r~720$~w~/~g~190$~w~)')
		end
		if original_text == "АЬЩПeЭc¶Ь" then
			sampTextdrawSetString(id, 'АЬЩПeЭc¶Ь ~w~(~r~760$~w~/~g~200$~w~)')
		end
		if original_text == "АoЮ©•oЭ £ake¶ c eЪoЭ" then
			sampTextdrawSetString(id, 'АoЮ©•oЭ £ake¶ c eЪoЭ ~w~(~r~1 050$~w~/~g~280$~w~)')
		end
		if original_text == "МЬЙЙa БpaЃko" then
			sampTextdrawSetString(id, 'МЬЙЙa БpaЃko ~w~(~r~1 250$~w~/~g~260$~w~)')
		end
		if original_text == "МЬЙЙa ГoѓeЃЬka" then
			sampTextdrawSetString(id, 'МЬЙЙa ГoѓeЃЬka ~w~(~r~1 350$~w~/~g~280$~w~)')
		end
		if original_text == "МЬЙЙa БpaЃ§ecka" then
			sampTextdrawSetString(id, 'МЬЙЙa БpaЃ§ecka ~w~(~r~1 320$~w~/~g~270$~w~)')
		end
		if original_text == "CaѓoЩoЃ" then
			sampTextdrawSetString(id, 'CaѓoЩoЃ ~w~(~r~310$~w~/~g~90$~w~)')
		end
		if original_text == "Notus" then
			sampTextdrawSetString(id, 'Notus ~w~(~r~40 000$~w~/~g~N~w~)')
		end
		if original_text == "Evixor" then
			sampTextdrawSetString(id, 'Evixor ~w~(~r~80 000$~w~/~g~5 000$~w~)')
		end
		if original_text == "Evixor" then
			sampTextdrawSetString(id, 'Evixor ~w~(~r~80 000$~w~/~g~5 000$~w~)')
		end
		if original_text == "DexZero" then
			sampTextdrawSetString(id, 'DexZero ~w~(~r~200 000$~w~/~g~10 000$~w~)')
		end
		if original_text == "ГЮЬЃЃaђ ҐepeҐka" then
			sampTextdrawSetString(id, 'ГЮЬЃЃaђ ҐepeҐka ~w~(~r~9 000$~w~/~g~1 200$~w~)')
		end
		if original_text == "Delirium" then
			sampTextdrawSetString(id, 'Delirium ~w~(~r~8 750$~w~/~g~800$~w~)')
		end
		if original_text == "Пo£ЮЬҐЃaђ cѓec©" then
			sampTextdrawSetString(id, 'Пo£ЮЬҐЃaђ cѓec© ~w~(~r~400$~w~/~g~300$~w~)')
		end
		if original_text == "≠oҐaђ Щpy££ЬpoҐka" then
			sampTextdrawSetString(id, '≠oҐaђ Щpy££ЬpoҐka ~w~(~r~600 000$~w~/~g~N~w~)')
		end
		if original_text == "CЬЃЬЭ ЃaЧop" then
			sampTextdrawSetString(id, 'CЬЃЬЭ ЃaЧop ~w~(~p~180PT~w~/~p~N~w~)')
		end
		if original_text == "ИeЮeЃ®Э ЃaЧop" then
			sampTextdrawSetString(id, 'ИeЮeЃ®Э ЃaЧop ~w~(~p~360PT~w~/~p~N~w~)')
		end
		if original_text == "ДeЮ¶®Э ЃaЧop" then
			sampTextdrawSetString(id, 'ДeЮ¶®Э ЃaЧop ~w~(~p~700PT~w~/~p~N~w~)')
		end
		if original_text == "OpaЃЫeҐ®Э ЃaЧop" then
			sampTextdrawSetString(id, 'OpaЃЫeҐ®Э ЃaЧop ~w~(~p~1500PT~w~/~p~N~w~)')
		end
		if original_text == "MaЮ®Э ЃaЧop" then
			sampTextdrawSetString(id, 'MaЮ®Э ЃaЧop ~w~(~r~15 000$~w~/~g~100$~w~)')
		end
		if original_text == "Ka¶aЮЬЯa¶op" then
			sampTextdrawSetString(id, 'Ka¶aЮЬЯa¶op ~w~(~p~100PT~w~/~p~N~w~)')
		end
		if original_text == "МП ѓЬЃa" then
			sampTextdrawSetString(id, 'МП ѓЬЃa ~w~(~r~5 000$~w~/~g~1 00$~w~)')
		end
		if original_text == "ММ ѓЬЃa" then
			sampTextdrawSetString(id, 'ММ ѓЬЃa ~w~(~r~4 000$~w~/~g~800$~w~)')
		end
		if original_text == "ГЬЃaѓЬ¶" then
			sampTextdrawSetString(id, 'ГЬЃaѓЬ¶ ~w~(~r~6 500$~w~/~g~1 250$~w~)')
		end
		if original_text == "C4" then
			sampTextdrawSetString(id, 'C4 ~w~(~r~12 000$~w~/~g~2 500$~w~)')
		end
		if original_text == "Гe¶oЃa¶op (STOCK)" then
			sampTextdrawSetString(id, 'Гe¶oЃa¶op (STOCK) ~w~(~r~500$~w~/~g~90$~w~)')
		end
		if original_text == 'МpeѓЬyѓ "Gain"' then
			sampTextdrawSetString(id, 'МpeѓЬyѓ "Gain" ~w~(~p~14PT~w~/~p~N~w~)')
		end
		if original_text == 'МpeѓЬyѓ "Care"' then
			sampTextdrawSetString(id, 'МpeѓЬyѓ "Care" ~w~(~p~12PT~w~/~p~N~w~)')
		end
		if original_text == 'МpeѓЬyѓ "Mega"' then
			sampTextdrawSetString(id, 'МpeѓЬyѓ "Mega" ~w~(~p~17PT~w~/~p~N~w~)')
		end
		if original_text == "MoЪЬШЬka¶op" then
			sampTextdrawSetString(id, 'MoЪЬШЬka¶op ~w~(~r~15 000$~w~/~g~500$~w~)')
		end
		if original_text == "MaЮaђ Чo§ka" then
			sampTextdrawSetString(id, 'MaЮaђ Чo§ka ~w~(~p~40PT~w~/~p~N~w~)')
		end
		if original_text == "CpeЪЃђђ Чo§ka" then
			sampTextdrawSetString(id, 'CpeЪЃђђ Чo§ka ~w~(~p~60PT~w~/~p~N~w~)')
		end
		if original_text == "АoЮ©•aђ Чo§ka" then
			sampTextdrawSetString(id, 'АoЮ©•aђ Чo§ka ~w~(~p~80PT~w~/~p~N~w~)')
		end
		if original_text == "YckopЬ¶eЮ©" then
			sampTextdrawSetString(id, 'YckopЬ¶eЮ© ~w~(~p~50PT~w~/~p~N~w~)')
		end
		if original_text == "OЧ®§Ѓ®Э yckopЬ¶eЮ©" then
			sampTextdrawSetString(id, 'OЧ®§Ѓ®Э yckopЬ¶eЮ© ~w~(~p~100PT~w~/~p~N~w~)')
		end
		if original_text == "YЮy§•eЃЃ®Э yckopЬ¶eЮ©" then
			sampTextdrawSetString(id, 'YЮy§•eЃЃ®Э yckopЬ¶eЮ© ~w~(~p~150PT~w~/~p~N~w~)')
		end
		if original_text == "AҐ¶ocЧop°Ьk" then
			sampTextdrawSetString(id, 'AҐ¶ocЧop°Ьk ~w~(~p~30PT~w~/~p~N~w~)')
		end
		if original_text == "YЮy§•eЃЃ®Э AҐ¶ocЧop°Ьk" then
			sampTextdrawSetString(id, 'YЮy§•eЃЃ®Э AҐ¶ocЧop°Ьk ~w~(~p~50PT~w~/~p~N~w~)')
		end
		if original_text == "MaЮoe xpaЃЬЮЬ°e" then
			sampTextdrawSetString(id, 'MaЮoe xpaЃЬЮЬ°e ~w~(~p~30PT~w~/~p~N~w~)')
		end
		if original_text == "CpeЪЃee xpaЃЬЮЬ°e" then
			sampTextdrawSetString(id, 'CpeЪЃee xpaЃЬЮЬ°e ~w~(~p~50PT~w~/~p~N~w~)')
		end
		if original_text == "Аyp" then
			sampTextdrawSetString(id, 'Аyp ~w~(~p~200PT~w~/~p~N~w~)')
		end
		if original_text == "ЛЬЪeoЃaЧЮЂЪeЃЬe" then
			sampTextdrawSetString(id, 'ЛЬЪeoЃaЧЮЂЪeЃЬe ~w~(~r~5 000$~w~/~g~250$~w~)')
		end
		if original_text == "Оokep" then
			sampTextdrawSetString(id, 'Оokep ~w~(~p~40PT~w~/~p~N~w~)')
		end
		if original_text == "CЮaЧ®Э ЬЃШopѓep" then
			sampTextdrawSetString(id, 'CЮaЧ®Э ЬЃШopѓep ~w~(~r~5 000$~w~/~g~250$~w~)')
		end
		if original_text == "CpeЪЃЬЭ ЬЃШopѓep" then
			sampTextdrawSetString(id, 'CpeЪЃЬЭ ЬЃШopѓep ~w~(~r~1 000$~w~/~g~300$~w~)')
		end
		if original_text == "CЬЮ©Ѓ®Э ЬЃШopѓep" then
			sampTextdrawSetString(id, 'CЬЮ©Ѓ®Э ЬЃШopѓep ~w~(~r~15 000$~w~/~g~300$~w~)')
		end
		if original_text == "БЬoЮe¶oҐ®Э ЃaЧop" then
			sampTextdrawSetString(id, 'БЬoЮe¶oҐ®Э ЃaЧop ~w~(~p~2 900PT~w~/~p~N~w~)')
		end

    end
end
if checboxingeb.checked_test_46.v then
	if id == 2069 or id == 2073 or id == 2077 or id == 2081 or id == 2085 or id == 2089 or id == 2093 or id == 2097 or id == 2101 or id == 2105 or id == 2109 or id == 2113 or id == 2117 or id == 2121 or id == 2125 or id == 2129 or id == 2133 or id == 2137 then
		if data.text:find('АeЮ®Э ЃaЧop') then
			sampSendClickTextdraw(id)
			sampSendClickTextdraw(2219)
			sampSendClickTextdraw(57)
		end
	end
end
if checboxingeb.checked_test_45.v then
	if id == 2069 or id == 2073 or id == 2077 or id == 2081 or id == 2085 or id == 2089 or id == 2093 or id == 2097 or id == 2101 or id == 2105 or id == 2109 or id == 2113 or id == 2117 or id == 2121 or id == 2125 or id == 2129 or id == 2133 or id == 2137 then
		if data.text:find('MaЮ®Э ЃaЧop') then
			sampSendClickTextdraw(id)
			sampSendClickTextdraw(2219)
			sampSendClickTextdraw(57)
		end
	end
end
if checboxingeb.checked_test_44.v then
	if id == 2069 or id == 2073 or id == 2077 or id == 2081 or id == 2085 or id == 2089 or id == 2093 or id == 2097 or id == 2101 or id == 2105 or id == 2109 or id == 2113 or id == 2117 or id == 2121 or id == 2125 or id == 2129 or id == 2133 or id == 2137 then
		if data.text:find('МЬҐo') or data.text:find('CaѓoЩoЃ')  then
			sampSendClickTextdraw(id)
			sampSendClickTextdraw(2219)
			sampSendClickTextdraw(57)
		end
	end
end
if checboxingeb.checked_test_47.v then
	if id == 2069 or id == 2073 or id == 2077 or id == 2081 or id == 2085 or id == 2089 or id == 2093 or id == 2097 or id == 2101 or id == 2105 or id == 2109 or id == 2113 or id == 2117 or id == 2121 or id == 2125 or id == 2129 or id == 2133 or id == 2137 then
		if data.text:find('Лay§ep') then
			sampSendClickTextdraw(id)
			sampSendClickTextdraw(2219)
			sampSendClickTextdraw(57)
		end
	end
end
if checboxingeb.checked_test_48.v then
	if id == 2069 or id == 2073 or id == 2077 or id == 2081 or id == 2085 or id == 2089 or id == 2093 or id == 2097 or id == 2101 or id == 2105 or id == 2109 or id == 2113 or id == 2117 or id == 2121 or id == 2125 or id == 2129 or id == 2133 or id == 2137 then
		if data.text:find('МoЪapok') then
			sampSendClickTextdraw(id)
			sampSendClickTextdraw(2219)
			sampSendClickTextdraw(57)
		end
	end
end


if checboxingeb.checked_test_38.v then
	if sampTextdrawIsExists(44) then
   		if id == 44 and data.text:find('(%d+)') then
			koneckapta = 1000 - tonumber(data.text)
			minuteskapt = math.floor(koneckapta / 60)
			secondskapt = math.floor(koneckapta % 60)
			textkapt = minuteskapt .. ' м ' .. secondskapt .. ' с'
    	end
	end
end
if checboxingeb.checked_test_40.v then
    if sampTextdrawIsExists(212) then
        sampSendClickTextdraw(212)
    end
end
  

antiflood_textdraw = os.clock() * 1000
    if checkTextdrawIgnore(id) then
       -- print(string.format("ID: %s | Text: %s | %s | %s", id, converGameToRussian(data.text), math.ceil(data.position.x), math.ceil(data.position.y)))
    end
    data.textdrawId = id
    data.textRu = converGameToRussian(data.text)
    textdraw[id] = data
saving()
end


function sampev.onServerMessage(color, text) -- ‘ункци€ дл€ работы с сообщени€ми в чате
		if checboxingeb.checked_test_66.v  and text == ' од введен верно, тайник открыт дл€ вас' then
			print(' од введен верно!')
			isCorrectCodeEntered = true
		end
		if checboxingeb.checked_test_7.v then
			if color == -1431655681 then
				local squareName = text:match("—амолет с провизией вылетел в квадрат (%a%d)")
				if squareName and squares[squareName] then
					local x, y = table.unpack(squares[squareName])
					setMapMarker(x, y, squareName)
					if wquares[squareName] then
						local zoneData = wquares[squareName]
						addGangZone(zoneData[1], zoneData[2], zoneData[3], zoneData[4], zoneData[5], 0xFF0000FF)
						sampAddChatMessage("[KHelper]{FFFFFF} „тобы убрать выделение квадрата используйте {FF0000}" .. mainIni.settings.keyactiv .. " {FFFFFF}как чит-код", 0x00befc)
					else
						print("ƒанные гангзоны дл€ квадрата " .. squareName .. " не найдены.")
					end
				end
			end
		end
	if checboxingeb.checked_test_8.v then
		if text:find("«аброшенный аэродром") and color == -12320513 or color == 16711935 then 
			local startTime = os.time() -- сохран€ем текущее врем€
			local endTime = startTime + (15 * 60) -- добавл€ем 15 минут
	
			lua_thread.create(function()
				while os.time() < endTime do
					local timeLeft = endTime - os.time() -- вычисл€ем оставшеес€ врем€
					printStringNow('Гo БМ: ~r~ ' .. tostring(math.floor(timeLeft / 60)) .. '~w~m ~r~' .. tostring(timeLeft % 60) .. '~w~s', 1000)
					wait(1000) -- задержка одна секунда
				end
				local file = getWorkingDirectory()..'\\resource\\fpgo.mp3'
				if doesFileExist(file) then
				local sound = loadAudioStream(file)
				setAudioStreamState(sound, 1)
			end
			end)
		end
	end
	if checboxingeb.checked_test_9.v then
		if getActiveInterior() ~= 0 then
			local function escapePattern(text)
				return text:gsub("([%W])", "%%%1")
			end
			for item, price in pairs(items) do
				local escapedItem = escapePattern(item)
				local matchPattern = escapedItem .. " {FFFFFF}x {44AAFF}(%d+)"
				local match = text:match(matchPattern)
				if match then
					local itemCount = tonumber(match)
					mainIni.house.totalItems = mainIni.house.totalItems + itemCount
					mainIni.house.totalProfit = mainIni.house.totalProfit + (itemCount * price)
					saving()
					inicfg.save(mainIni, "tychagova.ini")
					
				end
			end
	
			-- ƒобавл€ем новый шаблон дл€ поиска текста с суммой денег
			local moneyPattern = "{00AA00}%$(%d+) {FFFFFF}добавлено в инвентарь"
		local moneyMatch = text:match(moneyPattern)
		if moneyMatch then
			local moneyAmount = tonumber(moneyMatch)
			mainIni.house.totalMoneyAdded = mainIni.house.totalMoneyAdded or 0
			mainIni.house.totalMoneyAdded = mainIni.house.totalMoneyAdded + moneyAmount
			print("ƒеньги добавлены: " .. moneyAmount) -- Ћогирование дл€ отладки
			saving()
			end
		end
		end
	
	if checboxingeb.checked_test_15.v then
		if text:find("¬рем€ пребывани€ в темнице уменьшено на (%d+) секунд") then
			mainIni.jail.kamni = mainIni.jail.kamni + 1
			mainIni.jail.foodCounter = mainIni.jail.foodCounter - 1 -- ”меньшаем счетчик при каждом переносе камн€
			sampSendClickTextdraw(401)
			if mainIni.jail.foodCounter == 0 then
				mainIni.jail.foodCounter = 10 -- —брасываем счетчик до следующей еды
			end
		end
	end
	if checboxingeb.checked_test_16.v then
    -- ѕаттерны дл€ поиска чисел в сообщении
    local pattern1 = "x%s*=%s*(-?%d+)%^2%s*%+%s*sqrt%s*%((%d+)%)%s*-%s*(%d+)%s*%*%s*(%d+)"
    local pattern2 = "(%d+) %* x %- %((%-?%d+)%) %+ x = (%d+)"
    local pattern3 = "x%s*=%s*%(%s*(-?%d+)%s*-%s*(%d+)%s*%*%s*%(%s*(-?%d+)%s*-%s*(%d+)%)%)%s*/%s*-sqrt%s*%(%s*(%d+)%s*%+%s*(%d+)%)"
    local pattern4 = "x%s*=%s*%(%s*(-?%d+)%s*%+%s*(%d+)%s*%*%s*(%d+)%)%s*/%s*(%d+)%s*%*%s*%(%s*(-?%d+)%s*-%s*sqrt%s*%(%s*(-?%d+)%s*%^%s*(%d+)%)%)"
    
    -- ѕоиск по первому паттерну
    local a, b, c, d = text:match(pattern1)
    if a and b and c and d then
        a, b, c, d = tonumber(a), tonumber(b), tonumber(c), tonumber(d)
        local result = solveEquation(a, b, c, d)
        sampAddChatMessage("{FFFFFF}ќтвет: {FF0000}" .. result, -1)
		sampSendDialogResponse(93, 1, 0, result)
        return
    end
    
    -- ѕоиск по второму паттерну
    a, b, c = text:match(pattern2)
    if a and b and c then
        a, b, c = tonumber(a), tonumber(b), tonumber(c)
        local x = (c + b) / (a + 1)
        sampAddChatMessage("{FFFFFF}ќтвет: {FF0000}" .. x, -1)
		sampSendDialogResponse(93, 1, 0, x)
        return
    end
    
    -- ѕоиск по третьему паттерну
    a, b, c, d, e, f = text:match(pattern3)
    if a and b and c and d and e and f then
        a, b, c, d, e, f = tonumber(a), tonumber(b), tonumber(c), tonumber(d), tonumber(e), tonumber(f)
        local result = solveNewEquation(a, b, c, d, e, f)
        sampAddChatMessage("{FFFFFF}ќтвет: {FF0000}" .. result, -1)
		sampSendDialogResponse(93, 1, 0, result)
        return
    end
    
    -- ѕоиск по четвертому паттерну
    a, b, c, d, e, f, g = text:match(pattern4)
    if a and b and c and d and e and f and g then
        a, b, c, d, e, f, g = tonumber(a), tonumber(b), tonumber(c), tonumber(d), tonumber(e), tonumber(f), tonumber(g)
        local result = solveAnotherEquation(a, b, c, d, e, f, g)
        sampAddChatMessage("{FFFFFF}ќтвет: {FF0000}" .. result, -1)
		sampSendDialogResponse(93, 1, 0, result)
    end
	saving()
end

if checboxingeb.checked_test_17.v then 
	if text:find("две вишни") then
		mainIni.KAZIK.kazinodvevisni = mainIni.KAZIK.kazinodvevisni + 1
	elseif text:find("без выигрыша") then
		mainIni.KAZIK.kazinozero = mainIni.KAZIK.kazinozero + 1
	elseif text:find("приз x8") then
		mainIni.KAZIK.kazinovisnya = mainIni.KAZIK.kazinovisnya + 1
	elseif text:find("два колокольчика") then
		mainIni.KAZIK.kazinokolokol = mainIni.KAZIK.kazinokolokol + 1
	elseif text:find("приз x2") then
		mainIni.KAZIK.kazinofrukti = mainIni.KAZIK.kazinofrukti + 1
	elseif text:find("три семерки") then
		mainIni.KAZIK.kazinosemerky = mainIni.KAZIK.kazinosemerky + 1
	elseif text:find("колокольчики") then
		mainIni.KAZIK.kazinokolokola = mainIni.KAZIK.kazinokolokola + 1
	end
	mainIni.KAZIK.totalstavok = mainIni.KAZIK.kazinodvevisni + mainIni.KAZIK.kazinofrukti + mainIni.KAZIK.kazinokolokol + mainIni.KAZIK.kazinokolokola + mainIni.KAZIK.kazinosemerky + mainIni.KAZIK.kazinovisnya + mainIni.KAZIK.kazinozero
end
if checboxingeb.checked_test_32.v then
	if text:find("»гра окончена, вы набрали") then
		mainIni.TIR.currentScore = 0
		mainIni.TIR.timeLeft = 0
	elseif text:find("ѕоздравл€ем! ¬ы победили!") then
		mainIni.TIR.wins = mainIni.TIR.wins + 1
		mainIni.SimulyatorOpen.wallet = mainIni.SimulyatorOpen.wallet + 1
	elseif text:find("  сожалению, вы проиграли") then
		mainIni.TIR.lose = mainIni.TIR.lose + 1
	elseif isCharShooting(PLAYER_PED) then
		mainIni.TIR.totalshots = mainIni.TIR.totalshots + 1
	elseif text:find("{00AA00}%$(%d+) {FFFFFF}добавлено в инвентарь") then
		local amount = tonumber(text:match("%$(%d+)"))
		if amount then
			mainIni.TIR.money = mainIni.TIR.money + amount
		end
	end
end
if text:find("ѕоздравл€ем! ¬ы победили!") then
	mainIni.SimulyatorOpen.wallet = mainIni.SimulyatorOpen.wallet + 3
end
	saving()
	if checboxingeb.checked_test_37.v then
		local item_text, item_count = text:match("(.+)%s+{FFFFFF}x%s+{44AAFF}(%d+){FFFFFF}%s+добавлено%s+в%s+.+")
        if item_text and item_count then
            item_text = item_text:gsub("{%x+}", "")
            item_count = tonumber(item_count)
            if item_text ~= "ћалый набор" and item_text ~= "Ѕелый набор" and item_text ~= " расный набор" and item_text ~= "—иний набор" and item_text ~= "«еленый набор" and item_text ~= "∆елтый набор" and item_text ~= "ќранжевый набор" and item_text ~= "‘иолетовый набор" then
                for _, skin in ipairs(skin_texts) do
                    if item_text == skin then
                        item_text = "—кин"
						break
					end
				end
				local found = false
				for i, v in ipairs(data) do
					local occurrences, base_text, count = v:match("%[(%d+)%]%s+(.+)%s+x%s+(%d+)")
					if base_text == item_text then
						count = tonumber(count)
						occurrences = tonumber(occurrences)
						data[i] = string.format("[%d] %s x %d", occurrences + 1, base_text, count + item_count)
						found = true
						break
					end
				end
				if not found then
					table.insert(data, string.format("[1] %s x %d", item_text, item_count))
				end
            end
        end
    end
	if checboxingeb.checked_test_42.v then
		if not sampTextdrawIsExists(68) then
			for i, v in pairs(artprise) do
				if text:find("." .. v.name .. ".%s.L(%d+).D(%d+).") then
					local l, d = text:match("." .. v.name .. ".%s.L(%d+).D(%d+).")
					for _, coef in ipairs(coeficentart) do
						if tonumber(d) == coef.D then
							mainIni.ART.totalsummart = (mainIni.ART.totalsummart or 0) + tonumber(l) * v.priseforlvl * coef.C
							mainIni.ART.totalcollect = mainIni.ART.kost + mainIni.ART.lych + mainIni.ART.yadro + mainIni.ART.zerkalo + mainIni.ART.yantar + mainIni.ART.gilza + mainIni.ART.dysha + mainIni.ART.oskolok + mainIni.ART.glaz + mainIni.ART.batareika + mainIni.ART.krov + mainIni.ART.panaceya + mainIni.ART.linza + mainIni.ART.pandora
							if tonumber(l) >= 10 and tonumber(l) <= 16 then
								printStyledString("Xop. apt: ~r~(L"..l.."-D"..d ..")", 5000, 5)
							end
						end
					end
				end
			end
		end
	end
	if checboxingeb.checked_test_42.v then
		if not sampTextdrawIsExists(68) then
				if text:find(' ость') then
					mainIni.ART.kost = mainIni.ART.kost + 1
				elseif text:find('Ћуч') then
					mainIni.ART.lych = mainIni.ART.lych + 1
				elseif text:find('ядро') then
					mainIni.ART.yadro = mainIni.ART.yadro + 1
				elseif text:find('«еркало') then
					mainIni.ART.zerkalo = mainIni.ART.zerkalo + 1
				elseif text:find('янтарь') then
					mainIni.ART.yantar = mainIni.ART.yantar + 1
				elseif text:find('√ильза') then
					mainIni.ART.gilza = mainIni.ART.gilza + 1
				elseif text:find('ƒуша') then
					mainIni.ART.dysha = mainIni.ART.dysha + 1
				elseif text:find('ќсколок') then
					mainIni.ART.oskolok = mainIni.ART.oskolok + 1
				elseif text:find('√лаз') then
					mainIni.ART.glaz = mainIni.ART.glaz + 1
				elseif text:find('Ѕатарейка') then
					mainIni.ART.batareika = mainIni.ART.batareika + 1
				elseif text:find(' ровь') then
					mainIni.ART.krov = mainIni.ART.krov + 1
				elseif text:find('ѕанаце€') then
					mainIni.ART.panaceya = mainIni.ART.panaceya + 1
				elseif text:find('Ћинза') then
					mainIni.ART.linza = mainIni.ART.linza + 1
				elseif text:find('ѕандора') then
					mainIni.ART.pandora = mainIni.ART.pandora + 1
				elseif text:find('Ќота') then
					mainIni.ART.nota = mainIni.ART.nota + 1
				end
			end
		end
	end

-- ‘ункци€ дл€ проверки наличи€ элемента в таблице
function table_contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function saving() -- —охранение данных
    mainIni.checkboxs.checked_test = checboxingeb.checked_test.v
	mainIni.checkboxs.checked_test_2 = checboxingeb.checked_test_2.v
	mainIni.checkboxs.checked_test_3 = checboxingeb.checked_test_3.v
	mainIni.checkboxs.checked_test_4 = checboxingeb.checked_test_4.v
	mainIni.checkboxs.checked_test_5 = checboxingeb.checked_test_5.v
	mainIni.checkboxs.checked_test_6 = checboxingeb.checked_test_6.v
	mainIni.checkboxs.checked_test_7 = checboxingeb.checked_test_7.v
    mainIni.checkboxs.checked_test_8 = checboxingeb.checked_test_8.v
	mainIni.checkboxs.checked_test_9 = checboxingeb.checked_test_9.v
	mainIni.checkboxs.checked_test_10 = checboxingeb.checked_test_10.v
	mainIni.checkboxs.checked_test_11 = checboxingeb.checked_test_11.v
	mainIni.checkboxs.checked_test_12 = checboxingeb.checked_test_12.v
	mainIni.checkboxs.checked_test_13 = checboxingeb.checked_test_13.v
	mainIni.checkboxs.checked_test_14 = checboxingeb.checked_test_14.v
	mainIni.checkboxs.checked_test_15 = checboxingeb.checked_test_15.v
	mainIni.checkboxs.checked_test_16 = checboxingeb.checked_test_16.v
	mainIni.checkboxs.checked_test_66 = checboxingeb.checked_test_66.v
	mainIni.checkboxs.checked_test_17 = checboxingeb.checked_test_17.v
	mainIni.checkboxs.checked_test_18 = checboxingeb.checked_test_18.v
	mainIni.checkboxs.checked_test_19 = checboxingeb.checked_test_19.v
	mainIni.checkboxs.checked_test_20 = checboxingeb.checked_test_20.v
	mainIni.checkboxs.checked_test_21 = checboxingeb.checked_test_21.v -- 9 15 17 18 32 34 37 42
	mainIni.checkboxs.checked_test_22 = checboxingeb.checked_test_22.v
	mainIni.checkboxs.checked_test_23 = checboxingeb.checked_test_23.v
	mainIni.checkboxs.checked_test_24 = checboxingeb.checked_test_24.v
	mainIni.checkboxs.checked_test_25 = checboxingeb.checked_test_25.v
	mainIni.checkboxs.checked_test_26 = checboxingeb.checked_test_26.v
	mainIni.checkboxs.checked_test_27 = checboxingeb.checked_test_27.v
	mainIni.checkboxs.checked_test_28 = checboxingeb.checked_test_28.v
	mainIni.checkboxs.checked_test_29 = checboxingeb.checked_test_29.v
	mainIni.checkboxs.checked_test_30 = checboxingeb.checked_test_30.v
	mainIni.checkboxs.checked_test_31 = checboxingeb.checked_test_31.v
	mainIni.checkboxs.checked_test_32 = checboxingeb.checked_test_32.v
	mainIni.checkboxs.checked_test_33 = checboxingeb.checked_test_33.v
	mainIni.checkboxs.checked_test_34 = checboxingeb.checked_test_34.v
	mainIni.checkboxs.checked_test_35 = checboxingeb.checked_test_35.v
	mainIni.checkboxs.checked_test_36 = checboxingeb.checked_test_36.v
	mainIni.checkboxs.checked_test_37 = checboxingeb.checked_test_37.v
	mainIni.checkboxs.checked_test_38 = checboxingeb.checked_test_38.v
	mainIni.checkboxs.checked_test_39 = checboxingeb.checked_test_39.v
	mainIni.checkboxs.checked_test_40 = checboxingeb.checked_test_40.v
	mainIni.checkboxs.checked_test_41 = checboxingeb.checked_test_41.v
	mainIni.checkboxs.checked_test_42 = checboxingeb.checked_test_42.v
	mainIni.settings.prozrachnost = savesettings.prozrachnost.v
	mainIni.settings.skillcolor = savesettings.skillcolor.v
	mainIni.settings.skillcolorall = savesettings.skillcolorall.v
	mainIni.settings.anomalyzonecolor = savesettings.anomalyzonecolor.v
	mainIni.SimulyatorOpen.wallet = mainIni.SimulyatorOpen.wallet
	mainIni.house.totalItems = mainIni.house.totalItems
	mainIni.house.totalProfit = mainIni.house.totalProfit
	mainIni.house.totalMoneyAdded = mainIni.house.totalMoneyAdded
	mainIni.KAZIK.kazinozero = mainIni.KAZIK.kazinozero
	mainIni.KAZIK.kazinofrukti = mainIni.KAZIK.kazinofrukti
	mainIni.KAZIK.kazinovisnya = mainIni.KAZIK.kazinovisnya
	mainIni.KAZIK.kazinokolokol = mainIni.KAZIK.kazinokolokol
	mainIni.KAZIK.kazinosemerky = mainIni.KAZIK.kazinosemerky
	mainIni.KAZIK.kazinodvevisni = mainIni.KAZIK.kazinodvevisni
	mainIni.KAZIK.kazinokolokola = mainIni.KAZIK.kazinokolokola
	mainIni.KAZIK.totalstavok = mainIni.KAZIK.totalstavok
	mainIni.EXP.totalSum = mainIni.EXP.totalSum
	mainIni.EXP.simpleExpSum = mainIni.EXP.simpleExpSum
	mainIni.EXP.artifactsSum = mainIni.EXP.artifactsSum
	mainIni.EXP.zombiesSum = mainIni.EXP.zombiesSum
	mainIni.EXP.riaSum = mainIni.EXP.riaSum
	mainIni.TIR.currentScore = mainIni.TIR.currentScore
	mainIni.TIR.timeLeft = mainIni.TIR.timeLeft
	mainIni.TIR.Head = mainIni.TIR.Head
	mainIni.TIR.Body = mainIni.TIR.Body
	mainIni.TIR.previousScore = mainIni.TIR.previousScore
	mainIni.TIR.wins = mainIni.TIR.wins
	mainIni.TIR.lose = mainIni.TIR.lose
	mainIni.TIR.totalshots = mainIni.TIR.totalshots
	mainIni.TIR.previousNumber = mainIni.TIR.previousNumber
	mainIni.TIR.miss = mainIni.TIR.miss
	mainIni.TIR.money = mainIni.TIR.money

	local lines = {}
for line in globalText:gmatch("[^n]+") do
    table.insert(lines, line)
end
for _, line in ipairs(lines) do
    if not string.find(mainIni.settings.globalText, line, 1, true) then
        mainIni.settings.globalText = (mainIni.settings.globalText or "") .. "\n" .. line
    end
end
    inicfg.save(mainIni, "tychagova.ini")
end

function generateCombinations(input)
    local patterns = {}
    local function helper(pattern)
        if #pattern == #input then
            table.insert(patterns, pattern)
            return
        end
        local i = #pattern + 1
        if input:sub(i, i) == "-" then
            helper(pattern .. "0")
            helper(pattern .. "1")
        else
            helper(pattern .. input:sub(i, i))
        end
    end
    helper("")
    return patterns
end

function isPalindrome(number)
    local str = tostring(number)
    return str == string.reverse(str)
end

function looksLikeDate(number)
    local str = tostring(number)
    local day = tonumber(str:sub(1, 2))
    local month = tonumber(str:sub(3, 4))
    local year = tonumber(str:sub(5, 6))
    return #str == 6 and day >= 1 and day <= 31 and month >= 1 and month <= 12
end

function isRepeatingPairs(number)
    local str = tostring(number)
    return str:match("^(%d%d)%1%1$")
end

function hasRepeatingDigitsTwice(number)
    local str = tostring(number)
    local repeats = {}
    for digit in str:gmatch("%d") do
        repeats[digit] = (repeats[digit] or 0) + 1
    end
    local count = 0
    for _, v in pairs(repeats) do
        if v == 2 then count = count + 1 end
    end
    return count == 2
end

function handleHelpCommand(text, colorizeEquals)
	if text == nil or text == "" then
	  print("Error: No input provided.")
	  return
	end
    math.randomseed(os.time()) -- »нициализируем генератор случайных чисел
    local input = text:gsub(" ", "") -- ”дал€ем пробелы дл€ обработки как единой строки
    local combinations = generateCombinations(input)
    output = ""
    local line = "" -- ƒобавл€ем переменную дл€ хранени€ текущей строки
    -- √енерируем разделительную строку
    local delimiter = mainIni.settings.razdelitel
    local delimiterLine = string.rep(delimiter, mainIni.settings.yeban) 
    local delimiterBlock = string.rep(delimiterLine .. "\n", mainIni.settings.kolichestvoRazdelitelnihStrok)

    for i, combination in ipairs(combinations) do
        local decimal = tonumber(combination, 2) -- ѕереводим двоичное число в дес€тичное
        if isPalindrome(decimal) then
            line = line .. "{FF0000}" -- ¬ыдел€ем зеркальные числа красным
        elseif looksLikeDate(decimal) then
            line = line .. "{FFFF00}" -- ¬ыдел€ем числа, похожие на даты, желтым
        elseif isRepeatingPairs(decimal) then
            line = line .. "{00FF00}" -- ¬ыдел€ем числа с повтор€ющимис€ парами зеленым
        elseif hasRepeatingDigitsTwice(decimal) then
            line = line .. "{fb4aff}" -- ¬ыдел€ем числа с повтор€ющимис€ цифрами два раза розовым
        end
        line = line .. decimal .. " | " -- ƒобавл€ем число и разделитель в текущую строку
        if i % mainIni.settings.parolinonestroka == 0 then
            output = output .. line .. "\n" .. delimiterBlock -- ƒобавл€ем блок разделительных строк
            line = "" -- ќчищаем текущую строку дл€ следующей группы комбинаций
        end
    end

    if line ~= "" then
        output = output .. line -- ƒобавл€ем оставшиес€ комбинации, если они есть
    end
end







