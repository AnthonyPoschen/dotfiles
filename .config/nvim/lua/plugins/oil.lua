return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		keymaps = {
			["h"] = "actions.parent", -- Go up to parent directory
			["l"] = "actions.select", -- Enter selected directory/file
			["<CR>"] = "actions.select", -- Enter selected directory/file
			["q"] = "actions.close", -- Close Oil (saves changes by default)
			["/"] = function()
				require("telescope.builtin").find_files({ cwd = require("oil").get_current_dir() })
			end,
		},
		use_default_keymaps = false,
		view_options = {
			show_hidden = true, -- Optional: show hidden files
		},
		float = {
			padding = 4, -- Padding inside the float
			max_width = 90, -- Max width of the float
			max_height = 40, -- Max height of the float
			border = "rounded", -- Border style (rounded, single, double, etc.)
			win_options = {
				winblend = 0, -- Transparency (0 = opaque, 100 = fully transparent)
			},
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
