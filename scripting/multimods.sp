#pragma newdecls required;
#pragma semicolon 1;

#include <sourcemod>

#define MULTIMODS_PATH "addons/sourcemod/configs/multimods/multimods.ini"
#define MULTIMODS_PLUGINS "addons/sourcemod/configs/multimods/plugins.cfg"

public Plugin myinfo =
{
	name = "Multimods",
	author = "franzpedd",
	description = "manages plugins for each map by it's own plugins.cfg file",
	version = "0.0.1",
	url = "http://www.github.com/franzpedd/"
};

public void OnMapStart()
{
    UnloadPlugins();
    LoadPlugins();
}

void UnloadPlugins()
{
    if(FileExists(MULTIMODS_PLUGINS))
    {
        File pluginfile = OpenFile(MULTIMODS_PLUGINS, "r");
        char linebuffer[MAX_NAME_LENGTH];
        
        while(ReadFileLine(pluginfile, linebuffer, sizeof(linebuffer)))
        {
            ServerCommand("sm plugins unload %s", linebuffer);
        }

        CloseHandle(pluginfile);
    }
}

void LoadPlugins()
{
    char newmod[PLATFORM_MAX_PATH];

    if(FileExists(MULTIMODS_PATH))
    {
        KeyValues kv = new KeyValues("Multimod Maps");
        kv.ImportFromFile(MULTIMODS_PATH);

        do
        {
            char sname[128];
            kv.GetSectionName(sname, sizeof(sname));

            if(StrEqual("Multimod Maps", sname))
            {
                char mapname[64];
                GetCurrentMap(mapname, sizeof(mapname));
                
                if(kv.JumpToKey(mapname))
                {
                    kv.GetString("Plugins", newmod, sizeof(newmod));
                }
            }
        }
        while(kv.GotoNextKey());

        delete kv;
    }

    if(FileExists(newmod))
    {
        File pluginfile = OpenFile(newmod, "r");
        char linebuffer[MAX_NAME_LENGTH];

        while(ReadFileLine(pluginfile, linebuffer, sizeof(linebuffer)))
        {
            ServerCommand("sm plugins load %s", linebuffer);
        }

        CloseHandle(pluginfile);
    }
}