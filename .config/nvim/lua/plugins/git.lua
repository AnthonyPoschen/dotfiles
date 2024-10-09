-- nnoremap <Leader>gb :Git blame --date=short<cr> -- Old config using fugitive
return {
	{
		"tpope/vim-fugitive",
		lazy = false,
		cmd = {
			"G",
			"Git",
			"Gdiffsplit",
			"Gvdiffsplit",
			"Gedit",
			"Gsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"Glgrep",
			"Gmove",
			"Gdelete",
			"Gremove",
			"Gbrowse",
		},
		keys = {
			{ "cc", ":Telescope conventional_commits<CR>", "n", "fugitive" },
			{ "cu", ":!Git reset --soft HEAD~1<CR>", "n", "fugitive" },
			{ "<leader>gs", "<cmd>Git<CR>", { desc = "git", noremap = true, mode = { "n" } } },
		},
	},
	{

		"sindrets/diffview.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			keymaps = {
				view = {
					["<c-c>"] = "<cmd>tabc<cr>",
				},
				file_history_panel = {
					["<c-c>"] = "<cmd>tabc<cr>",
				},
				file_panel = {
					["<c-c>"] = "<cmd>tabc<cr>",
				},
			},
			view = {
				-- Available layouts:
				--  'diff1_plain'
				--    |'diff2_horizontal'
				--    |'diff2_vertical'
				--    |'diff3_horizontal'
				--    |'diff3_vertical'
				--    |'diff3_mixed'
				--    |'diff4_mixed'
				default = {
					-- layout = "diff2_horizontal", -- Default
					layout = "diff2_horizontal",
				},
				merge_tool = {
					-- Config for conflicted files in diff views during a merge or rebase.
					layout = "diff3_horizontal",
				},
				file_history = {
					-- Config for changed files in file history views.
					layout = "diff2_horizontal",
				},
			},
		},
	},
}
