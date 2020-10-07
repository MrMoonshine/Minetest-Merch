dofile(minetest.get_modpath("merch").."/images.lua")

local page_max = 4
local paintingUI = {}
paintingUI.ui_context = {}

local inv

if not minetest.global_exists("unified_inventory") then
	minetest.log("warning", "[merch] Mod will only provide uncraftable paintings")
	return
end

function paintingUI.getContext(player)
    --WIP
	if player then
		local playername = player:get_player_name()
		paintingUI.ui_context[playername] = paintingUI.ui_context[playername] or {}
		return paintingUI.ui_context[playername]
	else
		return {}
	end
end

local function drawPainting(name)

    local function can_paint()

    end

    local stack_i = inv:get_stack("merch_i",1)
    local stack_o = inv:get_stack("merch_o",1)
    local name_o = stack_o:get_name()
    local canv = stack_i:get_name()
    --print("Input item: "..canv)

    local pname = "merch:painting_"

    if canv == "merch:canvas_small" then
        pname = pname.."small_"..name
    elseif canv == "merch:canvas" then
        pname = pname..name
    elseif canv == "merch:canvas_large" then
        pname = pname.."large_"..name
    elseif canv == "merch:canvas_extra_large" then
        pname = pname.."extra_large_"..name
    else
        return
    end

    if name_o == "" or name_o == pname then
    --print("Output item: "..pname)
    inv:remove_item("merch_i",ItemStack(canv.." 1"))
    local outpainting = ItemStack(pname.." 1")

    inv:add_item("merch_o",outpainting)
    end
end

function paintingUI.on_click_buttons(player, context, fields)
    for field, _ in pairs(fields) do
        --print("[merch] field: "..field)
        local current = string.split(field, "$", 2)

        if current[1] == "paint_canvas" then
            --print("[merch] "..player:get_player_name().." wants to draw "..current[2].." on a canvas")
            drawPainting(current[2])
            return ""
        end

        if current[1] == "painter_page" then
            --print("[merch] field: "..current[1].." ; "..current[2])
			context.current_page = tonumber(current[2])
			return 'page'
		end
    end
    if fields.painter_select_option_page then
		context.current_page = tonumber(context.dropdown_values[fields.painter_select_option_page])
		return 'page'
	end
end

local function loadINV(player)
    local player_name = player:get_player_name()

    local invname = player_name.."_merch"

    inv = minetest.create_detached_inventory(invname,{
        allow_move = function() return 0 end,
        allow_put = function(inv,listname,index,stack,player)
            if listname == "merch_o" then
                return 0
            end
            return stack:get_count()
        end,
        allow_take = function(inv,listname,index,stack,player)
            return stack:get_count()
        end,
    })

    if inv:set_size("merch_i",1) then
        inv:set_width("merch_i",1)
    else
        print("[merch] Invalid itemname or size")
    end

    if inv:set_size("merch_o",1) then
        inv:set_width("merch_o",1)
    else
        print("[merch] Invalid itemname or size")
    end

end

local function loadCraftingSlots(player)
    local player_name = player:get_player_name()

    local invname = player_name.."_merch"

    local craft_formspec = "size[8,9;]"..
    --"field[4,4;1,1;maerch_name;merch_label;oida]"..
    "label[4,3;canvas-input]"..
    "list[detached:"..minetest.formspec_escape(invname)..";merch_i;4,3.5;2,1;]"..
    "label[6,3;output]"..
    "list[detached:"..minetest.formspec_escape(invname)..";merch_o;6,3.5;2,1;]"
    return  craft_formspec
end

local function loadImageSelection(arr,player_context)
    local i = 0
    local total_pages = 0
    local current_page = player_context.current_page or 1
    for pid in pairs(arr) do
        local iname = arr[pid][1]
        local fname = arr[pid][2]
        local dname = arr[pid][3]

        local page = math.floor(i/page_max)+1   -- +1 because i want to start at 1

        total_pages = page
        i = i + 1
    end

    local page = current_page

    --if there are at most 4 images
    
        i = 0
        local outstr = ""

        local i_max = (i+page)*4
        local i_min = (i + page - 1)*4

        --print("imax = "..i_max)
        --print("imin = "..i_min)
        for pid in pairs(arr) do
            --print(tostring(i >= i_min and i < i_max))
            if(i >= i_min and i < i_max) then
                local inam = arr[pid][1]
                local fnam = arr[pid][2]
                local dnam = arr[pid][3]
                local a = 2*(i - i_min)
                outstr = outstr.."image_button["..a..",0.6;2,2;"..fnam..";paint_canvas$"..inam..";"..dnam.."]"
            end
            i = i + 1
        end
        
    if total_pages > 1 then
        local page_prev = page - 1
        local page_next = page + 1
        
        --if the element is on the edge
        --refer to either the last or first one
        if page_prev < 1 then
            page_prev = total_pages
        elseif page_next > total_pages then
            page_next = 1
        end

        local page_list = ""
        player_context.dropdown_values = {}

        for pg=1, total_pages do
            --Output e.g : "Page 2/6" 
            local pagename = "Page".." "..pg.."/"..total_pages

            player_context.dropdown_values[pagename] = pg
            if pg > 1 then
                page_list = page_list..","
            end

            page_list = page_list..pagename
        end
        outstr = outstr.."button[0,"..tostring(3)..";1,.5;painter_page$"..page_prev..";<<]"
        .."dropdown[0.9,"..tostring(2.88)..";2,.5;painter_select_option_page;"..page_list..";"..page.."]"
        .."button[3,"..tostring(3)..";1,.5;painter_page$"..page_next..";>>]"
        return outstr
    end
    return ""
end

local function generateButtonList(player)
    local outstr = "background[0.06,0.99;7.92,7.52;ui_misc_form.png]"
    local i = 0
    local imgList = {}
    for line in img_locs:gmatch("([^\n]*)\n") do
        local fnam = line             --filename
        local inam = string.gsub(fnam,".png","")    --item-name
        inam = string.lower(inam)
        local dnam = string.gsub(line,".png","")    --display-name
        dnam = string.gsub(dnam,"_"," ")  
        local a = i*2          --replace _ with spaces
        --outstr = outstr.."image_button["..a..",1;2,2;"..fnam..";skins_page;"..dnam.."]"
        imgList[i] = {inam,fnam,dnam}
       i = i+1 
    end

    local player_context = paintingUI.getContext(player)
    outstr = outstr..loadImageSelection(imgList,player_context)

    return outstr
end



unified_inventory.register_page("merch", {
    get_formspec = function (player, perplayer_formspec)
        local pname = player:get_player_name()
        local fy = perplayer_formspec.formspec_y
        local formspec = generateButtonList(player)..loadCraftingSlots(player)
                
        return {formspec=formspec}
    end
})

unified_inventory.register_button("merch", {
	type = "image",
	image = "canvas.png",
	tooltip = "Paintings",
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "" then
		return
	end

	local context = paintingUI.getContext(player)
	local action = paintingUI.on_click_buttons(player, context, fields)
	if action == 'page' then
		unified_inventory.set_inventory_formspec(player, "merch")
    end
end)

minetest.register_on_joinplayer(function (player)
    loadINV(player)    
end)