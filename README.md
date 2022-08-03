# sm-multimod

## Description
It allows the server to handle a separate plugins list for each map.

## Support
This plugin should work on any Sourcemod compatible game but it was only tested on Counter-Strike Global Offensive.

## Usage
There's two examples on this repository, you can just follow along or:
* Declare a new plugin list by mapname inside "configs/multimods/multimods.ini".
* Create the file that will hold the plugin list, this must be the same declared on "configs/multimods/multimods.ini".
* Place your compiled plugin as usual, inside the plugins folder.
* Write the plugin's name.smx "configs/multimods/plugins.cfg"
* Write the lugin's name.smx in the declared plugin list.
* Done, now that map will only load the plugins listed for that map + plugins not listed inside "configs/multimods/plugins.cfg".

## Lifetime of the plugin
On map start it'll unload all plugins loaded inside "configs/multimods/plugins.cfg"
It'll then load the plugins listed inside the currentmap plugin list, if available.

## TODO:
Fuse "configs/multimods/plugins.cfg" and "configs/multimods/multimods.ini" as one KeyValue file, using "Multimod Maps" and "Multimod Plugins" as the roots.
