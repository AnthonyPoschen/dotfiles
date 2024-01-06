-- TODO: look at the source code for lspconfig key's and redo mappings as needed
return {
	"neovim/nvim-lspconfig",
	init = function()
		local keys = require("lazy-plugins.lsp.keymaps").get()
		-- change a keymap
		-- keys[#keys + 1] = { "K", "<cmd>echo 'hello'<cr>" }
		-- disable opening LSP Info keybind
		keys[#keys + 1] = { "<leader>cl", false }
		-- add a keymap
		-- keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
	end,
	opts = {
		setup = {
			tailwindcss = function(_, opts)
				local default = require("lspconfig.server_configurations.tailwindcss")
				default.default_config.filetypes[#default.default_config.filetypes + 1] = "templ"
				default.default_config.init_options = { userLanguages = { templ = "html" } }
			end,
			htmx = function(_, opts)
				local default = require("lspconfig.server_configurations.htmx")
				default.default_config.filetypes[#default.default_config.filetypes + 1] = "templ"
			end,
			html = function(_, opts)
				local default = require("lspconfig.server_configurations.html")
				default.default_config.filetypes[#default.default_config.filetypes + 1] = "templ"
			end,
		},
	},
}
