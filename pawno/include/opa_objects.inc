/*---------------------------------------

/--------\  /--------\     /\
|        |  |        |    /  \
|        |  |        |   /    \    |-----
|        |  |--------/  /      \   |
|        |  |          |--------|  \----\
|        |  |          |        |       |
\--------/  |          |        |  -----/

          OBJECTSTREAMER & MAPEDITOR
                VERSION 5.0.5
               GAMEMODE INCLUDE

-----------------------------------------
Use the standard functions and:
native RotateObject(objectid,Float:rX,Float:rY,Float:rZ,time);
native IsObjectStreamedIn(objectid,forplayerid);
native WaitForMap(playerid);
native SetObjectVirtualWorld(objectid,world);
native LinkObjectToInterior(objectid,interiorid);
native IsPlayerMapper(playerid);
native GetObjectVirtualWorld(objectid);
native GetObjectInterior(objectid);
---------------------------------------*/
#include <a_samp>
#if defined _opa_obj_included
#endinput
#endif
#define _opa_obj_included
#pragma library opa_obj
forward opa_obj_OnGameModeInit();
forward remoteExit();
forward remoteNumber(opa1);
forward OnObjectStreamIn(objectid,forplayerid);
forward OnObjectStreamOut(objectid,forplayerid);
forward OnStreamerAdminRequest(playerid);
new opaEnte;
public OnGameModeInit()
{
    print("\n...Opas Objectstremer loading [Gamemode connection]...\n");
    CallRemoteFunction("remoteConnectGM"," ");
	CallLocalFunction("opa_obj_OnGameModeInit"," ");
}
public remoteExit()
{
	opaEnte=0;
}
public remoteNumber(opa1)
{
	opaEnte=opa1;
}
stock opaCreateObject(opa1,Float:opa2,Float:opa3,Float:opa4,Float:opa5,Float:opa6,Float:opa7,Float:opa8=0.0)
{
	#pragma unused opa8
	if(!CallRemoteFunction("remoteObject","dffffff",opa1,opa2,opa3,opa4,opa5,opa6,opa7))return -1;
	//if(opa8!=-1)CallRemoteFunction("remoteVirtual","dd",opaEnte,opa8);
	return opaEnte;
}
stock SetObjectVirtualWorld(opa1,opa2)return CallRemoteFunction("remoteVirtual","dd",opa1,opa2);
stock LinkObjectToInterior(opa1,opa2)return CallRemoteFunction("remoteInt","dd",opa1,opa2);
stock opaMoveObject(opa1,Float:opa2,Float:opa3,Float:opa4,Float:opa5)return CallRemoteFunction("remoteMove","dffff",opa1,opa2,opa3,opa4,opa5);
stock opaSetObjectPos(opa1,Float:opa2,Float:opa3,Float:opa4)return CallRemoteFunction("remoteSetPos","dfff",opa1,opa2,opa3,opa4);
stock opaSetObjectRot(opa1,Float:opa2,Float:opa3,Float:opa4)return CallRemoteFunction("remoteSetRot","dfff",opa1,opa2,opa3,opa4);
stock opaDestroyObject(opa1)return CallRemoteFunction("remoteDestroy","d",opa1);
stock opaStopObject(opa1)return CallRemoteFunction("remoteStop","d",opa1);
stock CreateObjectEx(opa1,Float:opa2,Float:opa3,Float:opa4,Float:opa5,Float:opa6,Float:opa7,Float:opa8=0.0)
{
    CallRemoteFunction("remoteObjectEx"," ");
	return CreateObject(opa1,opa2,opa3,opa4,opa5,opa6,opa7,opa8);
}
stock MoveObjectEx(opa1,Float:opa2,Float:opa3,Float:opa4,Float:opa5)return MoveObject(opa1,opa2,opa3,opa4,opa5);
stock SetObjectPosEx(opa1,Float:opa2,Float:opa3,Float:opa4)return SetObjectPosEx(opa1,opa2,opa3,opa4);
stock SetObjectRotEx(opa1,Float:opa2,Float:opa3,Float:opa4)return SetObjectRot(opa1,opa2,opa3,opa4);
stock DestroyObjectEx(opa1)
{
    CallRemoteFunction("remoteDestroyEx"," ");
	return DestroyObject(opa1);
}
stock StopObjectEx(opa1)return StopObjectEx(opa1);
stock WaitForMap(opa1)return CallRemoteFunction("remoteMakeWait","d",opa1);
//IsObjectStreamedIn(objectid,forplayerid);
stock IsObjectStreamedIn(opa1,opa2)return CallRemoteFunction("remoteIsStreamed","dd",opa1,opa2);
stock RotateObject(opa1,Float:opa2,Float:opa3,Float:opa4,opa5)return CallRemoteFunction("remoteMoveRot","dfffd",opa1,opa2,opa3,opa4,opa5);
stock IsPlayerMapper(opa1)return CallRemoteFunction("remoteIsMapper","d",opa1);
#define CreateObject opaCreateObject
#define MoveObject opaMoveObject
#define SetObjectPos opaSetObjectPos
#define SetObjectRot opaSetObjectRot
#define DestroyObject opaDestroyObject
#define StopObject opaStopObject
#define OnGameModeInit opa_obj_OnGameModeInit
//Neue Funktionen seit 5.0:
new _opaIntReturn[3],Float:_opaFloatReturn[3];
forward opa_intReturn(opa1,opa2);
public opa_intReturn(opa1,opa2)_opaIntReturn[opa1]=opa2;
forward opa_floatReturn(opa1,Float:opa2);
public opa_floatReturn(opa1,Float:opa2)_opaFloatReturn[opa1]=opa2;
stock opaGetObjectPos(opa1,&Float:opa2,&Float:opa3,&Float:opa4)
{
	if(!CallRemoteFunction("r_getObjectPos","d",opa1))return false;
	opa2=_opaFloatReturn[0];
	opa3=_opaFloatReturn[1];
	opa4=_opaFloatReturn[2];
	return true;
}
stock opaGetObjectRot(opa1,&Float:opa2,&Float:opa3,&Float:opa4)
{
	if(!CallRemoteFunction("r_getObjectRot","d",opa1))return false;
	opa2=_opaFloatReturn[0];
	opa3=_opaFloatReturn[1];
	opa4=_opaFloatReturn[2];
	return true;
}
stock GetObjectVirtualWorld(opa1)
{
	if(!CallRemoteFunction("r_getObjectVirtualWorld","d",opa1))return 0;
	return _opaIntReturn[0];
}
stock GetObjectVirtualInterior(opa1)
{
	if(!CallRemoteFunction("r_getObjectInterior","d",opa1))return 0;
	return _opaIntReturn[0];
}
stock opaIsValidObject(opa1)
{
	if(!CallRemoteFunction("r_isValidObject","d",opa1))return false;
	return true;
}
stock GetObjectPosEx(opa1,&Float:opa2,&Float:opa3,&Float:opa4)return GetObjectPos(opa1,opa2,opa3,opa4);
stock GetObjectRotEx(opa1,&Float:opa2,&Float:opa3,&Float:opa4)return GetObjectRot(opa1,opa2,opa3,opa4);
stock IsValidObjectEx(opa1)return IsValidObject(opa1);
#define GetObjectPos opaGetObjectPos
#define GetObjectRot opaGetObjectRot
#define IsValidObject opaIsValidObject
