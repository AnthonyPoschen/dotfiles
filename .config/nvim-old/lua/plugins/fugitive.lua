-- nnoremap <Leader>gb :Git blame --date=short<cr> -- Old config using fugitive
return {
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
	config = function(_, opts)
		-- require(""
	end,
}
