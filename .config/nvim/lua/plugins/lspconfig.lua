-- TODO: look at the source code for lspconfig key's and redo mappings as needed
return {
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
			{ "folke/neodev.nvim", opts = {} },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					-- prefix = "icons",
				},
				severity_sort = true,
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = false,
			},
			-- add any global capabilities here
			capabilities = {},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				lua_ls = {
					-- mason = false, -- set to false if you don't want this server to be installed with mason
					-- Use this to add any additional keymaps
					-- for specific lsp servers
					---@type LazyKeysSpec[]
					-- keys = {},
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			},
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
		keys = {},
		config = function(_, opts)
			local Util = require("util")
			require("neoconf").setup()

			-- Setup LSP keys on the buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buffer = args.buf ---@type number
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.supports_method("textDocument/inlayHint") then
						Util.toggle.inlay_hints(buffer, true)
					end
					vim.keymap.set(
						"n",
						"<leader>cl",
						"<cmd>LspInfo<CR>",
						{ desc = "Lsp Info", buffer = buffer, silent = true }
					)

					vim.keymap.set("n", "gd", function()
						require("telescope.builtin").lsp_definitions({ reuse_win = true })
					end, { desc = "Goto Definition", silent = true })

					vim.keymap.set(
						"n",
						"gr",
						"<CMD>Telescope lsp_references<CR>",
						{ desc = "References", silent = true }
					)

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration", silent = true })

					vim.keymap.set("n", "gI", function()
						require("telescope.builtin").lsp_implementations({ reuse_win = true })
					end, { desc = "Goto Implementation", silent = true })

					vim.keymap.set("n", "gy", function()
						require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
					end, { desc = "Goto T[y]pe Definition", silent = true })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", silent = true })
					vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help", silent = true })
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ desc = "Code Action", silent = true }
					)
					vim.keymap.set("n", "<leader>cA", function()
						vim.lsp.buf.code_action({
							context = {
								only = {
									"source",
								},
								diagnostics = {},
							},
						})
					end, { desc = "Source Action", silent = true })
				end,
			})

			-- diagnostics
			local diagnostics = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for name, icon in pairs(diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
					or function(diagnostic)
						for d, icon in pairs(diagnostics) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
		end,
	},
	-- cmdline tools and lsp servers
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				-- "flake8",
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
	},
}
