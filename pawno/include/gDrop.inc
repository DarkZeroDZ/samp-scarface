/*
 $ Latest Update :				22 / 10 / 2010
 $ gDrop by :					Daniel "Goldkiller" ( gta-goldkiller [at] web.de )
 $ Supported SAMP Version:  	( 0.2-* & 0.3a ) 0.3b
 $ Visit :                  	www.san-vice.de.vu
 
 $ Usefull functions :          Mabako
*/
#define MONEY_PACKET 1212
#define MAX_MONEY_DROP 500000
#define MAX_MUNI_DROP 5000

#define MONEY_PACKET_COLOR 0x228B22FE
#define MONEY_PACKET_DISTANCE 18.0

#define DESTROY_COUNT 6

enum e_DropItem {
	DI_iDestroyCount,
	DI_iExtra, // Weapon | Munition   ||    Money
	Text3D:DI_t3dInfo,
	DI_iFlag
};
new
	tDropItems;
	
new DropItems[MAX_PICKUPS][e_DropItem];


enum ( <<= 1) {
	e_Flag_MoneyDrop = 1,
	e_Flag_WeaponDrop
}


new const PickupWeapons[] = // by Mabako
{
	-1, // no fists
	331, // - Brass Knuckles
	333, // Golf Club
	334, // Night Stick
	335, // Knife
	336, // baseball bat
	337, // shovel
	338, // pool cue
	339, // katama
	341, // chainsaw
	321, // regular dildo
	322, // white dildo
	323, // Medium, white vibrator
	324, // smaill, silver vibrator
	325, // flowers
	326, // cane
	342, // grendade
	343, // tear gas
	344, // molotov
	-1, // RPG rocket - we can't pick up those, do we oO
	-1, // Heat-Seeking Rocket
	-1, // Hydra rocket
	346, // colt 45
	347, // colt 45 + silencer
	348, // deagle
	349, // shotgun
	350, // sawn-off
	351, // spaz
	352, // micro-uzi
	353, // mp5
	355, // ak47
	356, // m4
	372, // tec9
	357, // country rifle
	358, // sniper rifle
	359, // rocket launcher
	360, // heat-seeking rocket launcher
	361, // flamethrower
	362, // minigun
	363, // sachtel charges
	-1, // detonator
	365, // spray can
	366, // fire extinguisher
	367, // camera
	-1, // night-vision goggles
	-1, // heat-vision goggles
	371 // parachute
};

stock _DropItemInit() {
    tDropItems = SetTimer("Drop_Pulse", (20 * 1000)  - 13,true);
    return 1;
}

stock _DropItemClose() {
	KillTimer(tDropItems);
	for(new i ; i < MAX_PICKUPS ; i++) {
	    if(DropItems[i][DI_iDestroyCount] > 0) {
            DestroyDropItem(i);
		}
	}
	return 1;
}


forward Drop_Pulse();
public Drop_Pulse() {
	for(new i ; i < MAX_PICKUPS ; i++) {
	    if(DropItems[i][DI_iDestroyCount] > 0) {
	        DropItems[i][DI_iDestroyCount]--;
	        if(DropItems[i][DI_iDestroyCount] == 0) {
	            DestroyDropItem(i);
	        }
	    }
	}
	return 1;
}

stock DestroyDropItem(pickup) {
	if(_:DropItems[pickup][DI_t3dInfo] != INVALID_3DTEXT_ID) {
		Delete3DTextLabel(DropItems[pickup][DI_t3dInfo]);
	}
	DropItems[pickup][DI_iExtra] = 0;
	DropItems[pickup][DI_iDestroyCount] = -1;
    DestroyPickup(pickup);
	return 1;
}

stock DropMoney(playerid) {
	new
	    money = GetPlayerMoney(playerid);
	if(money == 0) { // kein geld,kein drop
	    return 0;
	}
	new
	    iPickup,
	    sStr[16],
	    Float:fX,
	    Float:fY,
		Float:fZ;
	GetPlayerPos(playerid,fX,fY,fZ);
	fX = fX + random(3) - random(3);
	fY = fY + random(3) - random(3);
	if(money > MAX_MONEY_DROP) {
	    money = MAX_MONEY_DROP;
	}
	iPickup = CreatePickup(MONEY_PACKET,1,fX,fY,fZ,0);
	if(iPickup == -1) return 0;
	DropItems[iPickup][DI_iFlag]   = e_Flag_MoneyDrop;
	format(sStr,sizeof(sStr),"%d$",money);
	DropItems[iPickup][DI_t3dInfo] = Create3DTextLabel(sStr,MONEY_PACKET_COLOR,fX,fY,fZ + 0.3,MONEY_PACKET_DISTANCE,0,1);
	DropItems[iPickup][DI_iExtra]   = money;
	DropItems[iPickup][DI_iDestroyCount] = DESTROY_COUNT;
	
	ResetPlayerMoney(playerid);
    return 1;
}

stock Drop_OnPlayerPickUpPickup(playerid, pickupid) {
	if(DropItems[pickupid][DI_iFlag] & e_Flag_MoneyDrop) {
	    Money_OnPlayerPickUpPickup(playerid, pickupid);
	}
	else if(DropItems[pickupid][DI_iFlag] & e_Flag_WeaponDrop) {
	    Weapon_OnPlayerPickUpPickup(playerid,pickupid);
	}
	return 1;
}
stock Money_OnPlayerPickUpPickup(playerid, pickupid) {
	GivePlayerMoney(playerid,DropItems[pickupid][DI_iExtra]);
	PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
    DestroyDropItem(pickupid);
    return 1;
}

stock DropWeapon(playerid) {
	new
	    iPickup,
	    _tmp,
	    iWeapon,
	    iSlot,
	    iMuni,
	    Float:fX,
	    Float:fY,
		Float:fZ;
    iWeapon = GetPlayerWeapon(playerid);
	if(PickupWeapons[iWeapon] == -1) {
	    return 0;
	}
    iSlot = WeaponSlot(iWeapon);
	GetPlayerWeaponData(playerid,iSlot,_tmp,iMuni);
	GetPlayerPos(playerid,fX,fY,fZ);
	fX = fX + random(3) - random(3);
	fY = fY + random(3) - random(3);
	if(iMuni > MAX_MUNI_DROP) {
	    iMuni = MAX_MUNI_DROP;
	}
	iPickup = CreatePickup(PickupWeapons[iWeapon],1,fX,fY,fZ,0);
	if(iPickup == -1) return 0;
	DropItems[iPickup][DI_iFlag]   = e_Flag_WeaponDrop;
	DropItems[iPickup][DI_t3dInfo] = Text3D:INVALID_3DTEXT_ID;
	DropItems[iPickup][DI_iDestroyCount] = DESTROY_COUNT;
	DropItems[iPickup][DI_iExtra]   = iWeapon | ( iMuni << 8 );
	ResetPlayerWeapons(playerid);
    return 1;

}

stock Weapon_OnPlayerPickUpPickup(playerid, pickupid) {
	new
	    iSlotPicked,
	    iWeapon_picked = (DropItems[pickupid][DI_iExtra] & 0xFF),
	    iAmmo,
	    iMuni = ( DropItems[pickupid][DI_iExtra] >> 8 ) & 0xFF,
	    iArmedWeapon,
	    iWeapon;
	iSlotPicked = WeaponSlot(iWeapon_picked);
	GetPlayerWeaponData(playerid,iSlotPicked,iWeapon,iAmmo);
	iArmedWeapon = GetPlayerWeapon(playerid);
	if(iWeapon == iWeapon_picked) {
		GivePlayerWeapon(playerid,iWeapon_picked,iMuni);
		if(iArmedWeapon != iWeapon_picked) {
			SetPlayerArmedWeapon(playerid,iArmedWeapon);
		}
	}
	else {
	    new
	        keys,
			ud,
			lr;
		GetPlayerKeys(playerid,keys,ud,lr);
		if(keys & KEY_WALK) {
			GivePlayerWeapon(playerid,iWeapon_picked,iMuni);
		}
		else {
		    if( (iWeapon == 0) && (iAmmo == 0) ) {
			    GivePlayerWeapon(playerid,iWeapon_picked,iMuni);
		    }
		    else {
				GivePlayerWeapon(playerid,iWeapon,( iMuni + iAmmo ));
				if(iArmedWeapon != iWeapon_picked) {
					SetPlayerArmedWeapon(playerid,iArmedWeapon);
				}
			}
		}
	}
	PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
    DestroyDropItem(pickupid);
    return 1;
}
stock WeaponSlot(weaponid)
{
        switch (weaponid)
        {
            case 0,1: return 0;
            case 2..9: return 1;
            case 22..24: return 2;
            case 25..27: return 3;
            case 28,29,32: return 4;
            case 33,34: return 5;
            case 30,31: return 6;
            case 35..38: return 7;
            case 16..18,39: return 8;
            case 41..43: return 9;
            case 10..15: return 10;
            case 44..46: return 11;
            default: return 12;
        }
        return -1;
}

