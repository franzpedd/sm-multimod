# Multimods

## What is it?
This plugin allows a server to handle different plugins and configs per map.


## Installation 

#### Method 1
1) Place the compiled binary inside your plugins folder, as usual.
2) Use this repo's examples for "de_dust2" and "cs_office" in order to configuring this plugin.

#### Method 2
1) Place the compiled binary inside your plugins folder, as usual.
2) Create "configs\multimods\multimods.ini" inside your configs folder.
3) Make the KeyValue root field "Multimod Plugins"
    * Any child node inside it must follow 
```
  "Example plugin 1"
  {
      "File"  "pluginname.smx"
  }
```
4) Make the KeyValue root field "Multimod Maps"
    * Any child node inside it must follow
```
  "mapname"
  {
      "Configs"   "path\relative\to\cfg\customfolder\customfile.cfg"
      "Plugins"   "path\relative\to\addons\sourcemod\config\customfolder\customfile.cfg"
  }
```

5) Create the "Configs" config file and edit it as any .cfg file
6) List the "Plugins" config file and Make a KeyValue root field with the a custom name.
    * Any child node inside it must follow
```
  "Example plugin 1"
  {
      "File"  "pluginname.smx"
  }
```

## Lifetime of the plugin
On map start it'll unload all plugins listed in the first KeyValue root field inside "configs\multimods\multimods.ini" 
It'll then search for the current map's name in the second KeyValue root field inside "configs\multimods\multimods.ini"
Plugins and Configs key fields will be read and if it's path is valid, the plugin's listed inside it and configs will be loaded/executed.

## Notes
1) Any plugin that is not listed on "configs\multimods\multimods.ini" will work accross all mods.
2) A mod plugins.cfg is relative to "addons\sourcemod\configs" folder.
3) A mod configs.cfg is relative to "cfg" folder.
