-- nnoremap <Leader>gb :Git blame --date=short<cr> -- Old config using fugitive
return {
	"tpope/vim-fugitive",
	keys = {
		{ "cc", ":Telescope conventional_commits<CR>", "n", "fugitive" },
		{ "cu", ":!Git reset --soft HEAD~1<CR>", "n", "fugitive" },
	},
}
