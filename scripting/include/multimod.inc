#if defined _multimod_included
 #endinput
#endif
#define _multimod_included

enum struct Mod
{
    int id;
    char name[128];
    char dir_configs[256];
    char dir_plugins[256];
}