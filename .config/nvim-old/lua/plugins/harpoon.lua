-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
return {
	"ThePrimeagen/harpoon",
	name = "harpoon",
	event = "VeryLazy",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim", "notify" },
	config = function(_, opts)
		require("harpoon"):setup(opts)
	end,
	opts = {
		settings = {
			save_on_toggle = true,
		},
	},
	keys = {
		{
			"<C-n>",
			function()
				require("harpoon"):list():add()
				require("notify")("Buffer added", "info", {
					title = "harpoon",
				})
			end,
			desc = "Add File to Harpoon",
		},
		{
			"<C-b>",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			{ desc = "Harpoon menu", noremap = true, mode = { "n" } },
		},
		{
			"<C-f>",
			function()
				require("harpoon"):list():select(1)
			end,
			{ desc = "Harpoon Select 1", noremap = true, mode = { "n" } },
		},
		{
			"<C-j>",
			function()
				require("harpoon"):list():select(2)
			end,
			{ desc = "Harpoon Select 2", noremamp = true, mode = { "n" } },
		},
		{
			"<C-k>",
			function()
				require("harpoon"):list():select(3)
			end,
			{ desc = "Harpoon Select 3", noremap = true, mode = { "n" } },
		},
		{
			"<C-e>",
			function()
				require("harpoon"):list():select(4)
			end,
			{ desc = "Harpoon Select 4", noremap = true, mode = { "n" } },
		},
	},
}
