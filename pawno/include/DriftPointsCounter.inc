#if defined DRIFTER_PLUGIN_INCLUDED

#else

#define DRIFTER_PLUGIN_INCLUDED
#pragma library "DriftPointsCounter"
//-1 means set for all players.

#define DRIFT_INCLUDE_VERSION				(28)
#define DRIFT_REASON_TIME_EXPIRE			(0)
#define DRIFT_REASON_CAR_DAMAGED			(1)
#define DRIFT_REASON_PLAYER_EXIT_VEHICLE	(2)

forward OnPlayerDriftStart(playerid);
forward OnPlayerDriftUpdate(playerid,value,combo,flagid,Float:distance,Float:speed);
forward OnPlayerDriftEnd(playerid,value,combo,reason);

native DriftSet_UpdateDelay(delay);
native DriftGet_UpdateDelay();

native DriftSet_MinimalSpeed(Float:MinimalSpeed,playerid = (-1));
native DriftGet_MinimalSpeed(&Float:MinimalSpeed,playerid = (0));

native DriftSet_MinimalAngle(Float:MinimalAngle,playerid = (-1));
native DriftGet_MinimalAngle(&Float:MinimalAngle,playerid = (0));

native DriftSet_MaximalSpeed(Float:MaximalSpeed,playerid = (-1));
native DriftGet_MaximalSpeed(&Float:MaximalSpeed,playerid = (0));

native DriftSet_MaximalAngle(Float:MaximalAngle,playerid = (-1));
native DriftGet_MaximalAngle(&Float:MaximalAngle,playerid = (0));

native DriftSet_StartEndDelay(delay,playerid = (-1));
native DriftGet_StartEndDelay(playerid = (0));

native DriftSet_Divider(divider,playerid = (-1));
native DriftGet_Divider(playerid = (0));

native DriftSet_DamageCheck(enable = 1,playerid = (-1),Float:MaxHealthLoose = 0.0);//default = disabled (0), enabled = 1
native DriftGet_DamageCheck(playerid = (0),&Float:MaxHealthLoose = 0.0);

native IsPlayerDrifting(playerid);
native IsPlayerDrifting_precise(playerid);

native Drift_AddFLAG(Float:X,Float:Y,Float:Z);//returns flagid
native Drift_DisableFLAG(flagid);
native Drift_DeleteFLAG(flagid);
native Drift_EnableFLAG(flagid);
native Drift_MoveFLAG(flagid,Float:X,Float:Y,Float:Z);

native Drift_SetCheckForFlags(enabled = 1,playerid =(-1));
native Drift_GetCheckForFlags(playerid = 0);

native Drift_SetGlobalCheck(enable = 1);
native Drift_GetGlobalCheck();

native Drift_SetPlayerCheck(playerid = (-1),enable = 1);
native Drift_GetPlayerCheck(playerid = (0));

native Drift_SetBackwardsCheck(enabled = 1,playerid =(-1));
native Drift_GetBackwardsCheck(playerid = 0);

native Drift_SetDriftMaxHealthLoose(Float:MaximalHealthLoose = 0.0,playerid = (-1));
native Drift_GetDriftMaxHealthLoose(&Float:MaximalHealthLoose,playerid = (0));

native Private_DriftGetVersion();

native Drift_AllowModel(modelid);
native Drift_DisallowModel(modelid);
native Drift_ClearModelList();
native Drift_ResetDefaultModelList();

//
#include <a_http>

/* below is the plugin callback support code, you really shouldn't touch this */

#if defined FILTERSCRIPT
public OnFilterScriptInit()
{
	privGPB_AddUpdatecheck("DRIFT",2,Private_DriftGetVersion(),DRIFT_INCLUDE_VERSION);
	//gps_OnGameModeInit();
	return CallLocalFunction("call_drift_OnFilterScriptInit","");
}

#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif

#define OnFilterScriptInit call_drift_OnFilterScriptInit
forward call_drift_OnFilterScriptInit();

#else
public OnGameModeInit()
{
	privGPB_AddUpdatecheck("DRIFT",2,Private_DriftGetVersion(),DRIFT_INCLUDE_VERSION);
	//gps_OnGameModeInit();
	return CallLocalFunction("call_drift_OnGameModeInit","");
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit call_drift_OnGameModeInit
forward call_drift_OnGameModeInit();

#endif

#include <GPBMAIN>
#endif
