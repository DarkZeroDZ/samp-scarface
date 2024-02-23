/*
	
	@functions (Scripters Only)
        Spray::givePlayerPermission( clientid, bool:permissionToggle ) - 		Allows you to give permission to a sprayer.
        Spray::createSprayAtPlayerPos( clientid ) - 							Creates a spray at the player's position.
        Spray::Delete( sprayID ) - 												Deletes a spray.
        Spray::Load( ) - 														Loads sprays, already called on server start.
        Spray::doesPlayerHavePermission( clientid ) - 							Checks if a player has spraying permission.
        OnPlayerReceiveSprayPermission( playerid, errorID ) - 					Called during Spray::givePlayerPermission
        OnPlayerCreateSpray( playerid ) - 										When someone performs a spray.
        OnSprayDelete( sprayID ) - 												Called when a spray is deleted.
	@commands
	
	@errors
		1 - Error with sending / giving permission.
		2 - Player is not connected.
	@credits
	    Cyanide - 		Project Launcher & Developer
	    Bakr - 			Helping with trigonometry functions.
	    Y_Less -        YSI
	    Incognito -     Global Variable plugin.
	    SA-MP Team - 	San Andreas Multiplayer Modification.

*/
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#include <a_samp> 		// Package 0.3c RC3  | http://www.sa-mp.com
#include <gvar>   		// Version 1.3       | http://forum.sa-mp.com/showthread.php?t=151076
#include <YSI\y_hooks>  // N/A               | http://forum.sa-mp.com/showthread.php?p=884701

#if defined sprayTag_included
	#endinput
#endif
#define sprayTag_included
#define Spray:: Spray_
#define SPRAY_DIALOG_0      (90)
#define SPRAY_DIALOG_1      (100)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
forward OnPlayerReceiveSprayPermission( playerid, errorID );
forward OnPlayerCreateSpray( playerid );
forward OnSprayDelete( sprayID );
forward OnSprayLoaded( sprayID );
forward OnSpraySaved( sprayID );
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
stock
	totalSprays = 1,
	sp_g_string[ 300 ],
	DB:spray_db,
	DBResult:spray_q_result
;

stock
	jump_anims[ ][ ] =
	{
	    "JUMP_glide",
		"JUMP_land",
		"JUMP_launch",
		"JUMP_launch_R",
		"FALL_FALL"
	};
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Hook:spray_OnFilterScriptExit()
{
	for( new i; i != totalSprays; i ++ )
		Spray::Save( i );
}

Hook:spray_OnGameModeExit()
{
	for( new i; i != totalSprays; i ++ )
		Spray::Save( i );
}

Hook:spray_OnFilterScriptInit()
{
	Spray::Load( );
}

Hook:spray_OnGameModeInit()
{
	Spray::Load( );
}

Hook:spray_OnPlayerKeyStateChange( playerid, newkeys, oldkeys )
{
    if( Spray::doesPlayerHavePermission( playerid ) && ( GetPlayerWeapon( playerid ) == 41 ) && (newkeys & (KEY_FIRE)) == (KEY_FIRE))
	{
	    if( GetPlayerAnimationIndex( playerid ) )
	    {
	  		static
				s_animName[ 32 ]
			;
			GetAnimationName( GetPlayerAnimationIndex( playerid ), sp_g_string, sizeof sp_g_string, s_animName, sizeof s_animName );
			if( !strcmp( sp_g_string, "PED", true ) )
	  			for( new i; i != sizeof jump_anims; i ++ )
			    	if( !strcmp( s_animName, jump_anims[ i ], true ) )
						return true;
	    }
        ShowPlayerDialog( playerid, SPRAY_DIALOG_0, DIALOG_STYLE_MSGBOX, "Graffiti", "Möchtest du ein Gang Graffiti sprühen?", "Ja", "Nein" );
	}
	return true;
}

Hook:spray_OnDialogResponse( clientid, dialogid, response, listitem, inputtext[ ] )
{
	switch( dialogid )
	{
	    case SPRAY_DIALOG_0:
	    {
	        if( response )
		    	ShowPlayerDialog( clientid, SPRAY_DIALOG_1, DIALOG_STYLE_LIST, "Graffiti Menü", "Varrio Los Aztecas\nGrove Street\nRollin' Heights Ballas\nLos Santos Vagos", "Sprühen", "Abbrechen" );
		}
		case SPRAY_DIALOG_1:
		{
		    if( response )
			{
			    switch( listitem )
			    {
	                case 0:
			    Spray::createSprayAtPlayerPos( clientid, 18661 );
	                case 1:
			    Spray::createSprayAtPlayerPos( clientid, 18659 );    
                 	case 2:
	                    Spray::createSprayAtPlayerPos( clientid, 18667 );
	                case 3:
			    Spray::createSprayAtPlayerPos( clientid, 18665 );
	                    
			    }
			}
		}
	}
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
stock Spray::Save( id )
{
	spray_db = db_open( "sprays.db " );
	
	format( sp_g_string, sizeof sp_g_string, "SELECT SQLID FROM `sprays` WHERE SQLID = %i", id );
	spray_q_result = db_query( spray_db, sp_g_string );
	GetGVarString( "spray_name", sp_g_string, .id = id );
	if( db_num_rows( spray_q_result ) )
	{
	    format( sp_g_string, sizeof sp_g_string, "UPDATE `sprays` SET sprayer = '%s', object = %i, pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f' WHERE SQLID = %i", sp_g_string, GetGVarInt( "spray_object", id ), GetGVarFloat( "spray_x", id ), GetGVarFloat( "spray_y", id ), GetGVarFloat( "spray_z", id ), GetGVarFloat( "spray_a", id ), id);
        db_free_result( db_query( spray_db, sp_g_string ) );
 	}
 	else
 	{
 	    format( sp_g_string, sizeof sp_g_string, "INSERT INTO `sprays` (`sprayer`, `object`, `pos_x`, `pos_y`, `pos_z`, `pos_a`) VALUES('%s', %i, '%f', '%f', '%f', '%f');", sp_g_string, GetGVarInt( "spray_object", id ), GetGVarFloat( "spray_x", id ), GetGVarFloat( "spray_y", id ), GetGVarFloat( "spray_z", id ), GetGVarFloat( "spray_a", id ) );
		db_free_result( spray_q_result );
		db_free_result( db_query( spray_db, sp_g_string ) );
 	}
	db_close( spray_db );
	CallRemoteFunction( "OnSpraySaved", "i", id );
}

stock Spray::Load( )
{
	sp_g_string = "CREATE TABLE IF NOT EXISTS `sprays` ( 	\
  				SQLID INTEGER PRIMARY KEY AUTOINCREMENT,\
  				sprayer VARCHAR(24), 					\
  				object INTEGER,               			\
			    pos_x FLOAT, 							\
			    pos_y FLOAT, 							\
			    pos_z FLOAT,							\
			    pos_a FLOAT 							\
				)";
	spray_db = db_open( "sprays.db " );
	db_free_result( db_query( spray_db, sp_g_string ) );

	spray_q_result = db_query( spray_db, "SELECT * FROM sprays" );
	if( !db_num_rows( spray_q_result ) )
	    db_free_result( spray_q_result );
	else
	{
	    totalSprays = db_num_rows( spray_q_result );
	    for( new i; i != totalSprays + 1; ++ i )
	    {
	        db_get_field_assoc(spray_q_result, "pos_x", sp_g_string, 10);
	        SetGVarFloat( "spray_x", floatstr( sp_g_string ), i );
	        db_get_field_assoc(spray_q_result, "pos_y", sp_g_string, 10);
	        SetGVarFloat( "spray_y", floatstr( sp_g_string ), i );
	        db_get_field_assoc(spray_q_result, "pos_z", sp_g_string, 10);
	        SetGVarFloat( "spray_z", floatstr( sp_g_string ), i );
	        db_get_field_assoc(spray_q_result, "pos_a", sp_g_string, 10);
	        SetGVarFloat( "spray_a", floatstr( sp_g_string ), i );
	        db_get_field_assoc(spray_q_result, "object", sp_g_string, 10);
	        SetGVarInt( "spray_object", strval( sp_g_string ), i );
	        db_get_field_assoc(spray_q_result, "sprayer", sp_g_string, MAX_PLAYER_NAME);
	        SetGVarString( "spray_name", sp_g_string, i );
	        
	        format( sp_g_string, sizeof sp_g_string, "Gesprüht von {008000}%s", sp_g_string );
			SetGVarInt( "spray3D", _:Create3DTextLabel( sp_g_string, 0xFF0000FF, GetGVarFloat( "spray_x", i ), GetGVarFloat( "spray_y", i ), GetGVarFloat( "spray_z", i ) + 1.0, 20.0, 0, 1 ), i);
	        
	        SetGVarInt( "sprayObject", CreateObject( GetGVarInt( "spray_object", i ), GetGVarFloat( "spray_x", i ), GetGVarFloat( "spray_y", i ), GetGVarFloat( "spray_z", i ), 0.0, 0.0, GetGVarFloat( "spray_a", i ) ), i );
	        
	        CallRemoteFunction( "OnSprayLoaded", "i", i );
	        db_next_row( spray_q_result );
	    }
	}
	db_close( spray_db );
}

stock Spray::createSprayAtPlayerPos( clientid, tag, Float:clientDistance = 1.2  )
{
	new
	    Float:player_pos[ 4 ]
	;
	GetPlayerPos( clientid, player_pos[ 0 ], player_pos[ 1 ], player_pos [ 2 ] );
	GetPlayerFacingAngle( clientid, player_pos[ 3 ] );
	player_pos[ 0 ] += clientDistance * floatsin( -player_pos[ 3 ], degrees );
	player_pos[ 1 ] += clientDistance * floatcos( -player_pos[ 3 ], degrees );
	player_pos[ 3 ] += 90.0;
	
	if( GetPlayerSpecialAction( clientid ) == SPECIAL_ACTION_DUCK )
	    SetGVarInt( "sprayObject", CreateObject( tag, player_pos[ 0 ], player_pos[ 1 ], player_pos[ 2 ] - 0.3, 0.0, 0.0, player_pos[ 3 ] ), totalSprays );
	else
		SetGVarInt( "sprayObject", CreateObject( tag, player_pos[ 0 ], player_pos[ 1 ], player_pos[ 2 ], 0.0, 0.0, player_pos[ 3 ] ), totalSprays );
		
    SetGVarFloat( "spray_x", player_pos[ 0 ], totalSprays );
    SetGVarFloat( "spray_y", player_pos[ 1 ], totalSprays );
    SetGVarFloat( "spray_z", player_pos[ 2 ], totalSprays );
    SetGVarFloat( "spray_a", player_pos[ 3 ], totalSprays );
    SetGVarInt( "spray_object", tag, totalSprays );
	GetPlayerName( clientid, sp_g_string, MAX_PLAYER_NAME );
	SetGVarString( "spray_name", sp_g_string, totalSprays );
	
	format( sp_g_string, sizeof sp_g_string, "Gesprüht von {008000}%s", sp_g_string );
	SetGVarInt( "spray3D", _:Create3DTextLabel( sp_g_string, 0xFF0000FF, player_pos[ 0 ], player_pos[ 1 ], player_pos[ 2 ] + 1.0, 20.0, 0, 1 ), totalSprays);
    Spray::Save( totalSprays );

	CallRemoteFunction( "OnPlayerCreateSpray", "i", clientid );
    
    ApplyAnimation( clientid, "SPRAYCAN", "spraycan_full", 4.0, 0, 0, 0, 0, 0 );
    
    totalSprays ++;
	return true;
}

stock Spray::Delete( sprayID )
{
	Delete3DTextLabel( Text3D:GetGVarInt( "spray3D", sprayID ) );
	DestroyObject( GetGVarInt( "sprayObject", sprayID ) );
	
	CallRemoteFunction( "OnSprayDelete", "i", sprayID );
    totalSprays --;
    return true;
}

stock Spray::givePlayerPermission( clientid, bool:permissionToggle )
{
	if( clientid == INVALID_PLAYER_ID )
	    return print( "Error: The Spray Tag System tried to give permission to a player who is not connected." ), CallRemoteFunction( "OnPlayerReceiveSprayPermission", "ii", clientid, 2 );

	if( GetPVarType( clientid, "spray_permission" ) && permissionToggle )
		return print( "Error: The Spray Tag System tried to give permission to a player who already has permission." ), CallRemoteFunction( "OnPlayerReceiveSprayPermission", "ii", clientid, 1 );

    if( !GetPVarType( clientid, "spray_permission" ) && !permissionToggle )
		return print( "Error: The Spray Tag System tried to remove permission to a player who doesn't have it already." ), CallRemoteFunction( "OnPlayerReceiveSprayPermission", "ii", clientid, 1 );


	if( permissionToggle )
		SetPVarInt( clientid, "spray_permission", 0);
		
	else if( !permissionToggle )
		DeletePVar( clientid, "spray_permission" );
		
	CallRemoteFunction( "OnPlayerReceiveSprayPermission", "ii", clientid, 0 );
	return true;
}

stock Spray::doesPlayerHavePermission( clientid )
	return GetPVarType( clientid, "spray_permission" ) ? true : false;
