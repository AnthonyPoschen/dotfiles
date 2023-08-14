" au BufRead,BufNewFile *.ts set filetype=typescript
" au BufNewFile,BufRead ~/.ssh/prod,~/.ssh/prodall,~/.ssh/dev setf sshconfig
autocmd FileType css,html,javascript,vue,yaml,yml,typescript,typescriptreact,json setlocal ts=2 | setlocal sw=2 | setlocal sts=2

" Make netrw display line number
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

let g:rg_derive_root = 1
let g:rg_highlight = 1
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
let g:golden_ratio_exclude_filetypes = ["help","vim","vim-plug","qf","git","fugitive","fugitiveblame","godoc","godebug*"]
" Python executable locations for :pyx support
let g:python3_host_prog = '/opt/homebrew/bin/python3'
let g:python2_host_prog = '/Library/Frameworks/Python.framework/Versions/2.7/bin/python2'
" Break lines
" Package Manger for vim
filetype plugin on
filetype plugin indent on    " required by vim-go
syntax on
let g:go_gocode_propose_source = 1
let g:go_fmt_command = "goimports"
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_def_mapping_enabled = 0


" do not close the preview tab when switching to other buffers
let g:mkdp_auto_close = 0

" filetypes for closetag to close
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.tsx,*.jsx'

" config for tagbar
" let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:30%']
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" nmap <Leader>t :Vista!!<CR>
" let g:tagbar_autofocus = 1
" let g:tagbar_left = 1

" language bound keybinds, currently hard set for golang
" nnoremap <Leader>lv :GoCoverageToggle<cr>
function! DebugGo()
    if expand("%") =~ '_test.go'
        if exists(":GoDebugTest")
           execute ':GoDebugTest'
           return
        endif
    else
        if exists(":GoDebugStart")
           execute ':GoDebugStart'
           return
        endif
    endif
    execute ':GoDebugContinue'
endfunction
" this is needed to override all of the keys that vim-go sets for debugging
" because i want to simplify shit
function! DebugStop()
    execute ":GoDebugStop"
    execute "doautocmd goKeys FileType go"
endfunction

" disable vim-go godoc so we can use coc's K
let g:go_doc_keywordprg_enabled = 0
" allow suggestions for unimported packages
let g:go_gopls_complete_unimported = "gopls"
" The editor.action.organizeImport code action will auto-format code and add missing imports. To run this automatically on save, add the following line to your init.vim:
" autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
" modify go add tags to use camelcase instead of snakeCase
let g:go_addtags_transform = "camelcase"
" set window layout for go-vim debugging mode
let g:go_debug_windows = {
        \ 'vars':       'leftabove 60vnew',
        \ 'stack':      'leftabove 20new',
        \ 'goroutines': 'botright 10new',
        \ 'out':        'belowright vnew',
\ }

" let g:go_debug_log_output = 'debugger,rpc'
let g:go_debug_log_output = 'debugger,rpc'

" ranger config
let g:ranger_map_keys = 0
let g:ranger_command_override = 'ranger --cmd "set hidden_filter \.(?:pyc|pyo|bak|swp|git)$|^lost\+found$|^__(py)?cache__$|^vendor$"'

" FZF config
let g:fzf_prefer_tmux = 1
" noremap <Leader>f :Files <cr>
" noremap <Leader>f :Telescope find_files<cr>
" noremap <Leader>b :Telescope buffers <cr>
" nnore <C-W>s :<C-U>sp \| :Buffers <CR>
" nnore <C-W>v :<C-U>vsp \| :Buffers <CR>

" git fugitive review staged changes in a new tab
" command Greview :tabedit<cr> :r !git diff --staged | grep "^[^\+\-\ ]"
" command Greview :Gtabedit! diff --staged
" command Greview :Gtabedit! diff --staged \| grep \"^[^\+-\ ]\"
" nnoremap <leader>gr :Greview<cr>

" nnoremap <M-c> :Calendar -position=here -first_day=monday<cr>
" let g:calendar_view = "week"
" let g:calendar_google_calendar = 1
" let g:calendar_google_task = 1
" let g:calendar_views = ['year', 'month', 'week' , 'day' , 'clock' ]

" theme
let g:onedark_termcolors=256
let g:onedark_terminal_italics=1
syntax enable
set background=dark
colorscheme onedark

" colors for coc vim
" :help CocHighlightText
" Floats are the virtual


" :Find command with RipGrep
" FZF Config 
" TODO: enable or delete as telescope is now installed
" let $FZF_DEFAULT_OPTS='--layout=reverse'
" let $FZF_DEFAULT_COMMAND="rg --files --hidden --follow --smart-case --glob '!.git/*' --glob '!vendor/*'"
" let g:fzf_layout = { 'window': 'call FloatingFZF()' }
"
" function! FloatingFZF()
"   let buf = nvim_create_buf(v:false, v:true)
"   call setbufvar(buf, '&signcolumn', 'no')
"
"   let height = &lines - 3
"   let width = float2nr(&columns - (&columns * 2 / 10))
"   let col = float2nr((&columns - width) / 2)
"
"   let opts = {
"         \ 'relative': 'editor',
"         \ 'row': 1,
"         \ 'col': col,
"         \ 'width': width,
"         \ 'height': height
"         \ }
"
"   call nvim_open_win(buf, v:true, opts)
" endfunction
" command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --files --glob "!.git" --glob "!vendor" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Trailing Spaces Highlight and Detection for Line/Tabs.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" autocmd FileType DiffviewFileHistory nnoremap <C-c> :DiffviewClose<CR>

""""""""""""""""""""""""""
" Dim inactive windows
hi def Dim cterm=none ctermbg=none ctermfg=242
let g:dimIgnoreList = 'help\|vim\|vim-plug\|qf\|git\|fugitive\|fugitiveblame\|godoc\|vista\|godebug*'
let g:dimprvWin = ''
function! s:DimInactiveWindow()
    " set filetypes to ignore dim effect
    let g:dimprvWin = bufnr("%")
	if &ft =~ g:dimIgnoreList
        return
    endif
    syntax region Dim start='' end='$$$end$$$'
endfunction

function! s:UndimActiveWindow()
    " reset keybinds for go debugging because fuck vim-go
    execute "doautocmd goKeys FileType go"
    ownsyntax
endfunction

" autocmd WinEnter * call s:UndimActiveWindow()
" autocmd BufEnter * call s:UndimActiveWindow()
" autocmd WinLeave * call s:DimInactiveWindow()

function! s:goldenRatioDisabler()
	if &ft =~ g:dimIgnoreList
		  let g:golden_ratio_autocommand = 0
	endif
endfunction
function! s:goldenRatioEnabler()
	if &ft =~ g:dimIgnoreList
		  let g:golden_ratio_autocommand = 0
	endif
endfunction
autocmd WinEnter * call s:goldenRatioDisabler()
autocmd BufEnter * call s:goldenRatioDisabler()
autocmd WinLeave * call s:goldenRatioDisabler()
autocmd QuitPre * call s:goldenRatioEnabler()
" autocmd WinEnter * call set tabstop&
" autocmd FileType make setlocal noexpandtab

""""""""""""""""""""""""""
" Copilot
let g:copilot_no_tab_map = v:true " required atm as lua broken to test working
let g:copilot_assume_mapped = v:true " required atm as lua broken to test working
let g:copilot_proxy = $HTTPS_PROXY

""""""""""""""""""""""""""
""""""""""""""""""""""""""
""""""""""""""""""""""""""
lua require('plugins')
lua require('vim_options')
lua require('keybinds')
" learning materials for lua
" https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
lua <<EOF
-- Aesthetic
-- pcall catches errors if the plugin doesn't load

require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
    term_colors = false,
    dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.25,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})
vim.cmd.colorscheme "catppuccin"
-- copilot setup
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- Telescope config
local actions = require "telescope.actions"
require('telescope').setup({
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
  },
  defaults = {
    prompt_prefix = "$ ",
    file_ignore_patterns = {".git/","vendor/","node_modules/"},
    mappings = {
        i = {
            -- ["<c-a>"] = function() print(vim.inspect(action_state.get_selected_entry())) end
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
            ["<c-c>"] = actions.close,
        },
        n = {
            ["<c-k>"] = actions.preview_scrolling_up,
            ["<c-j>"] = actions.preview_scrolling_down,
            ["<c-c>"] = actions.close,
        }
      }
  },
  pickers = {
    find_files = {
        theme = "dropdown",
        hidden = true,
    },
    file_browser = {
        hidden = true,
    },
  }
})
-- require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
-- require('telescope').load_extension('coc')
-- lualine
require('lualine').setup{
  options = {
    theme = 'catppuccin'
  }
}

-- https://github.com/sindrets/diffview.nvim
local actions = require("diffview.actions")
require("diffview").setup({
keymaps = {
        view = {
            ["<c-c>"] = "<cmd>tabc<cr>",
        },
        file_history_panel = {
            ["<c-c>"] = "<cmd>tabc<cr>",
        },
        file_panel = {
            ["<c-c>"] = "<cmd>tabc<cr>",
        }
    }
})

-- native lsp setup
-- global setup.
local ok, cmp = pcall(require, "cmp")
if not ok then return end
-- configure functions to be used in mappings for tab and shift tab navigating completion menu's
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
-- formatting for vs code like icons
local cmp_kinds = {
  text = '  ',
  method = '  ',
  -- 'function' = '  ',
  constructor = '  ',
  field = '  ',
  variable = '  ',
  class = '  ',
  interface = '  ',
  module = '  ',
  property = '  ',
  unit = '  ',
  value = '  ',
  enum = '  ',
  keyword = '  ',
  snippet = '  ',
  color = '  ',
  file = '  ',
  reference = '  ',
  folder = '  ',
  enummember = '  ',
  constant = '  ',
  struct = '  ',
  event = '  ',
  operator = '  ',
  typeparameter = '  ',
}
local luasnip = require("luasnip")
cmp.setup({
  formatting = {
    fields = { "kind", "abbr" },
    format = function(_, vim_item)
      vim_item.kind = cmp_kinds[vim_item.kind] or ""
      return vim_item
    end,
  },
    snippet = {
       expand = function(args)
         require('luasnip').lsp_expand(args.body) -- for `luasnip` users.
       end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
   },
    mapping = {
        ['<c-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        -- ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<c-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        -- accept currently selected item. if none selected, `select` first item.
        -- set `select` to `false` to only confirm explicitly selected items.
        ['<cr>'] = cmp.mapping.confirm({ select = true }),
        ['<tab>'] = cmp.mapping(function(fallback)
            -- local copilot_keys = vim.fn['copilot#accept']()
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            -- elseif copilot_keys ~= '' and type(copilot_keys) == 'string' then
            --     vim.api.nvim_feedkeys(copilot_keys, 'i', true)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<c-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<s-tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<c-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" })
    },
    sources = cmp.config.sources({
        { name = 'luasnip' }, -- for luasnip users.
        { name = 'nvim_lsp' },
        { name = 'path' }, -- for path completion
        { name = 'buffer', keyword_length = 4 }, -- for buffer word completion
        { name = 'omni' },
        { name = 'emoji', insert = true, } -- emoji completion
    }),
    completion = {
        keyword_length = 1,
        completeopt = "noinsert,menuone,noselect,preview"
    },
})

-- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- snippet support
capabilities.textDocument.completion.completionItem.snippetSupport = true
luasnip.snippets = {
  html = {}
}
-- setup document color coding
capabilities.textDocument.colorprovider = {
  dynamicregistration = true
}
luasnip.filetype_extend("javascript", {"html"})
luasnip.filetype_extend("javascriptreact", {"html"})
luasnip.filetype_extend("typescriptreact", {"html"})
require("luasnip/loaders/from_vscode").load({include = {"html"}})
require("luasnip.loaders.from_vscode").lazy_load() -- lazy load in luasnip vscode plugins
require("mason").setup({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }

})

-- mappings.
-- see `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
-- use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    if client.server_capabilities.colorprovider then
        -- attach document colour support
        require("document-color").buf_attach(bufnr)
    end
    local builtin = require('telescope.builtin')

    -- mappings.
    -- see `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    -- todo: delete defaults once happy
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, bufopts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    -- vim.keymap.set('n', 'k', vim.lsp.buf.hover, bufopts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    -- vim.keymap.set('n', '<space>d', vim.lsp.buf.type_definition, bufopts)
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

    -- above is defaults
    buf_set_keymap('n', '<c-d>', "<cmd>Telescope lsp_definitions<cr>", opts)
    -- buf_set_keymap('n', '<c-d>', "<cmd>builtin.lsp_definitions<cr>", opts)
	buf_set_keymap('n', '<c-r>', "<cmd>Telescope lsp_references<cr>", opts)

	buf_set_keymap('n', 's', "<cmd>Telescope lsp_document_symbols<cr>", opts)
	buf_set_keymap('n', '<leader>k', "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

	buf_set_keymap('n', '<leader>i', "<cmd>Telescope lsp_implementations<cr>", opts)
	buf_set_keymap('n', '<leader>k', "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
	buf_set_keymap('n', '<leader>d', "<cmd>Telescope lsp_type_definitions<cr>", opts)
	buf_set_keymap('n', '<leader>rn', "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	buf_set_keymap('n', '<leader>ca', "<cmd>Telescope lsp_code_actions<cr>", opts)
	buf_set_keymap('n', 'gd', "<cmd> lua vim.lsp.buf.type_definition()<cr>", opts)
	buf_set_keymap('n', 'gi', "<cmd> lua vim.lsp.buf.implementation()<cr>", opts)
	buf_set_keymap('n', '<leader>dj', "<cmd> lua vim.diagnostic.goto_next()<cr>", opts)
	buf_set_keymap('n', '<leader>dk', "<cmd> lua vim.diagnostic.goto_prev()<cr>", opts)
	buf_set_keymap('n', '<leader>dl', "<cmd>Telescope diagnostics<cr>", opts)
	buf_set_keymap('n', '<leader>r', "<cmd> lua vim.lsp.buf.rename()<cr>", opts)
	buf_set_keymap('n', '<leader>ca', "<cmd> lua vim.lsp.buf.code_action()<cr>", opts)
    -- vim.cmd([[
    --     augroup formatting
    --         autocmd! * <buffer>
    --         autocmd bufwritepre <buffer> lua vim.lsp.buf.format()
    --         autocmd bufwritepre <buffer> lua organizeimports(150)
    --     augroup end
    -- ]])
    --
    -- -- set autocommands conditional on server_capabilities
    -- vim.cmd([[
    --     augroup lsp_document_highlight
    --         autocmd! * <buffer>
    --         autocmd cursorhold <buffer> lua vim.lsp.buf.document_highlight()
    --         autocmd cursormoved <buffer> lua vim.lsp.buf.clear_references()
    --     augroup end
    -- ]])
end
vim.api.nvim_create_autocmd("bufwritepre", {
  pattern = { "*.go" },
  callback = function()
	  vim.lsp.buf.formatting_sync(nil, 3000)
  end,
})

vim.api.nvim_create_autocmd("bufwritepre", {
	pattern = { "*.go" },
	callback = function()
		local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
		params.context = {only = {"source.organizeimports"}}

		local result = vim.lsp.buf_request_sync(0, "textdocument/codeaction", params, 3000)
		for _, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
				else
					vim.lsp.buf.execute_command(r.command)
				end
			end
		end
	end,
})

local lspconfig = require('lspconfig')
lspconfig.gopls.setup{
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			gofumpt = true,
		},
	},
	flags = {
		debounce_text_changes = 150,
	},
}
lspconfig.golangci_lint_ls.setup{
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {},
	flags = {
		debounce_text_changes = 150,
	},
}

local lsp_flags = {
  -- this is the default in nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['gopls'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['dockerls'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['tsserver'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['tailwindcss'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['cssls'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['cssmodules_ls'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['html'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    -- filetypes = { 'html','typescriptreact' },
}
require('lspconfig')['jsonls'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['pyright'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['rust_analyzer'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    -- server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
require('lspconfig')['luau_lsp'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['prismals'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['vimls'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['yamlls'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
        yaml = {
          schemas = {
            kubernetes = "*.{yml,yaml}",
            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
            ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
            ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
            ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
            ["http://json.schemastore.org/chart"] = "chart.{yml,yaml}",
            ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
            ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
            ["https://raw.githubusercontent.com/oai/openapi-specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
            ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
          },
        },
    },
}

vim.api.nvim_create_autocmd({'bufenter','bufadd','bufnew','bufnewfile','bufwinenter'}, {
  group = vim.api.nvim_create_augroup('ts_fold_workaround', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})

EOF

