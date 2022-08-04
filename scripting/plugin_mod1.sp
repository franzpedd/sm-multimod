/*
    This plugin pourpose is to help in testing the multimods plugin
*/

#pragma newdecls required;
#pragma semicolon 1;

#include <sourcemod>

public Plugin myinfo =
{
	name = "Mod 1",
	author = "franzpedd",
	description = "helps in testing the multimod plugins",
	version = "0.0.1",
	url = "http://www.github.com/franzpedd/"
};

public void OnPluginStart()
{
    RegConsoleCmd("mod1", CmdMod1);
}

public Action CmdMod1(int client, int argc)
{
	PrintToChat(client, "It's enabled");

	return Plugin_Handled;
}