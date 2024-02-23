/*					 TimerSys Include v1.1 by Templer
					   (for SAMP 0.3 / or higher)
		Dieses Script darf von jedermann verändert und benutzt werden!
	Mir ist es sogar egal, wenn Ihr was von hier für euren Vorteil rauskopiert!
	Was jedoch nicht Geduldet wird, dass das Copyright entfernt wird vom Script!

					Credits:
						-Double-O-Seven : Für das Zeigen wie Include und GM am besten kommunizieren!
						-Samp-Team : Die es überhaupt ermöglicht haben sowas Programmierbar für GTA zu machen!
						-Hagi: Er mich darauf aufmerksam machte, dass KillFastTimer einige Bugs bereitstellte in der ersten Version*/

#define COPYRIGHT_BY_TEMPLER
#define MAX_TIMERS (30) //Die maximale Anzahl an Timer die verwendet werden. (Default: 20 Timer)
#define MIN_FT_TIME_PERIOD (50) //Die kürzeste Zeit von einem Timer der sich wiederholen soll (Default: 700ms)
#define MAX_PUBLIC_NAME_LENGTH (64) //Die maximale Bezeichnungslänge eines public´s. (Default: 32 Charakter)
#define MAX_ARGUMENT_LENGTH (25) //Wieviele Argumente SA-MP Unterstützt. (Default: 25 Char)
#define ALLOW_REMOTE_CALL (true) //Ob die Timerfunktion die Funktionen außerhalb des Scriptes abrufen soll. (Default: true)

enum timerinfoenum
{
	bool:tmAktiv,
	tmName[MAX_PUBLIC_NAME_LENGTH],
	tmTime,
	tmCurrentTime,
	bool:tmRepeat,
	bool:tmPassed,
	tmEndTime,
	tmExVersion,
	tmExString[MAX_ARGUMENT_LENGTH],
};
enum timerexenum
{
	tmTyp,
	tmInteger,
	Float:tmFloat,
	tmString[MAX_PUBLIC_NAME_LENGTH],
}
new gTimerInfo[MAX_TIMERS][timerinfoenum];
new gTimerInfoEx[MAX_TIMERS][MAX_ARGUMENT_LENGTH][timerexenum];
new static gTimerCount = 0;
new gTimerString[256];

forward FT_OnGameModeInit();
forward FT_OnGameModeExit();
forward FT_FastTimerCheck();

stock floatval(Float:var)
{
	new str[32];
	format(str, sizeof(str), "%f", var);
	return strval(str);
}

stock SendErrorMsg(errormsg[sizeof gTimerString])
{
	printf("[FastTimer]: %s", errormsg);
	return false;
}

stock ReturnType(timer, arg, type)
{
	switch(type)
	{
		case 97: return gTimerInfoEx[timer][arg][tmInteger];
		case 98: return _:gTimerInfoEx[timer][arg][tmFloat];
		case 99: return gTimerInfoEx[timer][arg][tmString];
		default: return false;
	}
	return true;
}

stock ClearTimerExArguments(timerid)
{
	new arg = 0;
	for(; arg < (MAX_ARGUMENT_LENGTH-1); arg++)
	{
		gTimerInfoEx[timerid][arg][tmTyp] = 0;
		gTimerInfoEx[timerid][arg][tmInteger] = 0;
		gTimerInfoEx[timerid][arg][tmFloat] = 0.0;
		strdel(gTimerInfoEx[timerid][arg][tmString], 0, MAX_PUBLIC_NAME_LENGTH);
	}
	return true;
}

#if ALLOW_REMOTE_CALL == true
	#define Call_Function CallRemoteFunction
#else
	#define Call_Function CallLocalFunction
#endif

#if !defined COPYRIGHT_BY_TEMPLER
	#error "Removing Copyrights vom Script is not allowed"
#endif

stock SetFastTimer(startname[], time, repeat = 0, endtimer = 0)
{
	if(strlen(startname) >= MAX_PUBLIC_NAME_LENGTH) {
	format(gTimerString, sizeof gTimerString, "Der zu erstellende TimerName %s ist ungültig bzw. zu Lang!", startname);
	return SendErrorMsg(gTimerString); }
	if(gTimerCount == MAX_TIMERS) return SendErrorMsg("Maximale Timer Anzahl erreicht! Erhöhen Sie bitte den Wert in der timersys.inc");
	if(time < 0) {
	format(gTimerString, sizeof gTimerString, "Timerzeit bei %s ist ungültig!", startname);
	return SendErrorMsg(gTimerString); }
	format(gTimerInfo[gTimerCount][tmName], MAX_PUBLIC_NAME_LENGTH, startname);
	gTimerInfo[gTimerCount][tmTime] = time; gTimerInfo[gTimerCount][tmExVersion] = 0;
	gTimerInfo[gTimerCount][tmCurrentTime] = GetTickCount()+time;  gTimerInfo[gTimerCount][tmRepeat] = (repeat != 0 ? true : false);
	gTimerInfo[gTimerCount][tmEndTime] = (endtimer != 0 ? GetTickCount()+endtimer : 0); gTimerInfo[gTimerCount][tmAktiv] = true; gTimerInfo[gTimerCount][tmPassed] = false;
	gTimerCount++;
	return (gTimerCount-1);
}

stock SetFastTimerEx(startname[], time, repeat = 0, const params[], {Float,_}:...)
{
	if(strlen(startname) >= MAX_PUBLIC_NAME_LENGTH) {
	format(gTimerString, sizeof gTimerString, "Der zu erstellende TimerName %s ist ungültig bzw. zu Lang!", startname);
	return SendErrorMsg(gTimerString); }
	if(strlen(params)+4 != numargs()) {
	format(gTimerString, sizeof gTimerString, "Die Format-Params stimmen nicht überein vom Timer %s!", startname);
	return SendErrorMsg(gTimerString); }
	if(gTimerCount == MAX_TIMERS) return SendErrorMsg("Maximale Timer Anzahl erreicht! Erhöhen Sie bitte den Wert in der timersys.inc");
	if(time < 0) {
	format(gTimerString, sizeof gTimerString, "Timerzeit bei %s ist ungültig!", startname);
	return SendErrorMsg(gTimerString); }
	new arg = 4, cache[2][128], index = 0;
	while(arg != strlen(params)+4)
	{
		strdel(cache[0], 0, 128); strdel(cache[1], 0, 128);
		switch(params[arg-4])
		{
			case 'i','d','b','c': 
			{
				gTimerInfoEx[gTimerCount][arg-4][tmInteger] = getarg(arg); 
				gTimerInfoEx[gTimerCount][arg-4][tmTyp] = 97;
			}
			case 'f': 
			{
				format(cache[0], 128, "%f", getarg(arg));
				gTimerInfoEx[gTimerCount][arg-4][tmFloat] = floatstr(cache[0]); 
				gTimerInfoEx[gTimerCount][arg-4][tmTyp] = 98;
			}
			case 's':
			{
				new chari = 1;
				while(chari != 0)
				{
					chari = getarg(arg, index);
					format(cache[1], 128, "%s", getarg(arg, index++)); 
					strcat(cache[0], cache[1]);
				}
				format(gTimerInfoEx[gTimerCount][arg-4][tmString], MAX_PUBLIC_NAME_LENGTH, cache[0]);
				gTimerInfoEx[gTimerCount][arg-4][tmTyp] = 99;
			}
			default:
			{
				ClearTimerExArguments(gTimerCount);
				format(gTimerString, sizeof gTimerString, "Argumenten Mismatch Fehl-Unterstützung!", startname);
				return SendErrorMsg(gTimerString);
			}
		}
		arg++;
	}
	format(gTimerInfo[gTimerCount][tmName], MAX_PUBLIC_NAME_LENGTH, startname);
	format(gTimerInfo[gTimerCount][tmExString], MAX_ARGUMENT_LENGTH, params);
	gTimerInfo[gTimerCount][tmTime] = time; gTimerInfo[gTimerCount][tmExVersion] = strlen(params);
	gTimerInfo[gTimerCount][tmCurrentTime] = GetTickCount()+time;  gTimerInfo[gTimerCount][tmRepeat] = (repeat != 0 ? true : false);
	gTimerInfo[gTimerCount][tmEndTime] = (getarg(numargs(), 0) > 0 ? GetTickCount()+getarg(numargs(), 0) : 0); gTimerInfo[gTimerCount][tmAktiv] = true; 
	gTimerInfo[gTimerCount][tmPassed] = false;
	gTimerCount++;
	return (gTimerCount-1);
}

stock KillFastTimer(timerid)
{
	if(timerid < 0 || timerid >= gTimerCount) {
	format(gTimerString, sizeof gTimerString, "Der zu löschende Timer mit der ID %d wurde nicht gefunden!", timerid);
	return SendErrorMsg(gTimerString); }
	gTimerInfo[timerid][tmAktiv] = false;
	format(gTimerInfo[timerid][tmName], MAX_PUBLIC_NAME_LENGTH, "%s", "Nichts");
	format(gTimerInfo[timerid][tmExString], MAX_PUBLIC_NAME_LENGTH, "%s", "Nichts");
	gTimerInfo[timerid][tmTime] = 0; gTimerInfo[timerid][tmCurrentTime] = 0; gTimerInfo[timerid][tmRepeat] = false;
	gTimerInfo[timerid][tmEndTime] = 0; gTimerInfo[gTimerCount][tmExVersion] = 0;
	ClearTimerExArguments(timerid);
	gTimerCount--;
	if(timerid != gTimerCount)
	{
		while(timerid != gTimerCount)
		{
			timerid++;
			if(timerid == gTimerCount)
			{
				gTimerInfo[timerid-1][tmAktiv] = false;
				format(gTimerInfo[timerid-1][tmName], MAX_PUBLIC_NAME_LENGTH, "%s", "Nichts");
				format(gTimerInfo[timerid-1][tmExString], MAX_PUBLIC_NAME_LENGTH, "%s", "Nichts");
				gTimerInfo[timerid-1][tmTime] = 0; gTimerInfo[timerid-1][tmCurrentTime] = 0; gTimerInfo[timerid-1][tmRepeat] = false;
				gTimerInfo[timerid-1][tmEndTime] = 0; gTimerInfo[gTimerCount][tmExVersion] = 0;
				ClearTimerExArguments(timerid-1);
				printf("LastTimerID: %d", timerid-1);
				break;
			}
			printf("TimerID Verschiebung von %d zu %d", timerid, timerid-1);
			format(gTimerInfo[timerid-1][tmName], MAX_PUBLIC_NAME_LENGTH, gTimerInfo[timerid][tmName]);
			if(gTimerInfo[timerid][tmExVersion]) format(gTimerInfo[timerid-1][tmExString], 256, gTimerInfo[timerid][tmExString]);
			gTimerInfo[timerid-1][tmTime] = gTimerInfo[timerid][tmTime]; gTimerInfo[timerid-1][tmExVersion] = gTimerInfo[timerid][tmExVersion];
			gTimerInfo[timerid-1][tmCurrentTime] = gTimerInfo[timerid][tmCurrentTime]; gTimerInfo[timerid-1][tmRepeat] = gTimerInfo[timerid][tmRepeat];
			gTimerInfo[timerid-1][tmEndTime] = gTimerInfo[timerid][tmEndTime]; gTimerInfo[timerid-1][tmAktiv] = gTimerInfo[timerid][tmAktiv];
			for(new arg = 0; arg < (MAX_ARGUMENT_LENGTH-1); arg++)
			{
				gTimerInfoEx[timerid-1][arg][tmTyp] = gTimerInfoEx[timerid][arg][tmTyp];
				gTimerInfoEx[timerid-1][arg][tmInteger] = gTimerInfoEx[timerid][arg][tmInteger];
				gTimerInfoEx[timerid-1][arg][tmFloat] = gTimerInfoEx[timerid][arg][tmFloat];
				format(gTimerInfoEx[timerid-1][arg][tmString], MAX_PUBLIC_NAME_LENGTH, gTimerInfoEx[timerid][arg][tmString]);
			}
		}
	}
	return true;
}

public OnGameModeInit()
{
	for(new count = 0; count < (MAX_TIMERS-1); count++)
	{
		format(gTimerInfo[count][tmName], MAX_PUBLIC_NAME_LENGTH, "%s", "Nichts");
		format(gTimerInfo[count][tmExString], MAX_PUBLIC_NAME_LENGTH, "%s", "Nichts");
		gTimerInfo[count][tmTime] = 0;
		gTimerInfo[count][tmCurrentTime] = 0; gTimerInfo[count][tmRepeat] = false;
		gTimerInfo[count][tmEndTime] = 0; gTimerInfo[count][tmAktiv] = false; gTimerInfo[gTimerCount][tmExVersion] = 0;
		ClearTimerExArguments(count);
	}
	SetTimer("FT_FastTimerCheck", MIN_FT_TIME_PERIOD, true);
	return CallLocalFunction("FT_OnGameModeInit", "");
}

public OnGameModeExit()
{
	for(new count = 0; count < (MAX_TIMERS-1); count++)
	{
		format(gTimerInfo[count][tmName], MAX_PUBLIC_NAME_LENGTH, "%s", "Nichts");
		format(gTimerInfo[count][tmExString], MAX_PUBLIC_NAME_LENGTH, "%s", "Nichts");
		gTimerInfo[count][tmTime] = 0;
		gTimerInfo[count][tmCurrentTime] = 0; gTimerInfo[count][tmRepeat] = false;
		gTimerInfo[count][tmEndTime] = 0; gTimerInfo[count][tmAktiv] = false; gTimerInfo[gTimerCount][tmExVersion] = 0;
		ClearTimerExArguments(count);
	}
	return CallLocalFunction("FT_OnGameModeExit", "");
}

public FT_FastTimerCheck()
{
	new tcount = -1;
	while(tcount != gTimerCount)
	{
		tcount++;
		if(!gTimerInfo[tcount][tmAktiv] || gTimerInfo[tcount][tmCurrentTime] > GetTickCount() || gTimerInfo[tcount][tmCurrentTime] <= GetTickCount() && gTimerInfo[tcount][tmPassed]) continue;
		gTimerInfo[tcount][tmPassed] = true;
		new tick = GetTickCount();
		if(gTimerInfo[tcount][tmExVersion]) Call_Function(gTimerInfo[tcount][tmName], gTimerInfo[tcount][tmExString],
		ReturnType(tcount, 0, gTimerInfoEx[tcount][0][tmTyp]),
		ReturnType(tcount, 1, gTimerInfoEx[tcount][1][tmTyp]),
		ReturnType(tcount, 2, gTimerInfoEx[tcount][2][tmTyp]),
		ReturnType(tcount, 3, gTimerInfoEx[tcount][3][tmTyp]),
		ReturnType(tcount, 4, gTimerInfoEx[tcount][4][tmTyp]),
		ReturnType(tcount, 5, gTimerInfoEx[tcount][5][tmTyp]),
		ReturnType(tcount, 6, gTimerInfoEx[tcount][6][tmTyp]),
		ReturnType(tcount, 7, gTimerInfoEx[tcount][7][tmTyp]),
		ReturnType(tcount, 8, gTimerInfoEx[tcount][8][tmTyp]),
		ReturnType(tcount, 9, gTimerInfoEx[tcount][9][tmTyp]),
		ReturnType(tcount, 10, gTimerInfoEx[tcount][10][tmTyp]),
		ReturnType(tcount, 11, gTimerInfoEx[tcount][11][tmTyp]),
		ReturnType(tcount, 12, gTimerInfoEx[tcount][12][tmTyp]),
		ReturnType(tcount, 13, gTimerInfoEx[tcount][13][tmTyp]),
		ReturnType(tcount, 14, gTimerInfoEx[tcount][14][tmTyp]),
		ReturnType(tcount, 15, gTimerInfoEx[tcount][15][tmTyp]),
		ReturnType(tcount, 16, gTimerInfoEx[tcount][16][tmTyp]),
		ReturnType(tcount, 17, gTimerInfoEx[tcount][17][tmTyp]),
		ReturnType(tcount, 18, gTimerInfoEx[tcount][18][tmTyp]),
		ReturnType(tcount, 19, gTimerInfoEx[tcount][19][tmTyp]),
		ReturnType(tcount, 20, gTimerInfoEx[tcount][20][tmTyp]),
		ReturnType(tcount, 21, gTimerInfoEx[tcount][21][tmTyp]),
		ReturnType(tcount, 22, gTimerInfoEx[tcount][22][tmTyp]),
		ReturnType(tcount, 23, gTimerInfoEx[tcount][23][tmTyp]),
		ReturnType(tcount, 24, gTimerInfoEx[tcount][24][tmTyp]));
		else Call_Function(gTimerInfo[tcount][tmName], "");
		if((GetTickCount()-tick) > gTimerInfo[tcount][tmTime] && gTimerInfo[tcount][tmRepeat]) {
		gTimerInfo[tcount][tmTime] = (GetTickCount()-tick);
		format(gTimerString, sizeof gTimerString, "TimerZeit von %s wurde optimiert auf %d!", gTimerInfo[tcount][tmName], (GetTickCount()-tick));
		SendErrorMsg(gTimerString); }
		gTimerInfo[tcount][tmCurrentTime] = GetTickCount()+gTimerInfo[tcount][tmTime]; 
		gTimerInfo[tcount][tmPassed] = false;
		if(!gTimerInfo[tcount][tmRepeat] || gTimerInfo[tcount][tmEndTime] && gTimerInfo[tcount][tmEndTime] >= GetTickCount()) KillFastTimer(tcount);
	}
	return true;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit FT_OnGameModeInit

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit FT_OnGameModeExit