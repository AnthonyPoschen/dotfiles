-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- extra doco https://www.lazyvim.org/configuration/general
local utils = require("utils")
local map = vim.keymap.set
local g = vim.g
local opt_noremap = { noremap = true }
local opt_noremap_silent = { noremap = true, silent = true }
-- local opt_silent = { silent = true }

-- map leader
g.mapleader = " "
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

-- easier moving of code blocks
map("v", "<", "<gv", opt_noremap)
map("v", ">", ">gv", opt_noremap)

-- Add extra pagination keys to make navigating up, down and between windows easier
map("n", "<C-d>", "<C-d>zz", opt_noremap)
map("n", "<C-u>", "<C-u>zz", opt_noremap)
map("n", "<C-l>", "<C-w>w", opt_noremap)
map("n", "<C-h>", "<C-w>W", opt_noremap)

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

-- Telescope
map("n", "<Leader>f", ":Telescope find_files<CR>", opt_noremap)
-- map('n', '<Leader>g', ':Telescope live_grep<CR>', opt_noremap)
map("n", "<Leader>b", ":Telescope buffers<CR>", opt_noremap)

-- Golang Config
utils.create_augroup({
	{ "FileType", "dap-rel", [[lua require('dap.ext.autocompl').attach()]] },
}, "Tab2")

-- TODO: Fix go debugger not working
-- TODO: Fix keymaps for golang
-- Golang file keymaps
utils.create_augroup({
	{ "FileType", "go", "nnoremap", "<Leader>le", ":GoIfErr<CR>" },
	{ "FileType", "go", "nnoremap", "<Leader>lwe", ":GoWhicherrs<CR>" },
	{ "FileType", "go", "nnoremap", "<Leader>lc", ":GoCoverageToggle<CR>" },
	{ "FileType", "go", "nnoremap", "<Leader>ltt", ":GoTest<CR>" },
	{ "FileType", "go", "nnoremap", "<Leader>ltf", ":GoTestFunc<CR>" },
	{ "FileType", "go", "nnoremap", "<Leader>lta", ":GoAlternate<CR>" },
	{ "FileType", "go", "nnoremap", "<Leader>ls", ":GoFillStruct<CR>" },
	{ "FileType", "go", "nnoremap", "<Leader>ll", ":GoDeclsDir<CR>" },
	{ "FileType", "go", "nnoremap", "<Leader>lf", ":GoDecls<CR>" },
	{ "FileType", "go", "nnoremap", "<buffer>", "<F5>", ":call DebugGo()<CR>" },
	{ "FileType", "go", "nnoremap", "<buffer>", "<S-F5>", ":call DebugStop()<CR>" },
	{ "FileType", "go", "nnoremap", "<buffer>", "<F6>", ":GoDebugPrint<CR>" },
	{ "FileType", "go", "nnoremap", "<buffer>", "<F9>", ":GoDebugBreakpoint<CR>" },
	{ "FileType", "go", "nnoremap", "<buffer>", "<F10>", ":GoDebugNext<CR>" },
	{ "FileType", "go", "nnoremap", "<buffer>", "<F10>", ":GoDebugStep<CR>" },
	{ "FileType", "go", "nnoremap", "<buffer>", "<F10>", ":GoDebugStepOut<CR>" },
}, "goKeys")

utils.create_augroup({
	{ "FileType", "harpoon", "nnoremap", "<buffer>", "<C-j>", "<cmd>m +1<CR>" },
	{ "FileType", "harpoon", "nnoremap", "<buffer>", "<C-k>", "<cmd>m -2<CR>" },
}, "harpoon_custom")
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

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- formatting
map({ "n", "v" }, "<leader>cf", function()
	Util.format({ force = true })
end, { desc = "Format" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
