local utils = require('utils')
local map = utils.map
local g = vim.g
local opt_noremap = {noremap = true}
local opt_noremap_silent = {noremap = true, silent = true}
local opt_silent = {silent = true}

g.mapleader = " "

map('i', 'jj', '<Esc>', opt_noremap)

map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

-- tab management
map('n', '{', ':tabprevious<cr>', opt_noremap)
map('n', '}', ':tabnext<cr>', opt_noremap)
map('n', '+', ':tabnew<cr>', opt_noremap)
map('n', '_', ':tabclose<cr>', opt_noremap)

-- File Browser
map('n', '-', ':Ranger<CR>', opt_noremap)

-- easier moving of code blocks
map('v', '<', '<gv', opt_noremap)
map('v', '>', '>gv', opt_noremap)

-- terminal escape
map('t', '<Leader><Esc>', '<C-\\><C-n>', opt_noremap)

-- Close pane's when in normal mode, saving effort
map('n', '<Leader>q', ':q<CR>', opt_noremap)
-- terminal window below
map('n', '<Leader>o', ':below 10sp term://$SHELL<CR>i', opt_noremap)

-- Add extra pagination keys to make navigating up, down and between windows easier
map('n', '<C-j>', '<C-d>', opt_noremap)
map('n', '<C-k>', '<C-u>', opt_noremap)
map('n', '<C-l>', '<C-w>w', opt_noremap)
map('n', '<C-h>', '<C-w>W', opt_noremap)

-- allow scrolling previous console commands, invert direction to feel more natural
map('c', '<C-j>', '<Up>', opt_noremap)
map('c', '<C-k>', '<Down>', opt_noremap)

-- move line up and down ( does not work )
map('n', '<M-j>', ':m +1<CR>', opt_noremap_silent)
map('n', '<M-k>', ':m -2<CR>', opt_noremap_silent)
map('v', '<M-j>', ":m '>+1<CR>gv=gv", opt_noremap_silent)
map('v', '<M-k>', ":m '<-2<CR>gv=gv", opt_noremap_silent)

-- search for work under cursor
map('n', '<Leader>s', ':Rg <cword><CR>', opt_noremap)

-- GIT Keys --
-- fugitive for git integration
map('n', '<Leader>gs', ':Git<CR>', opt_noremap)
-- map leader gr to something to review all staged changes

-- git blame in file
map('n', '<Leader>gb', ':DiffviewFileHistory %%<CR>', opt_noremap)
-- nnoremap <Leader>gb :Git blame --date=short<cr> -- Old config using fugitive
-- End Git Keys --

-- TComment
map('v', '<Leader>c', ':TComment<CR>', opt_noremap)
map('n', '<Leader>c', ':TComment<CR>', opt_noremap)

-- clear search
map('n', '<C-c>', ':noh<CR>', opt_noremap)

-- Copilot
map('i', '<C-Space>', 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true})

-- Telescope
map('n', '<Leader>f', ':Telescope find_files<CR>', opt_noremap)
-- map('n', '<Leader>g', ':Telescope live_grep<CR>', opt_noremap)
map('n', '<Leader>b', ':Telescope buffers<CR>', opt_noremap)

-- Golang Config
utils.create_augroup({
  {'FileType', 'dap-rel', [[lua require('dap.ext.autocompl').attach()]]}
}, 'Tab2')

-- TODO: Fix go debugger not working
-- Golang file keymaps
utils.create_augroup({
    {'FileType', 'go', 'nnoremap', '<Leader>le',  ':GoIfErr<CR>'},
    {'FileType', 'go', 'nnoremap', '<Leader>lwe', ':GoWhicherrs<CR>'},
    {'FileType', 'go', 'nnoremap', '<Leader>lc',  ':GoCoverageToggle<CR>'},
    {'FileType', 'go', 'nnoremap', '<Leader>ltt', ':GoTest<CR>'},
    {'FileType', 'go', 'nnoremap', '<Leader>ltf', ':GoTestFunc<CR>'},
    {'FileType', 'go', 'nnoremap', '<Leader>lta', ':GoAlternate<CR>'},
    {'FileType', 'go', 'nnoremap', '<Leader>ls',  ':GoFillStruct<CR>'},
    {'FileType', 'go', 'nnoremap', '<Leader>ll',  ':GoDeclsDir<CR>'},
    {'FileType', 'go', 'nnoremap', '<Leader>lf',  ':GoDecls<CR>'},
    {'FileType', 'go', 'nnoremap', '<buffer>', '<F5>',   ':call DebugGo()<CR>'},
    {'FileType', 'go', 'nnoremap', '<buffer>', '<S-F5>', ':call DebugStop()<CR>'},
    {'FileType', 'go', 'nnoremap', '<buffer>', '<F6>',   ':GoDebugPrint<CR>'},
    {'FileType', 'go', 'nnoremap', '<buffer>', '<F9>',   ':GoDebugBreakpoint<CR>'},
    {'FileType', 'go', 'nnoremap', '<buffer>', '<F10>',  ':GoDebugNext<CR>'},
    {'FileType', 'go', 'nnoremap', '<buffer>', '<F10>',  ':GoDebugStep<CR>'},
    {'FileType', 'go', 'nnoremap', '<buffer>', '<F10>',  ':GoDebugStepOut<CR>'}
},'goKeys')

-- CMP / LSP
-- map('n', '<Space>e', vim.diagnostic.open_float, opt_noremap_silent)
-- map('n', '[d', vim.diagnostic.goto_prev, opt_noremap_silent)
-- map('n', ']d', vim.diagnostic.goto_next, opt_noremap_silent)
