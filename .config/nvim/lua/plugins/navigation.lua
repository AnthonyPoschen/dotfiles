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
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {
			keymaps = {
				normal = "s",
				normal_cur = "ss",
				visual = "s",
				delete = "ds",
				change = "cs",
			},
		},
	},
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		event = "VeryLazy",
		config = function()
			local leap = require("leap")
			leap.setup({
				-- safe_labels = { "s", "f", "n", "j", "k" },
				labels = { "s", "f", "n", "j", "k", "l", "h" },
				-- highlight_unlabeled_phase_one_targets = true,
				equivalence_classes = { " \t\r\n" },
			})
			vim.keymap.set({ "n", "v" }, "<leader>g", function()
				leap.leap({ target_windows = { vim.fn.win_getid() }, opts = { patterns = { "\\<\\k\\+\\>" } } })
			end, { desc = "Leap forward to word" })
			vim.keymap.set({ "n", "v" }, "<leader>G", function()
				leap.leap({
					target_windows = { vim.fn.win_getid() },
					opts = { patterns = { "\\<\\k\\+\\>" }, backward = true },
				})
			end, { desc = "Leap backward to word" })
		end,
	},

	{
		-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
		"ThePrimeagen/harpoon",
		name = "harpoon",
		event = "VeryLazy",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "notify" },
		config = function(_, opts)
			require("harpoon"):setup(opts)
			-- require("harpoon-tabline").setup()

			local utils = require("utils")
			utils.create_augroup({
				{ "FileType", "harpoon", "nnoremap", "<buffer>", "<C-j>", "<cmd>m +1<CR>" },
				{ "FileType", "harpoon", "nnoremap", "<buffer>", "<C-k>", "<cmd>m -2<CR>" },
			}, "harpoon_custom")
		end,
		opts = {
			settings = {
				save_on_toggle = true,
			},
		},
		keys = {
			{
				"<C-h>",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				{ desc = "Harpoon menu", noremap = true, mode = { "n" } },
			},
			{
				"<C-n>",
				function()
					require("harpoon"):list():add()
					require("notify")("Buffer added", "info", {
						title = "harpoon",
					})
				end,
				{ desc = "Add to harpoon", noremap = true, mode = { "n" } },
			},
			{
				"<C-j>",
				function()
					require("harpoon"):list():select(1)
				end,
				{ desc = "Harpoon Select 1", noremap = true, mode = { "n" } },
			},
			{
				"<C-k>",
				function()
					require("harpoon"):list():select(2)
				end,
				{ desc = "Harpoon Select 2", noremamp = true, mode = { "n" } },
			},
			{
				"<C-l>",
				function()
					require("harpoon"):list():select(3)
				end,
				{ desc = "Harpoon Select 3", noremap = true, mode = { "n" } },
			},
			{
				"<C-i>",
				function()
					require("harpoon"):list():select(4)
				end,
				{ desc = "Harpoon Select 4", noremap = true, mode = { "n" } },
			},
		},
	},
	-- {
	-- 	"jasonpanosso/harpoon-tabline.nvim",
	-- 	dependencies = { "ThePrimeagen/harpoon" },
	-- },
	{
		"letieu/harpoon-lualine",
		dependencies = {
			{
				"ThePrimeagen/harpoon",
				branch = "harpoon2",
			},
		},
	},
}
