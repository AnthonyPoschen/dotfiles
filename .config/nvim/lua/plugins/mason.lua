return {
	"williamboman/mason.nvim",
	cmd = "Mason",
	keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
	build = ":MasonUpdate",
	opts = {
		ensure_installed = {
			"asmfmt",
			"ast-grep",
			"bash-language-server",
			"buf",
			"css-lsp",
			"cssmodules-language-server",
			"delve",
			"docker-compose-language-service",
			"dockerfile-language-server",
			"eslint-lsp",
			"fixjson",
			"gitlint",
			"go-debug-adapter",
			"gofumpt",
			"goimports",
			"goimports-reviser",
			"golangci-lint-langserver",
			"golines",
			"gomodifytags",
			"gopls",
			"gotests",
			"gotestsum",
			"hadolint",
			"helm-ls",
			"html-lsp",
			"htmx-lsp",
			"iferr",
			"jq",
			"jq-lsp",
			"json-lsp",
			"json-to-struct",
			"lua-language-server",
			"luau-lsp",
			"markdownlint",
			"marksman",
			"nilaway",
			"prettier",
			"python-lsp-server",
			"shfmt",
			"stylua",
			"tailwindcss-language-server",
			"templ",
			"ts-standard",
			"typescript-language-server",
			"vim-language-server",
			"yaml-language-server",
			"yamlfmt",
			"yamllint",
		},
	},
	---@param opts MasonSettings | {ensure_installed: string[]}
	config = function(_, opts)
		require("mason").setup(opts)
		local mr = require("mason-registry")
		mr:on("package:install:success", function()
			vim.defer_fn(function()
				-- trigger FileType event to possibly load this newly installed LSP server
				require("lazy.core.handler.event").trigger({
					event = "FileType",
					buf = vim.api.nvim_get_current_buf(),
				})
			end, 100)
		end)
		local function ensure_installed()
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end
		if mr.refresh then
			mr.refresh(ensure_installed)
		else
			ensure_installed()
		end
	end,
}
