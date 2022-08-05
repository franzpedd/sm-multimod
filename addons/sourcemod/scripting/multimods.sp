#pragma newdecls required;
#pragma semicolon 1;

#include <sourcemod>

#define CONFIGS_DIR "configs/multimods/multimods.ini"
#define PLUGINS_DIR "plugins/multimods"

public Plugin myinfo =
{
	name = "Multimods",
	author = "franzpedd",
	description = "manages plugins for each map by it's own plugins.cfg file",
	version = "2.0",
	url = "http://www.github.com/franzpedd/"
};

public void OnMapStart()
{
    UnloadMultimodsPlugins();
    LoadCurrentMapPlugins();
}

void UnloadMultimodsPlugins()
{
    char dir[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, dir, sizeof(dir), PLUGINS_DIR);

    if(!DirExists(dir))
    {
        SetFailState("[Multimods] Folder %s doesn't exists.", dir);
    }

    else
    {
        DirectoryListing pluginsdir = OpenDirectory(dir);

        char fname[PLATFORM_MAX_PATH];
        FileType ftype;

        while(ReadDirEntry(pluginsdir, fname, sizeof(fname), ftype))
        {
            if(ftype == FileType_File && StrContains(fname, ".smx") == strlen(fname) - 4)
            {
                ServerCommand("sm plugins unload multimods/%s", fname);
            }
        }
        CloseHandle(pluginsdir);
    }
}

void LoadCurrentMapPlugins()
{
    char configs[PLATFORM_MAX_PATH];
    char plugins[PLATFORM_MAX_PATH];
    
    char dir[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, dir, sizeof(dir), CONFIGS_DIR);

    char mapname[64];
    GetCurrentMap(mapname, sizeof(mapname));

    if(FileExists(dir))
    {
        KeyValues kv = new KeyValues("Multimods");
        kv.ImportFromFile(dir);

        if(kv.JumpToKey(mapname))
        {
            char keyname[PLATFORM_MAX_PATH];
            kv.GetString("Configs", configs, sizeof(configs));
            kv.GetString("Plugins", keyname, sizeof(keyname));
            BuildPath(Path_SM, plugins, sizeof(plugins), "configs/%s", keyname);
        }

        delete kv;
    }

    if(FileExists(plugins))
    {
        KeyValues kv = new KeyValues("Custom mod Plugins");
        kv.ImportFromFile(plugins);

        if(kv.GotoFirstSubKey())
        {
            do
            {
                char plugin[64];
                kv.GetString("File", plugin, sizeof(plugin));
                ServerCommand("sm plugins load multimods/%s", plugin);
            } while(kv.GotoNextKey());
        }

        delete kv;
    }

    char cfgdir[PLATFORM_MAX_PATH];
    Format(cfgdir, sizeof(cfgdir), "cfg/%s", configs);

    if(FileExists(cfgdir))
    {
        ServerCommand("exec %s", configs);
    }
}