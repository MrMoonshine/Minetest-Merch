dofile(minetest.get_modpath("merch").."/images.lua")

--This function returns all files from textures and generates 
--an item id, a display name and the filename
function fetchImg()
    local idl = {};
    --local f = io.popen("ls textures/ | grep '.png'")
    local f = img_locs
    f = string.gsub(f,"-","_")

    --print("[merch]")
    --print(f)
if f then
    local i = 0
    for line in f:gmatch("([^\n]*)\n") do
        local fnam = line             --filename
        local inam = string.gsub(fnam,".png","")    --item-name
        inam = string.lower(inam)
        local dnam = string.gsub(line,".png","")    --display-name
        dnam = string.gsub(dnam,"_"," ")            --replace _ with spaces

        --print(inam.." <-> "..fnam.." <-> "..dnam)
        
        --table.insert(idl,{inam,fnam,dnam})
        idl[i] = {inam,fnam,dnam}
        i = i + 1
    end
else
    print("[merch] Failure: No Images Found")
end
    return idl
end

--Nodes are Wall paintings
function generateNodes(properties)
    for pid in pairs(properties) do
        local name = "merch:painting_"..properties[pid][1]
        local tex = properties[pid][2]
        local dname = "Painting "..properties[pid][3]
        --print("[merch] New painting added:"..name.." <-> "..tex.." <-> "..dname)
        minetest.register_node(name,{
           description = dname,
           drawtype = "signlike",
           visual_scale = 3.0,
           inventory_image = tex,
           wield_image = tex,
           tiles = {tex},
           paramtype = "light",
	        paramtype2 = "wallmounted",
	        sunlight_propagates = true,
	        walkable = false,
	        selection_box = {
		        type = "wallmounted",
            },
            groups = {cracky = 3, not_in_creative_inventory = 1}
        })

        name = "merch:painting_large_"..properties[pid][1]
        dname = "Large Painting "..properties[pid][3]

        minetest.register_node(name,{
            description = dname,
            drawtype = "signlike",
            visual_scale = 5.0,
            inventory_image = tex,
            wield_image = tex,
            tiles = {tex},
            paramtype = "light",
             paramtype2 = "wallmounted",
             sunlight_propagates = true,
             walkable = false,
             selection_box = {
                 type = "wallmounted",
             },
             groups = {cracky = 3, not_in_creative_inventory = 1}
         })

        name = "merch:painting_extra_large_"..properties[pid][1]
        dname = "Extra Large Painting "..properties[pid][3]

        minetest.register_node(name,{
            description = dname,
            drawtype = "signlike",
            visual_scale = 7.0,
            inventory_image = tex,
            wield_image = tex,
            tiles = {tex},
            paramtype = "light",
             paramtype2 = "wallmounted",
             sunlight_propagates = true,
             walkable = false,
             selection_box = {
                 type = "wallmounted",
             },
             groups = {cracky = 3, not_in_creative_inventory = 1}
         })

        name = "merch:painting_small_"..properties[pid][1]
        dname = "Small Painting "..properties[pid][3]

        minetest.register_node(name,{
            description = dname,
            drawtype = "signlike",
            visual_scale = 1.0,
            inventory_image = tex,
            wield_image = tex,
            tiles = {tex},
            paramtype = "light",
             paramtype2 = "wallmounted",
             sunlight_propagates = true,
             walkable = false,
             selection_box = {
                 type = "wallmounted",
             },
             groups = {cracky = 3, not_in_creative_inventory = 1}
         })
    end
end

local paintings = fetchImg()

generateNodes(paintings)

print("[merch] Loaded!")
