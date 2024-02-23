/*-----------------------------------------------------------------------------
	Title: 			jBan - The MySQL Ban API
	Version:		1
	Author: 		JaTochNietDan (http://www.jatochnietdan.com)
	Description:
					jBan allows users to create their own SA-MP PAWN gamemodes
					and filterscripts while being able to use jBan as their
					system for handling bans in a MySQL database. I've done my
					best to make this include as compatible as possible with
					other scripts, it uses hooks and other methods as
					prevention against conflicts with other scripts
					and user generated errors.

	Credits to:
					G-sTyLeZzZ for his MySQL plugin.
					Y_Less for his sscanf function and hooking methods.
-------------------------------------------------------------------------------*/

//--------------------------------------------
// The name of the ban table
//--------------------------------------------
#define J_TABLE samp_ban

//--------------------------------------------
// Set this to 1 to enable logging
//--------------------------------------------
#define J_LOGGING 1
#define MAX_PLAYER_IP 15
#define MAX_QUERY_LENGTH 400
#define MAX_RESULT_LENGTH 74
#define MAX_MESSAGE_LENGTH 128
#define MAX_REASON_LENGTH 50

#define QUERY_INITIALIZE 100
#define QUERY_BAN 101
#define QUERY_CHECKNAME 102
#define QUERY_UNBAN_NAME 103
#define QUERY_UNBAN_IP 104


new
	jNames[MAX_PLAYERS][MAX_PLAYER_NAME],
	jIP[MAX_PLAYERS][MAX_PLAYER_IP];

new
	jBan_Name[MAX_PLAYER_NAME],
	jBan_Reason[MAX_REASON_LENGTH],
	jBan_Message[MAX_MESSAGE_LENGTH],
	jBan_Time,
	jQuery[MAX_QUERY_LENGTH],
	jResult[MAX_RESULT_LENGTH];

/*-------------------------------------------------------------------
native jBan(pplayer_banned, player_banner, reason[], time = 0);

	Usage:
 			Use this to ban a selected player for a certain amount
			of time.

	Params:
			player_banned - The ID of the player to be banned
			player_banner - The ID of the player banning the player
			reason - The reason for the ban (Optional)
			time - The amount of the ban will last in minutes (Optional)

	Note:
			If a time is not specified, it will default to a
			permanent ban.
-------------------------------------------------------------------*/
stock jBan(player_banned, player_banner, reason[], time = 0)
{
	format(jQuery, MAX_QUERY_LENGTH, "INSERT INTO `"#J_TABLE"` (user_banned, user_banned_ip, user_banner, ban_reason, ban_timestamp, ban_time) VALUES ('%s', '%s', '%s', '%s', CURRENT_TIMESTAMP, %d)", jNames[player_banned], jIP[player_banned], jNames[player_banner], reason, time);
	mysql_function_query(GTADM,jQuery,false,"","");

	Kick(player_banned);

	#if J_LOGGING == 1
		printf("[tBan]: Player \"%s\" (%s) banned by \"%s\" with reason \"%s\" for %d minutes", jNames[player_banned], jIP[player_banned], jNames[player_banner], reason, time);
	#endif
	return 1;
}

/*-------------------------------------------------------------------
 native jBanCheck(playerid);

	Usage:
 			This function will find a player with an un-expired
			ban or a permanent ban and remove them from the
			server with the reason of their ban, the time left
			and the person that banned them.

	Params:
			playerid - ID of the player to check for ban

	Note:
			This function is already hooked and does not need
			to be called manually for any circumstances.
-------------------------------------------------------------------*/
stock jBanCheck(playerid)
{
	format(jQuery, MAX_QUERY_LENGTH, "SELECT user_banner, ban_reason, TIMESTAMPDIFF(MINUTE, NOW(), DATE_ADD(ban_timestamp, INTERVAL ban_time MINUTE)) FROM `"#J_TABLE"` WHERE user_banned_ip = '%s' AND (NOW() <= DATE_ADD(ban_timestamp, INTERVAL ban_time MINUTE) OR ban_time = 0)", jIP[playerid]);

	mysql_store_result();
	if(mysql_num_rows() > 0)
	{
	   mysql_fetch_row(jResult);
	   sscanf(jResult, "p<|>s[24]s[50]i", jBan_Name, jBan_Reason, jBan_Time);
       if(jBan_Time > 0)
       {
            format(jBan_Message, MAX_MESSAGE_LENGTH, "you have been temporary banned from this server your ban will expire in %d minutes!", jBan_Time);
            SendClientMessage(playerid, 0xFF0000FF, jBan_Message);

            Kick(playerid);
       }
	}
	mysql_free_result();
	return 1;
}

/*-------------------------------------------------------------------
 native jUnbanName(name[], bool:expired = false);

	Usage:
 			This function will remove bans for a specified name.

	Params:
			name[] - The name of the player as a string.
			bool:expired - Remove expired bans or not.

	Note:
			If expired is not set, it will not removed expired
			bans by default, it will only remove active bans.
-------------------------------------------------------------------*/
stock jUnbanName(name[], bool:expired = false)
{
	if(strlen(name) > MAX_PLAYER_NAME) return 0;

	mysql_real_escape_string(name, name);

	if(expired == false) format(jQuery, MAX_QUERY_LENGTH, "DELETE FROM `"#J_TABLE"` WHERE user_banned = '%s' AND NOW() <= DATE_ADD(ban_timestamp, INTERVAL ban_time MINUTE)", name);
	else format(jQuery, MAX_QUERY_LENGTH, "DELETE FROM `"#J_TABLE"` WHERE user_banned = '%s'", name);

	mysql_function_query(GTADM,jQuery,false,"","");
	return 1;
}

/*-------------------------------------------------------------------
 native jUnbanIP(IP[], bool:expired = false);

	Usage:
 			This function will remove bans for a specified IP address.

	Params:
			IP[] - The name of the player as a string.
			bool:expired - Remove expired bans or not.

	Note:
			If expired is not set, it will not removed expired
			bans by default, it will only remove active bans.
-------------------------------------------------------------------*/
stock jUnbanIP(IP[], bool:expired = false)
{
	if(strlen(IP) > MAX_PLAYER_IP) return 0;

	mysql_real_escape_string(IP, IP);

	if(expired == false) format(jQuery, MAX_QUERY_LENGTH, "DELETE FROM `"#J_TABLE"` WHERE user_banned_ip = '%s' AND NOW() <= DATE_ADD(ban_timestamp, INTERVAL ban_time MINUTE)", IP);
	else format(jQuery, MAX_QUERY_LENGTH, "DELETE FROM `"#J_TABLE"` WHERE user_banned_ip = '%s'", IP);

	mysql_function_query(GTADM,jQuery,false,"","");
	return 1;
}

stock jban_SetPlayerName(playerid, name[])
{
    format(jNames[playerid], MAX_PLAYER_NAME, name);
    return SetPlayerName(playerid, name);
}

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, jNames[playerid], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, jIP[playerid], MAX_PLAYER_IP);
	jBanCheck(playerid);
	return CallLocalFunction("jban_OnPlayerConnect", "i", playerid);
}




#if defined _ALS_SetPlayerName
    #undef SetPlayerName
#else
    #define _ALS_SetPlayerName
#endif
#define SetPlayerName jban_SetPlayerName
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect jban_OnPlayerConnect
forward jban_SetPlayerName(playerid, name[]);
forward jban_OnPlayerConnect(playerid);
