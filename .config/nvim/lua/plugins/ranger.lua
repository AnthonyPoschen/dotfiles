return {
	"francoiscabrol/ranger.vim",
	keys = {
		{ "-", "<cmd>Ranger<CR>" },
	},
}
-- return {
-- 	-- NOTE: this is a 2 day old repo when added,
-- 	-- currently the cool floating window breaks when you tab out and in, requiring a reboot of vim.
--
-- 	"Kicamon/ranger.nvim",
-- 	config = function()
-- 		require("ranger").setup({
-- 			win = {
-- 				width = 0.8,
-- 				height = 0.8,
-- 				position = "cc", -- 'cc' = center, tl = top-left, br = bottom-right, tr = top-right, br = bottom-right
-- 			},
-- 			-- TODO: Make tabedit
-- 			open = {
-- 				["edit"] = "-",
-- 				["tabedit"] = "=",
-- 				["split"] = nil,
-- 				["vsplit"] = nil,
-- 			},
-- 		})
-- 	end,
-- }
