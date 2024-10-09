-- TODO: evaluate if i should use https://github.com/prichrd/netrw.nvim to make netrw great again
-- TODO: maybe have discord presence of neovim? https://github.com/andweeb/presence.nvim
--
require("config.options")
require("config.keymaps")
-- lazy: package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	defaults = {
		lazy = false,
		version = "*", -- always use the latest git commit
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = false, -- get a notification when changes are found
	},
	install = { colorscheme = { "catppuccin", "tokyonight", "habamax" } },
	checker = { enabled = true }, -- automatically check for plugin updates
	performance = {
		cache = {
			enabled = true,
		},
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
	custom_keys = {
		-- disable default keys
		["<localleader>l"] = false,
		["<localleader>t"] = false,
	},
})
--" learning materials for lua
--" https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
vim.cmd.colorscheme("catppuccin")
require("config.autocmds")
-- copilot setup
-- TODO: See if the below is needed, if not delete
-- vim.g.copilot_proxy = vim.env.HTTPS_PROXY
-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""
