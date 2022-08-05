#pragma newdecls required;
#pragma semicolon 1;

#include <sourcemod>

public Plugin myinfo =
{
	name = "Hostage Example",
	author = "franzpedd",
	description = "helps in testing the multimod plugins",
	version = "0.0.1",
	url = "http://www.github.com/franzpedd/"
};

public void OnPluginStart()
{
    RegConsoleCmd("cs", Cmd_cs);
}

public Action Cmd_cs(int client, int argc)
{
	PrintToChat(client, "It's enabled");

	return Plugin_Handled;
}