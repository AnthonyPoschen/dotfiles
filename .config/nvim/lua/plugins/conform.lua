return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" } })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
	opts = {
		format = {
			timeout_ms = 3000,
			async = false, -- not recommended to change
			quiet = false, -- not recommended to change
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			lua = { "stylua" },
			fish = { "fish_indent" },
			sh = { "shfmt" },
			templ = { "templ" },
			yaml = { "yamlfmt" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			vue = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			less = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			markdown = { "prettier" },
			graphql = { "prettier" },
			handlebars = { "prettier" },
			sql = { "sql-formatter" },
		},
		-- The options you set here will be merged with the builtin formatters.
		-- You can also define any custom formatters here.
		---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
		formatters = {
			injected = { options = { ignore_errors = true } },
			["sql-formatter"] = {
				command = "sql-formatter",
				args = { "--fix", "$FILENAME" }, -- or adjust based on sql-formatter CLI options
				stdin = false,
				exit_codes = { 0 },
				-- If sql-formatter doesn't support in-place editing, use stdin
				-- args = { "--stdin" },
				-- stdin = true,
				-- Define where Mason installs the tool (optional, if not in PATH)
				-- Adjust this if Mason's install path isn't automatically picked up
				-- inherit = false,
				-- Example: assuming Mason installs to ~/.local/share/nvim/mason
				-- command = vim.fn.stdpath("data") .. "/mason/bin/sql-formatter",
			},
		},
	},
}
