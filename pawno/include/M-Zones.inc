/*
*
* M-Zones © by Maercell
*
* Released: 24.06.2009
* Version:  1.2
* Lignes:	350
* Language: German
* Coder:    Maercell aka [GCW]Marciii
*
*
native M_CreateZone(Float:minx,Float:miny,Float:maxx,Float:maxy,zonecolor,text[]="",textcolor=0xFFFFFFFF);
native M_DestroyZone(zoneid);
native M_ZoneFlashForPlayer(playerid,zoneid,flashcolor);
native M_ZoneFlashForAll(zoneid,flashcolor);
native M_ZoneStopFlashForPlayer(playerid,zoneid);
native M_ZoneStopFlashForAll(zoneid);
native M_ZoneSetTextDraw(zoneid,text[]="",textcolor=0xFFFFFFFF);
native M_ZoneSetZone(zoneid,Float:minx,Float:miny,Float:maxx,Float:maxy,zonecolor);
native M_ZoneGetZoneCoords(zoneid,&Float:minx,&Float:miny,&Float:maxx,&Float:maxy);
native M_IsValidZone(zoneid);
native M_IsPlayerInZone(playerid,zoneid);
native M_IsPlayerInAnyZone(playerid);
native M_GetPlayerCurrentZone(playerid);
native M_IsPlayerInArea(playerid,Float:minX,Float:minY,Float:maxX,Float:maxY);
native M_OnPlayerEnterZone(playerid,zoneid);
native M_OnPlayerLeaveZone(playerid,zoneid);
*
*/

#if defined m_zones_included
	#endinput
#endif
#define m_zones_included

// Wenn du mehr als 20 Zonen verwenden willst, erhöhe diese Zahl
#define MAX_ZONES 20

// Wenn du das TextDraw nicht anzeigen lassen willst, schreibe // vor das #define
#define USE_TEXTDRAW


enum ZoneInfo
{
	zGangZoneID,
    zValid,
	Float:zMinX,
	Float:zMinY,
	Float:zMaxX,
	Float:zMaxY,
	Text:zTextDraw,
	zText[100]
}

new zones = 0;
new Zonen[MAX_ZONES][ZoneInfo];
new InZone[MAX_PLAYERS][MAX_ZONES];

forward ShowZoneText();
forward M_OnPlayerEnterZone(playerid,zoneid);
forward M_OnPlayerLeaveZone(playerid,zoneid);

M_Init()
{
	SetTimer("ShowZoneText",999,1);
	for(new zoneid=0; zoneid<MAX_ZONES; zoneid++)
	{
		Zonen[zoneid][zGangZoneID] = -1;
		Zonen[zoneid][zValid] = 0;
		Zonen[zoneid][zMinX] = 0.0;
		Zonen[zoneid][zMinY] = 0.0;
		Zonen[zoneid][zMaxX] = 0.0;
		Zonen[zoneid][zMaxY] = 0.0;
		strmid(Zonen[zoneid][zText],"",0,0,255);
	}
	return 1;
}

public ShowZoneText()
{
	for(new i=0; i<GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			for(new zoneid=0; zoneid<MAX_ZONES; zoneid++)
			{
		        if(M_IsValidZone(zoneid))
		        {
				    if(M_IsPlayerInZone(i,zoneid) && InZone[i][zoneid] == 0)
				    {
						#if defined USE_TEXTDRAW
						{
							if(Zonen[zoneid][zText][0] != '\0')
							{
								TextDrawShowForPlayer(i,Zonen[zoneid][zTextDraw]);
							}	
						}
						#endif
						InZone[i][zoneid] = 1;
						M_OnPlayerEnterZone(i,zoneid);
					}
					if(!M_IsPlayerInZone(i,zoneid) && InZone[i][zoneid] == 1)
					{
						#if defined USE_TEXTDRAW
						{
							if(Zonen[zoneid][zText][0] != '\0')
							{
								TextDrawHideForPlayer(i,Zonen[zoneid][zTextDraw]);
							}	
						}
						#endif
						InZone[i][zoneid] = 0;	
						M_OnPlayerLeaveZone(i,zoneid);
					}
				}
			}
		}
	}
	return 1;
}

stock M_CreateZone(Float:minx,Float:miny,Float:maxx,Float:maxy,zonecolor,text[]="",textcolor=0xFFFFFFFF)
{
	if(!M_IsValidZone(zones) && zones != MAX_ZONES)
	{
		#if defined USE_TEXTDRAW
		{	
			if(text[0] != '\0')
			{
				Zonen[zones][zTextDraw] = TextDrawCreate(600.0,380.0,text);
				TextDrawFont(Zonen[zones][zTextDraw],1);
				TextDrawAlignment(Zonen[zones][zTextDraw],3);
				TextDrawLetterSize(Zonen[zones][zTextDraw],0.35,1.4);
				TextDrawSetShadow(Zonen[zones][zTextDraw],0);
				TextDrawSetOutline(Zonen[zones][zTextDraw],1);
				TextDrawColor(Zonen[zones][zTextDraw],textcolor);
				TextDrawBackgroundColor(Zonen[zones][zTextDraw],0x000000FF);
			}	
		}
		#endif
		if(minx > maxx) // FALSCHRUM!
		{
			Zonen[zones][zMinX] = maxx;
			Zonen[zones][zMaxX] = minx;
		}
		else
		{
			Zonen[zones][zMinX] = minx;
			Zonen[zones][zMaxX] = maxx;
		}
		if(miny > maxy)  // FALSCHRUM!
		{
			Zonen[zones][zMinY] = maxy;
			Zonen[zones][zMaxY] = miny;
		}
		else
		{
			Zonen[zones][zMinY] = miny;
			Zonen[zones][zMaxY] = maxy;		
		}
		Zonen[zones][zGangZoneID] = GangZoneCreate(Zonen[zones][zMinX],Zonen[zones][zMinY],Zonen[zones][zMaxX],Zonen[zones][zMaxY]);
		GangZoneShowForAll(Zonen[zones][zGangZoneID],zonecolor);
		Zonen[zones][zValid] = 1;
		strmid(Zonen[zones][zText],text,0,strlen(text),255);
		zones++;
		return zones-1;
	}
	return -1;
}

stock M_DestroyZone(zoneid)
{
	if(M_IsValidZone(zoneid))
	{
		#if defined USE_TEXTDRAW
		{
			if(Zonen[zoneid][zText][0] != '\0')
			{
				TextDrawHideForAll(Zonen[zoneid][zTextDraw]);
				TextDrawDestroy(Zonen[zoneid][zTextDraw]);
			}
		}
		#endif
		
		GangZoneHideForAll(Zonen[zoneid][zGangZoneID]);
		GangZoneDestroy(Zonen[zoneid][zGangZoneID]);
		Zonen[zoneid][zValid] = 0;
		Zonen[zoneid][zMinX] = 0.0;
		Zonen[zoneid][zMinY] = 0.0;
		Zonen[zoneid][zMaxX] = 0.0;
		Zonen[zoneid][zMaxY] = 0.0;
		strmid(Zonen[zoneid][zText],"",0,0,255);	
		return 1;
	}	
	return 0;
}

stock M_ZoneFlashForPlayer(playerid,zoneid,flashcolor)
{
	if(M_IsValidZone(zoneid) && IsPlayerConnected(playerid))
	{
		GangZoneFlashForPlayer(playerid,Zonen[zoneid][zGangZoneID],flashcolor);
		return 1;
	}
	return 0;
}

stock M_ZoneFlashForAll(zoneid,flashcolor)
{
	if(M_IsValidZone(zoneid))
	{
		GangZoneFlashForAll(Zonen[zoneid][zGangZoneID],flashcolor);
		return 1;
	}
	return 0;
}

stock M_ZoneStopFlashForPlayer(playerid,zoneid)
{
	if(M_IsValidZone(zoneid) && IsPlayerConnected(playerid))
	{
		GangZoneStopFlashForPlayer(playerid,Zonen[zoneid][zGangZoneID]);
		return 1;
	}
	return 0;
}

stock M_ZoneStopFlashForAll(zoneid)
{
	if(M_IsValidZone(zoneid))
	{
		GangZoneStopFlashForAll(Zonen[zoneid][zGangZoneID]);
		return 1;
	}
	return 0;
}

stock M_ZoneSetTextDraw(zoneid,text[]="",textcolor=0xFFFFFFFF)
{
	if(M_IsValidZone(zoneid))
	{
		#if defined USE_TEXTDRAW
		{	
			if(text[0] != '\0')
			{
				Zonen[zoneid][zTextDraw] = TextDrawCreate(600.0,380.0,text);
				TextDrawFont(Zonen[zoneid][zTextDraw],1);
				TextDrawAlignment(Zonen[zoneid][zTextDraw],3);
				TextDrawLetterSize(Zonen[zoneid][zTextDraw],0.35,1.4);
				TextDrawSetShadow(Zonen[zoneid][zTextDraw],0);
				TextDrawSetOutline(Zonen[zoneid][zTextDraw],1);
				TextDrawColor(Zonen[zoneid][zTextDraw],textcolor);
				TextDrawBackgroundColor(Zonen[zoneid][zTextDraw],0x000000FF);
			}	
		}
		#endif
		strmid(Zonen[zoneid][zText],text,0,strlen(text),255);
		return 1;
	}
	return 0;
}

stock M_ZoneSetZone(zoneid,Float:minx,Float:miny,Float:maxx,Float:maxy,zonecolor)
{
	if(M_IsValidZone(zoneid))
	{
		if(minx > maxx) // FALSCHRUM!
		{
			Zonen[zoneid][zMinX] = maxx;
			Zonen[zoneid][zMaxX] = minx;
		}
		else
		{
			Zonen[zoneid][zMinX] = minx;
			Zonen[zoneid][zMaxX] = maxx;
		}
		if(miny > maxy)  // FALSCHRUM!
		{
			Zonen[zoneid][zMinY] = maxy;
			Zonen[zoneid][zMaxY] = miny;
		}
		else
		{
			Zonen[zoneid][zMinY] = miny;
			Zonen[zoneid][zMaxY] = maxy;		
		}
		GangZoneHideForAll(Zonen[zoneid][zGangZoneID]);
		GangZoneDestroy(Zonen[zoneid][zGangZoneID]);
		Zonen[zoneid][zGangZoneID] = GangZoneCreate(Zonen[zoneid][zMinX],Zonen[zoneid][zMinY],Zonen[zoneid][zMaxX],Zonen[zoneid][zMaxY]);
		GangZoneShowForAll(Zonen[zoneid][zGangZoneID],zonecolor);
		return 1;
	}
	return 0;
}

stock M_ZoneGetZoneCoords(zoneid,&Float:minx,&Float:miny,&Float:maxx,&Float:maxy)
{
	if(M_IsValidZone(zoneid))
	{
		minx = Zonen[zoneid][minx];
		miny = Zonen[zoneid][miny];
		maxx = Zonen[zoneid][maxx];
		maxy = Zonen[zoneid][maxy];
		return 1;
	}
	return 0;
}

stock M_IsValidZone(zoneid)
{
	return Zonen[zoneid][zValid];
}

stock M_IsPlayerInZone(playerid,zoneid)
{
	if(M_IsValidZone(zoneid))
	{
		return (M_IsPlayerInArea(playerid,Zonen[zoneid][zMinX],Zonen[zoneid][zMinY],Zonen[zoneid][zMaxX],Zonen[zoneid][zMaxY]));
	}
	return 0;
}

stock M_IsPlayerInAnyZone(playerid)
{
	for(new zoneid=0; zoneid<MAX_ZONES; zoneid++)
	{
		if(M_IsValidZone(zoneid))
		{
			if(IsPlayerInZone(playerid,zoneid))
			{
				return 1;
			}
		}
	}
	return 0;
}

stock M_GetPlayerCurrentZone(playerid)
{
	for(new zoneid=0; zoneid<MAX_ZONES; zoneid++)
	{
		if(M_IsValidZone(zoneid))
		{
			if(M_IsPlayerInZone(playerid,zoneid))
			{
				return zoneid;
			}
		}
	}
	return -1;
}

stock M_IsPlayerInArea(playerid,Float:minX,Float:minY,Float:maxX,Float:maxY)
{
	new Float:pX, Float:pY, Float:pZ;
	GetPlayerPos(playerid,pX,pY,pZ);
	if(pX >= minX && pX <= maxX && pY >= minY && pY <= maxY)
	{
		return 1;
	}
	return 0;
}
