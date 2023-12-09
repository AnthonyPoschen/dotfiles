-- return {
-- 	"francoiscabrol/ranger.vim",
-- 	keys = {
--		{ "-", "<cmd>Ranger<CR>" },
--	},
--}
return {
	-- NOTE: this is a 2 day old repo when added,
	-- expect the keys to be done properly eventually
	"Kicamon/ranger.nvim",
	config = function()
		require("ranger").setup({
			win = {
				width = 0.8,
				height = 0.8,
				position = "cc", -- 'cc' = center, tl = top-left, br = bottom-right, tr = top-right, br = bottom-right
			},
			-- TODO: Make tabedit
			open = {
				["edit"] = "-",
				["tabedit"] = "=",
				["split"] = "<leader>abcdfefg",
				["vsplit"] = "<leader>abcdfefh",
			},
		})
	end,
}