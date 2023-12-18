-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- extra doco https://www.lazyvim.org/configuration/general
local utils = require("utils")
local LazyUtil = require("lazyvim.util")
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
map("n", "<leader>P", function()
	LazyUtil.news.changelog()
end, { desc = "LazyVim Changelog" })
-- tab management
map("n", "{", "<cmd>tabprevious<cr>", opt_noremap)
map("n", "}", "<cmd>tabnext<cr>", opt_noremap)
map("n", "+", "<cmd>tabnew<cr>", opt_noremap)
map("n", "_", "<cmd>tabclose<cr>", opt_noremap)

-- easier moving of code blocks
map("v", "<", "<gv", opt_noremap)
map("v", ">", ">gv", opt_noremap)

-- terminal escape
map("t", "<Leader><Esc>", "<C-\\><C-n>", opt_noremap)

-- Close pane's when in normal mode, saving effort
map("n", "<Leader>q", "<cmd>q<CR>", opt_noremap)
-- terminal window below
map("n", "<Leader>o", "<cmd>below 10sp term://$SHELL<CR>i", opt_noremap)

-- Add extra pagination keys to make navigating up, down and between windows easier
map("n", "<C-d>", "<C-d>zz", opt_noremap)
map("n", "<C-u>", "<C-u>zz", opt_noremap)
map("n", "<C-l>", "<C-w>w", opt_noremap)
map("n", "<C-h>", "<C-w>W", opt_noremap)

-- allow scrolling previous console commands, invert direction to feel more natural
-- map('c', '<C-j>', '<Up>', opt_noremap)
-- map('c', '<C-k>', '<Down>', opt_noremap)

-- move line up and down ( Macos Option-j and Option-k produce the weird symbols )
map("n", "∆", "<cmd>m +1<CR>", opt_noremap_silent)
map("n", "˚", "<cmd>m -2<CR>", opt_noremap_silent)
map("v", "∆", "<cmd>m '>+1<CR>gv=gv", opt_noremap_silent)
map("v", "˚", "<cmd>m '<-2<CR>gv=gv", opt_noremap_silent)
-- define the same but for windows pcs
-- map("n", "<A-j>", "<cmd>m +1<CR>", opt_noremap_silent)
-- map("n", "<A-k>", "<cmd>m -2<CR>", opt_noremap_silent)
-- map("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv", opt_noremap_silent)
-- map("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv", opt_noremap_silent)

-- search for work under cursor
map("n", "<Leader>s", ":Rg <cword><CR>", opt_noremap)

-- GIT Keys --
-- fugitive for git integration
map("n", "<Leader>gs", "<cmd>Git<CR>", opt_noremap)
-- map leader gr to something to review all staged changes

-- git blame in file
map("n", "<Leader>gb", ":DiffviewFileHistory %%<CR>", opt_noremap)
-- nnoremap <Leader>gb :Git blame --date=short<cr> -- Old config using fugitive
-- End Git Keys --

-- -- TComment
-- map('v', '<Leader>c', ':TComment<CR>', opt_noremap)
-- map('n', '<Leader>c', ':TComment<CR>', opt_noremap)

-- clear search
map("n", "<C-c>", ":noh<CR>", opt_noremap_silent)

-- Copilot
map("i", "<C-Space>", 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true })

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
-- TODO: these leader-l keys overlap now with harpoon
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
	{ "FileType", "fugitive", "nnoremap", "<buffer>", "cc", ":Telescope conventional_commits<CR>" },
	{ "FileType", "fugitive", "nnoremap", "<buffer>", "cu", ":!Git reset --soft HEAD~1<CR>" },
}, "fugitive_custom")

utils.create_augroup({
	{ "FileType", "harpoon", "nnoremap", "<C-j>", "<cmd>m +1<CR>" },
	{ "FileType", "harpoon", "nnoremap", "<C-k>", "<cmd>m -2<CR>" },
}, "harpoon_custom")
-- CMP / LSP
-- map('n', '<Space>e', vim.diagnostic.open_float, opt_noremap_silent)
-- map('n', '[d', vim.diagnostic.goto_prev, opt_noremap_silent)
-- map('n', ']d', vim.diagnostic.goto_next, opt_noremap_silent)
