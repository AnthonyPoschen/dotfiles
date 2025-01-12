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
	-- git signs highlights text that has changed since the list
	-- git commit, and also lets you interactively stage & unstage
	-- hunks in a commit.
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},
}
