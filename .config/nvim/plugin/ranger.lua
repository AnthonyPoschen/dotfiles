-- let g:ranger_map_keys = 0
-- let g:ranger_command_override = 'ranger --cmd "set hidden_filter \.(?:pyc|pyo|bak|swp|git)$|^lost\+found$|^__(py)?cache__$|^vendor$"'
vim.g.ranger_map_keys = 0
vim.g.ranger_command_override =
	'ranger --cmd "set hidden_filter .(?:pyc|pyo|bak|swp|git)$|^lost+found$|^__(py)?cache__$|^vendor$"'
