require('plugins')
require('vim_options')
require('keybinds')
--" learning materials for lua
--" https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- Aesthetic
-- copilot setup
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
vim.g.copilot_proxy = vim.env.HTTPS_PROXY


-- Telescope config
local actions = require "telescope.actions"
local cc = require('conventional_commits')
-- local ccactions = require("telescope._extensions.conventional_commits.actions")
require('telescope').setup({
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    conventional_commits = {
        action = cc.prompt,
        -- include_body_and_footer = true,
        -- action = function(entry)
        --     entry = {
        --         display = "feat       A new feature hello",
        --         index = 7,
        --         ordinal = "feat",
        --         value = "feat"
        --     }
        --     print(vim.inspect(entry))
        -- end,
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
require('telescope').load_extension("conventional_commits")
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
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  end
})

local lspconfig = require('lspconfig')
local util = require('lspconfig/util')
lspconfig.gopls.setup{
	capabilities = capabilities,
	on_attach = on_attach,
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
		gofumpt = true,
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
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
            -- kubernetes = "*.{yml,yaml}",
            ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.1-standalone/all.json"] = "*.{yml,yaml}",
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

-- vim.api.nvim_create_autocmd({'bufenter','bufadd','bufnew','bufnewfile','bufwinenter'}, {
--   group = vim.api.nvim_create_augroup('ts_fold_workaround', {}),
--   callback = function()
--     vim.opt.foldmethod     = 'expr'
--     vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
--   end
-- })
