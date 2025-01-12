-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Enable LazyVim auto format
vim.g.autoformat = true
-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
opt.autowrite = true -- Enable auto write
opt.timeoutlen = 300
opt.ts = 4
opt.sw = 4
opt.sts = 4
opt.colorcolumn = "80"
-- for specific files change the tabbing to 2
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"css",
		"html",
		"javascript",
		"vue",
		"yaml",
		"yml",
		"typescript",
		"typescriptreact",
		"json",
		"templ",
	},
	command = "setlocal ts=2 sw=2 sts=2",
})
-- additional filetypes
vim.filetype.add({
	extension = {
		templ = "templ",
	},
})
opt.listchars = { eol = " ", tab = "  ", trail = "-", extends = ">", precedes = "<", nbsp = "␣" }
opt.list = true

opt.confirm = true -- confirm if you want to close unsaved files
opt.wrap = false
-- opt.vb = true -- turn off beep sound = true
opt.number = true
opt.relativenumber = true
opt.inccommand = "split" -- preview incremental substitute
opt.guicursor = ""

-- opt.backup = false
-- opt.writebackup = false
-- opt.swapfile = false

-- Always show at least one line above/below the cursor.
opt.scrolloff = 4
-- Always show at least one line left/right of the cursor.
opt.sidescrolloff = 5

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- folding settings
opt.foldmethod = "syntax" -- fold based on indent
-- opt.foldenable = false -- dont fold by default
-- set foldlevel=1       -- this is just what i use

-- override
-- opt.completeopt = "menu,menuone,preview,noinsert,noselect"
-- add's - to keywords so autocomplete is awesome in css
opt.iskeyword = opt.iskeyword + "-"

-- Better copy & paste
-- When you want to paste large blocks of code into vim, press F4 before you
-- paste. At the bottom you should see ``-- INSERT (paste) --``.
-- opt.pastetoggle = "<F4>"

-- wild card ignores
opt.wildignore = opt.wildignore + "*.pyc,*.swp,.git,**/migrations/**,**/beans/**"

-- Smaller updatetime for CursorHold & CursorHoldI
opt.updatetime = 200
-- don't give |ins-completion-menu| messages.
-- opt.shortmess = opt.shortmess + "c"
-- always show signcolumns
opt.signcolumn = "yes"
opt.fillchars = opt.fillchars + "diff:╱"

opt.clipboard = "unnamedplus" -- old config set clipboard^=unnamed
opt.termguicolors = true

opt.signcolumn = "number" -- incase broken use set signcolumn=yes
opt.background = "dark"

opt.syntax = "enable"

opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
-- opt.expandtab = true -- Use spaces instead of tabs
-- opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.laststatus = 3 -- global statusline
opt.mouse = "a" -- Enable mouse mode
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
-- Split to right and below by default
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.undofile = true
opt.undolevels = 10000
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	-- fold = "⸱",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.foldlevel = 99

--TODO: review if needed once util refactor done
-- opt.foldtext = "v:lua.require'util'.ui.foldtext()"
-- opt.statuscolumn = [[%!v:lua.require'util'.ui.statuscolumn()]]
-- HACK: causes freezes on <= 0.9, so only enable on >= 0.10 for now
-- if vim.fn.has("nvim-0.10") == 1 then
-- 	vim.opt.foldmethod = "expr"
-- 	vim.opt.foldexpr = "v:lua.require'util'.ui.foldexpr()" -- this line causes :e to freeze
-- else
-- 	vim.opt.foldmethod = "indent"
-- end
-- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Fix markdown indentation settings
-- vim.g.markdown_recommended_style = 0
