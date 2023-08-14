-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
-- run :PackerCompile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- Theme
    use {'catppuccin/nvim', as = 'catppuccin'}
    --Markdown preview
    use 'ellisonleao/glow.nvim'
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    --File browsing
    use 'nvim-telescope/telescope-file-browser.nvim'

    --Buffer navigation
    use 'nvim-lualine/lualine.nvim'

    --Grammar checking because I can't english
    use 'rhysd/vim-grammarous'

    --Telescope Requirements
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    --Telescope
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use 'fannheyward/telescope-coc.nvim'

    --Git tools
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'TimUntersberger/neogit'


    --todo comments
    use 'folke/todo-comments.nvim'

    --devicons
    use 'kyazdani42/nvim-web-devicons'




    -- tabline visual tool
    -- use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}
    -- editor config
    use 'editorconfig/editorconfig-vim'
    --blank line showing
    use "lukas-reineke/indent-blankline.nvim"

    -- Configurations for Nvim LSP
    use 'neovim/nvim-lspconfig'
    use { "williamboman/mason.nvim" } -- LSP server manager
    use 'hrsh7th/nvim-cmp' -- completion engine
    use 'hrsh7th/cmp-nvim-lsp' -- use nviom-lspconfig for completions
    use 'hrsh7th/cmp-buffer' -- use buffer variables for completions
    use 'hrsh7th/cmp-path' -- use file system path for completions
    use({"L3MON4D3/LuaSnip", tag = "v1.*"}) -- snippet inserter ( can load vscode snippets check docs, can define own snippets easily too)
    use "rafamadriz/friendly-snippets" -- snippets for luasnip, make doing html easy
    use 'saadparwaiz1/cmp_luasnip' -- nvim-cmp integration for luasnip
    use { 'mrshmllow/document-color.nvim', config = function() -- plugin to do document colours
      require("document-color").setup {
        -- Default options
        mode = "single", -- "background" | "foreground" | "single"
      }
      end
    }

    --debugging
    use 'mfussenegger/nvim-dap' -- debugger
    use 'leoluz/nvim-dap-go' -- extra golang debugger features
    use 'theHamsta/nvim-dap-virtual-text' -- virtual text in debuggers for useful state changes without variable checking
    use 'nvim-telescope/telescope-dap.nvim' -- replace dap internal UI with telescope

    -- syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    -- github copilot
    use 'github/copilot.vim'
    --
    -- VIM plubins (not lua)
    --
    -- Color scheme
    use 'joshdick/onedark.vim'

    -- Tcomment for fast commenting and uncommenting of code
    use 'tomtom/tcomment_vim'

    -- RipGrep search
    use 'jremmen/vim-ripgrep'

    -- TODO: Review if needed
    use 'vim-scripts/matchit.zip'

    -- git plugins
    use 'tpope/vim-fugitive'

    -- Alternative file manager
    use 'rbgrouleff/bclose.vim'
    use 'francoiscabrol/ranger.vim'
    -- fuzzy search
    use {'junegunn/fzf', run = function() vim.fn['fzf#install()'](0) end }
    use 'junegunn/fzf.vim'

    -- align text
    use 'junegunn/vim-easy-align'

    -- Auto pair automatically closer bracers and quotations
    use 'jiangmiao/auto-pairs'

    -- show hex colors in vim
    use 'ap/vim-css-color'

    -- Color picker
    use 'KabbAmine/vCoolor.vim'
    -- git plugin
    use {'fatih/vim-go', run = ':GoUpdateBinaries' }
end)
