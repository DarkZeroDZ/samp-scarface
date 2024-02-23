AddPlayerClass(0,2506.9231,2745.4146,10.8203,343.1541,0,0,0,0,0,0); // team1 sp1
AddPlayerClass(0,2531.4355,2748.0732,10.8203,6.9678,0,0,0,0,0,0); // team1 sp2
AddPlayerClass(0,2566.8567,2747.3784,10.8203,35.4814,0,0,0,0,0,0); // team1 sp3
AddPlayerClass(0,2570.0901,2816.1819,10.8203,79.6617,0,0,0,0,0,0); // team2 sp1
AddPlayerClass(0,2569.1633,2836.0505,10.8203,116.9487,0,0,0,0,0,0); // team2 sp2
AddPlayerClass(0,2583.4070,2825.5032,10.8203,91.8818,0,0,0,0,0,0); // team2 sp3


new Float:TDm1SP1[ 3 ][ 4 ] =
{
{2506.9231,2745.4146,10.8203,343.1541},
{2531.4355,2748.0732,10.8203,6.9678},
{2566.8567,2747.3784,10.8203,35.4814}
};
new Float:TDm1SP2[ 3 ][ 4 ] =
{
{2570.0901,2816.1819,10.8203,79.6617},
{2569.1633,2836.0505,10.8203,116.9487},
{2583.4070,2825.5032,10.8203,91.8818}
};



new Float:TDm2SP1[ 3 ][ 4 ] =
{
{2767.9990,-2429.5305,13.6484,166.7691},
{2757.1729,-2431.1648,13.4831,166.7691},
{2740.0059,-2432.8406,13.6297,186.5093}
};
new Float:TDm2SP2[ 3 ][ 4 ] =
{
{2702.5078,-2507.6292,13.4547,278.3404},
{2702.4700,-2497.7642,13.6641,257.6602},
{2695.8572,-2500.8025,13.4753,257.6602}
};



CMD:tdm(playerid,params[])
{
    if(IsPlayerInAmmunation(playerid)) return SendClientMessage(playerid,RED," "RED2_"-Warning-"RED_" you can't use this command inside the Ammunation");
	new DmID;
    if((PlayerInfo[playerid][Jailed] > 0)) return SendClientMessage(playerid,RED," "RED2_"-Warning-"RED_" you can't use this command in Jail");
    if(GetPVarInt(playerid,"AFK")) return SendClientMessage(playerid,RED," "RED2_"-Warning-"RED_" you cant use this command in AFK Mode type (/back) then try again");
    if(GetPlayerState(playerid) == 7) return SendMsg(playerid, 3);
    if(GetPVarInt(playerid,"MissionProgress") || IsDeathMatcher(playerid)) return SendMsg(playerid, 1);
    if(LockDms == 1) return SendMsg(playerid, 6);
    if(IsInFight(playerid)) return SendMsg(playerid,2);
	if(sscanf(params,"d",DmID)) return SendClientMessage(playerid,RED,""RED2_" Useage"RED_" : /TDM <1-3>");

 	if(DmID > 3 || DmID < 0) return SendClientMessage(playerid,RED,""RED2_" Useage"RED_" : /TDM <1-3>");
 	SavePlayerCoords(playerid);

 	InHouse[playerid] = -255;
	Send_To_TDm(playerid,DmID);

	new str[128];
	SetPVarInt(playerid,"INTDM",DmID);
    SetPlayerArmour(playerid ,0);
    ResetSpawnInfo(playerid);


    format(str, sizeof(str), " -DmInfo- "DmCol2_"%s takes part in \"%s\" Team Deathmatch - "DmCol3_"(/TDM %d) ",pName[playerid], GetPlayerDMName(playerid),DmID);

	foreach(Player,i) if(!GetPVarInt(i,"TeleportsBlock")) SendClientMessage(i,DmCol1,str);

    GameTextForPlayer(playerid,"~w~Type ~r~(/Exit) ~w~to leave the dm",3000,4);
	SetPVarInt(playerid,"pDMKills",0);
	SetPVarInt(playerid,"pDMDeaths",0);
	SetPVarInt(playerid,"pDMKillStreak",0);

	new TD[128];
	format(TD,sizeof(TD),"~y~~h~~h~%s",GetPlayerDMName(playerid));

    PlayerTextDrawSetStringEX(playerid,DMpTD[playerid][0],"-");
	PlayerTextDrawSetStringEX(playerid,DMpTD[playerid][2],"-");
	PlayerTextDrawSetStringEX(playerid,DMpTD[playerid][6],"-");
    PlayerTextDrawSetStringEX(playerid,DMpTD[playerid][7],TD);
	PlayerTextDrawSetStringEX(playerid,DMpTD[playerid][3],"Kills:~y~ 0");
	PlayerTextDrawSetStringEX(playerid,DMpTD[playerid][4],"Deaths:~r~ 0");
	PlayerTextDrawSetStringEX(playerid,DMpTD[playerid][5],"Ratio:~P~ 0.00");
	PlayerTextDrawSetStringEX(playerid,DMpTD[playerid][1],"Serial Kills:~g~ 0");
    for(new x=0; x<8; x++) PlayerTextDrawShow(playerid,DMpTD[playerid][x]);

	HidePlayerMenu(playerid);
	DisablePlayerRaceCheckpoint(playerid);
    return 1;
}

stock GetPlayerDMName(playerid)
{
	new str[32];
	if(GetPVarInt(playerid,"INDM"))
	{
		switch(GetPVarInt(playerid,"INDM"))
		{
		  case 1: str = "Drugs Factory";
		  case 2: str = "Golf Field";
		  case 3: str = "Runnies";
		  case 4: str = "Rockets";
		  case 5: str = "Minigun";
		  case 6: str = "Beat Em up";
		  case 7: str = "Volcano Island";
		  case 8: str = "Ammunation";
		  case 9: str = "Blood Bowl";
		  case 10: str = "Libery City";
		  case 11: str = "Grand Theft Auto II";
		  case 12: str = "Big Smoke";
		  case 13: str = "Bugs In The Atruim";
		  case 14: str = "Rain Forest";
		  case 15: str = "Underwater Paradise";
		  case 16: str = "Runnies II";
		  case 17: str = "Playing With Trash";
		  case 18: str = "Gun Game";
		  case 19: str = "BattleField";
		}
	}
	else if(GetPVarInt(playerid,"WW"))
	{
       str = "Walkies World";
	}
	else if(GetPVarInt(playerid,"WW2"))
	{
       str = "Walkies World II";
	}
	else if(GetPVarInt(playerid,"TDM") == 1)
	{
       str = "K.A.C.C.";
	}
	else if(GetPVarInt(playerid,"TDM") == 2)
	{
       str = "LS Docks";
	}
	else if(GetPVarInt(playerid,"TDM") == 3)
	{
       str = "Walkies World II";
	}
	return str;
}

stock Send_To_Dm( playerid ,TDMID)
{
  HidePlayerDialog(playerid);
  HidePlayerMenu(playerid);
  SetPlayerHealth(playerid ,100);
  ResetPlayerWeaponsEX(playerid);
  new rand= random( 3 );
  SendpInfo(playerid," - ~y~Type ~r~/Exit ~y~to leave the Deathmatch",5000);
  switch(TDMID)
  {
   case 1:
   {
	SetPlayerVirtualWorld(playerid, 123);
	GivePlayerWeaponEX(playerid, 24,9999);
	GivePlayerWeaponEX(playerid, 34,9999);
	if(GetPlayerTeam(playerid) == 3) SetPlayerPos(playerid,TDm1SP[rand][0],TDm1SP[rand][1],TDm1SP[rand][2]);
	else if(GetPlayerTeam(playerid) == 4)
	TDm1SP1
	SetPlayerPos(playerid,TDm1SP[rand][0],TDm1SP[rand][1],TDm1SP[rand][2]);
	SetPlayerFacingAngle(playerid,Dm1SP[rand][3]);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerWorldBounds(playerid,-2098.3831,-2200.0667,-81.7697,-280.0457);
   }
   case 2:
   {
    SetPlayerVirtualWorld(playerid, 124);
    GivePlayerWeaponEX(playerid, 24,9999);
    GivePlayerWeaponEX(playerid, 27,9999);
    GivePlayerWeaponEX(playerid, 34,9999);
    SetPlayerPos(playerid,Dm2SP[rand][0],Dm2SP[rand][1],Dm2SP[rand][2]);
    SetPlayerFacingAngle(playerid,Dm2SP[rand][3]);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 0);
   }
   case 3:
   {
    SetPlayerVirtualWorld(playerid, 125);
    GivePlayerWeaponEX(playerid, 26,9999);
    GivePlayerWeaponEX(playerid, 28,9999);
    SetPlayerPos(playerid,Dm3SP[rand][0],Dm3SP[rand][1],Dm3SP[rand][2]);
    SetPlayerFacingAngle(playerid,Dm3SP[rand][3]);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 0);
    SetPlayerWorldBounds(playerid,1416.4606,1295.3322,2222.0486,2102.1685);
   }
  }
}


