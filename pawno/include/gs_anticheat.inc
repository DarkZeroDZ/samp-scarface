/* German Society AntiCheat */

//Funktionen
/*
	Anti GeldCheat
*/

new gGameModeLoaded=false;
new CheatString[128],CheatVehicleID;

new Iterator:Vehicles<MAX_VEHICLES>;

GS_SetPVarInt(playerid, varname[], integer_value)
{
	if(GetPVarInt(playerid,"AdminDebug")>0&&(GetPVarInt(playerid,"AdminDebugTimer")<1||GetPVarInt(playerid,"AdminDebugAllowTimer")==1)&&(GetPVarInt(playerid,"AdminDebugStreamer")<1||GetPVarInt(playerid,"AdminDebugCheckStreamer")==1)&&strfind(varname,"AdminDebug",false)==-1) DebugPlayerForAdmin(playerid,"[pVar:integer WRITE]","sd",varname,integer_value);
	if(strlen(varname)>6&&!strcmp(varname,"Spieler",false,7))
	{
		format(PVarString,sizeof(PVarString),"%s_Cached",varname);
		if(GetPVarInt(playerid,PVarString)!=1) CachePlayerData(playerid,varname,0);
		strdel(varname,0,7);
		format(PVarString,sizeof(PVarString),"UPDATE samp_players SET %s = '%i' WHERE SpielerName = '%s';",varname,integer_value,GetName(playerid));
		mysql_query(PVarString,PVAR_THREAD_SAFE,0,gPVarSQL); strins(varname,"Spieler",0,64);
	}
	if(GetInventarIDByName(varname)!=-1)
	{
		new menge = (GetPVarInt(playerid,varname)-integer_value);
		if(menge>=0) SetPVarFloat(playerid,"SpielerInventarGewicht",GetPVarFloat(playerid,"SpielerInventarGewicht")+InventarInfo[GetInventarIDByName(varname)][invGewicht]*menge);
		else SetPVarFloat(playerid,"SpielerInventarGewicht",GetPVarFloat(playerid,"SpielerInventarGewicht")-InventarInfo[GetInventarIDByName(varname)][invGewicht]*menge);
		if(menge>=0) SetPVarInt(playerid,"SpielerInventarMenge",GetPVarInt(playerid,"SpielerInventarMenge")+menge);
		else SetPVarInt(playerid,"SpielerInventarMenge",GetPVarInt(playerid,"SpielerInventarMenge")-menge);	
	}
	SetPVarInt(playerid, varname, integer_value);
	return true;
}
GS_SetPVarFloat(playerid, varname[], Float:float_value)
{
	if(GetPVarInt(playerid,"AdminDebug")>0&&(GetPVarInt(playerid,"AdminDebugTimer")<1||GetPVarInt(playerid,"AdminDebugAllowTimer")==1)&&(GetPVarInt(playerid,"AdminDebugStreamer")<1||GetPVarInt(playerid,"AdminDebugCheckStreamer")==1)&&strfind(varname,"AdminDebug",false)==-1) DebugPlayerForAdmin(playerid,"[pVar:float WRITE]","sf",varname,float_value);
	if(strlen(varname)>6&&!strcmp(varname,"Spieler",false,7))
	{
		format(PVarString,sizeof(PVarString),"%s_Cached",varname);
		if(GetPVarInt(playerid,PVarString)!=1) CachePlayerData(playerid,varname,1);
		strdel(varname,0,7);
		format(PVarString,sizeof(PVarString),"UPDATE samp_players SET %s = '%f' WHERE SpielerName = '%s';",varname,float_value,GetName(playerid));
		mysql_query(PVarString,PVAR_THREAD_SAFE,0,gPVarSQL); strins(varname,"Spieler",0,64);
	}
	if(GetInventarIDByName(varname)!=-1)
	{
		new Float:menge = (GetPVarFloat(playerid,varname)-float_value);
		if(menge>=0) SetPVarFloat(playerid,"SpielerInventarGewicht",GetPVarFloat(playerid,"SpielerInventarGewicht")+InventarInfo[GetInventarIDByName(varname)][invGewicht]*menge);
		else SetPVarFloat(playerid,"SpielerInventarGewicht",GetPVarFloat(playerid,"SpielerInventarGewicht")-InventarInfo[GetInventarIDByName(varname)][invGewicht]*menge);
		if(menge>=0) SetPVarInt(playerid,"SpielerInventarMenge",GetPVarInt(playerid,"SpielerInventarMenge")+floatround(menge));
		else SetPVarInt(playerid,"SpielerInventarMenge",GetPVarInt(playerid,"SpielerInventarMenge")-floatround(menge));	
	}
	SetPVarFloat(playerid, varname, float_value);
	return true;
}
GS_SetPVarString(playerid, varname[], string_value[])
{
	if(GetPVarInt(playerid,"AdminDebug")>0&&(GetPVarInt(playerid,"AdminDebugTimer")<1||GetPVarInt(playerid,"AdminDebugAllowTimer")==1)&&(GetPVarInt(playerid,"AdminDebugStreamer")<1||GetPVarInt(playerid,"AdminDebugCheckStreamer")==1)&&strfind(varname,"AdminDebug",false)==-1) DebugPlayerForAdmin(playerid,"[pVar:string WRITE]","ss",varname,string_value);
	if(strlen(varname)>6&&!strcmp(varname,"Spieler",false,7))
	{
		format(PVarString,sizeof(PVarString),"%s_Cached",varname);
		if(GetPVarInt(playerid,PVarString)!=1) CachePlayerData(playerid,varname,2);
		strdel(varname,0,7);
		format(PVarString,sizeof(PVarString),"UPDATE samp_players SET %s = '%s' WHERE SpielerName = '%s';",varname,string_value,GetName(playerid));
		mysql_query(PVarString,PVAR_THREAD_SAFE,0,gPVarSQL); strins(varname,"Spieler",0,64);
	}
	SetPVarString(playerid, varname, string_value);
	return true;
}
GS_GetPVarInt(playerid, varname[])
{
	if(GetPVarInt(playerid,"AdminDebug")>0&&(GetPVarInt(playerid,"AdminDebugTimer")<1||GetPVarInt(playerid,"AdminDebugAllowTimer")==1)&&(GetPVarInt(playerid,"AdminDebugStreamer")<1||GetPVarInt(playerid,"AdminDebugCheckStreamer")==1)&&strfind(varname,"AdminDebug",false)==-1) DebugPlayerForAdmin(playerid,"[pVar:integer READ]","s",varname);
	if(strlen(varname)>6&&!strcmp(varname,"Spieler",false,7))
	{
		format(PVarString,sizeof(PVarString),"%s_Cached",varname);
		if(GetPVarInt(playerid,PVarString)!=1) CachePlayerData(playerid,varname,0);
	}
	return GetPVarInt(playerid,varname);
}
Float:GS_GetPVarFloat(playerid, varname[])
{
	if(GetPVarInt(playerid,"AdminDebug")>0&&(GetPVarInt(playerid,"AdminDebugTimer")<1||GetPVarInt(playerid,"AdminDebugAllowTimer")==1)&&(GetPVarInt(playerid,"AdminDebugStreamer")<1||GetPVarInt(playerid,"AdminDebugCheckStreamer")==1)&&strfind(varname,"AdminDebug",false)==-1) DebugPlayerForAdmin(playerid,"[pVar:float READ]","s",varname);
	if(strlen(varname)>6&&!strcmp(varname,"Spieler",false,7))
	{
		format(PVarString,sizeof(PVarString),"%s_Cached",varname);
		if(GetPVarInt(playerid,PVarString)!=1) CachePlayerData(playerid,varname,1);
	}
	return GetPVarFloat(playerid,varname);
}
GS_GetPVarString(playerid, varname[], string_return[], len)
{
	if(GetPVarInt(playerid,"AdminDebug")>0&&(GetPVarInt(playerid,"AdminDebugTimer")<1||GetPVarInt(playerid,"AdminDebugAllowTimer")==1)&&(GetPVarInt(playerid,"AdminDebugStreamer")<1||GetPVarInt(playerid,"AdminDebugCheckStreamer")==1)&&strfind(varname,"AdminDebug",false)==-1) DebugPlayerForAdmin(playerid,"[pVar:string READ]","ssd",varname,string_return,len);
	if(strlen(varname)>6&&!strcmp(varname,"Spieler",false,7))
	{
		format(PVarString,sizeof(PVarString),"%s_Cached",varname);
		if(GetPVarInt(playerid,PVarString)!=1) CachePlayerData(playerid,varname);
	}
	GetPVarString(playerid, varname, string_return, len);
	return true;
}
CachePlayerData(playerid,field[],type=2)
{
	format(PVarString,sizeof(PVarString),"%s_Cached",field); SetPVarInt(playerid,PVarString,1); strdel(field,0,7);
	format(PVarString,sizeof(PVarString),"SELECT %s FROM samp_players WHERE SpielerName = '%s' LIMIT 1;",field,GetName(playerid));
	mysql_query(PVarString,-1,0,gPVarSQL); strins(field,"Spieler",0,64);
	mysql_store_result(gPVarSQL);
	mysql_fetch_string(PVarString,gPVarSQL);
	mysql_free_result(gPVarSQL);
	switch(type)
	{
		case 0: SetPVarInt(playerid,field,strval(PVarString));
		case 1: SetPVarFloat(playerid,field,floatstr(PVarString));
		case 2: SetPVarString(playerid,field,PVarString);
	}
	return PVarString;
}
CacheVehicleData(vehiclekey,field[],type=2)
{
	format(VVarString,sizeof(VVarString),"SELECT %s FROM samp_vehicles WHERE VehicleKey = '%d' LIMIT 1;",field,vehiclekey); mysql_query(VVarString,-1,0,gVVarSQL);
	format(VVarString,sizeof(VVarString),"%s_Cached",field); SetGVarInt(VVarString,1,vehiclekey+1);
	mysql_store_result(gVVarSQL);
	mysql_fetch_string(VVarString,gVVarSQL);
	mysql_free_result(gVVarSQL);
	switch(type)
	{
		case 0: SetGVarInt(field,strval(VVarString),vehiclekey+1);
		case 1: SetGVarFloat(field,floatstr(VVarString),vehiclekey+1);
		case 2: SetGVarString(field,VVarString,vehiclekey+1);
	}
	return VVarString;
}
GetVVarInt(vehiclekey,field[])
{
	if(vehiclekey==-1) return false;
	new value;
	format(VVarString,sizeof(VVarString),"%s_Cached",field);
	if(GetGVarInt(VVarString,vehiclekey+1)==1) value=GetGVarInt(field,vehiclekey+1);
	else value=strval(CacheVehicleData(vehiclekey,field,0));
	return value;
}
Float:GetVVarFloat(vehiclekey,field[])
{
	if(vehiclekey==-1) return 0.0;
	new Float:value;
	format(VVarString,sizeof(VVarString),"%s_Cached",field);
	if(GetGVarInt(VVarString,vehiclekey+1)==1) value=GetGVarFloat(field,vehiclekey+1);
	else value=floatstr(CacheVehicleData(vehiclekey,field,1));
	return value;
}
GetVVarString(vehiclekey,field[])
{
	format(VVarString,sizeof(VVarString),"%s_Cached",field);
	if(GetGVarInt(VVarString,vehiclekey+1)==1) GetGVarString(field,VVarString,sizeof(VVarString),vehiclekey+1);
	else format(VVarString,sizeof(VVarString),CacheVehicleData(vehiclekey,field));
	return VVarString;
}
SetVVarInt(vehiclekey,field[],buffer) {format(VVarString,sizeof(VVarString),"%i",buffer); SetVVarString(vehiclekey,field,VVarString,1);}
SetVVarFloat(vehiclekey,field[],Float:buffer) {format(VVarString,sizeof(VVarString),"%f",buffer); SetVVarString(vehiclekey,field,VVarString,2);}
SetVVarString(vehiclekey,field[],xbuffer[],type=0)
{
	new buffer[128]; format(buffer,sizeof(buffer),xbuffer);
	format(VVarString,sizeof(VVarString),"%s_Cached",field);
	if(GetGVarInt(VVarString,vehiclekey+1)!=1) CacheVehicleData(vehiclekey,field,type);
	if(type==0) {format(VVarString,sizeof(VVarString),"UPDATE samp_vehicles SET %s = '%s' WHERE VehicleKey = '%d';",field,buffer,vehiclekey); SetGVarString(field,buffer,vehiclekey+1);}
	else if(type==1) {format(VVarString,sizeof(VVarString),"UPDATE samp_vehicles SET %s = '%i' WHERE VehicleKey = '%d';",field,strval(buffer),vehiclekey); SetGVarInt(field,strval(buffer),vehiclekey+1);}
	else if(type==2) {format(VVarString,sizeof(VVarString),"UPDATE samp_vehicles SET %s = '%f' WHERE VehicleKey = '%d';",field,floatstr(buffer),vehiclekey); SetGVarFloat(field,floatstr(buffer),vehiclekey+1);}
	mysql_query(VVarString,VVAR_THREAD_SAFE,INVALID_PLAYER_ID,gVVarSQL); mysql_free_result(gVVarSQL);
	return true;
}
GS_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay=60, type=0)
{
	if(type==0) CheatVehicleID = CreateVehicle(modelid,x,y,z,angle,color1,color2,respawn_delay);
	else if(type==1) CheatVehicleID = AddStaticVehicle(modelid,x,y,z,angle,color1,color2);
	else if(type==2) CheatVehicleID = AddStaticVehicleEx(modelid,x,y,z,angle,color1,color2,respawn_delay);
	else if(type==4)
	{
		CheatVehicleID = CreateVehicle(modelid,x,y,z,angle,color1,color2,respawn_delay);
		gVehicleIndex[CheatVehicleID]=-3;
		return CheatVehicleID;
	}
	else if(type==3)
	{
		CheatVehicleID = CreateVehicle(modelid,x,y,z,angle,color1,color2,respawn_delay);
		gVehicleIndex[CheatVehicleID]=-2;
		return CheatVehicleID;
	}
	else return false;
	if(gGameModeLoaded)
	{
		CreateVehiceInformation(CheatVehicleID);
		SetVVarFloat(gVehicleIndex[CheatVehicleID],"VehiclePosX",x); SetVVarFloat(gVehicleIndex[CheatVehicleID],"VehiclePosY",y); SetVVarFloat(gVehicleIndex[CheatVehicleID],"VehiclePosZ",z);
		SetVVarFloat(gVehicleIndex[CheatVehicleID],"VehiclePosAngle",angle);
		SetVVarInt(gVehicleIndex[CheatVehicleID],"VehicleColor1",color1);
		SetVVarInt(gVehicleIndex[CheatVehicleID],"VehicleColor2",color2);
		SetVVarInt(gVehicleIndex[CheatVehicleID],"VehicleDestroyed",0);
		//SetVehicleToRespawn(CheatVehicleID);
	}
	Iter_Add(Vehicles,CheatVehicleID);
	return CheatVehicleID;
}
SpawnVehicle(vehiclekey, Float:x, Float:y, Float:z, Float:angle, respawn_delay=-1)
{
	if(GetVehicleIDfromVehicleIndex(vehiclekey)==-1) GS_SetVehicleState(GetVehicleIDfromVehicleIndex(vehiclekey),0);
	new vehicleid = CreateVehicle(GetVVarInt(vehiclekey,"VehicleModel"),x,y,z,angle,GetVVarInt(vehiclekey,"VehicleColor1"),GetVVarInt(vehiclekey,"VehicleColor2"),respawn_delay);
	gVehicleIndex[vehicleid] = vehiclekey;
	Iter_Add(Vehicles,vehicleid);
	return vehicleid;
}
GS_SetVehicleState(vehicleid,typo)
{
	if(typo==0)
	{
		//DeleteVehicleTuning(vehicleid);
		SetVVarInt(gVehicleIndex[vehicleid],"VehicleDestroyed",1);
		gVehicleIndex[vehicleid] = -1;
		DestroyVehicle(vehicleid);
		Iter_Remove(Vehicles,vehicleid);
	}
	else if(typo==1)
	{
		SetVehicleToRespawn(vehicleid);
	}
	else if(typo==2)
	{
		DeleteVehicleInformation(gVehicleIndex[vehicleid]);
		Iter_Remove(Vehicles,vehicleid);
		return true;
	}
	else if(typo==3)
	{
		DestroyVehicle(vehicleid);
		Iter_Remove(Vehicles,vehicleid);
		return true;
	}
	else return false;
	SetVVarInt(gVehicleIndex[vehicleid],"VehicleDestroyedCount",GetVVarInt(gVehicleIndex[vehicleid],"VehicleDestroyedCount")+1);
	return true;
}
GS_SpawnPlayer(playerid)
{
	CallLocalFunction("PlayerSpawnInfo","d",playerid);
	return SpawnPlayer(playerid);
}
GS_ForceClassSelection(playerid)
{
	if(GS_GetPVarInt(playerid,"PlayerLogged")==0) ShowLoginTextForPlayer(playerid,1);
	return ForceClassSelection(playerid);
}
GS_GivePlayerMoney(playerid,money,bool:set=false)
{
	if(set==true) GS_ResetPlayerMoney(playerid);
	new betrag = GS_GetPVarInt(playerid,"SpielerGeld")+(money);
	GS_SetPVarInt(playerid,"SpielerGeld",betrag);
	if(GS_GetPVarInt(playerid,"PlayerLogged")!=0)
	{
		if(money>0) format(CheatString,sizeof(CheatString),"~g~%d$",money);
		else format(CheatString,sizeof(CheatString),"~r~%d$",money);
		GameTextForPlayer(playerid,CheatString,1000,1);
	}
	GivePlayerMoney(playerid,money);
}
GS_GetPlayerMoney(playerid)
	return GS_GetPVarInt(playerid,"SpielerGeld");
	
GS_ResetPlayerMoney(playerid)
{
	GS_SetPVarInt(playerid,"SpielerGeld",0);
	ResetPlayerMoney(playerid);
}

GS_GetWeaponName(weaponid)
{
	switch(weaponid)
	{
		case 0: format(CheatString,sizeof(CheatString),"Faust");
		case 1: format(CheatString,sizeof(CheatString),"Schlagring");
		case 2: format(CheatString,sizeof(CheatString),"Golfschlaeger");
		case 3: format(CheatString,sizeof(CheatString),"Schlagstock");
		case 4: format(CheatString,sizeof(CheatString),"Messer");
		case 5: format(CheatString,sizeof(CheatString),"Baseballschlaeger");
		case 6: format(CheatString,sizeof(CheatString),"Schaufel");
		case 7: format(CheatString,sizeof(CheatString),"Billiardschlaeger");
		case 8: format(CheatString,sizeof(CheatString),"Katana");
		case 9: format(CheatString,sizeof(CheatString),"Kettensaege");
		case 10: format(CheatString,sizeof(CheatString),"LilaDildo");
		case 11: format(CheatString,sizeof(CheatString),"KleinerVibrator");
		case 12: format(CheatString,sizeof(CheatString),"GroßerVibrator");
		case 13: format(CheatString,sizeof(CheatString),"SilberVibrator");
		case 14: format(CheatString,sizeof(CheatString),"Blumen");
		case 15: format(CheatString,sizeof(CheatString),"Gehstock");
		case 16: format(CheatString,sizeof(CheatString),"HE-Granate");
		case 17: format(CheatString,sizeof(CheatString),"Rauchgranate");
		case 18: format(CheatString,sizeof(CheatString),"Molotov");
		case 22: format(CheatString,sizeof(CheatString),"9mm");
		case 23: format(CheatString,sizeof(CheatString),"Gedämpfte9mm");
		case 24: format(CheatString,sizeof(CheatString),"DesertEagle");
		case 25: format(CheatString,sizeof(CheatString),"Schrotflinte");
		case 26: format(CheatString,sizeof(CheatString),"AbgesaegteSchrotflinte");
		case 27: format(CheatString,sizeof(CheatString),"AutomatischeSchrotflinte");
		case 28: format(CheatString,sizeof(CheatString),"UZI");
		case 29: format(CheatString,sizeof(CheatString),"MP5");
		case 30: format(CheatString,sizeof(CheatString),"AK47");
		case 31: format(CheatString,sizeof(CheatString),"M4a1");
		case 32: format(CheatString,sizeof(CheatString),"Tec9");
		case 33: format(CheatString,sizeof(CheatString),"Gewehr");
		case 34: format(CheatString,sizeof(CheatString),"Sniper");
		case 35: format(CheatString,sizeof(CheatString),"Raketenwerfer");
		case 36: format(CheatString,sizeof(CheatString),"HSRaketenwerfer");
		case 37: format(CheatString,sizeof(CheatString),"Flammenwerfer");
		case 38: format(CheatString,sizeof(CheatString),"Minigun");
		case 39: format(CheatString,sizeof(CheatString),"Rucksackbombe");
		case 40: format(CheatString,sizeof(CheatString),"Zuender");
		case 41: format(CheatString,sizeof(CheatString),"Spraydose");
		case 42: format(CheatString,sizeof(CheatString),"Flammenloescher");
		case 43: format(CheatString,sizeof(CheatString),"Kamera");
		case 44: format(CheatString,sizeof(CheatString),"Nachtsichtgeraet");
		case 45: format(CheatString,sizeof(CheatString),"Waermesichtgeraet");
		case 46: format(CheatString,sizeof(CheatString),"Fallschirm");
		default: format(CheatString,sizeof(CheatString),"Unbekannt");
	}
	return CheatString;
}

GS_SetPlayerWantedLevel(playerid,level)
{
	GS_SetPVarInt(playerid,"SpielerWanted",level);
	return SetPlayerWantedLevel(playerid,level);
}

GS_SetPlayerColor(playerid, color)
{
	SetPlayerColor(playerid, color);
	foreach(Player, i)
	{
		if(AllowedToBeSeen(playerid, i)) SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid)+0x000000FF);
		else SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
	}
	return true;
}

GS_ShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	SetPVarInt(playerid,"PlayerInDialog",dialogid);
	return ShowPlayerDialog(playerid,dialogid,style,caption,info,button1,button2);
}

GS_SetSpawnInfo(playerid, team, skin, Float:x, Float:y, Float:z, Float:Angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
{
	SetPVarFloat(playerid,"SpawnPosX",x); SetPVarFloat(playerid,"SpawnPosY",y); SetPVarFloat(playerid,"SpawnPosZ",z); SetPVarFloat(playerid,"SpawnAngle",Angle);
	return SetSpawnInfo(playerid,team,skin,x,y,z,Angle,weapon1,weapon1_ammo,weapon2,weapon2_ammo,weapon3,weapon3_ammo);
}

GS_MapAndreas_FindZ_For2DCoord(Float:x,Float:y,&Float:z,sqlid=-1,playerid=INVALID_PLAYER_ID)
{
	MapAndreas_FindZ_For2DCoord(x,y,z);
	if(z==0&&sqlid!=-1)
	{
		SetPVarFloat(playerid,"FindZ_X",x); SetPVarFloat(playerid,"FindZ_Y",y);
		format(StockString,sizeof(StockString),"SELECT PosZ FROM samp_seaz WHERE PosX >= '%d' AND PosX <= '%d' AND PosY >= '%d' AND PosY <= '%d' ORDER BY ID ASC LIMIT 1;",floatround(floatsub(x,1)),floatround(floatadd(x,1)),floatround(floatsub(y,1)),floatround(floatadd(y,1)));
		mysql_query(StockString,sqlid,playerid);
	}
	return true;
}

#define SetPVarInt GS_SetPVarInt
#define SetPVarFloat GS_SetPVarFloat
#define SetPVarString GS_SetPVarString
#define GetPVarInt GS_GetPVarInt
#define GetPVarFloat GS_GetPVarFloat
#define GetPVarString GS_GetPVarString

#define CreateVehicle GS_CreateVehicle
#define AddStaticVehicle(%0,%1,%2,%4,%5,%6) GS_CreateVehicle(%0,%1,%2,%4,%5,%6,-1,1)
#define AddStaticVehicleEx(%0,%1,%2,%4,%5,%6,%7) GS_CreateVehicle(%0,%1,%2,%4,%5,%6,%7,2)
#define DestroyVehicle(%0) GS_SetVehicleState(%0,0)
#define DeleteVehicle(%0) GS_SetVehicleState(%0,2)
#define SetVehicleToRespawn(%0) GS_SetVehicleState(%0,1)
#undef GivePlayerMoney
#define GivePlayerMoney GS_GivePlayerMoney
#undef GetPlayerMoney
#define GetPlayerMoney GS_GetPlayerMoney
#undef ResetPlayerMoney
#define ResetPlayerMoney GS_ResetPlayerMoney
#define ForceClassSelection GS_ForceClassSelection
#define SpawnPlayer GS_SpawnPlayer
#define GetWeaponName GS_GetWeaponName
#define SetPlayerWantedLevel GS_SetPlayerWantedLevel
#define SetPlayerColor GS_SetPlayerColor
#define ShowPlayerDialog GS_ShowPlayerDialog
#undef SetSpawnInfo
#define SetSpawnInfo GS_SetSpawnInfo
#define MapAndreas_FindZ_For2DCoord GS_MapAndreas_FindZ_For2DCoord