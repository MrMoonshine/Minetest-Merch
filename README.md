# Minetest-Merch
* Infinite paintings for Minetest

This mod generates a bunch of usable paintings into the game.
Paintings are generated by a bash script using ImageMagick. (linux only)
The generated painting's sizes are 1024x1024.
If your image is a rectangle, it's longer side will be cropped to 1024 pixels and the remaining space will be filled with transparency.

Dump all your desired Minetest-paintings into the textures folder and run the script. (.png, .jpg, .jpeg)
to execute the script execute the following:
> user@host:\~/mods/merch$ chmod u+x generate.sh
> user@host:\~/mods/merch$ ./generate.sh
