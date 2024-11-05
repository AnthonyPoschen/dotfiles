require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.autocmds")

--TODO: which-key is reporting mysterious overlaps with "g" "gc" only other bindings is git related
-- TODO: move this once its working-- See `:h vim.filetype.add()` for more info
vim.filetype.add({
	-- Match by filename
	filename = {
		-- Set custom filetype and indentation config of spaces, 2 per indent
		["changelog.txt"] = function(path, bufnr)
			if vim.fs.find({ "info.json" }, { path = vim.fs.dir(path)() }) then
				vim.bo[bufnr].shiftwidth = 2
				vim.bo[bufnr].tabstop = 2
				vim.bo[bufnr].softtabstop = 2
				vim.bo[bufnr].expandtab = true
				return "factorio-changelog"
			end
		end,
	},
	-- Match by path pattern
	pattern = {
		[".*/locale/.*/.*%.cfg"] = "factorio-locale",
	},
})

local lspconfig = require("lspconfig")
local lsp_configs = require("lspconfig.configs")

-- See `:h lspconfig-new` for more information on creating language server configs
if not lsp_configs.fmtk_lsp then
	lsp_configs.fmtk_lsp = {
		default_config = {
			-- The command to start the language server
			cmd = { "npx", "--yes", "factoriomod-debug", "lsp", "--stdio" },
			-- The filetypes that the language server will be launched for
			filetypes = { "factorio-changelog", "factorio-locale", "lua" },
			-- Hints to find the project root
			root_dir = lspconfig.util.root_pattern("changelog.txt", "info.json"),
			-- Additional Language Server settings can be added here
			settings = {},
		},
	}
end
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

parser_configs.factorio_changelog = {
	install_info = {
		url = "~/projects/tree-sitter/tree-sitter-factorio-changelog",
		files = { "src/parser.c" },
		generate_requires_npm = false,
	},
	filetype = "factorio-changelog",
}

parser_configs.factorio_locale = {
	install_info = {
		url = "~/projects/tree-sitter/tree-sitter-factorio-locale",
		files = { "src/parser.c" },
		generate_requires_npm = false,
	},
	filetype = "factorio-locale",
}
