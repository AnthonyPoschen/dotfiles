return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function(opts)
			require("tokyonight").setup({
				style = "night",
				light_style = "moon",
				dim_inactive = true,
				lualine_bold = true,
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	-- catppuccin
	-- {
	-- 	"catppuccin/nvim",
	-- 	lazy = false,
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd([[colorscheme catppuccin]])
	-- 	end,
	-- 	opts = {
	-- 		dim_inactive = {
	-- 			enabled = true,
	-- 			shade = "dark",
	-- 			percentage = 0.25,
	-- 		},
	-- 		integrations = {
	-- 			harpoon = true,
	-- 			aerial = true,
	-- 			alpha = true,
	-- 			cmp = true,
	-- 			dashboard = true,
	-- 			flash = true,
	-- 			gitsigns = true,
	-- 			headlines = true,
	-- 			illuminate = true,
	-- 			indent_blankline = { enabled = true },
	-- 			leap = true,
	-- 			lsp_trouble = true,
	-- 			mason = true,
	-- 			markdown = true,
	-- 			mini = true,
	-- 			native_lsp = {
	-- 				enabled = true,
	-- 				underlines = {
	-- 					errors = { "undercurl" },
	-- 					hints = { "undercurl" },
	-- 					warnings = { "undercurl" },
	-- 					information = { "undercurl" },
	-- 				},
	-- 			},
	-- 			navic = { enabled = true, custom_bg = "lualine" },
	-- 			neotest = true,
	-- 			neotree = true,
	-- 			noice = true,
	-- 			notify = true,
	-- 			semantic_tokens = true,
	-- 			telescope = true,
	-- 			treesitter = true,
	-- 			treesitter_context = true,
	-- 			which_key = true,
	-- 		},
	-- 	},
	-- },
}
