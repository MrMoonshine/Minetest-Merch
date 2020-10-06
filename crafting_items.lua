minetest.register_craftitem("merch:canvas_small", {
	description = "Small Canvas",
	inventory_image = "canvas_small.png",
	wield_image = "canvas_small.png",
})

minetest.register_craftitem("merch:canvas", {
	description = "Canvas",
	inventory_image = "canvas.png",
	wield_image = "canvas.png",
})

minetest.register_craftitem("merch:canvas_large", {
	description = "Large Canvas",
	inventory_image = "canvas_large.png",
	wield_image = "canvas_large.png",
})

minetest.register_craftitem("merch:canvas_extra_large", {
	description = "Extra Large Canvas",
	inventory_image = "canvas_extra_large.png",
	wield_image = "canvas_extra_large.png",
})

--Recipes for the canvases
minetest.register_craft({
	output = "merch:canvas_small",
	recipe = {
			  {"default:paper", "default:paper", "default:paper"},
			  {"default:paper", "dye:white", "default:paper"},
			  {"default:paper", "default:paper", "default:paper"},
			  }
	})

minetest.register_craft({
	output = "merch:canvas",
	recipe = {
			  {"default:paper", "default:paper", "default:paper"},
			  {"default:paper", "merch:canvas_small", "default:paper"},
			  {"default:paper", "default:paper", "default:paper"},
			  }
	})

minetest.register_craft({
	output = "merch:canvas_large",
	recipe = {
			  {"default:paper", "default:paper", "default:paper"},
			  {"default:paper", "merch:canvas", "default:paper"},
			  {"default:paper", "default:paper", "default:paper"},
			  }
	})

minetest.register_craft({
	output = "merch:canvas_extra_large",
	recipe = {
			  {"default:paper", "default:paper", "default:paper"},
			  {"default:paper", "merch:canvas_large", "default:paper"},
			  {"default:paper", "default:paper", "default:paper"},
			  }
	})