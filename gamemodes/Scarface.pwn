////////////////////////////////////////////////
////////////////////////////////////////////////
/// DarkZero's World's first Scarface Server ///
////////////////// SA-MP 0.3z //////////////////
////////////////////////////////////////////////
////////////////////////////////////////////////

#if defined keks
TODO:
-Skinload/save fixxen
-Rennen entbuggen
-Häuser erstellen
#endif

#include 					<a_samp>
#include                    <dini>
#include 					<YSI\y_ini>
#include                    <streamer>
#include                    <foreach>
#include 					<mSelection>
#include 					<YSI\y_commands>
#include                    <sscanf2>
#include 					<objects.pwn>

#undef MAX_PLAYERS
#define MAX_PLAYERS         350

#define DIALOG_REGISTER 	0
#define DIALOG_LOGIN 		1
#define DIALOG_FORSALEHOUSE 2
#define DIALOG_OTHERSHOUSE  3
#define DIALOG_MYHOUSE      4
#define DIALOG_SELLHOUSE    5
#define DIALOG_EMPLOYMENT   6
#define DIALOG_LSPD         7

#define PRICE      		    4
#define GAS_MAXFULL         30      
#define GAS_SECONDS         60      
#define GAS_TIME            300 
#define GAS_STANDARD        10
#define START_MOTOR_KEY     132
#define MOTOR_OFF_KMH       500
#define LITER_PER_KM        0.2

#define JOB_NOTHING         0
#define JOB_COP             1

#define VehiclePath         "Cars/Vehicles"
#define UserPath 			"Users/%s.ini"
#define HousePath_          "Houses/%d.ini"

#define COLOR_RED 			0xFF000000 //Red
#define COLOR_DARKRED       0x7D0000FF //Dark Red
#define COLOR_RACE			0x46E01BFF //Lightgreen
#define COLOR_DARKYELLOW    0xBAAB34FF //Dark Yellow
#define COLOR_SILVER 		0x7BDDA5AA //Silver

#define MAX_RACES 			50
#define MAX_PROPS           50
#define MAX_HOUSES          50

new Menu:NotOwnedMenu;
new Menu:OwnedMenu;
new Menu:NotOwnedMenu2;
new Menu:OwnedMenu2;

new HousePickup[MAX_HOUSES];
new HouseIcon[MAX_HOUSES];
new CanOpenMenu[MAX_PLAYERS];
new InHouse[MAX_PLAYERS];

new Job_[MAX_PLAYERS];
new CP[MAX_PLAYERS];

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3; // CLICKABLE
new Text:Textdraw4; // CLICKABLE
new Text:Textdraw5;
new Text:Textdraw6;
new Text:Textdraw7; 
new Text:Textdraw8[MAX_PLAYERS];
new Text:Textdraw9;
new Text:Textdraw10;
new Text:Textdraw11[MAX_PLAYERS];

new Text3D:streetracelabel;

new enterhalle;
new exithalle;
new LSPDPickup;
new LSPDTimer[MAX_PLAYERS];

new Timen;
new Minute;

new TextDrawString[1500];

new InfoTDShown[MAX_PLAYERS];

new Float:RaceCPs[MAX_RACES][50][3];
new EDITORCPS[MAX_RACES][50];
new RaceIDCount,RaceStartIcon;
new RaceStarted;
new RaceTimer;
new finishedracers;
new RaceTicks;
new RaceEnd,RaceEndCount;
new organizeraced;

new pFirstLog[MAX_PLAYERS];
new TutTimer[MAX_PLAYERS];
new TutTime[MAX_PLAYERS];

new skinlist = mS_INVALID_LISTID;

new Spawned[MAX_PLAYERS];
new Float:RandomSpawn[][4] =
{
    {1582.4377,-2288.9763,13.2242,0.6983},
    {1672.0187,-2113.5859,13.2721,272.3224},
    {2236.0671,-2214.9980,13.2742,320.9240},
    {2058.0337,-1911.8290,13.2429,262.2585},
    {2097.4480,-1806.5833,13.2492,99.5457},
    {2157.5959,-1797.5150,13.0614,271.8326},
    {2515.7346,-1677.3353,13.6511,74.5229},
    {2219.3889,-1165.3864,25.4567,356.2194},
    {2351.4888,-1165.7837,27.2722,8.8323},
    {2049.2610,-1192.6522,23.3850,265.9168},
    {1880.8824,-1379.7836,13.2685,167.0501},
    {1687.8657,-1457.8669,13.2434,355.3788},
    {1543.3481,-1675.6354,13.2396,93.0711},
    {1133.0818,-2037.8676,68.7040,271.9052},
    {1095.2444,-1794.1292,13.3038,88.3507},
    {837.0518,-1840.7943,12.2809,4.6990},
    {621.0777,-1625.2831,16.3409,327.4093},
    {900.8960,-932.0934,42.3076,188.1652},
    {1217.3026,-909.4606,42.6115,194.4177},
    {1255.9218,-785.4917,92.0302,93.0232},
    {1334.9480,-627.2146,108.8314,13.6955}
};

new Float:Interiors[][5] =
{
    {5.00, 140.1788, 1369.1936, 1083.8641,359.2263},//0 // mansions
    {12.00, 2324.4490, -1145.2841, 1050.7101, 357.5873},//1
    {9.00, 2320.0730, -1023.9533, 1050.2109,358.4915},//2 //normal
    {8.00, 2365.2883, -1132.5228, 1050.8750,358.0393},//3
    {3.00, 2495.8035, -1695.0997, 1014.7422, 181.9661},//4 //cjhouse
    {1.00, 2214.8909, -1076.0967, 1050.4844,88.8910},//5 //normal
    {5.00, 2233.6057, -1111.7039, 1050.8828, 2.9124},//6 //smal house
    {6.00, 2193.9001, -1202.4185, 1049.0234,91.9386},//7 //Villa
    {0.00, -11.8886,   1505.7557, 77.8156,  257.3651},//8//ufo house 20
    {0.00, 49.4335,    1488.6993, 77.8156,  87.31626}, //9//ufo house 21
    {0.00,-1635.7112,  -2239.0850,31.4766,  262.0000},//10
	{5.00,1263.0787,-785.3076,1091.9063,275.0000},//11 // Maddog
	{1.00,1.808619,32.384357,1199.593750,180.00},//12	  //Shamal
    {0.0,1254.3190,-823.5728,89.6144,268.399},//13
    {0.0,1909.1932,-4418.1992,119.2238,89.3520},//14
    {0.0,2352.6855,-655.9788,128.0547,91.8349},//15
    {0.0,-2084.5889,1371.0323,7.1016,357.9261}//16
};

new Float:RandomAcceptLSPD[][1] =
{
    {1},
    {0},
    {0},
    {1},
    {0},
    {1}
};

new Text:Tacho[MAX_PLAYERS];
new timer[MAX_PLAYERS];
new Float:Tank[MAX_VEHICLES];
new engine,lights,alarm,doors,bonnet,boot,objective;
new bool:Motor[MAX_VEHICLES]=false;

forward loadaccount_user(playerid, name[], value[]);

forward Race5();
forward Race4();
forward Race3();
forward Race2();
forward Race1();
forward RaceGo();
forward RaceCounter();
forward RaceUpdate();
forward SetBackToNormalCam(playerid);
forward LoadRace_RaceInfo(r,name[],value[]);
forward LoadRaceRecords();
forward Startrace();

forward Tutorial(playerid);

forward SetRaceCheckPointForAll(type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size);

forward ExitBuilding(i);
forward LoadHouseData(houseid, name[], value[]);
forward HideMenusForPlayer(playerid);

forward ClockSync(playerid);

forward Speedometer(playerid);
forward FillGas(i,playerid,price);
forward Gas();
forward checkGas();
forward IsAtGasStation(playerid);

forward PlantWeedTimer(playerid);
forward UseWeedTimer(playerid);

forward LSPDTimer_(playerid);

native WP_Hash(buffer[],len,const str[]);

enum vehicleData {
        vehicleSpawnID,
        vehicleColor1,
        vehicleColor2,
        Float:vehicleKm,
        vehicleTank,

        Float:vLastX,
        Float:vLastY,
        Float:vLastZ
};
new vehicles[MAX_VEHICLES][vehicleData];

enum HouseInfo
{
  	Owner[24],
  	Name[64],
  	Cost,
  	Interior,
  	VirtualWorld,
  	Locked,
  	HInt,
  	Float:InteriorX,
  	Float:InteriorY,
  	Float:InteriorZ,
  	Float:InteriorA,
  	Float:ExteriorX,
  	Float:ExteriorY,
  	Float:ExteriorZ,
  	Float:sX,
  	Float:sY,
  	Float:sZ,
  	Float:SpawnA
}
new hInfo[MAX_HOUSES][HouseInfo];
new Hvw=100;

enum rifo
{
	RaceCpCount,
	Float:StartCP[3],
	RaceInt,
	Float:Spawnp[4]
};
new RaceInfo[MAX_RACES][rifo];

enum Rinfo
{
   	Top1Player[24],
   	Top2Player[24],
   	Top3Player[24],
   	Top4Player[24],
   	Top5Player[24],
   	toptime[5]
}
new RaceRecords[MAX_RACES][Rinfo];

enum PlayerInfo
{
    Pass[129],
    Adminlevel,
    Money,
    Scores,
    Kills,
    Deaths,
    Skin,
    House,
    HouseMoney,
    WeedPlant,
    Weed,
    Job
}
new pInfo[MAX_PLAYERS][PlayerInfo];

enum wInfo
{
    bool:wAbleToPlant,
    bool:wAbleToPick,
    wPlantObject,
	Float:wX,
	Float:wY,
	Float:wZ,
	wWeed,
	wSeeds,
	Text3D:wLabel,
	wLabels
};

new WeedInfo[50][wInfo];

main(){}
public OnGameModeInit()
{
	// Textdraws //
	Textdraw0 = TextDrawCreate(497.000000, 10.000000, "   MAIN MENU~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(Textdraw0, -1);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.500000, 1.000000);
	TextDrawColor(Textdraw0, 255);
	TextDrawSetOutline(Textdraw0, 1);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawUseBox(Textdraw0, 1);
	TextDrawBoxColor(Textdraw0, 0x00000060);
	TextDrawTextSize(Textdraw0, 637.000000, 0.000000);

	Textdraw1 = TextDrawCreate(480.000000, 15.000000, "-");
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 12.260011, 1.000000);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetShadow(Textdraw1, 1);

	Textdraw2 = TextDrawCreate(500.000000, 40.000000, "Welcome back to the server.~n~If you want to login, click ~n~the LOGIN button.~n~Have fun on our server !!");
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 2);
	TextDrawLetterSize(Textdraw2, 0.200000, 1.500000);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetOutline(Textdraw2, 1);
	TextDrawSetProportional(Textdraw2, 1);

	Textdraw3 = TextDrawCreate(519.000000, 130.000000, "   LOGIN");
	TextDrawBackgroundColor(Textdraw3, -1);
	TextDrawFont(Textdraw3, 2);
	TextDrawLetterSize(Textdraw3, 0.500000, 2.000000);
	TextDrawColor(Textdraw3, 255);
	TextDrawSetOutline(Textdraw3, 1);
	TextDrawSetProportional(Textdraw3, 1);
	TextDrawUseBox(Textdraw3, 1);
	TextDrawBoxColor(Textdraw3, -1);
	TextDrawTextSize(Textdraw3, 616.000000, 12.000000);

	Textdraw4 = TextDrawCreate(519.000000, 165.000000, "TUTORIAL");
	TextDrawBackgroundColor(Textdraw4, -1);
	TextDrawFont(Textdraw4, 2);
	TextDrawLetterSize(Textdraw4, 0.490000, 2.000000);
	TextDrawColor(Textdraw4, 255);
	TextDrawSetOutline(Textdraw4, 1);
	TextDrawSetProportional(Textdraw4, 1);
	TextDrawUseBox(Textdraw4, 1);
	TextDrawBoxColor(Textdraw4, -1);
	TextDrawTextSize(Textdraw4, 616.000000, 12.000000);
	
	Textdraw5 = TextDrawCreate(29.000000, 426.000000, "~l~www.SR-Page.de");
	TextDrawBackgroundColor(Textdraw5, -1);
	TextDrawFont(Textdraw5, 0);
	TextDrawLetterSize(Textdraw5, 0.500000, 1.600000);
	TextDrawColor(Textdraw5, -1);
	TextDrawSetOutline(Textdraw5, 1);
	TextDrawSetProportional(Textdraw5, 1);

	Textdraw6 = TextDrawCreate(150.000000, 350.000000, "~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(Textdraw6, 255);
	TextDrawFont(Textdraw6, 1);
	TextDrawLetterSize(Textdraw6, 0.500000, 1.000000);
	TextDrawColor(Textdraw6, -1);
	TextDrawSetOutline(Textdraw6, 0);
	TextDrawSetProportional(Textdraw6, 1);
	TextDrawSetShadow(Textdraw6, 1);
	TextDrawUseBox(Textdraw6, 1);
	TextDrawBoxColor(Textdraw6, 0xFFFFFF60);
	TextDrawTextSize(Textdraw6, 441.000000, 0.000000);

	Textdraw7 = TextDrawCreate(154.000000, 355.000000, "~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(Textdraw7, 255);
	TextDrawFont(Textdraw7, 1);
	TextDrawLetterSize(Textdraw7, 0.500000, 1.000000);
	TextDrawColor(Textdraw7, -1);
	TextDrawSetOutline(Textdraw7, 0);
	TextDrawSetProportional(Textdraw7, 1);
	TextDrawSetShadow(Textdraw7, 1);
	TextDrawUseBox(Textdraw7, 1);
	TextDrawBoxColor(Textdraw7, 0x00000060);
	TextDrawTextSize(Textdraw7, 436.000000, 0.000000);

	Textdraw9 = TextDrawCreate(130.000000, 337.000000, "~l~Information");
	TextDrawBackgroundColor(Textdraw9, -1);
	TextDrawFont(Textdraw9, 0);
	TextDrawLetterSize(Textdraw9, 0.569999, 1.700000);
	TextDrawColor(Textdraw9, -1);
	TextDrawSetOutline(Textdraw9, 1);
	TextDrawSetProportional(Textdraw9, 1);

	Textdraw10 = TextDrawCreate(150.000000, 210.000000, "_~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(Textdraw10, 255);
	TextDrawFont(Textdraw10, 1);
	TextDrawLetterSize(Textdraw10, 0.500000, 1.000000);
	TextDrawColor(Textdraw10, -1);
	TextDrawSetOutline(Textdraw10, 0);
	TextDrawSetProportional(Textdraw10, 1);
	TextDrawSetShadow(Textdraw10, 1);
	TextDrawUseBox(Textdraw10, 1);
	TextDrawBoxColor(Textdraw10, 66);
	TextDrawTextSize(Textdraw10, 473.000000, 0.000000);
	TextDrawSetSelectable(Textdraw10, 0);

	// Skins //
	for(new i = 0; i < 300; i++)
	{
    	if(IsValidSkin(i))
    	{
        	AddPlayerClass(i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    	}
	}

	// Server Settings //
	SetGameModeText("The World Is Yours");
	TextDrawSetSelectable(Textdraw3, true);
	TextDrawSetSelectable(Textdraw4, true);

	ConnectNPC("Streetrace_Organizer","streetrace1");
	
	SetTimer("ClockSync", 1000, 1);

	skinlist = LoadModelSelectionMenu("skins.txt");
	
	// Pickups //
   	LSPDPickup = CreateDynamicPickup(1274,2,256.9322,69.9256,1003.6406,0);
	enterhalle = CreateDynamicPickup(1318,1,1481.1625,-1771.0588,18.7958,0);
	exithalle = CreateDynamicPickup(1318,1,388.5354,173.6673,1008.3828,0);
	
	// 3D Text Labels //
	streetracelabel = Create3DTextLabel("Streetrace_Organizator(0)",COLOR_RED,30.0,40.0,50.0,50,0,1);
	Create3DTextLabel("Press the 'N' Button to open a list of\nall jobs!",0xFF0000FF,361.8299,173.6782,1008.3828,97.6657,0);

	// Houses //
	LoadHouses();
	NotOwnedMenu = CreateMenu("House Menu",1,440.000000, 240.000000,200,200);
    NotOwnedMenu2 = CreateMenu("House Menu",1,440.000000, 240.000000,200,200);
    OwnedMenu = CreateMenu("House Menu",1,440.000000, 240.000000,200,200);
    OwnedMenu2 = CreateMenu("House Menu",1,440.000000, 240.000000,200,200);
    AddMenuItem(NotOwnedMenu, 0, "Buy House");
    AddMenuItem(NotOwnedMenu, 0, "Enter House");
    AddMenuItem(NotOwnedMenu2, 0, "Buy House");
    AddMenuItem(NotOwnedMenu2, 0, "Enter House");
    DisableMenuRow(NotOwnedMenu2, 0);
    AddMenuItem(OwnedMenu, 0, "Enter House");
    AddMenuItem(OwnedMenu, 0, "Sell House");
    AddMenuItem(OwnedMenu2, 0, "Enter House");

	// Races //
	LoadCreatedRaces();
	RaceStarted=0;
	GenerateRaceID2();
	
	// Gas system //
	ManualVehicleEngineAndLights();
    for(new i =0; i<MAX_VEHICLES;i++)
	{
        Tank[i] = GAS_STANDARD;
        loadCar(i);
        Motor[i]=false;
        GetVehicleParamsEx(i,engine,lights,alarm,doors,bonnet,boot,objective);
        SetVehicleParamsEx(i,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
    }
    timer[1] = SetTimer("Speedometer",1000, 1);
    timer[2] = SetTimer("Gas", GAS_SECONDS * 1000, 1);

	// Objects //
	LoadObjects();
	
	    // LSPD Important Objects //
	CreateDynamicObject(2930,1582.5690918,-1637.8454590,15.0273151,0.0000000,0.0000000,90.0000000); //fußgänger-tor
	CreateDynamicObject(971,1588.7548828,-1638.0883789,12.9078903,0.0000000,0.0000000,0.0000000); //garagentor
	CreateDynamicObject(980,1547.1782227,-1627.6697998,15.1562042,0.0000000,0.0000000,90.0000000); //hoftor
		// LSH Important Objects //
	//Schranke Parkplatz: CreateObject(968, 1185.599609375, -1363.4105224609, 13.325004577637, 0, 0, 272); zu 1185.6245117188, -1363.4083251953, 13.325004577637, 0, 269.49993896484, 272.75
	//Tor Garage: CreateObject(16773, 1093.0762939453, -1365.3447265625, 9.1871271133423, 0, 0, 330); zu 1185.599609375, -1363.4105224609, 13.325004577637, 0, 0, 272
	return 1;
}

public OnGameModeExit()
{
    for (new i=0; i<MAX_VEHICLES; i++)
	{
        saveCar(i);
    }
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SendClientMessage(playerid, COLOR_DARKRED, "Please press any button to continue");
    SpawnPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	//RemoveUnneededObjects(playerid);
	TogglePlayerClock(playerid, 1);
	Textdraw8[playerid] = TextDrawCreate(153.000000, 355.000000, "_");
	TextDrawBackgroundColor(Textdraw8[playerid], 255);
	TextDrawFont(Textdraw8[playerid], 1);
	TextDrawLetterSize(Textdraw8[playerid], 0.230000, 1.200000);
	TextDrawColor(Textdraw8[playerid], -1);
	TextDrawSetOutline(Textdraw8[playerid], 0);
	TextDrawSetProportional(Textdraw8[playerid], 1);
	TextDrawSetShadow(Textdraw8[playerid], 1);
	
	Textdraw11[playerid] = TextDrawCreate(153.000000, 213.000000, "_");
	TextDrawBackgroundColor(Textdraw11[playerid], 255);
	TextDrawFont(Textdraw11[playerid], 2);
	TextDrawLetterSize(Textdraw11[playerid], 0.240000, 1.100000);
	TextDrawColor(Textdraw11[playerid], -1);
	TextDrawSetOutline(Textdraw11[playerid], 0);
	TextDrawSetProportional(Textdraw11[playerid], 1);
	TextDrawSetShadow(Textdraw11[playerid], 1);
	TextDrawSetSelectable(Textdraw11[playerid], 0);
	
    Tacho[playerid] = TextDrawCreate(460.000000, 381.500000, " ");
    TextDrawBackgroundColor(Tacho[playerid], 255);
    TextDrawFont(Tacho[playerid], 1);
    TextDrawLetterSize(Tacho[playerid], 0.32, 0.97);
    TextDrawColor(Tacho[playerid], -1);
    TextDrawSetOutline(Tacho[playerid], 0);
    TextDrawSetProportional(Tacho[playerid], 1);
    TextDrawSetShadow(Tacho[playerid], 1);

	timer[playerid] = SetTimerEx("Speedometer",1000, 1,"i",playerid);
	Spawned[playerid] = 0;
	InHouse[playerid] = -255;
	CanOpenMenu[playerid] = 1;
	PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/s/ffwsnn5znoceqaz/Scarface-%20The%20World%20is%20Yours%20%28Original%20Game%20Soundtrack%29%20-%20Mansion%20Storm.mp3");
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
 	if(GetPVarInt(playerid,"RACER")) RemoveFromRace(playerid);
    GetPlayerSkin(playerid);
    new INI:file = INI_Open(Path(playerid));
    INI_SetTag(file,"Player's Data");
    INI_WriteInt(file,"AdminLevel",pInfo[playerid][Adminlevel]);
    INI_WriteInt(file,"Money",GetPlayerMoney(playerid));
    INI_WriteInt(file,"Scores",GetPlayerScore(playerid));
    INI_WriteInt(file,"Kills",pInfo[playerid][Kills]);
    INI_WriteInt(file,"Deaths",pInfo[playerid][Deaths]);
    INI_WriteInt(file,"Skin",GetPlayerSkin(playerid));
    INI_WriteInt(file,"House",pInfo[playerid][House]);
    INI_WriteInt(file,"HouseMoney",pInfo[playerid][HouseMoney]);
    INI_WriteInt(file,"WeedPlant",pInfo[playerid][WeedPlant]);
    INI_WriteInt(file,"Weed",pInfo[playerid][Weed]);
    INI_WriteInt(file,"Job",pInfo[playerid][Job]);
    INI_Close(file);
	StopAudioStreamForPlayer(playerid);
	TextDrawHideForPlayer(playerid, Textdraw5);
	KillTimer(LSPDTimer[playerid]);
	KillTimer(timer[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(pFirstLog[playerid] == true)
	{
	    SetPlayerPos(playerid,0.0,0.0,0.0);
	    TogglePlayerControllable(playerid,false);
	    TutTime[playerid] = 1;
	    TutTimer[playerid] = SetTimerEx("Tutorial",1000,1,"i",playerid);
	    pFirstLog[playerid] = 0;
	}
	if(!Spawned[playerid])
	{
		SetPlayerInterior(playerid, 10);
		SetPlayerPos(playerid, 1955.8209,1017.5680,992.4688);
		InterpolateCameraPos(playerid, 2016.268554, 1016.721008, 1003.513977, 1947.354248, 986.605651, 993.685791, 20000);
		InterpolateCameraLookAt(playerid, 2011.324951, 1016.991638, 1002.815856, 1942.496093, 986.656799, 992.504455, 20000);
		TextDrawShowForPlayer(playerid, Textdraw0);
    	TextDrawShowForPlayer(playerid, Textdraw1);
		TextDrawShowForPlayer(playerid, Textdraw2);
    	TextDrawShowForPlayer(playerid, Textdraw3);
		TextDrawShowForPlayer(playerid, Textdraw4);
    	SelectTextDraw(playerid, 0xA3B4C5FF);
    	Spawned[playerid] = 1;
    }
    else if(Spawned[playerid] == 1)
	{
    	TextDrawHideForPlayer(playerid, Textdraw0);
	    TextDrawHideForPlayer(playerid, Textdraw1);
	    TextDrawHideForPlayer(playerid, Textdraw2);
	    TextDrawHideForPlayer(playerid, Textdraw3);
	    TextDrawHideForPlayer(playerid, Textdraw4);
	    TextDrawShowForPlayer(playerid, Textdraw5);
	    CancelSelectTextDraw(playerid);
	    StopAudioStreamForPlayer(playerid);
		SetPlayerInterior(playerid, 0);
    	new rand = random(sizeof(RandomSpawn));
    	SetPlayerPos(playerid, RandomSpawn[rand][0], RandomSpawn[rand][1],RandomSpawn[rand][2]);
    	SetPlayerFacingAngle(playerid, RandomSpawn[rand][3]);
	}
	else if(Spawned[playerid] == 2)
	{
	    TextDrawHideForPlayer(playerid, Textdraw0);
	    TextDrawHideForPlayer(playerid, Textdraw1);
	    TextDrawHideForPlayer(playerid, Textdraw2);
	    TextDrawHideForPlayer(playerid, Textdraw3);
	    TextDrawHideForPlayer(playerid, Textdraw4);
	    TextDrawShowForPlayer(playerid, Textdraw5);
	    CancelSelectTextDraw(playerid);
	    StopAudioStreamForPlayer(playerid);
		SetPlayerInterior(playerid, 0);
    	new rand = random(sizeof(RandomSpawn));
    	SetPlayerPos(playerid, RandomSpawn[rand][0], RandomSpawn[rand][1],RandomSpawn[rand][2]);
    	SetPlayerFacingAngle(playerid, RandomSpawn[rand][3]);
    	new ss = pInfo[playerid][Skin];
    	SetPlayerSkin(playerid, ss);
	}
  	if(IsPlayerNPC(playerid))
  	{
    	if(!strcmp(GetPlayerNameEx(playerid),"Streetrace_Organizator"))
    	{
    	    new string[128];
		    Attach3DTextLabelToPlayer(streetracelabel, playerid, 0.0, 0.0, 0.0);
		    format(string,sizeof(string),"Streetrace_Organizator(%d)",playerid);
		    Update3DTextLabelText(streetracelabel, COLOR_RED, string);
         	SetPlayerSkin(playerid,217);
         	ResetPlayerWeapons(playerid);
    	}
  	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    pInfo[killerid][Kills]++;
    pInfo[playerid][Deaths]++;
    if(GetPVarInt(playerid,"RACER")) RemoveFromRace(playerid);
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
    Motor[vehicleid] = false;
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		SetPlayerPos(playerid, -1894.1416015625, -5100.7763671875, 183.04374694824);
		return 1;
	}
	if(strcmp("/montana", cmdtext, true, 10) == 0)
	{
	    SetPlayerPos(playerid, -1888.8881836,-5071.7768555,188.8807068);
	    return 1;
	}
	if(strcmp("/test", cmdtext, true, 10) == 0)
	{
		GivePlayerMoney(playerid, 10000000);
		return 1;
	}
	return 0;
}

#if defined zcmdt
public OnPlayerCommandTextEx(playerid, cmdtext[])
{
	#endif
	CMD:raceeditor(playerid, params[])
	{
	  	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "SERVER: Unknown command.");
	  	if(GetPVarInt(playerid,"RaceEditing")) return SendClientMessage(playerid, COLOR_DARKRED,"<-> *** You are already in the race construction mode");
	  	ShowPlayerDialog(playerid,16551,DIALOG_STYLE_LIST,"Race Construction","Create a new race\nView Created Races\nDelete a Race","Select","Exit");
	  	return 1;
	}
	CMD:stopediting(playerid, params[])
	{
	  	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "SERVER: Unknown command.");
	  	if(!GetPVarInt(playerid,"RaceEditing")) return SendClientMessage(playerid, COLOR_DARKRED,"<-> *** You are not in the race construction mode");
	  	ShowPlayerDialog(playerid,412,DIALOG_STYLE_LIST,"Race Construction","Exit & Save Race\nExit Without Saving\nSet Race Laps","Select","Exit");
	  	return 1;
	}
	CMD:organizerace(playerid, params[])
	{
	    if(!IsPlayerInRangeOfPoint(playerid,3.00,2370.7659,-1649.2642,13.5469)) return SendClientMessage(playerid, COLOR_DARKRED, "<-> *** There's no race organizator in your near.");
	    if(organizeraced) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** There has already been organized a race in Los Santos");
	   	if((RaceStarted != 0)) return SendClientMessage(playerid,COLOR_DARKRED,"<-> *** There has already been started a race event in Los Santos!");
	   	if(RaceInfo[RaceIDCount][RaceCpCount] < 1)
	   	{
	    	new BA=RaceIDCount;
	    	GenerateRaceID();
	    	if(BA==RaceIDCount) GenerateRaceID2();
	   	}
	   	new str[128];
	   	SetRaceCheckPointForAll(0,RaceInfo[RaceIDCount][StartCP][0],RaceInfo[RaceIDCount][StartCP][1], RaceInfo[RaceIDCount][StartCP][2],RaceCPs[RaceIDCount][0][0],RaceCPs[RaceIDCount][0][1],RaceCPs[RaceIDCount][0][2],20.0);
		SendClientMessageToAll(COLOR_DARKRED, "======================== INFORMATION =======================");
	   	if(RaceIDCount == 0) format(str,sizeof(str),"%s has organized a race in the Grove Street!",GetPlayerNameEx(playerid));
	   	SendClientMessageToAll(COLOR_DARKYELLOW,str); //Has to be changed to Team-Members
		SendClientMessageToAll(COLOR_DARKYELLOW, "If you want to take part to the race, drive and park in to the start-CP");
		SendClientMessageToAll(COLOR_DARKYELLOW, "and wait there until the race starts. From now, you have 2 Minutes to come.");
		SendClientMessageToAll(COLOR_DARKRED, "======================== INFORMATION =======================");
		SetTimer("Startrace", 120000,false);
		organizeraced = 1;
		return 1;
	}
	CMD:createhouse(playerid,params[])
	{
	   	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "SERVER: Unknown command.");
	   	new NaMe[50],iD,PrIcE,interior;
	   	if(sscanf(params,"ddds[50]",iD,PrIcE,interior,NaMe)) return SendClientMessage(playerid,COLOR_DARKYELLOW,"</> *** /Createhouse <Housenumber> <Price> <Interior-ID (Use /Interiors for help)> <Housename>");
	   	if(fexist(HousePath(iD))) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** This housenumber does already exists.");
	   	if((iD < 1)) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** Housenumber has to be higher than 1.");
	   	if((strlen(NaMe) > 50) || (strlen(NaMe) == 0)) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** Housename has to be between 1-50 characters.");
	   	if((PrIcE < 10000) || (PrIcE > 1000000)) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** Houseprice should be between 10.000$ and 1.000.000$.");
	   	if(interior <= 0 || interior > 7) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** This Interior-ID isn't available. Use /Interiors to get shown a list of all interiors.");
	   	new Float:x,Float:y,Float:z,Float:a;
	   	GetPlayerPos(playerid,x,y,z);
	   	GetPlayerFacingAngle(playerid,a);
	   	new INI:File = INI_Open(HousePath(iD));
	   	INI_WriteString(File,"Name",NaMe);
	   	INI_WriteString(File,"Owner","For_Sale");
	   	INI_WriteInt(File,"Cost", PrIcE);
	   	INI_WriteFloat(File,"pickUpX", x);
	   	INI_WriteFloat(File,"pickUpY", y);
	   	INI_WriteFloat(File,"pickUpZ", z);
   		INI_WriteFloat(File,"SpawnX", x);
   		INI_WriteFloat(File,"SpawnY", y);
   		INI_WriteFloat(File,"SpawnZ", z);
   		INI_WriteFloat(File,"SpawnA", a);
	   	INI_WriteInt(File,"Int", interior);
	   	INI_Close(File);
	   	format(hInfo[iD][Name],50,"%s",NaMe);
	   	format(hInfo[iD][Owner],24,"For_Sale");
	   	hInfo[iD][Cost] = PrIcE;
	   	hInfo[iD][ExteriorX] = x;
	   	hInfo[iD][ExteriorY] = y;
	   	hInfo[iD][ExteriorZ] = z;
	   	new b=interior-1;
	   	hInfo[iD][HInt] = b;
	   	hInfo[iD][Interior] = floatround(Interiors[b][0]);
	   	hInfo[iD][InteriorX] = Interiors[b][1];
	   	hInfo[iD][InteriorY] = Interiors[b][2];
	   	hInfo[iD][InteriorZ] = Interiors[b][3];
	   	hInfo[iD][InteriorA] = Interiors[b][4];
    	hInfo[iD][sX] = x;
   		hInfo[iD][sY] = y;
   		hInfo[iD][sZ] = z;
   		hInfo[iD][SpawnA] = a;
	   	hInfo[iD][VirtualWorld] = Hvw;
	   	hInfo[iD][Locked] = 1;
	   	HousePickup[iD] = CreatePickup(1273, 23, x, y, z);
	   	HouseIcon[iD] = CreateDynamicMapIcon(x,y,z,31,0,0);
	   	new str[128];
	   	format(str,sizeof(str),"<+> *** This house with the housenumber ''%d'' has successfully been created!",iD);
	   	SendClientMessage(playerid,COLOR_RACE,str);
	   	Hvw++;
	   	return 1;
	}
	CMD:deletehouse(playerid,params[])
	{
	   	new iD;
	   	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "SERVER: Unknown command.");
	   	if(sscanf(params,"d",iD)) return SendClientMessage(playerid,COLOR_DARKYELLOW,"</> *** /Deletehouse <Housenumber>");
	   	if(!fexist(HousePath(iD))) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** This house doesn't even exist.");
	   	hInfo[ iD ][ ExteriorX ]= 0.0;
	   	hInfo[ iD ][ ExteriorY ]= 0.0;
	   	hInfo[ iD ][ ExteriorZ ]= 0.0;
	   	fremove(HousePath(iD));
	   	DestroyPickup(HousePickup[iD]);
	   	DestroyDynamicMapIcon(HouseIcon[iD]);
	   	new str[128];
	   	format(str,sizeof(str),"<+> *** This house with the housenumber ''%d'' has successfully been removed!",iD);
	   	SendClientMessage(playerid,COLOR_RACE,str);
	   	return 1;
	}
	CMD:createint(playerid,params[])
	{
	   	new iD;
	   	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "SERVER: Unknown command.");
	   	if(sscanf(params,"d",iD)) return SendClientMessage(playerid,COLOR_DARKYELLOW,"</> *** /CreateInt <HouseID>");
	   	if(!fexist(HousePath(iD))) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** This house doesn't even exist.");
	   	new Float:x,Float:y,Float:z,Float:a;
	   	GetPlayerPos(playerid,x,y,z);
	   	GetPlayerFacingAngle(playerid,a);
	   	new in=GetPlayerInterior(playerid);
	   	new INI:File = INI_Open(HousePath(iD));
	   	INI_WriteFloat(File,"InteriorX", hInfo[ iD ][ InteriorX ]);
	   	INI_WriteFloat(File,"InteriorY", hInfo[ iD ][ InteriorY ]);
	   	INI_WriteFloat(File,"InteriorZ", hInfo[ iD ][ InteriorZ ]);
	   	INI_WriteFloat(File,"InteriorA", hInfo[ iD ][ InteriorA ]);
	   	INI_WriteInt(File,"Interior", in);
	   	INI_WriteInt(File,"Int", -255);
	   	INI_Close(File);
	   	hInfo[iD][Interior] = in;
	   	hInfo[ iD ][ InteriorX ] = x;
	   	hInfo[ iD ][ InteriorY ] = y;
	   	hInfo[ iD ][ InteriorZ ] = z;
	   	hInfo[ iD ][ Interior ] = in;
	   	hInfo[ iD ][ HInt ] = -255;
	   	new str[128];
	   	format(str,sizeof(str),"<+> *** This house with the housenumber ''%d'' has successfully got a new interior!",iD);
	   	SendClientMessage(playerid,COLOR_RACE,str);
	   	return 1;
	}
	CMD:interiors(playerid,params[])
	{
	   	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "SERVER: Unknown command.");
	   	ShowPlayerDialog(playerid,7471,DIALOG_STYLE_MSGBOX,"House interiors","Available houe Interior ids\n1. mansion\n2. mansion\n3. normal house\n4. normal house\n5. cj house\n6. normal house\n4. small house (caravan)\n7. villa","Close","");
	   	return 1;
	}
	CMD:weed(playerid, params[])
	{
		new usage[10];
		if(sscanf(params, "s[10]", usage)) return SendClientMessage(playerid,COLOR_DARKYELLOW,"</> *** /Weed <Use / Plant>");
		else
		{
		    if(strcmp(usage, "plant", true) == 0)
		    {
		        print("step 1");
				if(!pInfo[playerid][WeedPlant])
				{
		        	print("step 2");
		        	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_DARKRED, "<-> *** You have to be on foot to use this command.");
		        	print("step 3");
			    	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_DARKRED, "<-> *** You have to be in your garden to use this command.");
		        	print("step 4");
		        	print("step 5");
					for(new weed = 0; weed < sizeof(WeedInfo); weed++)
	    	    	{
		        		print("step 6");
					    new Float:X,Float:Y,Float:Z;
	            	    ApplyAnimation(playerid, "BOMBER","BOM_Plant_In",4.0,0,0,0,0,0);
	            	    ApplyAnimation(playerid, "BOMBER","BOM_Plant_In",4.0,0,0,0,0,0);
			    	    GetPlayerPos(playerid, X, Y, Z);
			    	    WeedInfo[weed][wPlantObject] = CreateDynamicObject(3409, X, Y, Z-1.0, 0, 0, 0, 0);
			    	    WeedInfo[weed][wX] = X;
			    		WeedInfo[weed][wY] = Y;
			    		WeedInfo[weed][wZ] = Z;
			    		WeedInfo[weed][wAbleToPlant] = false;
			    		WeedInfo[weed][wSeeds] = 0;
						WeedInfo[weed][wLabel] = Create3DTextLabel("Here has weed been plant.\nThe weed isn't ready yet, so you can't\npick it right now.",COLOR_SILVER,WeedInfo[weed][wX],WeedInfo[weed][wY],WeedInfo[weed][wZ],10.0,0);
						WeedInfo[weed][wLabels]++;
						pInfo[playerid][WeedPlant] = 1;
						SetTimer("PlantWeedTimer",60000*1,0);
						SendClientMessage(playerid,COLOR_RACE,"<+> *** You have successfully plant your weed. It will taked 24 Ingame-Hours until");
						SendClientMessage(playerid,COLOR_RACE,"           you are able to pick it.");
			    		return 1;
					}
     			}
				else SendClientMessage(playerid, COLOR_DARKRED, "<-> *** You already have plant any weed.");
			}
			if(strcmp(usage, "use", true) == 0)
			{
			    if(pInfo[playerid][Weed] >= 20)
			    {
			        UseWeed(playerid);
			        return 1;
			    }
			    else SendClientMessage(playerid,COLOR_DARKRED,"<-> *** You must have at atleast 20 gram to use your gained weed.");
			}
		}
		return 1;
	}
	COMMAND:druginfo(playerid,params[])
	{
		new info[50];
		SendClientMessage(playerid,COLOR_DARKRED,"Narcotic statistics");
		format(info,sizeof(info),"SEEDS:[%s]", GetSeedInfo(playerid));
		SendClientMessage(playerid,COLOR_RACE,info);
		format(info,sizeof(info),"WEED GRAMS:[%d]", pInfo[playerid][Weed]);
		SendClientMessage(playerid,COLOR_RACE,info);
		return 1;
	}
	#if defined zcmdt
	return 1;
}
#endif

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
	{
        new vehicle = GetPlayerVehicleID(playerid);
        GetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet,boot,objective);
        if(GetVehicleModel(vehicle) == 509 || GetVehicleModel(vehicle) == 481 || GetVehicleModel(vehicle) == 510)
		{
			SetVehicleParamsEx(vehicle,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		}
        else
		{
			SendClientMessage(playerid, -1, "*** Use the 'Y/Z' button to turn on the motor.");
		}
        if(Motor[vehicle]==false)
		{
			SetVehicleParamsEx(vehicle,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
		}
        if(Tank[vehicle] <= 0)
		{
            Motor[vehicle]=false;
            Tank[vehicle] = 0;
            SetVehicleParamsEx(vehicle,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
            GameTextForPlayer(playerid,"~r~~n~~n~~n~~n~~n~~n~~n~~n~The tank is empty!",3000,3);
        }
    }
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
   	if(CP[playerid] == 30)
	{
	    SendClientMessage(playerid, -1, "Please enter the LSPD and go to the reception.");
	    SendClientMessage(playerid, -1, "There you'll find out whether you'll get accepted or not. Good Luck!");
	    CP[playerid] = 0;
        DisablePlayerCheckpoint(playerid);
    }
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(GetPVarInt(playerid,"RACER"))
	{
      	SetPVarInt(playerid,"PlayerCheckPoints",GetPVarInt(playerid,"PlayerCheckPoints")-1);
      	PlayerPlaySound(playerid, 1058, 0, 0, 5);
	  	new k=RaceInfo[RaceIDCount][RaceCpCount];
	  	new a = GetPVarInt(playerid,"PlayerCheckPoints");
	  	if(a == 1) SetPlayerRaceCheckpoint(playerid,1,RaceCPs[RaceIDCount][k-a][0],RaceCPs[RaceIDCount][k-a][1],RaceCPs[RaceIDCount][k-a][2],0,0,0,15.00);
	  	else if(a== 0) pFinishRace(playerid);
      	else SetPlayerRaceCheckpoint(playerid,0,RaceCPs[RaceIDCount][k-a][0],RaceCPs[RaceIDCount][k-a][1],RaceCPs[RaceIDCount][k-a][2],RaceCPs[RaceIDCount][k-a+1][0],RaceCPs[RaceIDCount][k-a+1][1],RaceCPs[RaceIDCount][k-a+1][2],15.00);
	}
	else if(IsPlayerInRaceStartCheckpoint(playerid))
	{
		 SendClientMessage(playerid,COLOR_RACE,"<+> *** You are in race start checkpoint. Wait here until the race starts.");
	}
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid==LSPDPickup)
	{
		ShowPlayerDialog(playerid,DIALOG_LSPD,DIALOG_STYLE_MSGBOX,"LSPD","Hello, sir!\nWell, you want to get a part of the Police in Los Santos?!","YES!","NO!");
		return 1;
	}
	if(pickupid == enterhalle)
	{
		SetPlayerInterior(playerid,3);
 		SetPlayerPos(playerid,384.808624,173.804992,1008.382812);
	}
	if(pickupid == exithalle)
	{
	    SetPlayerInterior(playerid,0);
	    SetPlayerPos(playerid, 1481.8009,-1768.5259,18.7958);
	}
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
  	if(CanOpenMenu[playerid])
  	{
    	if(GetHouseID(playerid) != -255)
    	{
			new x = GetHouseID(playerid);
    	    ShowMenus(playerid,x);
    	    OpenHouseDialog(playerid, x);
		}
    	CanOpenMenu[playerid] = 0;
    	SetTimerEx("HideMenusForPlayer",3500,false,"i",playerid);
  	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	TogglePlayerControllable(playerid,1);
	new Menu:current;
    current = GetPlayerMenu(playerid);
    if(current == OwnedMenu)
    {
        switch(row)
        {
		    case 0:
		    {
  	            EnterHouse(playerid, GetHouseID(playerid));
		    }
		    case 1:
		    {
                new string[101];
                new price = floatround(hInfo[GetHouseID(playerid)][Cost]*0.5,floatround_ceil);
                format(string,sizeof(string), "Are you sure that you want to sell your house for %d$?", price);
                ShowPlayerDialog(playerid, DIALOG_SELLHOUSE, DIALOG_STYLE_MSGBOX, "House", string, "Yes", "No");
	        }
        }
    }
    if((current == NotOwnedMenu) || (current == NotOwnedMenu2))
    {
        switch(row)
        {
            case 0:
	       	{
	           	if(GetPlayerMoney(playerid) < hInfo[GetHouseID(playerid)][Cost]) return SendClientMessage(playerid,COLOR_DARKRED,"<-> *** You don't have enough money to buy this house.");
	           	BuyHouse(playerid, GetHouseID(playerid));
	       	}
           	case 1:
           	{
  	           	EnterHouse(playerid, GetHouseID(playerid));
           	}
        }
    }
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	TogglePlayerControllable(playerid, true);
	return 1;
}

public OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid)
{
  	HidePlayerDialog(playerid);
  	if(newinteriorid == 0 && oldinteriorid != 1)
  	{
    	if((InHouse[playerid] >= 0) || (GetPlayerVirtualWorld(playerid) == 7) || (GetPlayerVirtualWorld(playerid) == 1337) || (GetPlayerVirtualWorld(playerid) == 1336 || (GetPlayerVirtualWorld(playerid) == 1338)))
    	{
    	 	SetTimerEx("ExitBuilding",1000,false,"i",playerid);
    	}
    	if(GetPlayerVirtualWorld(playerid) == 1338) SetPlayerVirtualWorld(playerid,0);
  	}
  	if(GetPVarInt(playerid,"INDM"))
  	{
   		if((newinteriorid == 0) && GetPlayerVirtualWorld(playerid) == 7) SetPlayerInterior(playerid, 10);
   		if((newinteriorid == 0) && GetPlayerVirtualWorld(playerid) == 10) SetPlayerInterior(playerid, 1);
   		if((newinteriorid == 0) && GetPlayerVirtualWorld(playerid) == 12) SetPlayerInterior(playerid, 1);
   		if((newinteriorid == 0) && GetPlayerVirtualWorld(playerid) == 15) SetPlayerInterior(playerid, 18);
   		if((newinteriorid == 0) && GetPlayerVirtualWorld(playerid) == 14) SetPlayerInterior(playerid, 2);
  	}
  	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
  	if(( newkeys & KEY_YES))
  	{
  	  	toggleMotor(playerid);
		print("1");
	    if(IsPlayerInRangeOfPoint(playerid,5.0,WeedInfo[playerid][wX],WeedInfo[playerid][wY],WeedInfo[playerid][wZ]))
	  	{
	  	    print("2");
		    for(new weed = 0; weed < sizeof(WeedInfo); weed++)
		    {
		        print("3");
	            if(WeedInfo[playerid][wAbleToPick] == false) SendClientMessage(playerid,COLOR_DARKRED,"<-> *** There's no weed that is ready to pick.");
			    ApplyAnimation(playerid, "BOMBER","BOM_Plant_In",4.0,0,0,0,0,0);
				WeedInfo[weed][wAbleToPick] = false;
				DestroyDynamicObject(WeedInfo[weed][wPlantObject]);
				pInfo[playerid][Weed] = 50;
				SendClientMessage(playerid, COLOR_RACE,"<+> *** You have successfully picked your weed. (Gained: 50 Grams)");
				Delete3DTextLabel(WeedInfo[weed][wLabel]);
				WeedInfo[weed][wLabels]--;
				pInfo[playerid][WeedPlant] = 0;
				return 1;
			}
		}
 	}
  	if(( newkeys & KEY_NO))
  	{
  		if(GetPVarInt(playerid,"RaceEditing"))
		{
			new Float:pos[4],str[256];
		   	new r=GetPVarInt(playerid,"RaceID");
		   	new pr=GetPVarInt(playerid,"RaceCP");
	       	GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
	       	GetPlayerFacingAngle(playerid,pos[3]);
		   	if(GetPVarInt(playerid,"StartP"))
		   	{
               	new INI:File = INI_Open(RacePath(r));
               	INI_SetTag(File,"RaceInfo");
               	INI_WriteFloat(File,"SpawnpX",pos[0]);
               	INI_WriteFloat(File,"SpawnpY",pos[1]);
               	INI_WriteFloat(File,"SpawnpZ",pos[2]);
               	INI_WriteFloat(File,"SpawnpA",pos[3]);
               	INI_Close(File);
               	RaceInfo[r][Spawnp][0]=pos[0];
               	RaceInfo[r][Spawnp][1]=pos[1];
               	RaceInfo[r][Spawnp][2]=pos[2];
               	RaceInfo[r][Spawnp][3]=pos[3];
               	DeletePVar(playerid,"StartP");
               	format(str,sizeof(str),"press 'N' to create the race start point");
		   	}
		   	else
		   	{
				if(pr == 0)
				{
               		new INI:File = INI_Open(RacePath(r));
               		INI_SetTag(File,"RaceInfo");
               		INI_WriteFloat(File,"StartX",pos[0]);
               		INI_WriteFloat(File,"StartY",pos[1]);
               		INI_WriteFloat(File,"StartZ",pos[2]);
               		INI_Close(File);
               		RaceInfo[r][StartCP][0]=pos[0];
               		RaceInfo[r][StartCP][1]=pos[1];
               		RaceInfo[r][StartCP][2]=pos[2];
               		format(str,sizeof(str),"press 'N' to create a race checkpoint");
				}
				else
				{
               		new INI:File = INI_Open(RacePath(r));
	           		new strvar[24];
               		INI_SetTag(File,"RaceInfo");
               		format(strvar,sizeof(strvar),"X_CheckPoint%d",pr-1);
               		INI_WriteFloat(File,strvar,pos[0]);
               		format(strvar,sizeof(strvar),"Y_CheckPoint%d",pr-1);
               		INI_WriteFloat(File,strvar,pos[1]);
               		format(strvar,sizeof(strvar),"Z_CheckPoint%d",pr-1);
               		INI_WriteFloat(File,strvar,pos[2]);
               		INI_Close(File);
               		RaceCPs[r][pr-1][0]=pos[0];
               		RaceCPs[r][pr-1][1]=pos[1];
               		RaceCPs[r][pr-1][2]=pos[2];
               		format(str,sizeof(str),"press 'N' to create a race checkpoint~n~type (/stopediting) to save & exit Created Checkpints %d",GetPVarInt(playerid,"RaceCP"));
				}
            	SetPVarInt(playerid,"RaceCP",pr+1);
		   	}
           	SendClientMessage(playerid,-1,str);
           	EDITORCPS[playerid][pr] = CreateDynamicRaceCP(2,pos[0],pos[1],pos[2],0.0,0.0,0.0, 10, GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,361.8299,173.6782,1008.3828))
		{
			ShowPlayerDialog(playerid,DIALOG_EMPLOYMENT,DIALOG_STYLE_LIST,"Jobs","Cop","Ok","Cancel");
		}
	}
  	if(newkeys & KEY_LOOK_BEHIND)
  	{
		for(new i=0; i<MAX_HOUSES; i++)
		{
      		if(GetPlayerVirtualWorld(playerid) == hInfo[i][VirtualWorld] && (InHouse[playerid] == i))
	  		{
        		ExitHouse(playerid, i);
				break;
      		}
		}
  	}
  	if(newkeys & KEY_WALK)
  	{
  	    if(IsPlayerInAnyVehicle(playerid))
		{
            if(IsAtGasStation(playerid))
			{
                new vehicle = GetPlayerVehicleID(playerid);
                new liter = GAS_MAXFULL; liter -= floatround(Tank[vehicle],floatround_floor);
                if(Motor[vehicle] == true)
				{
					SendClientMessage(playerid, COLOR_DARKRED, "<-> *** You have to turn off the motor before you can do that!");
				}
                else
				{
                    if(GetPlayerMoney(playerid) > liter*PRICE)
					{
                        TogglePlayerControllable(playerid, 1);
                        SetTimerEx("FillGas", 1000, 0, "iii", vehicle, playerid,0);
                        GameTextForPlayer(playerid, "~w~~n~~n~~n~~n~~n~~n~~n~~n~Your vehicle is going refueled...",GAS_TIME,3);
                    }
                    else
					{
						SendClientMessage(playerid, COLOR_DARKRED, "<-> *** You don't have enough money.");
					}
                }
            }
        }

		for(new i=0; i<MAX_HOUSES; i++)
		{
      		if(GetPlayerVirtualWorld(playerid) == hInfo[i][VirtualWorld] && (InHouse[playerid] == i))
	  		{
				if(pInfo[playerid][House] == i)
				{
          			if(IsPlayerInRangeOfPoint(playerid,2.0, hInfo[i][InteriorX], hInfo[i][InteriorY], hInfo[i][InteriorZ]))
          			ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"House Menu","Eat\nGet Armour\nMoney Storage","Select","Cancel");
	  	  			break;
	  			}
      		}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,3.00,2370.7659,-1649.2642,13.5469) && !InfoTDShown[playerid])
    {
        TextDrawShowForPlayer(playerid, Textdraw6);
        TextDrawShowForPlayer(playerid, Textdraw7);
        TextDrawShowForPlayer(playerid, Textdraw8[playerid]);//
        TextDrawSetString(Textdraw8[playerid], "Use the command /organizerace to organize a race right here!");
        TextDrawShowForPlayer(playerid, Textdraw9);
		InfoTDShown[playerid] = 1;
	}
	else if(!IsPlayerInRangeOfPoint(playerid,3.00,2370.7659,-1649.2642,13.5469) && InfoTDShown[playerid])
	{
        TextDrawHideForPlayer(playerid, Textdraw6);
        TextDrawHideForPlayer(playerid, Textdraw7);
        TextDrawHideForPlayer(playerid, Textdraw8[playerid]);
        TextDrawHideForPlayer(playerid, Textdraw9);
		InfoTDShown[playerid] = 0;
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_REGISTER)
    {
        if(!response) return Kick(playerid);
        if(response)
        {
            if(!strlen(inputtext))
            {
                ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"Register","Welcome! This account hasn't been registred yet.\nEnter your own password to create a new account.\nPlease enter the password!","Register","Quit");
                return 1;
            }
            new hashpass[129];
            WP_Hash(hashpass,sizeof(hashpass),inputtext);
            new INI:file = INI_Open(Path(playerid));
            INI_SetTag(file,"Player's Data");
            INI_WriteString(file,"Password",hashpass);
            INI_WriteInt(file,"AdminLevel",0);
            INI_WriteInt(file,"Money",0);
			INI_WriteInt(file,"Scores",0);
            INI_WriteInt(file,"Kills",0);
            INI_WriteInt(file,"Deaths",0);
            INI_WriteInt(file,"Skin",0);
            INI_WriteInt(file,"House",-255);
    		INI_WriteInt(file,"HouseMoney",0);
            INI_WriteInt(file,"WeedPlant",0);
    		INI_WriteInt(file,"Weed",0);
    		INI_WriteInt(file,"Job",0);
            INI_Close(file);
            SendClientMessage(playerid,-1,"You have successfully been registered. Please choose your skin now.");
            SendClientMessage(playerid,-1,"WARNING: Be sure that you like your choosen skin. You won't be able");
            SendClientMessage(playerid,-1,"                to change it anymore.");
			ShowModelSelectionMenu(playerid, skinlist, "Select Skin");
			pFirstLog[playerid] = true;
            return 1;
        }
    }
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);
        if(response)
        {
            new hashpass[129];
            WP_Hash(hashpass,sizeof(hashpass),inputtext);
            if(!strcmp(hashpass, pInfo[playerid][Pass], false))
            {
                INI_ParseFile(Path(playerid),"loadaccount_%s",.bExtra = true, .extra = playerid);
                SetPlayerScore(playerid,pInfo[playerid][Scores]);
                GivePlayerMoney(playerid,pInfo[playerid][Money]);
                SendClientMessage(playerid,-1,"Welcome back! You have successfully been logged in.");
                Spawned[playerid] = 2;
                SpawnPlayer(playerid);
            }
            else
            {
                ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Welcome back. This account has already been registred. \nInsert your password to login to your account.\nIncorrect password!","Login","Quit");
                return 1;
            }
        }
    }
    if(dialogid == DIALOG_EMPLOYMENT)
    {
        if(response)
        {
            switch(listitem)
            {
				case 0:
				{
				    CP[playerid] = 30;
					SetPlayerCheckpoint(playerid,1543.3094,-1675.6703,13.5562,3.0);
                    SendClientMessage(playerid, -1, "Ok, you told us now which job you want to get.");
                    SendClientMessage(playerid, -1, "Please drive to the Checkpoint that we set for you, and enter the LSPD!");
				}
			}
		}
	}
	if(dialogid == DIALOG_LSPD)
    {
    	if(response)
    	{
			SendClientMessage(playerid, COLOR_RED, "Cop: {FFFFFF}Ok, we'll tell you in 24 Ingame-Hours whether you got accepted or not.");
    		LSPDTimer[playerid] = SetTimerEx("LSPDTimer_", 60000*24, 1, "d", playerid);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "Cop: {FFFFFF}Ok, so please leave the reception now.");
		}
	}
	if(dialogid == 16551)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPVarInt(playerid,"RaceID",GetFreeRaceID());
                    new str[1024];
  				    str="Welcome To Race Construction Center\nPlease read the following carefully before creating any race:-\n-When entering race construction mode you will be putten in a diffrent virtual world\n- Press N to create a race checkpoint\n- The first checkpoint is the Race Spawn point\n- The second checkpoint is the race start point\n-Type (/StopEditing) When you are finished";
				    ShowPlayerDialog(playerid,16550,DIALOG_STYLE_MSGBOX,"Race Construction", str,"Create","Exit");
				}
				case 1:
				{
                    new str[1024];
                    for(new x=0; x<MAX_RACES; x++)
                    {
		 			    if(RaceInfo[x][RaceCpCount] > 0)
						{
							format(str,sizeof(str),"%s\nRaceID %d",str,x+1);
						}
                    }
					ShowPlayerDialog(playerid,16552,DIALOG_STYLE_LIST,"Race Construction", str,"Exit","");
				}
				case 2:
				{
                    new str[1024];
                    for(new x=0; x<MAX_RACES; x++)
                    {
				    	if(RaceInfo[x][RaceCpCount] > 0) format(str,sizeof(str),"%s\nRaceID %d",str,x);
						else format(str,sizeof(str),"%s\nRaceID %d",str,x+1);
                    }
					ShowPlayerDialog(playerid,16553,DIALOG_STYLE_LIST,"Race Construction", str,"Delete","Exit");
				}
			}
		}
	}
	if(dialogid == 16553)
	{
		if(response)
		{
			if(RaceInfo[listitem][RaceCpCount] < 1)
			{
				SendClientMessage(playerid,COLOR_RED,"This Race hasnt been created yet");
                new str[1024];
                for(new x=0; x<MAX_RACES; x++)
                {
					if(RaceInfo[x][RaceCpCount] > 0) format(str,sizeof(str),"%s\nRaceID %d",str,x);
					else format(str,sizeof(str),"%s\nRaceID %d",str,x);
                }
				ShowPlayerDialog(playerid,16553,DIALOG_STYLE_LIST,"Race Construction", str,"Delete","Exit");
			}
			else
			{
				fremove(RacePath(listitem));
				new str[128];
				format(str,sizeof(str),"Race ID %d has been removed",listitem);
				SendClientMessage(playerid,COLOR_RACE,str);
				for(new x=0; x<50; x++)
				{
					RaceCPs[listitem][x][0]=0;
					RaceCPs[listitem][x][1]=0;
					RaceCPs[listitem][x][2]=0;
				}
				RaceInfo[listitem][RaceCpCount]=0;
			}
		}
	}
	if(dialogid == 412)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if((GetPVarInt(playerid,"RaceCP") < 2)) { SendClientMessage(playerid,COLOR_RED,"You cant save races with less than two checkpoints"),ShowPlayerDialog(playerid,452,DIALOG_STYLE_LIST,"Race Construction","Exit & Save Race\nExit Without Saving\nSet Race Laps","Select","Exit"); }
					else
					{
					    SendClientMessage(playerid,-1,"Thank you, the race has been saved and will be added as soon as possible by the scripter");
					    SetPlayerVirtualWorld(playerid,0);
						new r=GetPVarInt(playerid,"RaceCP");
						new INI:File = INI_Open(RacePath(GetPVarInt(playerid,"RaceID")));
                        INI_SetTag(File,"RaceInfo");
                        INI_WriteInt(File,"CpCount",r-1);
                        INI_Close(File);
				        RaceInfo[GetPVarInt(playerid,"RaceID")][RaceCpCount]=(r-1);
				        DeletePVar(playerid,"RaceEditing");
				        DeletePVar(playerid,"RaceCP");
				        DeletePVar(playerid,"RaceID");
                    	for(new x=0; x<50; x++) if(IsValidDynamicRaceCP(EDITORCPS[playerid][x])) DestroyDynamicRaceCP(EDITORCPS[playerid][x]);
				   	}
				}
				case 1:
				{
					SendClientMessage(playerid,-1,"Race construction cancelled without saving");
				    SetPlayerVirtualWorld(playerid,0);
					new r=GetPVarInt(playerid,"RaceID");
					fremove(RacePath(r));
				    for(new x=0; x<50; x++)
				    {
					   	RaceCPs[r][x][0]=0;
					   	RaceCPs[r][x][1]=0;
					   	RaceCPs[r][x][2]=0;
				    }
				    RaceInfo[r][RaceCpCount]=0;
			        DeletePVar(playerid,"RaceEditing");
			        DeletePVar(playerid,"RaceCP");
			        DeletePVar(playerid,"RaceID");
                   	for(new x=0; x<50; x++) if(IsValidDynamicRaceCP(EDITORCPS[playerid][x])) DestroyDynamicRaceCP(EDITORCPS[playerid][x]);
			 	}
			}
		}
	}
	if(dialogid == 16550)
	{
		if(response)
		{
			SetPlayerVirtualWorld(playerid,1010101);
			SetPVarInt(playerid,"StartP",true);
			SetPVarInt(playerid,"RaceCP",0);
			SetPVarInt(playerid,"RaceEditing",true);
			SendClientMessage(playerid, -1, "Press N to set the Start-CP");
   	    	new Float:pos[4];
	    	GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
	    	GetPlayerFacingAngle(playerid,pos[3]);
  	    	new ah= CreateVehicle(541, pos[0],pos[1],pos[2],pos[2], 6,0, 10);
        	PutPlayerInVehicle(playerid,ah,0);
	    	SetVehicleVirtualWorld(ah,GetPlayerVirtualWorld(playerid));
		}
    }
	if(dialogid == DIALOG_OTHERSHOUSE)
	{
      	if(!response) return 1;
	  	EnterHouse(playerid, GetHouseID(playerid));
		return 1;
	}
	if(dialogid == DIALOG_SELLHOUSE)
	{
        if(!response) return 1;
	    SellHouse(playerid, GetHouseID(playerid));
	    return 1;
	}
	if(dialogid == 2000)
	{
	    if(response)
	    {
		    switch(listitem)
		    {
		      	case 0: SetPlayerHealth(playerid,99),ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"House Menu","Eat\nGet Armour\nMoney Storage","Select","Cancel");
		      	case 1: SetPlayerArmour(playerid,99),ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"House Menu","Eat\nGet Armour\nMoney Storage","Select","Cancel");
		      	case 2: ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"House Money Storage","Store Money\nWithDraw Money\nCheck balance","Select","Cancel");
		    }
		}
  	}
    if(dialogid == 2001)
    {
	   	new str[256];
	   	if(!response)ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"House Menu","Eat\nGet Armour\nMoney Storage","Select","Cancel");
       	else if(response)
       	{
	       	switch(listitem)
	       	{
	         	case 0:
	         	{
               		format(str,sizeof(str),"Your Balance: %d\nPlease enter the money that you want to store.",pInfo[playerid][HouseMoney]);
               		ShowPlayerDialog(playerid,2003,DIALOG_STYLE_INPUT,"Store Money",str,"Store","Cancel");
	         	}
	         	case 1:
	         	{
               		format(str,sizeof(str),"Your Balance: %d\nPlease enter the money that you want to withdraw.",pInfo[playerid][HouseMoney]);
	          		ShowPlayerDialog(playerid,2004,DIALOG_STYLE_INPUT,"WithDraw Money",str,"Withdraw","Cancel");
	         	}
	         	case 2:
	         	{
               		format(str,sizeof(str),"Your Balance: %d",pInfo[playerid][HouseMoney]);
	          		ShowPlayerDialog(playerid,2005,DIALOG_STYLE_MSGBOX,"Bank Balance",str,"Back","");
	         	}
	      	}
       	}
       	return 1;
	}
    if(dialogid == 2003)
    {
       	if(!response) ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"House Money Storage","Store Money\nWithDraw Money\nCheck balance","Select","Cancel");
       	else if(response)
       	{
          	new oldcash = pInfo[playerid][HouseMoney];
           	new amount;
           	if(sscanf(inputtext, "d", amount)) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** Please use only numbers.");
           	if(amount > GetPlayerMoney(playerid) || amount < 0) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** You can't store less than 1$.");
          	GivePlayerMoney(playerid,-amount);
          	pInfo[playerid][HouseMoney] = (oldcash + amount);
	      	ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"House Money Storage","Store Money\nWithDraw Money\nCheck balance","Select","Cancel");
	   	}
    }
    if(dialogid == 2004)
    {
       	new amount;
       	new oldcash = pInfo[playerid][HouseMoney];
       	if(!response) ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"House Money Storage","Store Money\nWithDraw Money\nCheck balance","Select","Cancel");
       	else if(response)
       	{
           	if(sscanf(inputtext, "i", amount)) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** Please use only numbers.");
           	if(amount > oldcash) return SendClientMessage(playerid,COLOR_DARKRED, "<-> *** You don't have enough money.");
          	GivePlayerMoney(playerid,amount);
          	pInfo[playerid][HouseMoney] = (oldcash - amount);
         	ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"House Money Storage","Store Money\nWithDraw Money\nCheck balance","Select","Cancel");
       	}
    }
    if(dialogid == 2005)
	{
	    ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"House Money Storage","Store Money\nWithDraw Money\nCheck balance","Select","Cancel");
	}
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(_:clickedid != INVALID_TEXT_DRAW)
  	{
	    if(clickedid == Textdraw3)
	   	{
	    	if(fexist(Path(playerid)))
		    {
		        INI_ParseFile(Path(playerid),"loadaccount_%s", .bExtra = true, .extra = playerid);
		        ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Welcome back. Your account has already been registred.\nInsert your password to login to your account","Login","Quit");
		    }
		    else
		    {
		        ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"Register","Welcome! This account hasn't been registred yet.\nEnter your own password to create a new account.","Register","Quit");
		        return 1;
		    }
	    }
	    else if(clickedid == Textdraw4)
	    {
			//NOTHING YET
	    }
	}
    return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == skinlist)
	{
	    if(response)
	    {
		    SendClientMessage(playerid,-1, "Your skin has been saved.");
		    SendClientMessage(playerid,-1, "Your accout has successfully been created. You'll see the toturial now...");
            new INI:file = INI_Open(Path(playerid));
            INI_SetTag(file,"Player's Data");
            INI_WriteInt(file,"AdminLevel",0);
            INI_WriteInt(file,"Money",0);
			INI_WriteInt(file,"Scores",0);
            INI_WriteInt(file,"Kills",0);
            INI_WriteInt(file,"Deaths",0);
            INI_WriteInt(file,"Skin",modelid);
            INI_WriteInt(file,"House",-255);
    		INI_WriteInt(file,"HouseMoney",0);
            INI_WriteInt(file,"WeedPlant",0);
    		INI_WriteInt(file,"Weed",0);
    		INI_WriteInt(file,"Job",0);
            INI_Close(file);
	    	TextDrawHideForPlayer(playerid, Textdraw0);
	    	TextDrawHideForPlayer(playerid, Textdraw1);
	    	TextDrawHideForPlayer(playerid, Textdraw2);
	    	TextDrawHideForPlayer(playerid, Textdraw3);
	    	TextDrawHideForPlayer(playerid, Textdraw4);
	    	CancelSelectTextDraw(playerid);
	    	Spawned[playerid] = 1;
	    	SpawnPlayer(playerid);
	    	SendClientMessage(playerid,COLOR_RED, "Ok, there's no tutorial yet. Enjoy playing on an empty server =)");
	    	SetPlayerSkin(playerid, modelid);
	    	SetSpawnInfo(playerid,0,modelid,0.0,0.0,0.0,0.0,0,0,0,0,0,0);
	    }
    	return 1;
	}
	return 1;
}

// Own functions //
public loadaccount_user(playerid, name[], value[])
{
    INI_String("Password", pInfo[playerid][Pass],129);
    INI_Int("AdminLevel",pInfo[playerid][Adminlevel]);
    INI_Int("Money",pInfo[playerid][Money]);
    INI_Int("Scores",pInfo[playerid][Scores]);
    INI_Int("Kills",pInfo[playerid][Kills]);
    INI_Int("Deaths",pInfo[playerid][Deaths]);
    INI_Int("Skin",pInfo[playerid][Skin]);
	INI_Int("House",pInfo[playerid][House]);
	INI_Int("HouseMoney",pInfo[playerid][HouseMoney]);
	INI_Int("WeedPlant",pInfo[playerid][WeedPlant]);
	INI_Int("Weed",pInfo[playerid][Weed]);
	INI_Int("Job",pInfo[playerid][Job]);
//	SetPlayerSkin(playerid,pInfo[playerid][Skin]);
//	SetSpawnInfo(playerid,0,pInfo[playerid][Skin],0.0,0.0,0.0,0.0,0,0,0,0,0,0);
    return 1;
}

public SetBackToNormalCam(playerid)
{
    SetCameraBehindPlayer(playerid);
    DisablePlayerRaceCheckpoint(playerid);
}

public Startrace()
{
	new count=0;
/*	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(GetPlayerState(i) != 2 && IsPlayerInRaceStartCheckpoint(i)) return SendClientMessage(i,-1,"The race has been started without you because you had no vehicle.");
		if(!IsPlayerInRaceStartCheckpoint(i) && GetPlayerState(i) == 2) return SendClientMessage(i,-1,"The race has been started without you because you weren't in the start-CP.");
		DisablePlayerRaceCheckpoint(i);
	}*/
	foreach(new i : Player)	if(IsPlayerInRaceStartCheckpoint(i) && GetPlayerState(i) == 2) count++;
	finishedracers=0;
	foreach (new i : Player)
	{
 		if(IsPlayerInRaceStartCheckpoint(i))
 		{
	  		TogglePlayerControllable(i,0);
	  		SetPVarInt(i,"RACER",true);
	  		SetPVarInt(i,"PlayerCheckPoints",RaceInfo[RaceIDCount][RaceCpCount]);
      		SetPlayerRaceCheckpoint(i,0,RaceCPs[RaceIDCount][0][0],RaceCPs[RaceIDCount][0][1],RaceCPs[RaceIDCount][0][2],RaceCPs[RaceIDCount][1][0],RaceCPs[RaceIDCount][1][1],RaceCPs[RaceIDCount][1][2],15.00);
      		RepairVehicle(GetPlayerVehicleID(i));
      		GameTextForPlayer(i,"~r~~h~The race will start now",1000,5);
		}
   	}
   	RaceEnd=0;
   	RaceStarted=2;
   	SetTimer("Race5",1000,false);
   	SetTimer("Race4",2000,false);
   	SetTimer("Race3",3000,false);
   	SetTimer("Race2",4000,false);
   	SetTimer("Race1",5000,false);
   	SetTimer("RaceGo",6000,false);
   	DestroyDynamicMapIcon(RaceStartIcon);
   	return 1;
}

public Race5() foreach (new i : Player) if(GetPVarInt(i,"RACER")) GameTextForPlayer(i,"~r~~h~~n~~n~~n~5",1000,5);
public Race4() foreach (new i : Player) if(GetPVarInt(i,"RACER")) GameTextForPlayer(i,"~r~~h~~n~~n~~n~4",1000,5);
public Race3() foreach (new i : Player) if(GetPVarInt(i,"RACER")) GameTextForPlayer(i,"~r~~h~~n~~n~~n~3",1000,5),PlayerPlaySound(i, 7417,0,0,0);
public Race2() foreach (new i : Player) if(GetPVarInt(i,"RACER")) GameTextForPlayer(i,"~r~~h~~n~~n~~n~2",1000,5),PlayerPlaySound(i, 7418,0,0,0);
public Race1() foreach (new i : Player) if(GetPVarInt(i,"RACER")) GameTextForPlayer(i,"~r~~n~~n~~n~1",1000,5),PlayerPlaySound(i, 7419,0,0,0);
public RaceGo()
{
    RaceStarted=1;
	foreach (new i : Player)
	{
	   if(GetPVarInt(i,"RACER"))
	   {
            TogglePlayerControllable(i,1);
        	GameTextForPlayer(i,"~g~~n~~n~~n~GO GO GO!",1000,5);
        	PlayerPlaySound(i, 3200,0,0,0);
	   }
	}
	RaceTicks=GetTickCount();
	RaceTimer = SetTimer("RaceUpdate",1000,true);
	return 1;
}

public RaceUpdate()
{
  	if(RaceEnd == 1) RaceEndCount--;
  	foreach(Player,playerid)
  	{
      	if(GetPVarInt(playerid,"RACER"))
      	{
	    	new str[128];
			if(RaceEnd==1)
			{
			 	format(str,sizeof(str),"The race ends in %d seconds",RaceEndCount);
			 	GameTextForPlayer(playerid,str,3000,3);
			}
			if((RaceEndCount == 0) && RaceEnd == 1) RemoveFromRace(playerid);
	  	}
  	}
  	return 1;
}


public SetRaceCheckPointForAll(type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size)
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		SetPlayerRaceCheckpoint(i, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size);
	}
	return 1;
}

public LoadRace_RaceInfo(r,name[],value[])
{
    INI_Float("StartX",RaceInfo[r][StartCP][0]);
	INI_Float("StartY",RaceInfo[r][StartCP][1]);
	INI_Float("StartZ",RaceInfo[r][StartCP][2]);
    INI_Float("SpawnpX",RaceInfo[r][Spawnp][0]);
	INI_Float("SpawnpY",RaceInfo[r][Spawnp][1]);
	INI_Float("SpawnpZ",RaceInfo[r][Spawnp][2]);
	INI_Float("SpawnpA",RaceInfo[r][Spawnp][3]);
    INI_Int("CPCount",RaceInfo[r][RaceCpCount]);
	new strvar[24];
	for(new x=0; x<50; x++)
	{
        format(strvar,sizeof(strvar),"X_CheckPoint%d",x);
        INI_Float(strvar,RaceCPs[r][x][0]);
        format(strvar,sizeof(strvar),"Y_CheckPoint%d",x);
        INI_Float(strvar,RaceCPs[r][x][1]);
        format(strvar,sizeof(strvar),"Z_CheckPoint%d",x);
        INI_Float(strvar,RaceCPs[r][x][2]);
	}
    return 0;
}

public ExitBuilding(i)
{
//  	if(GetPlayerVirtualWorld(i) == 1337)  SetPlayerVirtualWorld(i,0),  TeleportPlayer(i,-1901.4202,487.2479,35.1719,91.1588,0),SetPlayerVirtualWorld(i,0);
//  	if(GetPlayerVirtualWorld(i) == 1336)  SetPlayerVirtualWorld(i,0),  TeleportPlayer(i,1480.7491,-1768.4452,18.7958,358.8733,0),SetPlayerVirtualWorld(i,0);
  	if(InHouse[i] >= 0) SetPlayerPosEx(i,hInfo[InHouse[i]][sX],hInfo[InHouse[i]][sY],hInfo[InHouse[i]][sZ],hInfo[InHouse[i]][SpawnA]),  SetPlayerVirtualWorld(i,0),InHouse[i] =-255;
  	if(GetPlayerVirtualWorld(i) == 7)  SetPlayerInterior(i,10);
  	return 1;
}

public HideMenusForPlayer(playerid)
{
	CanOpenMenu[playerid] = 1;
	TextDrawHideForPlayer(playerid,Textdraw6);
    TextDrawHideForPlayer(playerid,Textdraw7);
	TextDrawHideForPlayer(playerid,Textdraw8[playerid]);
    TextDrawHideForPlayer(playerid,Textdraw9);
}

public LoadHouseData(houseid, name[], value[])
{
    INI_String("Name",hInfo[ houseid ][ Name ], 64);
    INI_String("Owner",hInfo[ houseid ][ Owner ], 24);
	INI_Int("Cost", hInfo[ houseid ][ Cost ]);
    INI_Float("pickUpX", hInfo[ houseid ][ ExteriorX ]);
	INI_Float("pickUpY", hInfo[ houseid ][ ExteriorY ]);
	INI_Float("pickUpZ", hInfo[ houseid ][ ExteriorZ ]);
	INI_Float("SpawnX", hInfo[ houseid ][ sX ]);
	INI_Float("SpawnY", hInfo[ houseid ][ sY ]);
	INI_Float("SpawnZ", hInfo[ houseid ][ sZ ]);
	INI_Float("SpawnA", hInfo[ houseid ][ SpawnA ]);
	INI_Float("InteriorX", hInfo[ houseid ][ InteriorX ]);
	INI_Float("InteriorY", hInfo[ houseid ][ InteriorY ]);
	INI_Float("InteriorZ", hInfo[ houseid ][ InteriorZ ]);
	INI_Float("InteriorA", hInfo[ houseid ][ InteriorA ]);
	INI_Int("Interior", hInfo[houseid][Interior]);
	INI_Int("Int", hInfo[houseid][HInt]);
    return 0;
}

public PlantWeedTimer(playerid)
{
	Update3DTextLabelText(WeedInfo[playerid][wLabel],COLOR_SILVER,"The weed is ready to get picked!\nPress Y/Z to pick up the weed!");
	WeedInfo[playerid][wAbleToPick] = true;
}

public UseWeedTimer(playerid)
{
	SetPlayerDrunkLevel(playerid, 0);
	SendClientMessage(playerid,-1,"Marijuana effects have faded away.");
}

public ClockSync(playerid)
{
  	Minute = Minute + 1;
  	if(Minute == 60)
  	{
    	Timen = Timen + 1;
    	Minute = 0;
  	}
  	for(new i; i<MAX_PLAYERS; i++)
  	SetPlayerTime(i, Timen, Minute);
  	return 1;
}

public LSPDTimer_(playerid)
{
    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
        new rand = random(sizeof(RandomAcceptLSPD));
        if(rand == 1)
        {
            SendClientMessage(playerid, COLOR_RACE, "< !!CONGRATULATIONS!! > You got accepted as a cop! Go to the LSPD, and turn on your cop-skin!");
			Job_[playerid] = JOB_COP;
			pInfo[playerid][Job] = JOB_COP;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_DARKRED, "< !!SORRY!! > You haven't been accepted as a cop. If you still want to be a cop, apply again.");
		}
	}
	KillTimer(LSPDTimer[playerid]);
	return 1;
}

public Speedometer(playerid)
{
    TextDrawHideForPlayer(playerid, Tacho[playerid]);
    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
        if(IsPlayerInAnyVehicle(playerid))
		{
            TextDrawShowForPlayer(playerid, Tacho[playerid]);
            new Float:chealth, speed_string[80], kmh, vehicleid = GetPlayerVehicleID(playerid);
            GetVehicleHealth(vehicleid, chealth);
            kmh = getKmh(playerid, true);
            if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
			    new Float:x2, Float:y2, Float:z2, Float:output;
               	GetVehiclePos(vehicleid, x2, y2, z2);
                output = floatsqroot(floatpower(floatabs(floatsub(x2, vehicles[vehicleid][vLastX])), 2)+floatpower(floatabs(floatsub(y2, vehicles[vehicleid][vLastY])), 2)+floatpower(floatabs(floatsub(z2, vehicles[vehicleid][vLastZ])), 2));
                new Float:rtank = output / 1000 * LITER_PER_KM;
                Tank[vehicleid] -= rtank;
                vehicles[vehicleid][vehicleKm] += output;
                vehicles[vehicleid][vLastX] = x2; vehicles[vehicleid][vLastY] = y2; vehicles[vehicleid][vLastZ] = z2;
            }
            format(speed_string,255,"%d KM/H~n~%.2f KMs~n~%.1f/%dl", kmh,(vehicles[vehicleid][vehicleKm]/1000), Tank[vehicleid], GAS_MAXFULL);
            TextDrawSetString(Tacho[playerid], speed_string);
        }
    }
    return 1;
}

public Gas()
{
    new vehicleid;
    for(new i=0; i < MAX_VEHICLES;i++)
	{
        for(new p=0; p < MAX_PLAYERS; p++)
		{
            if(IsPlayerConnected(p) && !IsPlayerNPC(p))
			{
                vehicleid = GetPlayerVehicleID(p);
                vehicleid = GetPlayerVehicleID(p);
                if(vehicleid == i)
				{
                    if(Tank[i] <= 4 && Tank[i] >= 1)
					{
						PlayerPlaySound(p, 1085, 0.0, 0.0, 0.0);
					}
                }
            }
        }
        if(Motor[i] == true)
		{
            Tank[i] -= 0.1;
            if(Tank[i] <= 0)
			{
				Motor[i] = false;
				SetVehicleParamsEx(i, VEHICLE_PARAMS_OFF, lights,alarm,doors,bonnet,boot,objective);
			}
        }
    }
    return 1;
}

// Stocks //
stock Path(playerid)
{
    new str[128],name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,name,sizeof(name));
    format(str,sizeof(str),UserPath,name);
    return str;
}

stock HousePath(houseid)
{
  	new housefile[64];
  	format(housefile, sizeof(housefile), HousePath_, houseid);
  	return housefile;
}

stock IsValidSkin(skinid)
{
    switch (skinid)
    {
        default: return 1;
    }
    return 1;
}

stock GenerateRaceID()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfPoint(i,3.00,2370.7659,-1649.2642,13.5469))
		{
		    RaceIDCount = 0;
		    break;
		}
			/*for(new x=(RaceIDCount+1); x<MAX_RACES; x++)
			{
				if(RaceInfo[x][RaceCpCount] > 0)
				{
					RaceIDCount=x;
					break;
				}
			}
  */}
}

stock GenerateRaceID2()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfPoint(i,3.00,2370.7659,-1649.2642,13.5469))
		{
		    RaceIDCount = 0;
		    break;
		}
			/*for(new x=(RaceIDCount+1); x<MAX_RACES; x++)
			{
				if(RaceInfo[x][RaceCpCount] > 0)
				{
					RaceIDCount=x;
					break;
				}
			}
  */}
}

stock IsPlayerInRaceStartCheckpoint(playerid)
{
   	if(!IsPlayerInRangeOfPoint(playerid,20.0,RaceInfo[RaceIDCount][StartCP][0],RaceInfo[RaceIDCount][StartCP][1],RaceInfo[RaceIDCount][StartCP][2])
   	|| !IsPlayerInRaceCheckpoint(playerid)
   	|| GetPVarInt(playerid,"pOur")) return 0;
   	return 1;
}

stock RemoveFromRace(playerid)
{
	DeletePVar(playerid,"RACER");
	if(CountRace() == 0) EndRace();
}
stock EndRace()
{
    KillTimer(RaceTimer);
    RaceStarted=0;
	SendClientMessageToAll(COLOR_DARKYELLOW," *** The race has been finished");
    DestroyDynamicMapIcon(RaceStartIcon);
	if(finishedracers > 0)
	{
       	new BA=RaceIDCount;
      	GenerateRaceID();
      	if(RaceIDCount == BA) GenerateRaceID2();
	}
    foreach (new i : Player) SetPlayerRaceCheckpoint(i,0,RaceInfo[RaceIDCount][StartCP][0],RaceInfo[RaceIDCount][StartCP][1], RaceInfo[RaceIDCount][StartCP][2],RaceCPs[RaceIDCount][0][0],RaceCPs[RaceIDCount][0][1],RaceCPs[RaceIDCount][0][2],15.0);
    finishedracers=0;
}

stock pFinishRace(playerid)
{
	new rTime=GetTickCount() - RaceTicks;
    DisablePlayerRaceCheckpoint(playerid);
	new Float:x,Float:y,Float:z;
	GetPlayerCameraPos(playerid,x,y,z),SetPlayerCameraPos(playerid,x,y,z);
	GetPlayerPos(playerid,x,y,z),SetPlayerCameraLookAt(playerid,x,y,z);
	SetTimerEx("SetBackToNormalCam",3000,false,"i",playerid);
    finishedracers++;
  	new str3[128];
    if(finishedracers == 1)
	{
	   	GivePlayerMoney(playerid,200);
	   	format(str3,sizeof(str3)," *** %s has finished the Race%s - 1st place in %s",GetPlayerNameEx(playerid),RaceIDstring(),ConvertTime(rTime));
       	RaceEndCount=30;
       	RaceEnd=1;
	}
	else if(finishedracers == 2) format(str3,sizeof(str3)," *** %s has finished the Race%s - 2nd place in %s",GetPlayerNameEx(playerid),RaceIDstring(),ConvertTime(rTime));
    else if(finishedracers == 3) format(str3,sizeof(str3)," *** %s has finished the Race%s - 3rd place in %s",GetPlayerNameEx(playerid),RaceIDstring(),ConvertTime(rTime));
    else format(str3,sizeof(str3)," *** %s has finished the Race%s - %dth place in %s",GetPlayerNameEx(playerid),RaceIDstring(),finishedracers,ConvertTime(rTime));
    SendClientMessageToAll(COLOR_DARKYELLOW,str3);
	new count=0;
	for(new d=0;d<5;d++)
	{
		if((rTime < RaceRecords[RaceIDCount][toptime][d]) || (RaceRecords[RaceIDCount][toptime][d] == 0))
		{
			count++;
		}
	}
    RemoveFromRace(playerid);
    RepairVehicle(GetPlayerVehicleID(playerid));
	return 1;
}

stock Float:GetpRaceNextCp(playerid,pos)
{
	new Float:rpos;
	new cpp=GetPVarInt(playerid,"PlayerCheckPoints");
	rpos = RaceCPs[RaceIDCount][cpp+1][pos];
	return rpos;
}

stock Float:GetpRaceNext2Cp(playerid,pos)
{
	new Float:rpos;
	new cpp=GetPVarInt(playerid,"PlayerCheckPoints");
	rpos = RaceCPs[RaceIDCount][cpp+2][pos];
	return rpos;
}

stock GetRacePosition(playerid)
{
  new count = 1;
  new a=GetPVarInt(playerid,"PlayerCheckPoints");
  new k=RaceInfo[RaceIDCount][RaceCpCount];
  foreach(Player,x)
  {
     new b=GetPVarInt(x,"PlayerCheckPoints");
     if(GetPVarInt(x,"RACER") && x != playerid)
	 {
       if(b < a)
       {
          count++;
       }
       else if(b == a)
       {
         new
         Float:pDistance = GetPlayerDistanceFromPoint(playerid, RaceCPs[RaceIDCount][k-a][0],RaceCPs[RaceIDCount][k-a][1],RaceCPs[RaceIDCount][k-a][2]),
         Float:xDistance = GetPlayerDistanceFromPoint(x, RaceCPs[RaceIDCount][k-b][0],RaceCPs[RaceIDCount][k-b][1],RaceCPs[RaceIDCount][k-b][2]);
         if(xDistance<pDistance) count++;
       }
     }
  }
  return count+finishedracers;
}


stock RaceIDstring()
{
 	new str[10];
 	new k=RaceIDCount+1;
 	switch(k)
 	{
	 	case 0..9:  format(str,sizeof(str),"00%d",k);
	 	case 10..99: format(str,sizeof(str),"0%d",k);
	 	default: format(str,sizeof(str),"%d",k);
 	}
 	return str;
}

stock LoadCreatedRaces()
{
  	for(new r=0;r<MAX_RACES;r++)
  	{
    	if(fexist(RacePath(r)))
    	{
      		INI_ParseFile(RacePath(r), "LoadRace_%s", .bExtra = true, .extra = r);
		}
  	}
}

stock GetFreeRaceID()
{
	 new Q;
	 for(new x=0; x<MAX_RACES; x++)
	 {
		  if(RaceInfo[x][RaceCpCount] == 0)
		  {
				Q=x;
				break;
		  }
	 }
	 return Q;
}

stock RacePath(raceid)
{
       new pathh[128];
       format(pathh,sizeof(pathh),"/Races/%d.ini",raceid);
       return pathh;
}

stock CountRace()
{
	new avo=0;
	foreach (new i : Player)
	{
	   if(GetPVarInt(i,"RACER"))
	   {
		 avo++;
	   }
	}
	return avo;
}

stock ConvertTime(Milliseconds)
{
	new string[50];
    new Hours = Milliseconds / (1000*60*60);
    new Minutes = (Milliseconds % (1000*60*60)) / (1000*60);
    new Seconds = ((Milliseconds % (1000*60*60)) % (1000*60)) / 1000;
    new ms = Milliseconds - (Hours*60*60*1000) - (Minutes*60*1000) - (Seconds*1000);
	format(string,sizeof(string),"%02d:%02d:%03d",Minutes,Seconds,ms);
	return string;
}

stock LoadHouses()
{
  	for(new houseid=0;houseid<MAX_HOUSES;houseid++)
  	{
    	if(fexist(HousePath(houseid)))
    	{
	  		format(hInfo[houseid][Owner],24,"For_Sale");
      		INI_ParseFile(HousePath(houseid), "LoadHouseData", .bExtra = true, .extra = houseid);
      		new Float:eX=hInfo[houseid][ExteriorX];
      		new Float:eY=hInfo[houseid][ExteriorY];
      		new Float:eZ=hInfo[houseid][ExteriorZ];
      		if(strcmp(hInfo[houseid][Owner],"For_Sale",true) == 0)
      		{
        		HousePickup[houseid] = CreatePickup(1273, 23, eX, eY, eZ);
        		HouseIcon[houseid] = CreateDynamicMapIcon(eX,eY,eZ,31,0,0);
      		}
      		else
      		{
        		HousePickup[houseid] = CreatePickup(1272, 23, eX, eY, eZ);
        		HouseIcon[houseid] = CreateDynamicMapIcon(eX,eY,eZ,32,0,0);
	      	}
      		new a = hInfo[houseid][HInt];
      		if(a != -255)
      		{
  	    		hInfo[houseid][Interior] = floatround(Interiors[a][0],floatround_round);
	    		hInfo[houseid][InteriorX] = Interiors[a][1];
	    		hInfo[houseid][InteriorY] = Interiors[a][2];
	    		hInfo[houseid][InteriorZ] = Interiors[a][3];
	    		hInfo[houseid][InteriorA] = Interiors[a][4];
	    		hInfo[houseid][VirtualWorld] = Hvw;
        		hInfo[houseid][Locked] = 1;
	  		}
	  		Hvw++;
    	}
  	}
}

stock OpenHouseDialog(playerid, houseid)
{
  	if(strcmp(hInfo[houseid][Owner], "For_Sale",true) == 0)
  	{
		if(pInfo[playerid][House] > 0)
		{
    		TogglePlayerControllable(playerid,false);
    		ShowMenuForPlayer(NotOwnedMenu2,playerid);
		}
		else
		{
    		TogglePlayerControllable(playerid,false);
			ShowMenuForPlayer(NotOwnedMenu,playerid);
		}
  	}
  	else
  	{
		if(strcmp(hInfo[houseid][Owner], GetPlayerNameEx(playerid), true) == 0)
		{
	      	ShowMenuForPlayer(OwnedMenu,playerid);
	      	TogglePlayerControllable(playerid,false);
		}
		else
		{
	  		if(IsOwnerOnline(houseid))
	  		{
      		 	TogglePlayerControllable(playerid,false);
      		 	ShowMenuForPlayer(OwnedMenu2,playerid);
      		}
		}
  	}
  	return 1;
}

stock IsOwnerOnline(houseid)
{
   	foreach(Player,i)
   	{
	  	if(pInfo[i][House] == houseid)
	  	return 1;
   	}
   	return 0;
}

stock ShowMenus(playerid,houseid)
{
	new string[256];
    TextDrawShowForPlayer(playerid, Textdraw6);
    TextDrawShowForPlayer(playerid, Textdraw7);
    TextDrawShowForPlayer(playerid, Textdraw8[playerid]);//
    format(string, sizeof(string), "~w~Housenumber: ~y~%d~n~~w~Price: ~y~%d~n~~w~Owner: ~y~%s~n~~w~This is a house. If you want to buy it, press the ''Buy House'' button!", houseid,hInfo[houseid][Cost],hInfo[houseid][Owner]);
    TextDrawSetString(Textdraw8[playerid], string);
    TextDrawShowForPlayer(playerid, Textdraw9);
}

stock GetHouseID(playerid)
{
  	for(new i=1; i<MAX_HOUSES; i++)
  	{
    	if(IsPlayerInRangeOfPoint(playerid,2.0, hInfo[i][ExteriorX], hInfo[i][ExteriorY], hInfo[i][ExteriorZ]))
		{
	  		return i;
		}
  	}
  	return -255;
}

stock BuyHouse(playerid, houseid)
{
  	new string[256];
  	format(string,sizeof(string),HousePath_, houseid);
  	new INI:File2 = INI_Open(string);
  	INI_SetTag(File2,"housedata");
  	INI_WriteString(File2,"Name", hInfo[houseid][Name]);
  	INI_WriteString(File2,"Owner", GetPlayerNameEx(playerid));
  	INI_WriteInt(File2,"Locked", 1);
  	INI_Close(File2);
  	GivePlayerMoney(playerid, -hInfo[houseid][Cost]);
  	pInfo[playerid][House] = houseid;
  	hInfo[houseid][Owner] = GetPlayerNameEx(playerid);
  	DestroyPickup(HousePickup[houseid]);
  	DestroyDynamicMapIcon(HouseIcon[houseid]);
  	HousePickup[houseid] = CreatePickup(1272, 23, hInfo[houseid][ExteriorX], hInfo[houseid][ExteriorY], hInfo[houseid][ExteriorZ]);
  	HouseIcon[houseid] = CreateDynamicMapIcon(hInfo[houseid][ExteriorX], hInfo[houseid][ExteriorY], hInfo[houseid][ExteriorZ],32,0,0);
  	PlayerPlaySound(playerid,5450 ,0.0,0.0,0.0);
	SendClientMessage(playerid, COLOR_RACE, "<+> *** Congratulations, you have bought a house!");
	return 1;
}

stock GetOwnedHouseID(playerid)
{
  	new str[20];
  	if(pInfo[playerid][House] > 0) format(str,20,"(%d)",pInfo[playerid][House]);
  	else format(str,20,"   ");
  	return str;
}

stock SellHouse(playerid, houseid)
{
  	new string[256];
  	format(string,sizeof(string),HousePath_, houseid);
  	new INI:File2 = INI_Open(string);
  	INI_SetTag(File2,"housedata");
  	INI_WriteString(File2,"Name", hInfo[houseid][Name]);
  	INI_WriteString(File2,"Owner", "For_Sale");
  	INI_WriteInt(File2,"Locked", 0);
  	INI_Close(File2);
  	new sell = floatround(floatdiv(hInfo[houseid][Cost],100));
  	GivePlayerMoney(playerid, sell*40);
  	format(hInfo[houseid][Owner],24,"For_Sale");
  	DestroyPickup(HousePickup[houseid]);
  	DestroyDynamicMapIcon(HouseIcon[houseid]);
  	HousePickup[houseid] = CreatePickup(1273, 23, hInfo[houseid][ExteriorX], hInfo[houseid][ExteriorY], hInfo[houseid][ExteriorZ]);
  	HouseIcon[houseid] = CreateDynamicMapIcon(hInfo[houseid][ExteriorX], hInfo[houseid][ExteriorY], hInfo[houseid][ExteriorZ],31,0,0);
  	pInfo[playerid][House] = -255;
	SendClientMessage(playerid, COLOR_RACE, "<+> *** You have successfully sold your house.");
  	return 1;
}

stock EnterHouse(playerid, houseid)
{
  	SetPlayerPos(playerid, hInfo[houseid][InteriorX], hInfo[houseid][InteriorY], hInfo[houseid][InteriorZ]);
  	SetPlayerInterior(playerid, hInfo[houseid][Interior]);
  	SetPlayerVirtualWorld(playerid, hInfo[houseid][VirtualWorld]);
  	TogglePlayerControllable(playerid,true);
  	if(pInfo[playerid][House] == houseid)
  	{
  	   	ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"House Menu","Eat\nGet Armour\nMoney Storage","Select","Cancel");
  	}
  	InHouse[playerid] = houseid;
  	return 1;
}


stock ExitHouse(playerid, houseid)
{
  	SetPlayerPosEx(playerid,hInfo[houseid][sX],hInfo[houseid][sY],hInfo[houseid][sZ],hInfo[houseid][SpawnA]);
  	SetPlayerVirtualWorld(playerid, 0);
  	InHouse[playerid] = -255;
  	return 1;
}

stock HidePlayerDialog(playerid)
{
 	return ShowPlayerDialog(playerid,-1,0,"","","","");
}

GetPlayerNameEx(playerid)
{
	new NAME[MAX_PLAYER_NAME];
	GetPlayerName(playerid,NAME,MAX_PLAYER_NAME);
	return NAME;
}

stock SetPlayerPosEx(playerid, Float:X, Float:Y, Float:Z, Float:A)
{
	SetPlayerPos(playerid, X, Y, Z);
	SetPlayerFacingAngle(playerid, A);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, 0);
	return 1;
}

stock UseWeed(playerid)
{
	WeedInfo[playerid][wWeed] = -20;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	SetPlayerDrunkLevel(playerid, 5000);
	SendClientMessage(playerid,COLOR_RACE,"<+> *** Weed has successfully been used. (20 gram has been used)");
	SetTimer("UseWeedTimer", 60000*5, 0); // 5 minutes
}

stock GiveSeeds(playerid)
{
    WeedInfo[playerid][wSeeds] = 1;
	SendClientMessage(playerid,COLOR_RACE,"<+> *** Seeds has successfully been given.");
	WeedInfo[playerid][wAbleToPlant] = true;
}

stock GetSeedInfo(playerid)
{
	new seedinfo[10];
	if(WeedInfo[playerid][wSeeds] == 0) seedinfo = ("No");
	if(WeedInfo[playerid][wSeeds] == 1) seedinfo = ("Yes");
	return seedinfo;
}

stock RemoveUnneededObjects(playerid)
{
	RemoveBuildingForPlayer(playerid, 1529, 1098.8125, -1292.5469, 17.1406, 0.25);
 	RemoveBuildingForPlayer(playerid, 5930, 1134.2500, -1338.0781, 23.1563, 0.25);
 	RemoveBuildingForPlayer(playerid, 5931, 1114.3125, -1348.1016, 17.9844, 0.25);
 	RemoveBuildingForPlayer(playerid, 5934, 1076.7109, -1358.0938, 15.4453, 0.25);
 	RemoveBuildingForPlayer(playerid, 5935, 1120.1563, -1303.4531, 18.5703, 0.25);
 	RemoveBuildingForPlayer(playerid, 5936, 1090.0547, -1310.5313, 17.5469, 0.25);
 	RemoveBuildingForPlayer(playerid, 1440, 1085.7031, -1361.0234, 13.2656, 0.25);
 	RemoveBuildingForPlayer(playerid, 5731, 1076.7109, -1358.0938, 15.4453, 0.25);
 	RemoveBuildingForPlayer(playerid, 5788, 1080.9844, -1305.5234, 16.3594, 0.25);
 	RemoveBuildingForPlayer(playerid, 5787, 1090.0547, -1310.5313, 17.5469, 0.25);
 	RemoveBuildingForPlayer(playerid, 5764, 1065.1406, -1270.5781, 25.7109, 0.25);
 	RemoveBuildingForPlayer(playerid, 5810, 1114.3125, -1348.1016, 17.9844, 0.25);
 	RemoveBuildingForPlayer(playerid, 5993, 1110.8984, -1328.8125, 13.8516, 0.25);
 	RemoveBuildingForPlayer(playerid, 5811, 1131.1953, -1380.4219, 17.0703, 0.25);
 	RemoveBuildingForPlayer(playerid, 5708, 1134.2500, -1338.0781, 23.1563, 0.25);
 	RemoveBuildingForPlayer(playerid, 1440, 1141.9844, -1346.1094, 13.2656, 0.25);
 	RemoveBuildingForPlayer(playerid, 1440, 1148.6797, -1385.1875, 13.2656, 0.25);
 	RemoveBuildingForPlayer(playerid, 617, 1178.6016, -1332.0703, 12.8906, 0.25);
 	RemoveBuildingForPlayer(playerid, 620, 1184.0078, -1353.5000, 12.5781, 0.25);
 	RemoveBuildingForPlayer(playerid, 620, 1184.0078, -1343.2656, 12.5781, 0.25);
 	RemoveBuildingForPlayer(playerid, 5737, 1120.1563, -1303.4531, 18.5703, 0.25);
 	RemoveBuildingForPlayer(playerid, 618, 1177.7344, -1315.6641, 13.2969, 0.25);
 	RemoveBuildingForPlayer(playerid, 620, 1184.8125, -1292.9141, 12.5781, 0.25);
 	RemoveBuildingForPlayer(playerid, 620, 1184.8125, -1303.1484, 12.5781, 0.25);
    RemoveBuildingForPlayer(playerid, 5843, 1196.8438, -914.8672, 41.9688, 0.25);
    RemoveBuildingForPlayer(playerid, 5858, 1214.1484, -913.4453, 43.0547, 0.25);
    RemoveBuildingForPlayer(playerid, 1308, 1233.0000, -921.0625, 42.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 5741, 1196.8438, -914.8672, 41.9688, 0.25);
    RemoveBuildingForPlayer(playerid, 1522, 1199.9688, -917.6406, 42.0234, 0.25);
    RemoveBuildingForPlayer(playerid, 5844, 1206.1406, -900.9766, 42.1094, 0.25);
    RemoveBuildingForPlayer(playerid, 6010, 1214.1484, -913.4453, 43.0547, 0.25);
    RemoveBuildingForPlayer(playerid, 5742, 1197.3203, -899.2109, 45.0938, 0.25);
    RemoveBuildingForPlayer(playerid, 1533, 1369.3984, -1278.2813, 12.5391, 0.25);
    //
	RemoveBuildingForPlayer(playerid, 1260, 1371.4688, -1268.2188, 37.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 1617, 1398.8906, -1250.6016, 16.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 1617, 1398.8906, -1250.6016, 25.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 4588, 1405.8750, -1254.7891, 34.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 5156, 2838.0391, -2423.8828, 10.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 5159, 2838.0313, -2371.9531, 7.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5160, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5161, 2838.0234, -2358.4766, 21.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5162, 2838.0391, -2423.8828, 10.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 5163, 2838.0391, -2532.7734, 17.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 5164, 2838.1406, -2447.8438, 15.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 5165, 2838.0313, -2520.1875, 18.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 5166, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5167, 2838.0313, -2371.9531, 7.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5335, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5336, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5352, 2838.1953, -2488.6641, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5157, 2838.0391, -2532.7734, 17.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 5154, 2838.1406, -2447.8438, 15.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3724, 2838.1953, -2488.6641, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5155, 2838.0234, -2358.4766, 21.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 3724, 2838.1953, -2407.1406, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5158, 2837.7734, -2334.4766, 11.9922, 0.25);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

public IsAtGasStation(playerid)
{
    if(IsPlayerConnected(playerid))
	{
        if(IsPlayerInRangeOfPoint(playerid,15.0,1004.0070,-939.3102,42.1797) || IsPlayerInRangeOfPoint(playerid,15.0,1944.3260,-1772.9254,13.3906)) { return 1; }
        else if(IsPlayerInRangeOfPoint(playerid,15.0,-90.5515,-1169.4578,2.4079) || IsPlayerInRangeOfPoint(playerid,15.0,-1609.7958,-2718.2048,48.5391)) { return 1; }
        else if(IsPlayerInRangeOfPoint(playerid,15.0,-2029.4968,156.4366,28.9498) || IsPlayerInRangeOfPoint(playerid,15.0,-2408.7590,976.0934,45.4175)) { return 1; }
        else if(IsPlayerInRangeOfPoint(playerid,15.0,-2243.9629,-2560.6477,31.8841) || IsPlayerInRangeOfPoint(playerid,6.0,-1676.6323,414.0262,6.9484)) { return 1; }
        else if(IsPlayerInRangeOfPoint(playerid,15.0,2202.2349,2474.3494,10.5258) || IsPlayerInRangeOfPoint(playerid,15.0,614.9333,1689.7418,6.6968)) { return 1; }
        else if(IsPlayerInRangeOfPoint(playerid,15.0,-1328.8250,2677.2173,49.7665) || IsPlayerInRangeOfPoint(playerid,15.0,70.3882,1218.6783,18.5165)) { return 1; }
        else if(IsPlayerInRangeOfPoint(playerid,15.0,2113.7390,920.1079,10.5255) || IsPlayerInRangeOfPoint(playerid,15.0,-1327.7218,2678.8723,50.0625)) { return 1; }
        else if(IsPlayerInRangeOfPoint(playerid,15.0,2146.6143,2748.4758,10.3852)||IsPlayerInRangeOfPoint(playerid,15.0,2639.0022,1108.0353,10.3852)) { return 1; }
        else if(IsPlayerInRangeOfPoint(playerid,15.0,1598.2035,2198.6448,10.3856)) { return 1; }
    }
    return 0;
}

stock getKmh(playerid,bool:kmh)
{
    new Float:x,Float:y,Float:z,Float:rtn;
    if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z); else GetPlayerVelocity(playerid,x,y,z);
    rtn = floatsqroot((x*x)+(y*y)+(z*z));
    return kmh?floatround(rtn * 85 * 1.61):floatround(rtn * 50);
}

public FillGas(i, playerid,price)
{
    new str[50];
    if(floatround(Tank[i],floatround_ceil) < GAS_MAXFULL)
	{
        if(IsAtGasStation(playerid) && Motor[i] == false )
		{
            format(str, sizeof str, "<-> *** You don't have enough money.", PRICE);
            if(GetPlayerMoney(playerid) >= PRICE)
			{
                Tank[i] ++;
                SetTimerEx("FillGas", GAS_TIME * 1, 0, "iii", i, playerid,price + PRICE);
                GivePlayerMoney(playerid, -PRICE);
                GameTextForPlayer(playerid, "~w~~n~~n~~n~~n~~n~~n~~n~~n~Your vehicle is going refueled...",GAS_TIME,3);
            }
            else
			{
				SendClientMessage(playerid,COLOR_DARKRED, str);
			}
        }
    }
    else
	{
		format(str, sizeof str, "<+> *** Your vehicle has been fueled for %d$!",price);
		SendClientMessage(playerid, COLOR_RACE, str);
	}
    return 1;
}

forward loadCar(carid);
public loadCar(carid)
{
    new file[50];
	format(file,sizeof file, "%s/Vehicle%d.cfg",VehiclePath,carid);
    if(!dini_Exists(file))
	{
		return 0;
	}
    new model = dini_Int(file,"model");
    vehicles[carid][vehicleKm] = dini_Float(file,"km");
    vehicles[carid][vehicleColor1] = dini_Int(file,"color1");
    vehicles[carid][vehicleColor2] = dini_Int(file,"color2");
    Tank[carid] = dini_Float(file,"tank");
    if ( Tank[carid] > GAS_MAXFULL )
	{
		Tank[carid] = GAS_MAXFULL;
	}
    Tank[carid] -= 5.0;
    new Float:x = dini_Float(file,"float_x");
    new Float:y = dini_Float(file,"float_y");
    new Float:z = dini_Float(file,"float_z");
    new Float:r = dini_Float(file,"float_r");
    vehicles[carid][vehicleSpawnID] = CreateVehicle(model,x,y,z,r,vehicles[carid][vehicleColor1],vehicles[carid][vehicleColor2],0);
    GetVehiclePos(vehicles[carid][vehicleSpawnID],x,y,z);
    vehicles[carid][vLastX] = x; vehicles[carid][vLastY] = y; vehicles[carid][vLastZ] = z;
    return 1;
}

forward saveCar(carid);
public saveCar(carid)
{
    if(GetVehicleModel(carid) > 0)
	{
        new file[50]; format(file,sizeof file, "%s/Vehicle%d.cfg",VehiclePath,carid);
        if(!dini_Exists(file))
		{
			dini_Create(file);
		}
        dini_IntSet(file,"model", GetVehicleModel(carid));
        dini_IntSet(file,"color1", vehicles[carid][vehicleColor1]);
        dini_IntSet(file,"color2", vehicles[carid][vehicleColor2]);
        dini_FloatSet(file,"tank", Tank[carid]);
        dini_FloatSet(file,"km", vehicles[carid][vehicleKm]);
        new Float:x,Float:y,Float:z,Float:r;
        GetVehiclePos(carid, x,y,z);
        GetVehicleZAngle(carid,r);
        dini_FloatSet(file,"float_x",x);
        dini_FloatSet(file,"float_y",y);
        dini_FloatSet(file,"float_z",z);
        dini_FloatSet(file,"float_r",r);
        DestroyVehicle(carid);
    }
    return 1;
}

forward toggleMotor(playerid);
public toggleMotor(playerid)
{
    if(GetPlayerVehicleSeat(playerid) == 0)
	{
        new car = GetPlayerVehicleID(playerid);
        if(GetVehicleModel(car) == 509 || GetVehicleModel(car) == 481 || GetVehicleModel(car) == 510)
		{
			GameTextForPlayer(playerid, "",3000,3);
		}
        else if(Motor[car] == false)
		{
            GetVehicleParamsEx(car,engine,lights,alarm,doors,bonnet,boot,objective);
            if(Tank[car] >= 1)
			{
				Motor[car] = true;
				SetVehicleParamsEx(car,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
			}
            else
			{
				Motor[car] = false;
				SetVehicleParamsEx(car,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
				GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~The fuel is empty!",3000,3);
			}
        }
        else
		{
        	if(getKmh(playerid,true) > MOTOR_OFF_KMH)
			{
				return SendClientMessage(playerid, COLOR_DARKRED, "<-> *** Your vehicle is too fast to turn off the motor now.");
			}
            GetVehicleParamsEx(car,engine,lights,alarm,doors,bonnet,boot,objective);
            SetVehicleParamsEx(car,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
            Motor[car] = false;
        }
    }
    return 1;
}

public Tutorial(playerid)
{
	if(TutTime[playerid] >= 1) 
	{
		if(TutTime[playerid] == 2)
		{
			InterpolateCameraPos(playerid, 2857.860595, -2177.666503, 83.533813, 762.572448, -1096.484863, 130.022674, 120000);
			InterpolateCameraLookAt(playerid, 2854.316162, -2174.331054, 82.388153, 767.278991, -1098.133178, 129.660034, 120000);
			TextDrawShowForPlayer(playerid, Textdraw10);
			TextDrawShowForPlayer(playerid, Textdraw11[playerid]);
			format(TextDrawString, sizeof(TextDrawString), "Welcome to SA-MP's first Scarface-Server!~n~While the game is loading, we'll tell you some important~n~things about the server.~n~~n~~r~PLEASE READ CAREFULLY!~n~~n~~w~At the end of the tutorial, you will have to~n~answer some questions about the server.");
			TextDrawSetString(Textdraw11[playerid], TextDrawString);
		}
		else if(TutTime[playerid] == 20)
		{
			format(TextDrawString, sizeof(TextDrawString), "The server was made by ~g~DarkZero~w~.~n~His plan was to create a server, which includes~n~functions from the Game and Movie 'Scarface - The world is yours'~n~ in SA-MP!~n~~n~He worked on the server since autumn 2013.");
			TextDrawSetString(Textdraw11[playerid], TextDrawString);
		}
		else if(TutTime[playerid] == 40)
		{
			format(TextDrawString, sizeof(TextDrawString), "Do you see the city in the background?~n~That's the city, where you will live for next time.~n~After the tutorial, you will have to wait for the next ship,~n~that will bring you from Miami to Los Santos...");
			TextDrawSetString(Textdraw11[playerid], TextDrawString);
		}
		else if(TutTime[playerid] == 60)
		{
			format(TextDrawString, sizeof(TextDrawString), "...After that, there will be a person called 'Dave', who will~n~wait for you. ~n~He will show you some things in Los Santos, and~n~he will tell you important things~n~about jobs, crime, and much more.~n~~n~~r~WE RECOMMEND TO LISTEN CAREFULLY TO HIM!");
			TextDrawSetString(Textdraw11[playerid], TextDrawString);
		}
		else if(TutTime[playerid] == 80)
		{
			format(TextDrawString, sizeof(TextDrawString), "Every 5 InGame-Hours, a ship will come, with that you can drive.~n~~n~~r~NOTE: ~w~One InGame-Hour corresponds one minute in Reallife.~n~~n~On this ship, you will have to drive 1 InGame-Hour.");
			TextDrawSetString(Textdraw11[playerid], TextDrawString);
		}
		else if(TutTime[playerid] == 100)
		{
			format(TextDrawString, sizeof(TextDrawString), "When you are in Los Santos, you will need a phone!~n~Without a phone, you will not be able to play.~n~But Dave know that! He will bring you to a shop, where~n~you can get a phone~n~~n~Ok, the tutorial is over.~n~Now you will have to answer the following questions!");
			TextDrawSetString(Textdraw11[playerid], TextDrawString);

		}
		else if(TutTime[playerid] == 110)
		{
		    KillTimer(TutTimer[playerid]);
            TutTime[playerid] = -1;
			SpawnPlayer(playerid); //SetPlayerPos(playerid,0.0,0.0,0.0);
			TogglePlayerControllable(playerid,true);
			TextDrawHideForPlayer(playerid, Textdraw10);
			TextDrawHideForPlayer(playerid, Textdraw11[playerid]);
			//Hier muessen nachher die Fragen hin
		}
		TutTime[playerid]++;
	}
}
