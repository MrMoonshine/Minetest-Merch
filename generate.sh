MAX_SIZE=1024

rm textures/canvas_small.png
rm textures/canvas.png
rm textures/canvas_large.png
rm textures/canvas_extra_large.png

echo "Converting JPGs to PNGs....."
for x in textures/*.jpg; do
    #remove .jpg suffix
    y=$(echo $x | cut -d "." -f 1) 
    magick $x $y.png
    rm $x
done

echo "Converting JPEGs to PNGs....."
for x in textures/*.jpeg; do
    #remove .jpg suffix
    y=$(echo $x | cut -d "." -f 1) 
    magick $x $y.png
    rm $x
done

echo "Resizing PNGs"
for z in textures/*.png; do
    imgname=$(echo $z | cut -d "." -f 1) 
    #echo $imgname
    convert $z -resize $(echo $MAX_SIZE)x$(echo $MAX_SIZE) -gravity center -background none -extent $(echo $MAX_SIZE)x$(echo $MAX_SIZE) $z
done

echo "Generate LUA data structure.........."
echo 'img_locs = [[' > images.lua
ls textures/ | grep '.png' >> images.lua
echo ']]' >> images.lua

echo "Copying canvas textures...."

cp textures/crafting_items/*.png textures/
