new Float:TelePos[MAX_PLAYERS][3];
//Hoooks
enum psenum
{
 psmodel[10],
 psbone[10],
 Float:psx[10],
 Float:psy[10],
 Float:psz[10],
 Float:psrx[10],
 Float:psry[10],
 Float:psrz[10],
 Float:pssx[10],
 Float:pssy[10],
 Float:pssz[10]
}
new pSavedA[MAX_PLAYERS][psenum];

//Hook PutPlayerInVehicle

forward call_PutPlayerInVehicle(playerid, vehicleid,seatid);
public call_PutPlayerInVehicle(playerid, vehicleid,seatid)
{
    return PutPlayerInVehicle(playerid, vehicleid,seatid);
}
forward _ALT_PutPlayerInVehicle(playerid, vehicleid,seatid);public _ALT_PutPlayerInVehicle(playerid, vehicleid,seatid)
{
    SetSyncTime (playerid);
    return CallRemoteFunction("call_PutPlayerInVehicle", "iii", playerid,vehicleid,seatid);
}
#define PutPlayerInVehicle _ALT_PutPlayerInVehicle



//Hook SetPlayerAttachedObject
forward call_SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
public call_SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    return SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
}
forward _ALT_SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
public _ALT_SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	pSavedA[playerid][psmodel][index]=modelid;
	pSavedA[playerid][psbone][index]=bone;
	pSavedA[playerid][psx][index]=fOffsetX;
	pSavedA[playerid][psy][index]=fOffsetY;
	pSavedA[playerid][psz][index]=fOffsetZ;
	pSavedA[playerid][psrx][index]=fRotX;
	pSavedA[playerid][psry][index]=fRotY;
	pSavedA[playerid][psrz][index]=fRotZ;
	pSavedA[playerid][pssx][index]=fScaleX;
	pSavedA[playerid][pssy][index]=fScaleY;
	pSavedA[playerid][pssz][index]=fScaleZ;
    return CallRemoteFunction("call_SetPlayerAttachedObject", "iiiifffffffff", playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
}
#define SetPlayerAttachedObject _ALT_SetPlayerAttachedObject

//Hook SetPlayerPos

forward call_SetPlayerPos(playerid, Float: x, Float: y, Float: z);
public call_SetPlayerPos(playerid, Float: x, Float: y, Float: z)
{
    return SetPlayerPos(playerid, x,y,z);
}
forward _ALT_SetPlayerPos(playerid,  Float: x, Float: y, Float: z);public _ALT_SetPlayerPos(playerid, Float: x, Float: y, Float: z)
{
    TelePos[playerid][0]=x;
    TelePos[playerid][1]=y;
    TelePos[playerid][2]=z;
    SetSyncTime (playerid);
    return CallRemoteFunction("call_SetPlayerPos", "ifff", playerid,x,y,z);
}
#define SetPlayerPos _ALT_SetPlayerPos


//Hook SetPlayerPosFindZ
forward call_SetPlayerPosFindZ(playerid, Float: x, Float: y, Float: z);
public call_SetPlayerPosFindZ(playerid, Float: x, Float: y, Float: z)
{
    return SetPlayerPosFindZ(playerid, x,y,z);
}
forward _ALT_SetPlayerPosFindZ(playerid,  Float: x, Float: y, Float: z);public _ALT_SetPlayerPosFindZ(playerid, Float: x, Float: y, Float: z)
{
    TelePos[playerid][0]=x;
    TelePos[playerid][1]=y;
    TelePos[playerid][2]=z;
    SetSyncTime (playerid);
    return CallRemoteFunction("call_SetPlayerPosFindZ", "ifff", playerid,x,y,z);
}
#define SetPlayerPosFindZ _ALT_SetPlayerPosFindZ


//Hook SetVehiclePos
forward call_SetVehiclePos(vehicleid, Float: x, Float: y, Float: z);
public call_SetVehiclePos(vehicleid, Float: x, Float: y, Float: z)
{
	if (vehicleid != INVALID_VEHICLE_ID)
	{
		foreach(Player,i)
		{
		  if (GetPlayerVehicleID (i) == vehicleid)
		  {
			TelePos[i][0]=x;
			TelePos[i][1]=y;
			TelePos[i][2]=z;
			SetSyncTime (i);
		  }
		}
	}
    return SetVehiclePos(vehicleid, x,y,z);
}
forward _ALT_SetVehiclePos(vehicleid,  Float: x, Float: y, Float: z);public _ALT_SetVehiclePos(vehicleid, Float: x, Float: y, Float: z)
{
    SetSyncTime (vehicleid);
    return CallRemoteFunction("call_SetVehiclePos", "ifff", vehicleid,x,y,z);
}
#define SetVehiclePos _ALT_SetVehiclePos
//


new warned[MAX_PLAYERS];
enum
{
  INVALID_POINT = -1,
  BANK_1,
  BANK_2,
  BANK_3,
  BANK_4,
  BANK_5,
  BANK_6,
  BANK_7
}
static Float:Banks[][] =
{
  { -828.0267,1503.6108,19.7586 },
  { -185.9201,1039.6997,19.5938 },
  { 1481.0878,-1771.8583,18.7958 },
  { -1896.4723,486.9743,35.1719 },
  { 2165.4414,2009.1182,10.8203 },
  { -1555.4460,-2752.8757,48.5391 },
  { 1464.7112,-1010.6835,26.8438 }
};

GetClosestPoint(Float:x, Float:y, Float:z, &Float:d = 0.0)
{
  new
    c = INVALID_POINT,
    Float:x2,
    Float:y2,
    Float:z2,
    Float:d2 = 70000.0
  ;
  for (new p = 0; p < sizeof Banks; p ++)
  {
    x2 = x - Banks[p][0];
    x2 *= x2;
    y2 = y - Banks[p][1];
    y2 *= y2;
    z2 = z - Banks[p][2];
    z2 *= z2;
    d = floatsqroot(x2 + y2 + z2);
    if (d < d2)
    {
      d2 = d;
      c = p;
    }
  }
  d = d2;
  return c;
}

GetPlayerClosestBank(playerid)
{
  new
    Float:x,
    Float:y,
    Float:z
  ;
  GetPlayerPos(playerid, x, y, z);
  return GetClosestPoint(x, y, z);
}
//
new PlayerColors[] = {
0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,0xF4A460AA,
0xEE82EEAA,0xFFD720AA,0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,0x10DC29AA,
0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34DAAA,0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,0x65ADEBAA,
0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,0x275222AA,0xF09F5BAA,0x3D0A4FAA,
0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,0x057F94AA,
0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,0x18F71FAA,
0x4B8987AA,0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,0x12D6D4AA,
0x48C000AA,0x2A51E2AA,0xE3AC12AA,0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,0x2FD9DEAA,
0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,0x3214AAAA,
0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,0x9F945CAA,0xDCDE3DAA,
0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,0xD8C762AA,
0xD8C762AA,0xFF8C13AA,0xC715FFAA,0x20B2AAAA,0xDC143CAA,0x6495EDAA,0xf0e68cAA,0x778899AA,0xFF1493AA,
0xF4A460AA,0xEE82EEAA,0xFFD720AA,0x8b4513AA,0x4949A0AA,0x148b8bAA,0x14ff7fAA,0x556b2fAA,0x0FD9FAAA,
0x10DC29AA,0x534081AA,0x0495CDAA,0xEF6CE8AA,0xBD34DAAA,0x247C1BAA,0x0C8E5DAA,0x635B03AA,0xCB7ED3AA,
0x65ADEBAA,0x5C1ACCAA,0xF2F853AA,0x11F891AA,0x7B39AAAA,0x53EB10AA,0x54137DAA,0x275222AA,0xF09F5BAA,
0x3D0A4FAA,0x22F767AA,0xD63034AA,0x9A6980AA,0xDFB935AA,0x3793FAAA,0x90239DAA,0xE9AB2FAA,0xAF2FF3AA,
0x057F94AA,0xB98519AA,0x388EEAAA,0x028151AA,0xA55043AA,0x0DE018AA,0x93AB1CAA,0x95BAF0AA,0x369976AA,
0x18F71FAA,0x4B8987AA,0x491B9EAA,0x829DC7AA,0xBCE635AA,0xCEA6DFAA,0x20D4ADAA,0x2D74FDAA,0x3C1C0DAA,
0x12D6D4AA,0x48C000AA,0x2A51E2AA,0xE3AC12AA,0xFC42A8AA,0x2FC827AA,0x1A30BFAA,0xB740C2AA,0x42ACF5AA,
0x2FD9DEAA,0xFAFB71AA,0x05D1CDAA,0xC471BDAA,0x94436EAA,0xC1F7ECAA,0xCE79EEAA,0xBD1EF2AA,0x93B7E4AA,
0x3214AAAA,0x184D3BAA,0xAE4B99AA,0x7E49D7AA,0x4C436EAA,0xFA24CCAA,0xCE76BEAA,0xA04E0AAA,0x9F945CAA,
0xDCDE3DAA,0x10C9C5AA,0x70524DAA,0x0BE472AA,0x8A2CD7AA,0x6152C2AA,0xCF72A9AA,0xE59338AA,0xEEDC2DAA,
0xD8C762AA,0xD8C762AA,0xA2FF00AA,0xFFA600AA,0xFF00AEAA,0xBF00FFAA,0xFF0000AA,0x333333AA,0x0022FFAA,
0x115099AA
};
//
new PlayerColors2[] = {
0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,0xF4A460FF,
0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,
0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,0x65ADEBFF,
0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,0x3D0A4FFF,
0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,0x057F94FF,
0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,
0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,
0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,
0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,0x3214AAFF,
0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,0xDCDE3DFF,
0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,
0xD8C762FF,0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,
0xF4A460FF,0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,
0x10DC29FF,0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,
0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,
0x3D0A4FFF,0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,
0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,
0x18F71FFF,0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,
0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,
0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,
0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,
0xDCDE3DFF,0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,
0xD8C762FF,0xD8C762FF,0xA2FF00FF,0xFFA600FF,0xFF00AEFF,0xBF00FFFF,0xFF0000FF,0x333333FF,0x0022FFFF,
0x115099FF
};

new PlayerColors_[][10] = {
"FF8C13","C715FF","20B2AA","DC143C","6495ED","f0e68c","778899","FF1493","F4A460",
"EE82EE","FFD720","8b4513","4949A0","148b8b","14ff7f","556b2f","0FD9FA","10DC29",
"534081","0495CD","EF6CE8","BD34DA","247C1B","0C8E5D","635B03","CB7ED3","65ADEB",
"5C1ACC","F2F853","11F891","7B39AA","53EB10","54137D","275222","F09F5B","3D0A4F",
"22F767","D63034","9A6980","DFB935","3793FA","90239D","E9AB2F","AF2FF3","057F94",
"B98519","388EEA","028151","A55043","0DE018","93AB1C","95BAF0","369976","18F71F",
"4B8987","491B9E","829DC7","BCE635","CEA6DF","20D4AD","2D74FD","3C1C0D","12D6D4",
"48C000","2A51E2","E3AC12","FC42A8","2FC827","1A30BF","B740C2","42ACF5","2FD9DE",
"FAFB71","05D1CD","C471BD","94436E","C1F7EC","CE79EE","BD1EF2","93B7E4","3214AA",
"184D3B","AE4B99","7E49D7","4C436E","FA24CC","CE76BE","A04E0A","9F945C","DCDE3D",
"10C9C5","70524D","0BE472","8A2CD7","6152C2","CF72A9","E59338","EEDC2D","D8C762",
"D8C762","FF8C13","C715FF","20B2AA","DC143C","6495ED","f0e68c","778899","FF1493",
"F4A460","EE82EE","FFD720","8b4513","4949A0","148b8b","14ff7f","556b2f","0FD9FA",
"10DC29","534081","0495CD","EF6CE8","BD34DA","247C1B","0C8E5D","635B03","CB7ED3",
"65ADEB","5C1ACC","F2F853","11F891","7B39AA","53EB10","54137D","275222","F09F5B",
"3D0A4F","22F767","D63034","9A6980","DFB935","3793FA","90239D","E9AB2F","AF2FF3",
"057F94","B98519","388EEA","028151","A55043","0DE018","93AB1C","95BAF0","369976",
"18F71F","4B8987","491B9E","829DC7","BCE635","CEA6DF","20D4AD","2D74FD","3C1C0D",
"12D6D4","48C000","2A51E2","E3AC12","FC42A8","2FC827","1A30BF","B740C2","42ACF5",
"2FD9DE","FAFB71","05D1CD","C471BD","94436E","C1F7EC","CE79EE","BD1EF2","93B7E4",
"3214AA","184D3B","AE4B99","7E49D7","4C436E","FA24CC","CE76BE","A04E0A","9F945C",
"DCDE3D","10C9C5","70524D","0BE472","8A2CD7","6152C2","CF72A9","E59338","EEDC2D",
"D8C762","D8C762","A2FF00","FFA600","FF00AE","BF00FF","FF0000","333333","0022FF",
"115099"
};


//==============================================================================
//Vehicle Names

enum evInfo
{
	vName[32],
	vMaxSpeed
}

new vInfo [][evInfo] =
{
	{"Landstalker", 140},
	{"Bravura", 131},
	{"Buffalo", 166},
	{"Linerunner", 98},
	{"Pereniel", 118},
	{"Sentinel", 146},
	{"Dumper", 98},
	{"Firetruck", 132},
	{"Trashmaster", 89},
	{"Stretch", 140},
	{"Manana", 115},
	{"Infernus", 197},
	{"Voodoo", 150},
	{"Pony", 98},
	{"Mule", 94},
	{"Cheetah", 171},
	{"Ambulance", 137},
	{"Leviathan", 399},
	{"Moonbeam", 103},
	{"Esperanto", 133},
	{"Taxi", 129},
	{"Washington", 137},
	{"Bobcat", 124},
	{"Mr Whoopee", 88},
	{"BF Injection", 120},
	{"Hunter", 399},
	{"Premier", 154},
	{"Enforcer", 147},
	{"Securicar", 139},
	{"Banshee", 179},
	{"Predator", 399},
	{"Bus", 116},
	{"Rhino", 84},
	{"Barracks", 98},
	{"Hotknife", 148},
	{"Trailer", 0},
	{"Previon", 133},
	{"Coach", 140},
	{"Cabbie", 127},
	{"Stallion", 150},
	{"Rumpo", 121},
	{"RC Bandit", 67},
	{"Romero", 124},
	{"Packer", 112},
	{"Monster Truck A", 98},
	{"Admiral", 146},
	{"Squalo", 399},
	{"Seasparrow", 399},
	{"Pizzaboy", 162},
	{"Tram", 399},
	{"Trailer", 399},
	{"Turismo", 172},
	{"Speeder", 399},
	{"Reefer", 399},
	{"Tropic", 399},
	{"Flatbed", 140},
	{"Yankee", 94},
	{"Caddy", 84},
	{"Solair", 140},
	{"Berkley's RC Van", 121},
	{"Skimmer", 399},
	{"PCJ-600", 180},
	{"Faggio", 155},
	{"Freeway", 180},
	{"RC Baron", 399},
	{"RC Raider", 399},
	{"Glendale", 131},
	{"Oceanic", 125},
	{"Sanchez", 164},
	{"Sparrow", 399},
	{"Patriot", 139},
	{"Quad", 98},
	{"Coastguard", 399},
	{"Dinghy", 399},
	{"Hermes", 133},
	{"Sabre", 154},
	{"Rustler", 399},
	{"ZR-350", 166},
	{"Walton", 105},
	{"Regina", 124},
	{"Comet", 164},
	{"BMX", 86},
	{"Burrito", 139},
	{"Camper", 109},
	{"Marquis", 399},
	{"Baggage", 88},
	{"Dozer", 56},
	{"Maverick", 399},
	{"News Chopper", 399},
	{"Rancher", 124},
	{"FBI Rancher", 139},
	{"Virgo", 132},
	{"Greenwood", 125},
	{"Jetmax", 399},
	{"Hotring", 191},
	{"Sandking", 157},
	{"Blista Compact", 145},
	{"Police Maverick", 399},
	{"Boxville", 96},
	{"Benson", 109},
	{"Mesa", 125},
	{"RC Goblin", 399},
	{"Hotring Racer", 191},
	{"Hotring Racer", 191},
	{"Bloodring Banger", 154},
	{"Rancher", 124},
	{"Super GT", 159},
	{"Elegant", 148},
	{"Journey", 96},
	{"Bike", 93},
	{"Mountain Bike", 117},
	{"Beagle", 399},
	{"Cropdust", 399},
	{"Stunt", 399},
	{"Tanker", 107},
	{"RoadTrain", 126},
	{"Nebula", 140},
	{"Majestic", 140},
	{"Buccaneer", 146},
	{"Shamal", 399},
	{"Hydra", 399},
	{"FCR-900", 190},
	{"NRG-500", 200},
	{"HPV1000", 172},
	{"Cement Truck", 116},
	{"Tow Truck", 143},
	{"Fortune", 140},
	{"Cadrona", 133},
	{"FBI Truck", 157},
	{"Willard", 133},
	{"Forklift", 54},
	{"Tractor", 62},
	{"Combine", 98},
	{"Feltzer", 148},
	{"Remington", 150},
	{"Slamvan", 140},
	{"Blade", 154},
	{"Freight", 399},
	{"Streak", 399},
	{"Vortex", 89},
	{"Vincent", 136},
	{"Bullet", 180},
	{"Clover", 146},
	{"Sadler", 134},
	{"Firetruck", 132},
	{"Hustler", 131},
	{"Intruder", 133},
	{"Primo", 127},
	{"Cargobob", 399},
	{"Tampa", 136},
	{"Sunrise", 128},
	{"Merit", 140},
	{"Utility", 108},
	{"Nevada", 399},
	{"Yosemite", 128},
	{"Windsor", 141},
	{"Monster Truck B", 98},
	{"Monster Truck C", 98},
	{"Uranus", 139},
	{"Jester", 158},
	{"Sultan", 150},
	{"Stratum", 137},
	{"Elegy", 158},
	{"Raindance", 399},
	{"RC Tiger", 79},
	{"Flash", 146},
	{"Tahoma", 142},
	{"Savanna", 154},
	{"Bandito", 130},
	{"Freight", 399},
	{"Trailer", 399},
	{"Kart", 83},
	{"Mower", 54},
	{"Duneride", 98},
	{"Sweeper", 53},
	{"Broadway", 140},
	{"Tornado", 140},
	{"AT-400", 399},
	{"DFT-30", 116},
	{"Huntley", 140},
	{"Stafford", 136},
	{"BF-400", 170},
	{"Newsvan", 121},
	{"Tug", 76},
	{"Trailer", 399},
	{"Emperor", 136},
	{"Wayfarer", 175},
	{"Euros", 147},
	{"Hotdog", 96},
	{"Club", 145},
	{"Trailer", 399},
	{"Trailer", 399},
	{"Andromada", 399},
	{"Dodo", 399},
	{"RC Cam", 54},
	{"Launch", 399},
	{"Police Car (LSPD)", 156},
	{"Police Car (SFPD)", 156},
	{"Police Car (LVPD)", 156},
	{"Police Ranger", 140},
	{"Picador", 134},
	{"S.W.A.T. Van", 98},
	{"Alpha", 150},
	{"Phoenix", 152},
	{"Glendale", 131},
	{"Sadler", 134},
	{"Luggage Trailer", 399},
	{"Luggage Trailer", 399},
	{"Stair Trailer", 399},
	{"Boxville", 96},
	{"Farm Plow", 399},
	{"Utility Trailer", 399}
};

//Vehicle Mods Saving

new tuned;
new spoiler[20][0] = {
	{1000},{1001},{1002},{1003},{1014},{1015},{1016},{1023},{1058},{1060},{1049},
	{1050},{1138},{1139},{1146},{1147},{1158},{1162},{1163},{1164}
};

new nitro[3][0] = {
   {1008},{1009},{1010}
};

new fbumper[23][0] = {
    {1117},{1152},{1153},{1155},{1157},{1160},{1165},{1167},{1169},{1170},{1171},
    {1172},{1173},{1174},{1175},{1179},{1181},{1182},{1185},{1188},{1189},{1192},
    {1193}
};

new rbumper[22][0] = {
    {1140},{1141},{1148},{1149},{1150},{1151},{1154},{1156},{1159},{1161},{1166},
    {1168},{1176},{1177},{1178},{1180},{1183},{1184},{1186},{1187},{1190},{1191}
};

new exhaust[28][0] = {
    {1018},{1019},{1020},{1021},{1022},{1028},{1029},{1037},{1043},{1044},{1045},
    {1046},{1059},{1064},{1065},{1066},{1089},{1092},{1104},{1105},{1113},{1114},
	{1126},{1127},{1129},{1132},{1135},{1136}
};

new bventr[2][0] = {
    {1142},{1144}
};

new bventl[2][0] = {
    {1143},{1145}
};

new bscoop[4][0] = {
	{1004},{1005},{1011},{1012}
};

new rscoop[17][0] = {
    {1006},{1032},{1033},{1035},{1038},{1053},{1054},{1055},{1061},{1067},{1068},
    {1088},{1091},{1103},{1128},{1130},{1131}
};

new lskirt[21][0] = {
    {1007},{1026},{1031},{1036},{1039},{1042},{1047},{1048},{1056},{1057},{1069},
    {1070},{1090},{1093},{1106},{1108},{1118},{1119},{1133},{1122},{1134}
};

new rskirt[21][0] = {
    {1017},{1027},{1030},{1040},{1041},{1051},{1052},{1062},{1063},{1071},{1072},
	{1094},{1095},{1099},{1101},{1102},{1107},{1120},{1121},{1124},{1137}
};

new hydraulics[1][0] = {
    {1087}
};

new rbase[1][0] = {
    {1086}
};

new rbbars[4][0] = {
    {1109},{1110},{1123},{1125}
};

new fbbars[2][0] = {
    {1115},{1116}
};

new wheels[17][0] = {
    {1025},{1073},{1074},{1075},{1076},{1077},{1078},{1079},{1080},{1081},{1082},
    {1083},{1084},{1085},{1096},{1097},{1098}
};

new lights[2][0] = {
	{1013},{1024}
};



stock SetPlayerFacingObject(playerid,Float:x,Float:y)
{
	new Float:px,Float:py,Float:pz;
  	GetPlayerPos(playerid,px,py,pz);
  	SetPlayerFacingAngle(playerid,(atan2((y - py), (x - px)) + 270.0));
}

stock Float: GetXYInFrontOfPlayer(playerid, &Float:q, &Float:w, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, q, w, a);
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    else GetPlayerFacingAngle(playerid, a);
    q += (distance * floatsin(-a, degrees));
    w += (distance * floatcos(-a, degrees));
    return a;
}

stock GetXYInLeftOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);

	if(GetPlayerVehicleID(playerid)) { GetVehicleZAngle(GetPlayerVehicleID(playerid), a); } else { GetPlayerFacingAngle(playerid, a); }

	x += (distance * floatsin(-a +270, degrees));
	y += (distance * floatcos(-a +270, degrees));
}

stock GetXYInLeftOfPoint(Float:inx,Float:iny,Float:ina, &Float:x, &Float:y, Float:distance)
{
	x=inx,y=iny;
	x += (distance * floatsin(-ina +270, degrees));
	y += (distance * floatcos(-ina +270, degrees));
}

stock GetXYBehindPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;

    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    x -= (distance * floatsin(-a, degrees));
    y -= (distance * floatcos(-a, degrees));
}


stock TextDrawSetStringEX(Text:text, string[])
{
  if(_:text != INVALID_TEXT_DRAW)
  {
     if (string[0] == '\0' || string[0] == '\1' && string[1] == '\0')
     {
            TextDrawSetString(text, " ");
     }
     else
     {
            TextDrawSetString(text, string);
     }
  }
  return 1;
}
stock PlayerTextDrawSetStringEX(playerid,PlayerText:text, string[])
{
  if(_:text != INVALID_TEXT_DRAW)
  {
     if (string[0] == '\0' || string[0] == '\1' && string[1] == '\0')
     {
            PlayerTextDrawSetString(playerid,text, " ");
     }
     else
     {
            PlayerTextDrawSetString(playerid,text, string);
     }
  }
  return 1;
}


stock IsPlayerInRangeOfPlayer(playerid, id, Float:range)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	if(IsPlayerInRangeOfPoint(playerid,range,x,y,z)) return 1;
	return 0;                     /*                */
}



stock IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
                new Float:X, Float:Y, Float:Z;
                GetPlayerPos(playerid, X, Y, Z);
                if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) {
                        return 1;
                }
                return 0;
}
stock stringContainsIP(const str[])
{
    new iDots,i,szStr[180];
    format(szStr,sizeof(szStr),"%s",str);
    while(szStr[i] != EOS)
    {
        if('0' <= szStr[i] <= '9')
        {
            do
            {
                if(szStr[i] == '.')
                    iDots++;

                i++;
            }
            while(('0' <= szStr[i] <= '9') || szStr[i] == '.' || szStr[i] == ':');
        }
        if(iDots > 2)
            return 1;
        else
            iDots = 0;

        i++;
    }
    return 0;
}
stock str_replace( const search[], const replacement[],string[], bool:ignorecase = true, pos = 0, limit = -1, maxlength = sizeof(string)) {
    // No need to do anything if the limit is 0.
    if (limit == 0)
        return 0;

    new
             sublen = strlen(search),
             replen = strlen(replacement),
        bool:packed = ispacked(string),
             maxlen = maxlength,
             len = strlen(string),
             count = 0
    ;


    // "maxlen" holds the max string length (not to be confused with "maxlength", which holds the max. array size).
    // Since packed strings hold 4 characters per array slot, we multiply "maxlen" by 4.
    if (packed)
        maxlen *= 4;

    // If the length of the substring is 0, we have nothing to look for..
    if (!sublen)
        return 0;

    // In this line we both assign the return value from "strfind" to "pos" then check if it's -1.
    while (-1 != (pos = strfind(string, search, ignorecase, pos))) {
        // Delete the string we found
        strdel(string, pos, pos + sublen);

        len -= sublen;

        // If there's anything to put as replacement, insert it. Make sure there's enough room first.
        if (replen && len + replen < maxlen) {
            strins(string, replacement, pos, maxlength);

            pos += replen;
            len += replen;
        }

        // Is there a limit of number of replacements, if so, did we break it?
        if (limit != -1 && ++count >= limit)
            break;
    }

    return count;
}
new legalmods[48][22] = {
    {400, 1024,1021,1020,1019,1018,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {401, 1145,1144,1143,1142,1020,1019,1017,1013,1007,1006,1005,1004,1003,1001,0000,0000,0000,0000},
    {404, 1021,1020,1019,1017,1016,1013,1007,1002,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {405, 1023,1021,1020,1019,1018,1014,1001,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {410, 1024,1023,1021,1020,1019,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {415, 1023,1019,1018,1017,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {418, 1021,1020,1016,1006,1002,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {420, 1021,1019,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {421, 1023,1021,1020,1019,1018,1016,1014,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {422, 1021,1020,1019,1017,1013,1007,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {426, 1021,1019,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {436, 1022,1021,1020,1019,1017,1013,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {439, 1145,1144,1143,1142,1023,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {477, 1021,1020,1019,1018,1017,1007,1006,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {478, 1024,1022,1021,1020,1013,1012,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {489, 1024,1020,1019,1018,1016,1013,1006,1005,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
    {491, 1145,1144,1143,1142,1023,1021,1020,1019,1018,1017,1014,1007,1003,0000,0000,0000,0000,0000},
    {492, 1016,1006,1005,1004,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {496, 1143,1142,1023,1020,1019,1017,1011,1007,1006,1003,1002,1001,0000,0000,0000,0000,0000,0000},
    {500, 1024,1021,1020,1019,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {516, 1021,1020,1019,1018,1017,1016,1015,1007,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
    {517, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1016,1007,1003,1002,0000,0000,0000,0000,0000},
    {518, 1145,1144,1143,1142,1023,1020,1018,1017,1013,1007,1006,1005,1003,1001,0000,0000,0000,0000},
    {527, 1021,1020,1018,1017,1015,1014,1007,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {529, 1023,1020,1019,1018,1017,1012,1011,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000},
    {534, 1185,1180,1179,1178,1127,1126,1125,1124,1123,1122,1106,1101,1100,0000,0000,0000,0000,0000},
    {535, 1121,1120,1119,1118,1117,1116,1115,1114,1113,1110,1109,0000,0000,0000,0000,0000,0000,0000},
    {536, 1184,1183,1182,1181,1128,1108,1107,1105,1104,1103,0000,0000,0000,0000,0000,0000,0000,0000},
    {540, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1004,1001,0000,0000,0000,0000},
    {542, 1145,1144,1021,1020,1019,1018,1015,1014,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {546, 1145,1144,1143,1142,1024,1023,1019,1018,1017,1007,1006,1004,1002,1001,0000,0000,0000,0000},
    {547, 1143,1142,1021,1020,1019,1018,1016,1003,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {549, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1012,1011,1007,1003,1001,0000,0000,0000,0000},
    {550, 1145,1144,1143,1142,1023,1020,1019,1018,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000},
    {551, 1023,1021,1020,1019,1018,1016,1006,1005,1003,1002,0000,0000,0000,0000,0000,0000,0000,0000},
    {558, 1168,1167,1166,1165,1164,1163,1095,1094,1093,1092,1091,1090,1089,1088,0000,0000,0000,0000},
    {559, 1173,1162,1161,1160,1159,1158,1072,1071,1070,1069,1068,1067,1066,1065,0000,0000,0000,0000},
    {560, 1170,1169,1141,1140,1139,1138,1033,1032,1031,1030,1029,1028,1027,1026,0000,0000,0000,0000},
    {561, 1157,1156,1155,1154,1064,1063,1062,1061,1060,1059,1058,1057,1056,1055,1031,1030,1027,1026},
    {562, 1172,1171,1149,1148,1147,1146,1041,1040,1039,1038,1037,1036,1035,1034,0000,0000,0000,0000},
    {565, 1153,1152,1151,1150,1054,1053,1052,1051,1050,1049,1048,1047,1046,1045,0000,0000,0000,0000},
    {567, 1189,1188,1187,1186,1133,1132,1131,1130,1129,1102,0000,0000,0000,0000,0000,0000,0000,0000},
    {575, 1177,1176,1175,1174,1099,1044,1043,1042,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {576, 1193,1192,1191,1190,1137,1136,1135,1134,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {580, 1023,1020,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {589, 1145,1144,1024,1020,1018,1017,1016,1013,1007,1006,1005,1004,1000,0000,0000,0000,0000,0000},
    {600, 1022,1020,1018,1017,1013,1007,1006,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {603, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000}
};


iswheelmodel(modelid)
{
	new wheelmodels[17] = {1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1096,1097,1098};
	for(new wm; wm < sizeof(wheelmodels); wm++)
	{
	    if (modelid == wheelmodels[wm]) return true;
	}
	return false;
}

IllegalCarNitroIde(carmodel) {
new illegalvehs[29] = { 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449 };
for(new iv; iv < sizeof(illegalvehs); iv++) {
    if (carmodel == illegalvehs[iv])
        return true;
}
return false;
}

stock islegalcarmod(vehicleide, componentid) {
new modok = false;
if ( (iswheelmodel(componentid)) || (componentid == 1086) || (componentid == 1087) || ((componentid >= 1008) && (componentid <= 1010))) {
    new nosblocker = IllegalCarNitroIde(vehicleide);
    if (!nosblocker)
        modok = true;
} else {
    for(new lm; lm < sizeof(legalmods); lm++) {
        if (legalmods[lm][0] == vehicleide) {
            for(new J = 1; J < 22; J++) {
                if (legalmods[lm][J] == componentid)
                    modok = true;
            }
        }
    }
}
return modok;
}

stock Float:GetVehicleSpeed(vehicleid,UseMPH = 0)
{
	new Float:speed_x,Float:speed_y,Float:speed_z,Float:temp_speed;
	GetVehicleVelocity(vehicleid,speed_x,speed_y,speed_z);
	if(UseMPH == 0)
	{
//	    temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z))*136.666667;
	    temp_speed = floatsqroot((speed_x*speed_x)+(speed_y*speed_y))*136.666667;
	}
	else
	{
//	    temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z))*85.4166672;
	    temp_speed = floatsqroot((speed_x*speed_x)+(speed_y*speed_y))*85.4166672;
	}
	floatround(temp_speed,floatround_round);
	return temp_speed;
}

stock isNumeric(const string[])
{
  new length=strlen(string);
  if (length==0) return false;
  for (new i = 0; i < length; i++)
    {
      if (
            (string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
             || (string[i]=='-' && i!=0)                                             // A '-' but not at first.
             || (string[i]=='+' && i!=0)                                             // A '+' but not at first.
         ) return false;
    }
  if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
  return true;
}


stock GetVehicleMaxSpeed (vehicleid)
{
	new modelid = GetVehicleModel (vehicleid) - 400;

	if (modelid >= 0 && modelid < sizeof (vInfo))
	    return vInfo[modelid][vMaxSpeed];
	return 9999;
}


