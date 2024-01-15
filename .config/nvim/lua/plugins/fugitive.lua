-- nnoremap <Leader>gb :Git blame --date=short<cr> -- Old config using fugitive
return {
	"tpope/vim-fugitive",
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
		{ "<leader>gs", "<CMD>Git<CR>", desc = "git" },
	},
}
