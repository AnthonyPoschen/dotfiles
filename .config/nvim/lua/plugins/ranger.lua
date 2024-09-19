return {
	"Kicamon/ranger.nvim",
	config = function()
		require("ranger").setup({
			win = {
				width = 0.8,
				height = 0.8,
				position = "cc", -- 'cc' = center, tl = top-left, br = bottom-right, tr = top-right, br = bottom-right
			},
		})
	end,
}
-- return {
--   "kelly-lin/ranger.nvim",
--   config = function()
--     require("ranger-nvim").setup({ replace_netrw = true })
--     vim.api.nvim_set_keymap("n", "-", "", {
--       noremap = true,
--       callback = function()
--         require("ranger-nvim").open(true)
--       end,
--     })
--   end,
-- }
