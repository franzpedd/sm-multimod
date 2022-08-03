#if defined _multimods_included
 #endinput
#endif
#define _multimods_included

enum struct Mod
{
    int id;
    char name[128];
    char dir_plugins[256];
}

enum Operation
{
    Load,
    Unload,
    Write,
    Read
}