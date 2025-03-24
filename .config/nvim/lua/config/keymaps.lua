local utils = require("utils")
local map = vim.keymap.set
local g = vim.g
local opt_noremap = { noremap = true }
local opt_noremap_silent = { noremap = true, silent = true }
-- local opt_silent = { silent = true }

-- delete conflicts
vim.keymap.del("n", "gcc")
vim.keymap.del("n", "gc")
-- map leader
g.mapleader = " "
g.maplocalleader = "\\"

--TODO: disable this keymap eventually
map("i", "jj", "<Esc>", opt_noremap)

map("n", "n", "nzz")
map("n", "N", "Nzz")

map("n", "<leader>p", "<cmd>Lazy<cr>", { desc = "LazyVim Panel" })

-- TODO: consider tab management keys to reclaim { and } keys
-- tab management
map("n", "{", "<cmd>tabprevious<cr>", opt_noremap)
map("n", "}", "<cmd>tabnext<cr>", opt_noremap)
map("n", "+", "<cmd>tabnew<cr>", opt_noremap)
map("n", "_", "<cmd>tabclose<cr>", opt_noremap)

-- File management
-- map("n", "-", "<cmd>Ranger<cr>", opt_noremap)
-- map("n", "=", "<cmd>Ranger tabe<cr>", opt_noremap)
-- map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
map("n", "-", function()
	require("oil").open_float()
end, { desc = "Open parent directory" })

map("n", "<C-s>", ":wall<CR>", { desc = "save all buffers", silent = true, noremap = true })

-- easier moving of code blocks
map("v", "<", "<gv", opt_noremap)
map("v", ">", ">gv", opt_noremap)

-- Add extra pagination keys to make navigating up, down and between windows easier
map("n", "<C-d>", "<C-d>zz", opt_noremap)
map("n", "<C-u>", "<C-u>zz", opt_noremap)
-- map("n", "<C-l>", "<C-w>w", opt_noremap) -- NOTE: Disabled window switching here
-- map("n", "<C-h>", "<C-w>W", opt_noremap) --NOTE: disabled window switching here
-- Remap Ctrl-w w and Ctrl-w Ctrl-w to use the custom function
map("n", "<C-w>w", utils.cycle_windows, { desc = "Cycle to next window (skip Noice)" })
map("n", "<C-w><C-w>", utils.cycle_windows, { desc = "Cycle to next window (skip Noice)" })

-- allow scrolling previous console commands, invert direction to feel more natural
-- map('c', '<C-j>', '<Up>', opt_noremap)
-- map('c', '<C-k>', '<Down>', opt_noremap)

-- move line up and down ( Macos Option-j and Option-k produce the weird symbols )
map("n", "∆", "<cmd>m .+1<CR>==", { desc = "Move line down", noremap = true, silent = true })
map("n", "˚", "<cmd>m .-2<CR>==", { desc = "Move line up", noremap = true, silent = true })
map("v", "∆", "<cmd>m '>+1<CR>gv=gv", { desc = "Move line down", noremap = true, silent = true })
map("v", "˚", "<cmd>m '<-2<CR>gv=gv", { desc = "Move line up", noremap = true, silent = true })
map("i", "∆", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down", noremap = true, silent = true })
map("i", "˚", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up", noremap = true, silent = true })

-- define the same but for windows pcs
map("n", "<A-j>", "<cmd>m +1<CR>", opt_noremap_silent)
map("n", "<A-k>", "<cmd>m -2<CR>", opt_noremap_silent)
map("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv", opt_noremap_silent)
map("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv", opt_noremap_silent)

-- git blame in file
map("n", "<Leader>gb", ":DiffviewFileHistory %%<CR>", opt_noremap)
-- End Git Keys --

-- -- TComment
-- map('v', '<Leader>c', ':TComment<CR>', opt_noremap)
-- map('n', '<Leader>c', ':TComment<CR>', opt_noremap)

-- clear search
-- map("n", "<C-c>", ":noh<CR>", opt_noremap_silent)

map(
	"n",
	"<C-c>",
	"<Cmd>noh<CR><Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- Copilot
-- map("i", "<C-Space>", 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true })

-- map('n', '<Leader>g', ':Telescope live_grep<CR>', opt_noremap)
-- TODO: This is a good keymap, but it's conflicting with the mini.bufremove keymaps
-- map("n", "<Leader>b", ":Telescope buffers<CR>", opt_noremap)

-- Golang Config
utils.create_augroup({
	{ "FileType", "dap-rel", [[lua require('dap.ext.autocompl').attach()]] },
}, "Tab2")

-- TODO: Fix keymaps for golang? < involces getting old plugins back, maybe just
-- adopt the new school way of doing these things language agnostics
-- Golang file keymaps, and remove below as they are handled
utils.create_ft_augroup("go", {
	-- { "nnoremap", "<Leader>lc", ":GoCoverageToggle<CR>" },
	-- { "nnoremap", "<Leader>ltt", ":GoTest<CR>" },
	-- { "nnoremap", "<Leader>ltf", ":GoTestFunc<CR>" },
	-- { "nnoremap", "<Leader>lta", ":GoAlternate<CR>" },
	{ "nnoremap", "<leader>ee", "oif err != nil {<CR>}<ESC>Oreturn err<ESC>" },
}, "goKeys")

-- CMP / LSP
-- map('n', '<Space>e', vim.diagnostic.open_float, opt_noremap_silent)
-- map('n', '[d', vim.diagnostic.goto_prev, opt_noremap_silent)
-- map('n', ']d', vim.diagnostic.goto_next, opt_noremap_silent)

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- formatting
map({ "n", "v" }, "<leader>cf", function()
	require("conform").format({})
end, { desc = "Format" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
local file_search = function()
	require("telescope").extensions.smart_open.smart_open({
		filename_first = true,
		cwd_only = true,
		previewer = false,
		hidden = true,
		layout_strategy = "vertical",
		sorting_strategy = "descending",
		layout_config = {
			prompt_position = "bottom",
			width = 130,
			height = 0.75,
		},
		show_line = false,
		results_title = false,
		git_command = {
			"git",
			"ls-files",
			"--exclude-standard",
			"--cached",
			":!:*.meta", -- unity
			":!:*.asset", -- unity
			":!:*.prefab", -- unity
			":!:*.unity", -- unity
		},
	})
end
vim.api.nvim_create_user_command("FileSearch", file_search, { desc = "Find Files" })
map("n", "<space><space>", file_search, { desc = "Find files" })
