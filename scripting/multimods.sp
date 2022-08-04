#pragma newdecls required;
#pragma semicolon 1;

#include <sourcemod>

#define DIR_MAPS "addons/sourcemod/configs/multimods/maps.cfg"
#define DIR_PLUGINS "addons/sourcemod/configs/multimods/plugins.cfg"

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
    UnloadMultimodPlugins();
    LoadCurrentMapPlugins();
}

void UnloadMultimodPlugins()
{
    if(FileExists(DIR_PLUGINS))
    {
        File pluginfile = OpenFile(DIR_PLUGINS, "r");
        char linebuffer[MAX_NAME_LENGTH];
        
        while(ReadFileLine(pluginfile, linebuffer, sizeof(linebuffer)))
        {
            if(StrContains(linebuffer, ".smx", true) > 0)
            {
                ParseLine(linebuffer, sizeof(linebuffer));
                ServerCommand("sm plugins unload %s", linebuffer);
            }
        }

        CloseHandle(pluginfile);
    }
}

void LoadCurrentMapPlugins()
{
    char newmod[PLATFORM_MAX_PATH];

    if(FileExists(DIR_MAPS))
    {
        KeyValues kv = new KeyValues("Multimod Maps");
        kv.ImportFromFile(DIR_MAPS);

        char sname[128];
        kv.GetSectionName(sname, sizeof(sname));

        char mapname[64];
        GetCurrentMap(mapname, sizeof(mapname));

        if(kv.JumpToKey(mapname))
        {
            kv.GetString("Plugins", newmod, sizeof(newmod));
            PrintToServer("Map %s Plugins file %s", mapname, newmod);
        }

        delete kv;
    }
    
    if(FileExists(newmod))
    {
        File pluginfile = OpenFile(newmod, "r");
        char linebuffer[MAX_NAME_LENGTH];
        
        while(ReadFileLine(pluginfile, linebuffer, sizeof(linebuffer)))
        {
            if(StrContains(linebuffer, ".smx", true) > 0)
            {
                ParseLine(linebuffer, sizeof(linebuffer));
                ServerCommand("sm plugins load %s", linebuffer);
            }
        }

        CloseHandle(pluginfile);
    }
}

void ParseLine(char[] linebuffer, int maxlength)
{
    char pname[MAX_NAME_LENGTH];
    char c[1];
    int qcount = 0;

    for(int i = 0; i < maxlength; i++)
    {
        if(qcount == 2) break;

        c[0] = linebuffer[i];
        if(strcmp(c[0], "\"") == 0) 
        {
            qcount++;
            continue;
        }

        if(qcount != 1) continue;

        else
        {
            StrCat(pname, sizeof(pname), c[0]);
        }
    }

    strcopy(linebuffer, maxlength, pname);
}