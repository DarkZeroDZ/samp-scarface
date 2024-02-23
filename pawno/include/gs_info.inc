//      Defines
#define MAX_VEHICLE_DATA 19
#define MAX_SCHROTTPLATZ 1
#define MAX_LOGIN_STEP 3
#define MAX_PASSWORD_LENGTH 16
#define MAX_ADMIN_LEVEL 5
#define MAX_HOUSES 32
#define MAX_TIMER 4
#define MAX_HOUSE_MIETER 10
#define MAX_FRAKTIONEN 20
#define MAX_FRAKTION_GROUPS 4
#define MAX_PLAYER_SKINS 300
#define MAX_FRAKTION_RANK 7
#define MAX_INTERIORS 129
#define MAX_MOTEL_COST 300
#define MAX_SELL_HOUSE_PERCENTAGE 50
#define RESTART_STUNDE 23
#define RESTART_MINUTE 59
#define MAX_INTEGER 32
#define MAX_WEAPON_ID 47
#define MAX_MATERIAL_SLOTS 6

#define MAX_CARRY_MATERIALS_WITH_TRUCK 2500
#define MAX_CARRY_MATERIALS_ONFOOT 750
#define MAX_MATERIAL_COST 65
#define MAX_PLAYER_KEYS 7
#define MAX_FRAKTION_KEYS 25
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define MAX_CAR_SHOPS 1
#define MAX_BOT_CARS 1
#define MAX_BOTS 4
#define MAX_VEHICLE_MODEL 211
#define PVAR_THREAD_SAFE -1
#define VVAR_THREAD_SAFE -1
#define MAX_TRAILER 10
#define MAX_PLAYER_WANTED 7
#define ARREST_TIME_PER_WANTED 5
#define ARREST_KATION_PER_WANTED 1000
#define MAX_CHECK_FEED 3000
#define MAX_GANG_WAR_ZONES 35
#define MAX_GANG_WAR_FLAGS 3
#define MAX_GANG_WAR_ROUNDTIME 30 //Einheit in Minuten
#define MAX_GANG_WAR_COOLDOWN 3 //Einheit in Stunden
#define GetStringArg(%1,%2) for(new x = 0; getarg(%1,x) != '\0'; x++) %2[x] = getarg(%1,x)
#define MAX_DIVIDE_STRENGTH 900

//		Farben
#define COLOR_GREY (0xAFAFAFAA)
#define COLOR_GREEN (0x33AA33AA)
#define COLOR_RED (0xAA3333AA)
#define COLOR_ORANGE (0xFF9900AA)
#define COLOR_LIGHTRED (0xFF6347AA)
#define COLOR_BLUE (0x33CCFFAA)
#define COLOR_LIGHTBLUE (0x33CCFFAA)
#define COLOR_LIGHTGREEN (0x9ACD32AA)
#define COLOR_YELLOW (0xFFFF00AA)
#define COLOR_WHITE (0xFFFFFFAA)
#define COLOR_HOUSE_INFORMATION (0x008080FF)
#define COLOR_HOUSE_EXIT (0xAA3333FF)

#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E

//		Reverse´s
#define REVERSE(_%0) %0

//      Dialog-ID´s
#define LoginDialog (1)
#define AdminDialog (2)
#define InteriorDialog (3)
#define HouseDialog (4)
#define MotelDialog (5)
#define FraktionMenuDialog (6)
#define SchluesselDialog (7)
#define CarshopDialog (8)
#define HandyDialog (9)
#define SchrottDialog (10)
#define Waffenlieferant (11)
#define ConfigDialog (12)
#define FraktionlagerDialog (13)
#define BankDialog (14)
#define PDDialog (15)
#define PlayerImport (16)
#define InventarDialog (17)
#define InventarDialogExt (18)

//		Dialog-Texte
#define SchluesselText ("Fahrzeugschlüssel\nUnterkunftsschluessel")
#define SchluesselText2 ("Schlüessel verkaufen\nSchlüssel ablegen\nFahrzeug parken")
#define FraktionMenuText ("Kassa\nWaffenlager\nMitglieder\nFahrzeuge\nTagesbilanz\nBeziehungen\nEinstellungen")
#define FraktionMenuText2 ("Rangnamen verändern\nGehalt setzen\nWaffenlagerpreise verändern")
#define ConfigMenuText ("Fraktions.config\nUnterkunfts.config\nKleidershop.config\nCarshop.config\nGangWar.config")
#define ConfigMenuText1 ("Fraktionsnamen ändern\nFraktionsfarbe ändern\nFraktionsgruppe ändern\nFraktionskassa setzen\nSpawnpunkt setzen\nMenüpunkt setzen\nLieferposition setzen\nSpawnwaffe setzen")
#define ConfigMenuText2 ("Unterkunft erstellen\nUnterkunft reseten\nUnterkunft löschen")
#define ConfigMenuText3 ("GangWarZone erstellen\nGangWarZonen auflisten")
#define ConfigMenuText3_1 ("Name der Zone ersetzen\nZonenbesitzer ändern\nFlaggen neu setzen\nZone löschen")
#define FraktionLagerText ("Fahrzeug spenden\nMaterialien lagern")
#define BankmenuText ("Bargeld Ein-/Auszahlen\nÜberweisung\nKontoauszug\nKontostand\nEinstellungen")
#define PDText ("Derzeitig Gesuchte\nFahndung setzen\nAkte auflösen\nVerhaftete Spieler")
#define InventarDialogText ("Schlüsselband\nRohstoffe\nGeldbörsel")

//		Team Ordnung
/*
		0	..	Zivilisten
		1	..	Behörden (Niedrig)
		2	..	Behörden (Mittel)
		3	..	Behörden (Hoch)
		4	..	Gang´s
		5	..	Mafien
		6	..	Präsident
		7	..	Sonstige Fraktionen
*/

//      P-Vars
/*
	PlayerLoginStep
	PlayerAccount
	PlayerLogged
	OldClassID
	AdminSysPlayer
	AdminSysStep
	AngebotWaffeSpieler
	AngebotWaffeWert
	AngebotWaffeID
	AngebotWaffeAmmo
	AngebotRohlingeSpieler
	AngebotRohlingeSlot
	AngebotRohlingeMenge
	AngebotRohlingeWert
	AngebotMunitionSpieler
	AngebotMunitionSlot
	AngebotMunitionMenge
	AngebotMunitionWert
	SchluesselID
*/

new Menu:Kleidershop;
new Menu:UnterkunftsMenu[4];

new gVehicleIndex[MAX_VEHICLES]={-1,...};
new gCurrentTime[3];
new Kleidungspickup[6];

new BotNames[][]={
	"TruckerCaS",
	"PorterSteve",
	"StaplerJosef",
	"StaplerDieter"
};

enum bInfo
{
	bID,
	bName[MAX_PLAYER_NAME],
	bType,
	bData[3],
};
new BotInfo[MAX_BOTS][bInfo];
new BotID[MAX_PLAYERS];
new LieferBotCar[2];
new BotCount;
new SCInfo[MAX_SCHROTTPLATZ][3];

new BotCars[MAX_BOTS];
new Carshoppickup[MAX_CAR_SHOPS];

enum trailerInfo
{
	tCarID,
	tMenge,
	tWepMat[MAX_MATERIAL_SLOTS],
	tMagMat[MAX_MATERIAL_SLOTS],
};
new TrailInfo[MAX_TRAILER][trailerInfo];
new AmuNationTrailPickup;

enum fishEnum
{
	fscName[MAX_PLAYER_NAME],
	Float:fscGewichtMin,
	Float:fscGewichtMax,
	fscTiefe,
	fscVorkommen,
};

enum precacheInfo
{
	pcType,
	pcText[22],
};
new VehiclePreCacheInfo[][precacheInfo]={
{0,"VehicleKey"},
{2,"VehicleOwner"},
{0,"VehicleCost"},
{2,"VehicleOldOwner"},
{0,"VehicleModel"},
{1,"VehiclePosX"},
{1,"VehiclePosY"},
{1,"VehiclePosZ"},
{1,"VehiclePosAngle"},
{0,"VehicleColor1"},
{0,"VehicleColor2"},
{2,"VehicleTuning"},
{0,"VehicleDestroyed"},
{2,"VehicleDamageStatus"},
{0,"VehicleDestroyedCount"},
{1,"VehicleHealth"},
{1,"VehiclePickPos"},
{0,"VehicleKeyState"},
{0,"VehicleDelivery"},
{0,"VehicleDeliveryShop"},
{0,"VehicleLocked"},
{0,"VehicleParking"}
};

#define MAX_FISCH 20
new FischInfo[20][fishEnum]={
{"Elritze",3.0,5.0,-1,98},
{"Seestern",3.0,9.0,-2,90},
{"Aal",8.0,11.0,-5,70},
{"Barbe",7.0,13.0,-4,80},
{"Barsch",12.0,18.0,-4,80},
{"Dorsch",40.0,50.0,-30,40},
{"Forelle",14.0,30.0,-8,60},
{"Hecht",20.0,30.0,-10,50},
{"Karpfen",20.0,35.0,-20,45},
{"Krake",20.0,25.0,-50,10},
{"Königskrabbe",12.0,16.0,-10,67},
{"Lachs",30.0,35.0,-25,42},
{"Riesenmaulhai",400.0,500.0,-110,1},
{"Schwertfisch",100.0,200.0,-60,30},
{"Wels",19.0,25.0,-18,60},
{"Zander",15.0,20.0,-30,50},
{"Mantarochen",1000.0,2000.0,-50,15},
{"Kugelfisch",1000.0,2000.0,-48,20},
{" A",1000.0,10000.0,-50,10},
{"Wal",50000.0,120000.0,-70,2}
};

enum spshopinfo
{
	shID,
	Float:shPosX,
	Float:shPosY,
	Float:shPosZ,
	Float:shPosAngle,
};
new CarShopParks[][spshopinfo]={
{0,2132.3372,-1128.4139,25.3053,89.1943}, // CaSPos1
{0,2133.3286,-1134.1687,25.3912,89.7258}, // CaSPos2
{0,2134.2551,-1140.3442,24.9883,93.3039}, // CaSPos3
{0,2148.2024,-1194.8293,23.5435,269.8758}, // CaSPos4
{0,2148.2739,-1184.7676,23.5258,269.5716}, // CaSPos5
{0,2148.2048,-1175.4187,23.5256,268.8782}, // CaSPos6
{0,2148.3535,-1166.0887,23.5259,270.3757}, // CaSPos7
{0,2148.5439,-1157.1348,23.5521,270.3914} // CaSPos8
};

new Float:ArrestPort[][4]={
{0.0,198.6635,162.0265,1003.0300}, // LSPD-Zelle 1
{0.0,193.9474,174.8804,1003.0234}, // LSPD-Zelle 2
{0.0,197.9699,174.9836,1003.0234} // LSPD-Zelle 3
};
#define MAX_LSPD_CELLS 3

new Float:BomberManSpawn[][3]={
{1784.0964,-1307.5327,136.6115}, // SpawnPos 1 R
{1793.4786,-1307.7517,142.5827}, // SpawnPos 2
{1804.8733,-1307.8450,137.5334}, // SpawnPos 3
{1823.5432,-1308.2285,138.0056}, // SpawnPos 4
{1826.2811,-1308.0178,146.4418}, // SpawnPos 5
{1780.8239,-1307.6658,149.4093}, // SpawnPos 6
{1816.5756,-1308.2054,143.4719}, // SpawnPos 7
{1802.2314,-1308.4296,143.5866}, // SpawnPos 8
{1786.5828,-1307.7415,135.3859} // SpawnPos 9
};

new CarName[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
 	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
 	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
 	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
 	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum",
	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
 	"Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
 	"Phoenix", "2. Gebrauchtwagen", "1. Gebrauchtwagen", "Luggage", "Luggage", "Stairs", "Boxville",
 	"Tiller", "Utility Trailer"
};
enum dataenum
{
	dType,
	dText[32],
	dInteger,
	Float:dFloat,
	dString[32],
};
enum adminenum
{
	aText[32],
	aMinAdmin,
	aHighAdmin,
};
new gPlayerAdminInformation[][adminenum] = {
//Supporter
{"Kicken",1,MAX_ADMIN_LEVEL}, 
{"Zufluestern",1,MAX_ADMIN_LEVEL}, 
{"Hin Porten",1,MAX_ADMIN_LEVEL}, 
{"Mute/Unmute",1,MAX_ADMIN_LEVEL}, 
{"Einfrieren (N/A)",1,MAX_ADMIN_LEVEL},
//Operator
{"Her Porten",2,MAX_ADMIN_LEVEL},
{"Beobachten (TV) (N/A)",2,MAX_ADMIN_LEVEL}, 
{"Zeitbann setzen (N/A)",2,MAX_ADMIN_LEVEL}, 
{"Stats-Check (N/A)",2,MAX_ADMIN_LEVEL}, 
{"CNN Nachricht (N/A)",2,MAX_ADMIN_LEVEL}, 
{"Stumm kicken",2,MAX_ADMIN_LEVEL}, 
{"Schlagen",2,MAX_ADMIN_LEVEL},
{"Debuggen",2,MAX_ADMIN_LEVEL},
//Security
{"Interior setzen",3,MAX_ADMIN_LEVEL}, 
{"Verwarnen (N/A)",3,MAX_ADMIN_LEVEL}, 
{"Stumm bannen",3,MAX_ADMIN_LEVEL}, 
{"Ins/Aus Haft (N/A)",3,MAX_ADMIN_LEVEL}, 
{"Lizenz vergeben (N/A)",3,MAX_ADMIN_LEVEL},
//Admin
{"Fraktion setzen",4,MAX_ADMIN_LEVEL}, 
{"Lebenszustand setzen",4,MAX_ADMIN_LEVEL}, 
{"Ruestung setzen",4,MAX_ADMIN_LEVEL}, 
{"Geld geben",4,MAX_ADMIN_LEVEL},
{"Fahrzeugzustand setzen",4,MAX_ADMIN_LEVEL}, 
{"Fahrzeug erstellen",4,MAX_ADMIN_LEVEL},
//Server OwneR
{"Geld setzen",5,MAX_ADMIN_LEVEL}, 
{"Waffe geben",5,MAX_ADMIN_LEVEL}, 
{"Admin setzen",5,MAX_ADMIN_LEVEL}
};

enum houseenum
{
	hBesitzer[MAX_PLAYER_NAME],
	hPreis,
	hMietbar,
	hMiete,
	Float:hEnterX,
	Float:hEnterY,
	Float:hEnterZ,
	Float:hEnterAngle,
	hVorlageID,
	hEnterPickup,
	hExitPickup,
	hMenuPickup,
	Text3D:hEnterText,
	Text3D:hExitText,
	hMapIcon,
	hMieterUpPrice[MAX_HOUSE_MIETER+1],
	bool:hMieterOwnerRight[MAX_HOUSE_MIETER+1],
	bool:hLock,
	hKassa,
	hMaxKassa,
};
new HInfo[MAX_HOUSES+1][houseenum];
new HInfoMieter[MAX_HOUSES+1][MAX_HOUSE_MIETER+1][MAX_PLAYER_NAME];
new Iterator:Houses<MAX_HOUSES>;
enum housevenum
{
	hvText[MAX_PLAYER_NAME],
	Float:hvExitX,
	Float:hvExitY,
	Float:hvExitZ,
	Float:hvExitAngle,
	Float:hvMenuX,
	Float:hvMenuY,
	Float:hvMenuZ,
	Float:hvMenuAngle,
	hvInterior,
};
new HVorlage[][housevenum]={
{"Hotel Suite 1",2217.5508,-1076.1528,1050.4844,88.1200,2208.1013,-1071.8403,1050.4766,179.4458,1},
{"Hotel Suite 2",2237.3855,-1081.3196,1049.0234,358.2883,2242.8137,-1068.4121,1049.5226,325.4114,2},
{"CJ House",2495.8918,-1692.6210,1014.7422,173.5648,2495.7949,-1704.0040,1018.3438,79.5641,3},
{"Bed Room",2233.7859,-1114.7562,1050.8828,354.5517,2230.7490,-1107.7715,1050.8828,272.1676,5},
{"3 Bedroom",2196.4417,-1204.2874,1049.0234,92.0250,2200.5935,-1214.7854,1049.0234,181.2276,6},
{"SmallApartment",2308.9473,-1212.5209,1049.0234,1.7584,2317.1006,-1210.2059,1049.0234,96.2176,6},
{"WoodHouse",2333.2783,-1077.0439,1049.0234,355.1315,2344.1011,-1067.3754,1049.0234,15.9801,6},
{"Suburban Template",2365.1895,-1135.5068,1050.8826,356.4550,2372.6411,-1123.7477,1051.3507,356.6468,8},
{"Large Multi-Story House",2318.0881,-1026.6554,1050.2178,359.5183,2327.1238,-1011.6322,1050.7101,36.0103,9},
{"Large House",2270.0181,-1210.2531,1047.5625,90.1449,2258.6587,-1208.7462,1049.0234,180.8440,10},
{"Efficiency Apartment",2283.1636,-1139.8307,1050.8984,1.1084,2278.0920,-1134.7277,1050.8984,89.3008,11},
{"Very Big House",2324.5732,-1149.0836,1050.7101,357.9516,2324.4856,-1141.7264,1050.9835,251.2723,12}
};
enum frakenum
{
	fName[MAX_PLAYER_NAME],
	fColor,
	fTeam,
	fKassa,
	fGehalt[MAX_FRAKTION_RANK],
	Float:fMenu[3],
	fMenuID, //CACHED
	Float:fSpawn[3],
	Float:fLiefer[3],
	fLieferInfo[2],
	fSpawnInfo[2],
	fSpawnWeapon,
	fSpawnAmmo,
	fVehicles[MAX_FRAKTION_KEYS],
	fWepCost[MAX_WEAPON_ID],
	fMagCost[MAX_MATERIAL_SLOTS],
	fWepMat[MAX_MATERIAL_SLOTS],
	fMagMat[MAX_MATERIAL_SLOTS],
	fGangWar,
};
new FInfo[MAX_FRAKTIONEN][frakenum];
new FInfoRang[MAX_FRAKTIONEN][MAX_FRAKTION_RANK][MAX_PLAYER_NAME];
new FMotD[MAX_FRAKTIONEN][256];

enum gwenum
{
	gwID,
	gwName[MAX_PLAYER_NAME],
	gwOwner,
	gwBonus,
	Float:gwPos[4], //MinX, MinY, MaxX, MaxY
	Float:gwFlagPos1[3],
	Float:gwFlagPos2[3],
	Float:gwFlagPos3[3],
	gwFlagOwnTime[MAX_GANG_WAR_FLAGS],
	gwFlagMinPlayer[MAX_GANG_WAR_FLAGS],
	gwFlagOwner[MAX_GANG_WAR_FLAGS],
	bool:gwWar,
	gwRoundTime,
	gwAttacker,
	gwPointsDefense,
	gwPointsAttacker,
	gwGangWarMaded,
	
	//Variablen die nicht in SQL gespeichert werden...
	gwSphere,
	gwFlagSphere[MAX_GANG_WAR_FLAGS],
	gwFlagIcon[MAX_GANG_WAR_FLAGS],
	gwFlagTakeOver[MAX_GANG_WAR_FLAGS],
	gwFlagTPCDefense[MAX_GANG_WAR_FLAGS],
	gwFlagTPCAttacker[MAX_GANG_WAR_FLAGS],
};
new GWInfo[MAX_GANG_WAR_ZONES][gwenum];

enum InteriorInfo
{
	iPickIDIn,
	iPickIDOut,
	bool:iVW,
	Float:iXIn,
	Float:iYIn,
	Float:iZIn,
	iIntIn,
	iText[64],
	Float:iXOut,
	Float:iYOut,
	Float:iZOut,
	iIntOut,
	iPD,
	iKleidung,
	iFrak,
}
new IInfo[MAX_INTERIORS][InteriorInfo] = {
//CluckinBell´s
{-1,-1,true,2397.7205,-1897.7749,13.5469,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  1
{-1,-1,true,2420.8010,-1509.1154,24.0000,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  2
{-1,-1,true,928.4771,-1352.9467,13.3438,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  3
{-1,-1,true,-2155.1011,-2460.2571,30.8516,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  4
{-1,-1,true,-1213.0835,1830.8761,41.9297,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  5
{-1,-1,true,172.6963,1176.6672,14.7645,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  6
{-1,-1,true,2637.5459,1671.8496,11.0234,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  7
{-1,-1,true,2392.8354,2042.0293,10.8203,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  8
{-1,-1,true,2102.3254,2228.7620,11.0234,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  9
{-1,-1,true,2838.3931,2407.2756,11.0690,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1}, // clucking bell  10
{-1,-1,true,-2671.3799,258.4465,4.6328,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1},
{-1,-1,true,-1816.6078,618.0471,35.1719,0,"Willkommen im~n~~y~CluckinBell",365.0331,-10.9481,1001.8516,9,0,-1,-1},
//BurgerShoot´s
{-1,-1,true,1199.263549,-918.892028,43.117515,0,"Willkommen im~n~~p~BurgerShoot",363.2596,-74.8009,1001.5078,10,0,-1,-1}, // Burger Shoot North
{-1,-1,true,1139.5436,2080.8547,11.0547,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1}, // bruger shot rein 1
{-1,-1,true,1139.5684,2080.7209,11.0547,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1}, // bruger shot rein 1
{-1,-1,true,1139.6057,2080.7292,11.0547,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1}, // bruger shot rein 2
{-1,-1,true,1872.9126,2071.8245,11.0625,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1}, // bruger shot rein 3
{-1,-1,true,2170.0642,2795.5339,10.8203,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1}, // bruger shot rein 4
{-1,-1,true,2365.8750,2071.1240,10.8203,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1}, // bruger shot rein 5
{-1,-1,true,2471.9868,2034.3071,11.0625,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1}, // bruger shot rein 6
{-1,-1,true,-1912.0594,828.4325,35.1800,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1},
{-1,-1,true,-2356.2739,1008.0617,50.8984,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1},
{-1,-1,true,810.7878,-1616.2417,13.5469,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1},
{-1,-1,true,-2335.9463,-167.0042,35.5547,0,"Willkommen im~n~~r~BurgerShoot", 363.2596,-74.8009,1001.5078,10,0,-1,-1}, //(23)
//WellStackedPizza´s
{-1,-1,true,2352.0139,2532.8303,10.8203,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},  // pizza stack rein 1
{-1,-1,true,2756.4868,2477.2700,11.0625,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},  // pizza stack rein 2
{-1,-1,true,2083.1816,2224.4839,11.0234,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},  // pizza stack rein 3
{-1,-1,true,2638.3103,1849.6935,11.0234,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},  // pizza stack rein 4
{-1,-1,true,2332.8389,75.1001,26.6210,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1}, // pizza stack rein 4
{-1,-1,true,2083.2419,2223.9675,11.0234,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},  // pizza stack rein 6
{-1,-1,true,203.2982,-202.6826,1.5781,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},  // pizza stack rein 8
{-1,-1,true,1367.4498,248.4098,19.5669,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},
{-1,-1,true,2105.0894,-1806.3676,13.5547,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},
{-1,-1,true,-1721.5542,1359.7612,7.1853,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1},
{-1,-1,true,-1808.4524,945.5787,24.8906,0,"Willkommen im~n~~p~WellStackedPizza",372.2693,-133.3035,1001.4922,5,0,-1,-1}, // (34)
//AmmuNation´s
{-1,-1,true,2400.4602,-1981.2893,13.5469,0,"Willkommen im~n~~g~AmmuNation",285.5844,-41.4660,1001.5156,1,0,-1,-1}, // ammu nations rein 1
{-1,-1,true,1368.4019,-1279.7991,13.5469,0,"Willkommen im~n~~g~AmmuNation",285.5844,-41.4660,1001.5156,1,0,-1,-1}, // ammu nations rein 2
{-1,-1,true,-2625.8442,208.3442,4.8125,0,"Willkommen im~n~~g~AmmuNation",285.7368,-85.8856,1001.5229,4,0,-1,-1}, // ammu nations rein 3
{-1,-1,true,776.7213,1871.3209,4.9061,0,"Willkommen im~n~~g~AmmuNation",296.9272,-111.6407,1001.5156,6,0,-1,-1}, // ammu nations rein 4
{-1,-1,true,2159.5178,943.2438,10.8203,0,"Willkommen im~n~~g~AmmuNation",296.9272,-111.6407,1001.5156,6,0,-1,-1}, // ammu nations rein 5
{-1,-1,true,2332.7883,30.8857,26.6752,0,"Willkommen im~n~~g~AmmuNation",296.9272,-111.6407,1001.5156,6,0,-1,-1}, // ammu nations rein 6
{-1,-1,true,242.3536,-178.5564,1.5781,0,"Willkommen im~n~~g~AmmuNation",315.8419,-143.4170,999.6016,7,0,-1,-1}, // ammu nations rein 7
{-1,-1,true,-2093.4998,-2464.7092,30.6250,0,"Willkommen im~n~~g~AmmuNation",315.8419,-143.4170,999.6016,7,0,-1,-1}, // ammu nations rein 8
{-1,-1,true,-1508.9208,2610.4458,55.8359,0,"Willkommen im~n~~g~AmmuNation",316.3879,-169.7038,999.6010,6,0,-1,-1}, // ammu nations rein 9 (43)
//KleiderShop´s
{-1,-1,true,2244.5164,-1665.0430,15.4766,0,"Willkommen im~n~~y~Binco",207.7141,-110.5676,1005.1328,15,0,0,-1}, //Binco
{-1,-1,true,1656.7595,1733.0797,10.8281,0,"Willkommen im~n~~y~Binco",207.7141,-110.5676,1005.1328,15,0,0,-1}, //Binco
{-1,-1,true,2102.4470,2257.4856,11.0234,0,"Willkommen im~n~~y~Binco",207.7141,-110.5676,1005.1328,15,0,0,-1}, //Binco
{-1,-1,true,-2374.5625,910.1388,45.4453,0,"Willkommen im~n~~y~Binco",207.7141,-110.5676,1005.1328,15,0,0,-1}, //Binco
{-1,-1,true,1456.8954,-1137.8680,23.9683,0,"Willkommen im~n~~y~ZIP",161.4016,-95.8055,1001.8047,18,0,1,-1}, //ZIP
{-1,-1,true,2090.5923,2224.1396,11.0234,0,"Willkommen im~n~~y~ZIP",161.4016,-95.8055,1001.8047,18,0,1,-1}, //ZIP
{-1,-1,true,2572.1379,1904.3624,11.0234,0,"Willkommen im~n~~y~ZIP",161.4016,-95.8055,1001.8047,18,0,1,-1}, //ZIP
{-1,-1,true,-1882.7614,866.1122,35.1719,0,"Willkommen im~n~~y~ZIP",161.4016,-95.8055,1001.8047,18,0,1,-1}, //ZIP
{-1,-1,true,2802.6797,2430.4709,11.0625,0,"Willkommen im~n~~r~Victim",226.7520,-8.3009,1002.2109,5,0,2,-1},  //Victim
{-1,-1,true,461.3894,-1501.0518,31.0582,0,"Willkommen im~n~~r~Victim",226.7520,-8.3009,1002.2109,5,0,2,-1},  //Victim
{-1,-1,true,-1694.9139,951.5002,24.8906,0,"Willkommen im~n~~r~Victim",226.7520,-8.3009,1002.2109,5,0,2,-1},  //Victim
{-1,-1,true,2112.8789,-1211.9406,23.9636,0,"Willkommen im~n~~g~SubUrban",203.8486,-49.7364,1001.8047,1,0,3,-1}, //SubUrban
{-1,-1,true,-2490.5850,-28.9064,25.6172,0,"Willkommen im~n~~g~SubUrban",203.8486,-49.7364,1001.8047,1,0,3,-1}, //SubUrban
{-1,-1,true,2779.4390,2453.4863,11.0625,0,"Willkommen im~n~~g~SubUrban",203.8486,-49.7364,1001.8047,1,0,3,-1}, //SubUrban
{-1,-1,true,2825.6052,2407.1868,11.0625,0,"Willkommen im~n~~p~ProLaps",207.1100,-139.6778,1003.5078,3,0,4,-1}, //Pro Laps
{-1,-1,true,499.8573,-1360.0259,16.3144,0,"Willkommen im~n~~p~ProLaps",207.1100,-139.6778,1003.5078,3,0,4,-1}, //Pro Laps
{-1,-1,true,453.7297,-1478.2819,30.8179,0,"Willkommen im~n~~y~DidierSachs",204.4420,-168.3208,1000.5234,14,0,5,-1}, //Didier Sachs (60)
//24-7 Geschäfte
{-1,-1,true,2884.8904,2453.4675,11.0690,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,2247.3777,2396.7266,10.8203,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,2097.5808,2224.2058,11.0234,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,1937.2527,2307.3037,10.8203,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,2194.3687,1991.2288,12.2969,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,2546.6064,1972.2306,10.8203,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,2452.4561,2064.8037,10.8203,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,-181.6485,1034.8743,19.7422,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,999.9622,-919.9145,42.3281,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,1315.4205,-898.1963,39.5781,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,1352.1752,-1758.8496,13.5078,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,1833.3612,-1842.6625,13.5781,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,-1561.8632,-2733.4980,48.7435,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,-2588.5767,59.6401,4.3359,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,-1726.5050,1041.9061,45.2109,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,-2419.8884,969.7161,45.2969,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,-2442.6370,754.8516,35.1719,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,-2242.3665,128.6578,35.3203,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1},
{-1,-1,true,-1676.0004,431.9978,7.1797,0,"Willkommen im~n~~g~24-7",-30.9464,-91.5944,1003.5469,18,0,-1,-1}, // (79)
//Bar´s, Strip´s und Club´s
{-1,-1,true,2348.7273,-1372.8805,24.3984,0,"~w~Nine~r~Red~w~Bottles",-228.9972,1401.1423,27.7656,18,0,-1,-1}, // LS Bar 1
{-1,-1,true,2308.3879,-1637.5309,14.8270,0,"Ten~g~Green~w~Bottles",-228.9972,1401.1423,27.7656,18,0,-1,-1}, // LS Bar 2
{-1,-1,true,2441.3367,2064.9922,10.8203,0,"Craw Bar",-228.9972,1401.1423,27.7656,18,0,-1,-1}, // LV Bar 1
{-1,-1,true,-89.0038,1378.3325,10.4698,0,"Lil Probe Inn",-228.9972,1401.1423,27.7656,18,0,-1,-1}, // LV Bar 2
{-1,-1,true,-2242.7385,-88.4393,35.3203,0,"Mistys",-228.9972,1401.1423,27.7656,18,0,-1,-1}, // SF Bar 
{-1,-1,true,1836.5155,-1682.5873,13.3447,0,"Alhambra",493.3749,-24.5056,1000.6797,17,0,-1,-1}, // LS Club
{-1,-1,true,2244.3403,2524.9475,10.8203,0,"Dancing Eyes",493.3749,-24.5056,1000.6797,17,0,-1,-1}, // LV Club 1
{-1,-1,true,2507.3518,1242.9572,10.8203,0,"Dancing Arms",493.3749,-24.5056,1000.6797,17,0,-1,-1}, // LV Club 2
{-1,-1,true,-2550.9358,193.7573,6.2266,0,"Gaydar Station",493.3749,-24.5056,1000.6797,17,0,-1,-1}, // SF Club 
{-1,-1,true,1038.0266,-1340.4061,13.7411,0,"Willkommen im~n~~y~Rusty browns Donuts",377.0735,-192.9417,1000.6401,17,0,-1,-1}, // LS Donut
{-1,-1,true,-2767.8674,788.7773,52.7813,0,"Tuff Nuts",377.0735,-192.9417,1000.6401,17,0,-1,-1}, // SF Donut 
{-1,-1,true,-144.0472,1224.7430,19.8992,0,"King Ring",377.0735,-192.9417,1000.6401,17,0,-1,-1}, // LV Donut
{-1,-1,true,-1941.9480,2379.3804,49.7031,0,"Willkommen in~n~~y~Jay's Diner",460.0375,-88.5379,999.5547,4,0,-1,-1}, // LV Dinner 1
{-1,-1,true,-311.2849,1303.3799,53.6643,0,"Willkommen in~n~~y~Jay's Diner",460.0375,-88.5379,999.5547,4,0,-1,-1}, // LV Dinner 2
{-1,-1,true,-857.8732,1535.7695,22.5870,0,"Willkommen in~n~~y~Jay's Diner",460.0375,-88.5379,999.5547,4,0,-1,-1}, // LV Dinner 3
{-1,-1,true,-255.1455,2603.1370,62.8582,0,"Willkommen in~n~~y~Jay's Diner",460.0375,-88.5379,999.5547,4,0,-1,-1}, // LV Dinner 4
{-1,-1,true,2368.7520,1984.1053,10.8203,0,"Smoking Beef Grill",460.0375,-88.5379,999.5547,4,0,-1,-1}, // LV Dinner 5
//Nicht VW-Pickup´s
{-1,-1,false,1554.6516,-1675.6982,16.1953,0,"~b~~h~LosSantos~n~~y~Police Department",288.7744,167.6400,1007.1719,3,1,-1,-1}, //LosSantos Eingang
{-1,-1,false,1568.6608,-1690.7703,5.8906,0,"~b~~h~LosSantos~n~~y~Police Department",238.7659,139.5746,1003.0234,3,1,-1,-1}, //LosSantos Garage
{-1,-1,false,-1605.4916,712.0397,13.8672,0,"~b~~h~SanFierro~n~~y~Police Department",246.3941,108.0785,1003.2188,10,2,-1,-1}, //SanFierro Eingang
{-1,-1,false,-1593.6344,716.1575,-5.2422,0,"~b~~h~SanFierro~n~~y~Police Department",214.7043,117.5488,999.0156,10,2,-1,-1}, //SanFierro Garage
{-1,-1,false,726.24810, -1439.44860, 13.53906,0,"~b~~r~La~w~Cosa~g~Nostra~n~~y~HQ",689.6337,-1366.5149,-59.2550,0,0,-1,5}, //LaCosaNostraHQ
{-1,-1,false,1456.6544,2773.5042,10.8203,0,"Hitman-Base",1261.1721,-785.4310,1091.9063,5,0,-1,7}, //Hitman Base
{-1,-1,false,681.6329,-473.7572,16.5363,0,"HellsAngels-HQ",501.9695,-67.8692,998.7578,11,0,-1,12}, //HellsAngels Base
{-1,-1,false,2524.3459,-1998.3035,14.1131,0,"BloodZ-HQ",2468.8408,-1698.2744,1013.5078,2,0,-1,14}, //Ballas Base
{-1,-1,false,2847.6292,983.5700,10.7500,0,"2Fast2Furious-HQ",620.1318,-70.9034,997.9922,2,0,-1,15}, //2Fast Base
{-1,-1,false,2196.1687,1677.0852,12.3672,0,"Camorra-HQ",2233.9583,1714.0676,1012.3319,1,0,-1,17}, //Camorra Base
{-1,-1,false,-2137.5198,-247.9899,36.5156,0,"Scarfo-HQ",2548.7998,-1294.6652,1060.9844,2,0,-1,18}, //Scarfo Base
{-1,-1,false,2340.2349,2458.4375,14.9688,0,"FBI-HQ",246.6837,63.0766,1003.6406,6,21,-1,-1}, //FBI Base
{-1,-1,false,-2902.7729,464.9154,5.5976,0,"Hitman-HQ",-2769.4214,515.8702,-32.6194,8,0,-1,8}, //Hitman Base
{-1,-1,false,1480.9576,-1770.6440,18.7958,0,"Stadthalle",389.0762,173.7839,1008.3828,3,0,-1,-1}, //Stadthalle
{-1,-1,false,-3746.0264,1781.5256,4.0,0,"Alkatraz-Zellentrakt",-3726.6067,1780.1539,3.9,0,3,-1,-1}, //Alkatraz
{-1,-1,false,2634.7603,1824.1775,11.0161,0,"VatosLocos-HQ",2352.9341,-1180.9927,1027.9766,5,0,-1,16}, //VatosLocos HQ 
{-1,-1,false,-2624.5369,1412.2297,7.0938,0,"Yakuza-HQ",1204.8079,-13.8093,1000.9219,2,0,-1,6}, //YakuzaHQ
{-1,-1,false,1154.1804,-1772.2246,16.5992,0,"Taxi-HQ",-2158.6755,643.1403,1052.3750,1,0,-1,10}, //Taxi HQ
{-1,-1,false,2166.2642,-1671.6808,15.0740,0,"Crackhoele",318.6689,1114.9237,1083.8828,5,0,-1,-1}, //CrackHöle 
{-1,-1,false,-2026.4900,-101.2353,35.1641,0,"Fahrschule~n~SanFierro",-2027.1090,-104.0910,1035.1719,3,0,-1,-1}, //FahrschuleSF 1
{-1,-1,false,-2029.9613,-121.6232,35.1824,0,"Fahrschule~n~SanFierro",-2029.7036,-118.9597,1035.1719,3,0,-1,-1}, //FahrschuleSF 2
{-1,-1,false,2033.8390,-1403.3538,17.2869,0,"Los Santos~n~~r~Krankenhaus",1169.4768,-1299.9683,9.2581,0,0,-1,4}, //FahrschuleSF 2 
{-1,-1,false,2146.9192,-1808.4298,16.1406,0,"~g~GrooveStreet-HQ",2214.9724,-1150.3407,1025.7969,15,0,-1,-1},
{-1,-1,false,-2719.1160,2180.5393,53.1051,0,"Alkatraz-Zellentrakt",-2853.6482,2243.6953,139.4547,0,7,-1,-1}, //Alka Haupteingang
{-1,-1,false,-2840.6992,2145.4751,187.5208,0,"Alkatraz-Heliplatform",-2851.0808,2145.2229,195.1213,0,7,-1,-1}, //Alka Flugplatz
{-1,-1,false,-2834.9729,2153.1265,187.5208,0,"Alkatraz-Zellentrakt",-2851.2009,2229.9722,142.6812,0,6,-1,-1}, //Alka Zellentrakt
{-1,-1,false,-2836.7290,2136.6057,187.5208,0,"Alkatraz-Kantine",-2840.4512,2206.1357,156.7161,0,0,-1,-1}, //Alka Kantine
{-1,-1,false,-2008.4493,-1517.2864,85.1563,0,"Praesidenten Bunker",-2016.8116,-1515.3651,85.3493,0,0,-1,7},  //Präsidenten Bunker
{-1,-1,false,-2061.2122,473.4280,35.1723,0,"NewsDach",-2054.8589,456.7184,139.6406,0,0,-1,-1},
{-1,-1,false,240.2154,71.7884,1005.0391,0,"FBI-HQ~n~Dach",2268.0957,2439.2749,46.9766,0,0,-1,-1},
{-1,-1,false,1573.2225,-1675.6029,28.3955,0,"~b~SAPD-~y~Dach",297.4656,186.3542,1007.1719,3,1,-1,-1},
{-1,-1,true,593.6802,-1250.7239,18.2481,0,"~y~SanAndreas~n~B a n k",595.1665,-1263.1907,3.9019,0,-1,-1,-1} //(Pickup Zahl: 128)
};
new Float:ObdachlosenSpawn[][4]={
//LosSantos
{1483.7850,-1730.5548,6.7276,155.3167}, // Pennerspawn 1
{1483.4003,-1733.3042,6.7283,14.3154}, // Pennerspawn 2
{1500.1219,-1734.8098,6.5103,307.2614}, // Pennerspawn 3
{1502.7301,-1733.6343,6.4697,103.9296}, // Pennerspawn 4
{1487.7043,-1728.9429,6.6936,294.1013}, // Pennerspawn 5
{1484.0770,-1721.8235,7.3420,219.5506}, // Pennerspawn 6
{1472.2045,-1728.1570,7.3143,268.6976} // Pennerspawn 7
};
new LoginText[][][]={
{"Welcome","Willkommen auf unserem...~n~~n~...Metropolitan Reloaded Roleplay Server!~n~~n~Um am Spiel beizutreten~n~klicken Sie unten auf den ~n~JOIN-Button..."},
{"ChangeName","Ist dieser Spielername vergeben?~n~oder passt er nicht?~n~~n~Dann wechseln Sie Ihren Namen, einfach~n~unten auf SPAWN klicken um die~n~Prozedur zu starten..."},
{"Lost PW","Sie haben Ihr Passwort vergessen?~n~Kein Problem,~n~klicken Sie einfach auf SPAWN~n~um Ihr Passwort wieder-~n~herzustellen..."},
{"Credits","Copyright by Templer~n~~n~Credits to:~n~SkEiTa (PHP)~n~Metropolitan Community (MTA)~n~~n~2010"}
};
new PedestrianSkins[][]={
{136,168,182,183,75,206,210,234,236,218,261,28,44,47,262,7,72,95,128,131,132,133,157,158,159,160,196,197,198,199,161,200,201,202,31,32,33,34}, //Obdachlose (Preisklasse 900$ - 2.000$)
{10,151,168,182,54,183,206,220,234,235,236,89,218,28,44,69,43,58,191,192}, //Arm/Schäbig (Preisklasse 3.000$ - 6.000$)
{138,139,140,145,146,154,251,92,97,45,18}, //Beach (Preisklasse 5.000$ - 8.500$)
{258,259,26,51,52,23,96,99}, //Sportliche (Preisklasse 9.000$ - 13.500$)
{101,13,14,143,144,15,156,170,180,184,263,188,19,20,21,22,210,225,222,88,24,25,250,261,41,35,37,38,36,39,262,229,232,72,94,95,195,190}, //Normal (Preisklasse 10.000$ - 15.000$)
{12,169,17,186,185,216,214,215,221,226,223,227,231,228,76,40,46,9,93,48,47,59,60,233,67,7,55,98,56,193,194,240} //Wohlhabend/Reich (Preisklasse 25.000$ - 40.000$)
};
//Kategorien
/*
	Fahrzeug-/Unterkunftsschlüssel
	Rohstoffe
*/
#define MAX_INVENTAR_SLOTS (3) //maximale Slots..
//Variablen
enum invEnum
{
	invKategorie,
	invTyp,
	invVariable[32],
	invHeader[24],
	invSlotName[24],
	invEinheit[16],
	Float:invGewicht,
	invEditTyp,
};
new InventarInfo[][invEnum]={
{1,2,"SpielerWeaponRohlinge","Waffenrohlinge","INV_GetWeaponMaterials","Stk.",1.5,0},
{1,2,"SpielerAmmoMaterials","Waffenmunition","INV_GetAmmoMaterials","Stk.",0.25,1},
{1,2,"SpielerRohFisch","Rohe Fische","INV_GetFishWeight","kg",1.0,2},
{MAX_INVENTAR_SLOTS-1,2,"SpielerAdmin","-> Personalien","INV_GetPlayerStatistik"," ",0.0,-1},
{MAX_INVENTAR_SLOTS-1,2,"SpielerAdmin","-> Vermögen","INV_GetPlayerStatistik"," ",0.0,-1},
{MAX_INVENTAR_SLOTS-1,2,"SpielerAdmin","* Zusammenfassung","INV_GetPlayerStatistik"," ",0.0,-1}
};
//Produktdefines
new	gSlotBegin[MAX_INVENTAR_SLOTS+1]={sizeof(InventarInfo),...};

new CacheString[128],FormatString[256],StockString[512],GrandCacheString[2048];
new VVarString[256],PVarString[256];
new TimerList[MAX_TIMER];
new MotelLosSantos[2];
new FactoryPickup[6];
new AmmoPickup[11];
new PDSystem[1];
new PDArrestZone[1];
new BankSchalter[4][2];
new HitmanSniper;

//		MySQL-Connection´s
new gPVarSQL,
	gVVarSQL,
	gBVarSQL;

//		TextDraw´s
new Text:LoginBalken[7];
new Text:LogHeader[MAX_LOGIN_STEP+1][3];
new Text:LogText[MAX_LOGIN_STEP+1][3];
new Text:Rechteck[4];
new Text:PunktLinksObenRot;
new Text:PunktLinksObenGreen;
new Text:PunktRechtsUntenRot;
new Text:PunktRechtsUntenGreen;
new Text:FlagPointer[20];
new Text:GWBackground;
new Text:GWTimeTable[MAX_GANG_WAR_ZONES];
new Text:GWDefenseTable[MAX_GANG_WAR_ZONES];
new Text:GWAttackerTable[MAX_GANG_WAR_ZONES];
new Text:PlayerTextDraw[MAX_PLAYERS][2];
new Text:FishBarBG[3];