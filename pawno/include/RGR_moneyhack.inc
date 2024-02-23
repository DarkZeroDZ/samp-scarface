#if defined FILTERSCRIPT
	#endinput
#endif

#if defined _moneyhax_included
	#endinput
#endif
#define _moneyhax_included

#define CHECK_TIME 30

new PMoney[MAX_PLAYERS];

forward GetPlayerMonez(playerid);
forward ResetPlayerMonez(playerid);
forward GivePlayerMonez(playerid,money);
forward MoneyCheck();

public MoneyCheck()
{
	new money;
	#if defined _foreach_included
	foreach(Player,playerid)
	{
		money = GetPlayerMoney(playerid);
		if( money < PMoney[playerid] && money > -1 ) PMoney[playerid]=money;
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,PMoney[playerid]);
	}
	#else
	for(new playerid;playerid<MAX_PLAYERS;playerid++) if(IsPlayerConnected(playerid))
	{
		money = GetPlayerMoney(playerid);
		if( money < PMoney[playerid] && money > -1 ) PMoney[playerid]=money;
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,PMoney[playerid]);

	}
	#endif

	return 1;
}

public GivePlayerMonez(playerid, money)
{
	new rmoney = GetPlayerMoney(playerid);
	if( rmoney < PMoney[playerid] && rmoney > -1 ) PMoney[playerid]=rmoney;

	PMoney[playerid]+=money;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,PMoney[playerid]);
	return 1;
}
public ResetPlayerMonez(playerid)
{
	ResetPlayerMoney(playerid);
	PMoney[playerid]=0;
	return 1;
}
public GetPlayerMonez(playerid) return PMoney[playerid];


#define GivePlayerMoney GivePlayerMonez
#define GetPlayerMoney GetPlayerMonez
#define ResetPlayerMoney ResetPlayerMonez

