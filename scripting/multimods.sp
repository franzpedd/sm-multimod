/*
    Lifetime of the plugin
        Plugin starts, a call for the plugins to be reset is made. This makes the previous loaded map to have it's plugin
        file to be read and unloaded. This exists in order to avoid conflicts whenever the server crashes.

        When a map starts the multimod.ini get's read and tries to find the map inside it. If found, it'll fill a global
        variable with it's configuration.
        After that, a call to load the plugins for that map is made.

        When a map ends the multimod.ini get's read once more in search of the previous-map field in order to unload it's
        list of plugins, it's made this way to avoid checking the whole plugins or avoid a list of always available 
        plugins.
        After found, the plugins are then unloaded.

*/
#pragma newdecls required;
#pragma semicolon 1;

#include <sourcemod>
#include <multimods>

Mod g_Mod;

public Plugin myinfo =
{
	name = "Multimods",
	author = "franzpedd",
	description = "manages plugins for each map",
	version = "0.0.1",
	url = "http://www.github.com/franzpedd/"
};

public void OnMapStart()
{
    QueryMod();
    ManagePlugins(Load);
}

public void OnMapEnd()
{
    ManagePlugins(Unload);
}

public void OnPluginStart()
{
    ClearCache(Read);
}

public void OnPluginEnd()
{
    ClearCache(Write);
}

void QueryMod()
{
    char mapname[64];
    GetCurrentMap(mapname, sizeof(mapname));

    char mmfile[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, mmfile, sizeof(mmfile), "configs/multimod/multimod.ini");

    KeyValues kv = new KeyValues("Multimod Maps");
    kv.ImportFromFile(mmfile);

    if(kv.JumpToKey(mapname))
    {
        char path[PLATFORM_MAX_PATH];
        g_Mod.id = kv.GetNum("id");
        kv.GetString("name", g_Mod.name, sizeof(g_Mod.name));
        kv.GetString("plugins", path, sizeof(path));
        BuildPath(Path_SM, g_Mod.dir_plugins, sizeof(g_Mod.dir_plugins), path); 
    }

    delete kv;
}

void ManagePlugins(Operation operation)
{
    if(FileExists(g_Mod.dir_plugins) && g_Mod.id != 0)
    {
        File file = OpenFile(g_Mod.dir_plugins, "r");
        char linebuffer[256];

        while(ReadFileLine(file, linebuffer, sizeof(linebuffer)))
        {
            ReplaceString(linebuffer, sizeof(linebuffer), "\n", "", false);
            ReplaceString(linebuffer, sizeof(linebuffer), ".smx", "", false);

            char enabled[128];
            char disabled[128];
            BuildPath(Path_SM, enabled, sizeof(enabled), "plugins/%s", linebuffer);
            BuildPath(Path_SM, disabled, sizeof(disabled), "plugins/disabled/%s", linebuffer);

            if(operation == Load)
            {
                RenameFile(enabled, disabled);
                ServerCommand("sm plugins load %s", linebuffer);
            }
            
            else if(operation == Unload)
            {
                RenameFile(disabled, enabled);
                ServerCommand("sm plugins unload %s", linebuffer);
            }
        }

        CloseHandle(file);
    }
}

void ClearCache(Operation operation)
{
    char mapname[64];
    GetCurrentMap(mapname, sizeof(mapname));

    char mmfile[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, mmfile, sizeof(mmfile), "configs/multimod/multimod.ini");

    KeyValues kv = new KeyValues("Multimod Configs");
    kv.ImportFromFile(mmfile);

    if(kv.JumpToKey("last-mod"))
    {
        if(operation == Write)
        {
            kv.SetNum("id", 0);
            kv.SetString("name", "");
            kv.SetString("plugins", "");
        }

        else if(operation == Read)
        {
            char path[PLATFORM_MAX_PATH];
            g_Mod.id = kv.GetNum("id");
            kv.GetString("name", g_Mod.name, sizeof(g_Mod.name));
            kv.GetString("plugins", path, sizeof(path));
            BuildPath(Path_SM, g_Mod.dir_plugins, sizeof(g_Mod.dir_plugins), path); 
        }
    }

    delete kv;

    ManagePlugins(Unload);

    g_Mod.id = 0;
    g_Mod.name = "Default";
    BuildPath(Path_SM, g_Mod.dir_plugins, sizeof(g_Mod.dir_plugins), "plugins/");
}