-- lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{ import = "lazyvim.plugins" },
		-- import any extras modules here
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.go" },
		{ "laytan/cloak.nvim" },
		{ "tpope/vim-fugitive" },
		{ "jremmen/vim-ripgrep" },
		{ "s1n7ax/nvim-window-picker" },

		-- { import = "lazyvim.plugins.extras.ui.mini-animate" },
		-- import/override with your plugins
		-- { import = "plugins" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = { enabled = true }, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
-- require("lazy").setup("lazyvim.plugins")
-- vim.opt.rtp:prepend(lazypath)
-- lazyvim
-- require('lazyvim').setup()
-- vim options and autocmds
require("vim_options")
-- need to remove any that are for plugins into its after file
--" learning materials for lua
--" https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

-- copilot setup
-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""
vim.g.copilot_proxy = vim.env.HTTPS_PROXY
require("conform").setup({
	formatters_by_ft = {
		go = { "goreturns" },
	},
})
