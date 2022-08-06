# Multimods

## What is it?
This plugin allows a server to handle different plugins and configs per map.
   * It unloads all plugins inside ```plugins/multimods``` and loads back the selected ones for a given map.
   * It also exec a configuration file for the map.
      * Both as specified inside ```addons/sourcemod/configs/multimods.ini```

## Installation
   * Compile this plugin, it doesn't require any fancy stuff.
   * Paste the compiled binary inside the plugins folder.
   * Use this repo's files as guides, there's examples for ```cs_office``` and ```de_dust2```, or
      * Create ```addons/sourcemod/plugins/multimods``` folder
      * Create ```addons/sourcemod/configs/multimods.ini``` file
      
## Setting up a mod
   * ```addons/sourcemod/configs/multimods.ini``` is read as a KeyValues and must have the root key ```"Multimods"```, the key value system must follow something     like:
      ```
      "Multimods
      {
         "mapname"
         {
            "Configs"   "path\to\custom\configs.cfg" // relative to cfg folder
            "Plugins"   "path\to\custom\plugins.cfg" // relative to addons/sourcemod/configs folder
         }
      }
      ```
   * Create both ```Configs``` and ```Plugins``` custom paths. The ```Configs``` path works as any .cfg file you ```exec``` on console, but the ```Plugins``` also must follow a KeyValue system, like:
      ```
      "Custom mod Plugins"
      {
         "Custom Plugin Name"
         {
            "File"   "plugin_name.smx" // must be inside plugins/multimods
         }
      }
      ```
* Done, now any plugin installed under the standart sourcemod's folder will work accross all mods and all plugins under plugins/multimods will only work when a map get's loaded and has it's name inside it's list.
