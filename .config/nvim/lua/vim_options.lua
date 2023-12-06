local opt = vim.opt

opt.ttyfast = true
opt.ttimeout = true
opt.ttimeoutlen = 50
opt.ts = 4
opt.sw = 4
opt.sts = 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css","html","javascript","vue","yaml","yml","typescript","typescriptreact","json" },
  command = "setlocal ts=2 sw=2 sts=2",
})
-- opt.listchars = {  eol="↲",tab="-",trail="-",extends=">",precedes="<",nbsp="␣" }
opt.list = true

opt.expandtab = true
opt.hidden = true
opt.backspace = "indent,eol,start"
opt.confirm = true
opt.ruler = true
opt.wrap = false
opt.vb = true -- turn off beep sound = true
opt.number = true
opt.relativenumber = true
opt.clipboard= "unnamedplus"
opt.inccommand= "split"
opt.guicursor = ""

opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Always show at least one line above/below the cursor.
opt.scrolloff = 2
-- Always show at least one line left/right of the cursor.
opt.sidescrolloff = 5

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- folding settings
opt.foldmethod = "syntax"   -- fold based on indent
opt.foldnestmax = 10      -- deepest fold is 10 levels
opt.foldenable = false       -- dont fold by default
-- set foldlevel=1       -- this is just what i use

-- Split to right and below by default
opt.splitright = true
opt.splitbelow = true

-- will buffer screens instead of updating
opt.lazyredraw = true

-- To make nvim faster, not exactly sure though.
-- set noshowcmd noruler

-- For command mode auto complete
opt.wildmenu = true
opt.wildmode = "longest:full,list:full"

opt.completeopt = "noinsert,menuone,noselect,preview"
-- add's - to keywords so autocomplete is awesome in css
opt.iskeyword = opt.iskeyword + "-"

-- Better copy & paste
-- When you want to paste large blocks of code into vim, press F4 before you
-- paste. At the bottom you should see ``-- INSERT (paste) --``.
opt.pastetoggle = "<F4>"

-- wild card ignores
opt.wildignore = opt.wildignore + "*.pyc,*.swp,.git,**/migrations/**,**/beans/**"

-- COC.vim SETUP
-- Better display for messages
opt.cmdheight = 1
-- Smaller updatetime for CursorHold & CursorHoldI
opt.updatetime = 300
-- don't give |ins-completion-menu| messages.
opt.shortmess = opt.shortmess + "c"
-- always show signcolumns
opt.signcolumn = "yes"
opt.fillchars = opt.fillchars + "diff:╱"

opt.clipboard = opt.clipboard + "unnamedplus" -- old config set clipboard^=unnamed
opt.termguicolors = true

opt.signcolumn = "number" -- incase broken use set signcolumn=yes
opt.background = "dark"

opt.syntax = "enable"
