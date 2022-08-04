#pragma newdecls required;
#pragma semicolon 1;

#include <sourcemod>

#define INI "configs/multimods/multimods.ini"

public Plugin myinfo =
{
	name = "Multimods",
	author = "franzpedd",
	description = "manages plugins for each map by it's own plugins.cfg file",
	version = "1.0",
	url = "http://www.github.com/franzpedd/"
};

public void OnMapStart()
{
    UnloadMultimodPlugins();
    LoadCurrentMapPlugins();
}

void UnloadMultimodPlugins()
{
    char multimods[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, multimods, sizeof(multimods), INI);

    if(FileExists(multimods))
    {
        KeyValues kv = new KeyValues("Multimod Plugins");
        kv.ImportFromFile(multimods);

        if(kv.GotoFirstSubKey())
        {
            do
            {
                char plugin[MAX_NAME_LENGTH];
                kv.GetString("File", plugin, sizeof(plugin));
                ServerCommand("sm plugins unload %s", plugin);
            }
            while(kv.GotoNextKey());

            kv.GoBack();
        }

        delete kv;
    }
}

void LoadCurrentMapPlugins()
{
    char multimods[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, multimods, sizeof(multimods), INI);

    char newmod[PLATFORM_MAX_PATH];
    char newcfg[PLATFORM_MAX_PATH];
    char configs[PLATFORM_MAX_PATH];

    BuildPath(Path_SM, configs, sizeof(configs), "configs");

    if(FileExists(multimods))
    {
        KeyValues kv = new KeyValues("Multimod Maps");
        kv.ImportFromFile(multimods);

        do
        {
            char sname[64];
            kv.GetSectionName(sname, sizeof(sname));

            if(StrEqual(sname, "Multimod Maps"))
            {
                char mapname[64];
                GetCurrentMap(mapname, sizeof(mapname));

                if(kv.JumpToKey(mapname))
                {
                    char ncfg[PLATFORM_MAX_PATH];
                    char nmod[PLATFORM_MAX_PATH];

                    kv.GetString("Configs", ncfg, sizeof(ncfg));
                    kv.GetString("Plugins", nmod, sizeof(nmod));  

                    BuildPath(Path_SM, newcfg, sizeof(newcfg), ncfg);
                    Format(newmod, sizeof(newmod), "%s\\%s", configs, nmod);
                } 
            }
        } while(kv.GotoNextKey());

        delete kv;
    }

    if(FileExists(newmod))
    {
        KeyValues kv = new KeyValues("Multimod Plugins");
        kv.ImportFromFile(newmod);

        if(kv.GotoFirstSubKey())
        {
            do
            {
                char plugin[MAX_NAME_LENGTH];
                kv.GetString("File", plugin, sizeof(plugin));
                ServerCommand("sm plugins load %s", plugin);
            }
            while(kv.GotoNextKey());

            kv.GoBack();
        }

        delete kv;
    }

    char cfgdir[PLATFORM_MAX_PATH];
    Format(cfgdir, sizeof(cfgdir), "cfg/%s", newcfg);

    if(FileExists(cfgdir))
    {
        ServerCommand("exec %s", newcfg);
    }
}