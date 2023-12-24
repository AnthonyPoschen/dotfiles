-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
return {
	"ThePrimeagen/harpoon",
	event = "VeryLazy",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
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
				require("harpoon"):list():append()
				require("notify")("Buffer added", "info", {
					title = "harpoon",
				})
			end,
			desc = "Add File to Harpoon",
		},
		{
			"<C-h>",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "Harpoon menu",
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
			desc = "Harpoon Select 2",
		},
		{
			"<C-k>",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "Harpoon Select 3",
		},
		{
			"<C-l>",
			function()
				require("harpoon"):list():select(4)
			end,
			{ desc = "Harpoon Select 4", noremap = true },
		},
	},
}
