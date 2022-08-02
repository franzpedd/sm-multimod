/*

*/
#pragma newdecls required;
#pragma semicolon 1;

#include <sourcemod>
#include <multimod>

Mod g_Mod;

public Plugin myinfo =
{
	name = "Multimod",
	author = "franzpedd",
	
	version = "0.0.1",
	url = "http://www.github.com/franzpedd/"
};

public void OnMapStart()
{
    LoadModInfo();
}

public void OnPluginStart()
{
    RegAdminCmd("mm_debug", Cmd_mm_debug, ADMFLAG_BAN);
}

/**
 * For now only shows the debugging stuff
**/
public Action Cmd_mm_debug(int client, int argc)
{
    PrintToChat(client, "Mod id %d", g_Mod.id);
    PrintToChat(client, "Mod name %s", g_Mod.name);
    PrintToChat(client, "Mod configs %s", g_Mod.dir_configs);
    PrintToChat(client, "Mod plugins %s", g_Mod.dir_plugins);

    return Plugin_Continue;
}

/**
 * Loads a mod configuration from the multimods file
**/
void LoadModInfo()
{
    char mapname[64];
    GetCurrentMap(mapname, sizeof(mapname));

    char mmfile[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, mmfile, sizeof(mmfile), "configs/multimod/multimod.ini");

    KeyValues kv = new KeyValues("Multimod");
    kv.ImportFromFile(mmfile);

    if(!kv.GotoFirstSubKey())
    {
        delete kv;
        return;
    }

    if(kv.JumpToKey(mapname))
    {
        char configs[PLATFORM_MAX_PATH];
        char plugins[PLATFORM_MAX_PATH];

        g_Mod.id = kv.GetNum("id");
        kv.GetString("name", g_Mod.name, sizeof(g_Mod.name));
        kv.GetString("configs", configs, sizeof(configs));
        kv.GetString("plugins", plugins, sizeof(plugins));

        BuildPath(Path_SM, g_Mod.dir_configs, sizeof(g_Mod.dir_configs), configs);
        BuildPath(Path_SM, g_Mod.dir_plugins, sizeof(g_Mod.dir_plugins), plugins);
    }

    else
    {
        g_Mod.id = 0;
        g_Mod.name = "Default";
        BuildPath(Path_SM, g_Mod.dir_configs, sizeof(g_Mod.dir_configs), "configs/");
        BuildPath(Path_SM, g_Mod.dir_plugins, sizeof(g_Mod.dir_plugins), "plugins/");
    }

    delete kv;
}