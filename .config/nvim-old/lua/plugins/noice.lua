return {
	"folke/noice.nvim",
	keys = {
		-- remove scrolling so that we can overwrite vim default scrolling
		-- harpoon wants these keys
		{ "<C-f>", false, mode = { "i", "n", "s" } },
		{ "<C-b>", false, mode = { "i", "n", "s" } },
	},
}
