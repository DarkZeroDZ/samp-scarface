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
                 OCMD MODULE

---------------------------------------*/
#include <a_samp>
forward ocmdOnPlayerCommandText(playerid,cmdtext[]);
#define ocmd:%1(%2) forward ocmd_%1(%2);\
public ocmd_%1(%2)
public OnPlayerCommandText(playerid,cmdtext[])
{
    new ocmdStr[32],i=1;
	for(;i<128;i++)
	{
	    if(!cmdtext[i]||cmdtext[i]==' ')break;
	    ocmdStr[i-1]=tolower(cmdtext[i]);
	}
	format(ocmdStr,128,"ocmd_%s",ocmdStr);
	if(!strlen(cmdtext[i+1])&&CallLocalFunction(ocmdStr,"ds",playerid," "))return 1;
	if(CallLocalFunction(ocmdStr,"ds",playerid,cmdtext[i+1]))return 1;
	return CallLocalFunction("ocmdOnPlayerCommandText","ds",playerid,cmdtext);
}
#define OnPlayerCommandText ocmdOnPlayerCommandText
