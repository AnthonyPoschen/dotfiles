return {
	"Kicamon/ranger.nvim",
	config = function()
		require("ranger").setup({
			win = {
				width = 0.8,
				height = 0.8,
				position = "cc", -- 'cc' = center, tl = top-left, br = bottom-right, tr = top-right, br = bottom-right
			},
			open = {
				["edit"] = "-",
				["tabedit"] = "=",
				["split"] = nil,
				["vsplit"] = nil,
			},
		})
	end,
}
