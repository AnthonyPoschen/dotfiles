return {
	{
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
				"sql-formatter",
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
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"b0o/schemastore.nvim",
			"nvim-telescope/telescope.nvim",
			-- "Issafalcon/lsp-overloads.nvim",
			"Hoffs/omnisharp-extended-lsp.nvim",
			-- "Decodetalkers/csharpls-extended-lsp.nvim",
		},
		config = function()
			-- on_attach function to overwrite the default keymaps
			local function map(keys, func, desc, bufnr)
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

			-- These can have more fields like cmd, settings and filetypes
			local servers = {
				marksman = {},
				arduino_language_server = {},
				zls = {},
				bashls = {
					filetypes = { "sh", "zsh", "zshrc" },
				},
				clangd = {},
				rust_analyzer = {},
				gopls = {

					keys = {
						-- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
						{ "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
					},
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = false,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							experimentalPostfixCompletions = true,
							-- organizeImports = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},
				mesonlsp = {},
				powershell_es = {
					settings = {
						powershell = {
							enableProfileLoading = false,
						},
					},
				},
				html = {},
				azure_pipelines_ls = {},
				docker_compose_language_service = {},
				dockerls = {},
				-- nginx_language_server = {},
				ts_ls = {
					settings = {
						javascript = {
							inlayHints = {
								enumMemberValues = {
									enabled = true,
								},
								functionLikeReturnTypes = {
									enabled = true,
								},
								parameterNames = {
									enabled = true,
									suppressWhenArgumentMatchesName = true,
								},
								parameterTypes = {
									enabled = true,
								},
								propertyDeclarationTypes = {
									enabled = true,
								},
								variableTypes = {
									enabled = true,
									suppressWhenTypeMatchesName = true,
								},
							},
						},
						typescript = {
							inlayHints = {
								enumMemberValues = {
									enabled = true,
								},
								functionLikeReturnTypes = {
									enabled = true,
								},
								parameterNames = {
									enabled = true,
									suppressWhenArgumentMatchesName = true,
								},
								parameterTypes = {
									enabled = true,
								},
								propertyDeclarationTypes = {
									enabled = true,
								},
								variableTypes = {
									enabled = true,
									suppressWhenTypeMatchesName = true,
								},
							},
						},
					},
				},
				taplo = {
					settings = {
						evenBetterToml = {
							schema = {
								associations = {
									[".air.toml"] = "file://~/.config/nvim/schemas/air_schema.json",
								},
							},
						},
					},
				},
				-- sqls = {},
				pylsp = {},
				jqls = {},
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas({
								select = {
									".eslintrc",
									"package.json",
								},
							}),
							validate = { enable = true },
						},
					},
				},
				-- typos_lsp = {},
				lemminx = {
					settings = {
						xml = {
							validation = {
								filters = {
									{
										pattern = "**.*sproj",
										noGrammar = "ignore",
									},
								},
							},
						},
					},
				},
				tailwindcss = {
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ "cva\\(([^)]*)\\)", "[\"'`]?([^\"'`]*).*?[\"'`]?" },
									{ "cx\\(([^)]*)\\)", "[\"'`]?([^\"'`]*).*?[\"'`]?" },
								},
							},
						},
					},
					filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
				},
				glsl_analyzer = {},
				yamlls = {
					capabilities = {
						textDocument = {
							foldingRange = {
								dynamicRegistration = false,
								lineFoldingOnly = true,
							},
						},
					},
					settings = {
						yaml = {
							editor = {
								formatOnType = false,
							},

							schemaStore = {
								-- You must disable built-in schemaStore support if you want to use
								-- this plugin and its advanced options like `ignore`.
								enable = false,
								-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
							customTags = {
								"!Ref",
								"!Sub",
								"!GetAtt",
								"!Join",
								"!Select",
								"!ImportValue",
								"!Condition",
								"!Equals",
								"!Not",
								"!Or",
								"!And",
								"!If",
							},
							schemaValidation = "error",
							validate = { enable = true },
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = (function()
									local library_paths = {}
									local cwd = vim.fn.getcwd()

									-- Add Neovim runtime files if in Neovim config
									if cwd:match(vim.fn.stdpath("config")) then
										vim.list_extend(library_paths, vim.api.nvim_get_runtime_file("", true))
									end

									-- Add Factorio Lua objects if in a Factorio repo
									-- Match any path containing "factorio"
									if cwd:match("factorio") then
										-- Add the current working directory to library paths
										vim.list_extend(library_paths, { "~/.local/factorio/" })
									end

									return library_paths
								end)(),
							},
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = {
								globals = (function()
									local globals = { "vim" }
									local cwd = vim.fn.getcwd()

									-- Add Factorio globals if in a Factorio repo
									local factorio_paths = {
										"/factorio",
									}
									for _, path in ipairs(factorio_paths) do
										if cwd:match(path) then
											vim.list_extend(
												globals,
												{ "game", "script", "remote", "commands", "settings", "data", "mods" }
											)
											break
										end
									end

									return globals
								end)(),
							},
						},
					},
					-- Keep the root_dir function as it's used during setup, not sent to server
					root_dir = function(fname)
						local nvim_config = vim.fn.stdpath("config")
						local in_nvim_config = fname:match(nvim_config)

						-- For Factorio mods
						local is_factorio_mod = fname:match("/factorio/")
							or vim.fn.filereadable(vim.fn.getcwd() .. "/info.json") == 1

						if in_nvim_config then
							return nvim_config
						elseif is_factorio_mod then
							-- Use the mod directory as root for Factorio mods
							return vim.fn.getcwd()
						else
							-- Default root dir logic from lspconfig
							return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
								or vim.fs.dirname(vim.fs.find("node_modules", { path = fname, upward = true })[1])
								or vim.fs.dirname(vim.fs.find("package.json", { path = fname, upward = true })[1])
								or vim.fs.dirname(
									vim.fs.find(
										{ ".luarc.json", ".luacheckrc", ".stylua.toml" },
										{ path = fname, upward = true }
									)[1]
								)
								or vim.fn.getcwd()
						end
					end,
				},
				--     enabled = false,
				--     handlers = {
				--         ["textDocument/definition"] = require("csharpls_extended").handler,
				--         ["textDocument/typeDefinition"] = require("csharpls_extended").handler,
				--     },
				-- },
				omnisharp = {
					settings = {
						csharp = {
							inlayHints = {
								enableInlayHintsForImplicitObjectCreation = true,
								enableInlayHintsForImplicitVariableTypes = true,
								enableInlayHintsForLambdaParameterTypes = true,
								enableInlayHintsForTypes = true,
							},
							debug = {
								symbolOptions = {
									searchMicrosoftSymbolServer = true,
									searchNuGetOrgSymbolServer = true,
								},
							},
							format = {
								enable = true,
							},
							-- maxProjectFileCountForDiagnosticAnalysis = 1000,
							referencesCodeLens = {
								-- filteredSymbols = {},
							},
						},
						dotnet = {
							inlayHints = {
								enableInlayHintsForIndexerParameters = true,
								enableInlayHintsForLiteralParameters = true,
								enableInlayHintsForObjectCreationParameters = true,
								enableInlayHintsForOtherParameters = true,
								enableInlayHintsForParameters = true,
								suppressInlayHintsForParametersThatDifferOnlyBySuffix = true,
								suppressInlayHintsForParametersThatMatchArgumentName = true,
								suppressInlayHintsForParametersThatMatchMethodIntent = true,
							},
						},
						omnisharp = {
							enableAsyncCompletion = true,
							enableDecompilationSupport = true,
							-- enableEditorConfigSupport = true,
							enableLspDriver = true,
							organizeImportsOnFormat = true,
							sdkIncludePrereleases = true,
						},
					},
					on_attach = function(client, bufnr)
						map("gd", require("omnisharp_extended").telescope_lsp_definition, "Telescope Definition", bufnr)
						map(
							"<leader>D",
							require("omnisharp_extended").telescope_lsp_type_definition,
							"Telescope Type Definition",
							bufnr
						)
						map(
							"grr",
							require("omnisharp_extended").telescope_lsp_references,
							"Telescope References",
							bufnr
						)
						map(
							"gri",
							require("omnisharp_extended").telescope_lsp_implementation,
							"Telescope Implementation",
							bufnr
						)
					end,
				},
			}

			-- require("mason").setup({
			-- 	max_concurrent_installers = 10,
			-- })

			-- TODO: remove if not needed after updating to 2.0
			-- require("mason-lspconfig").setup_handlers({
			-- 	-- The first entry (without a key) will be the default handler
			-- 	-- and will be called for each installed server that doesn't have
			-- 	-- a dedicated handler.
			-- 	function(server_name) -- default handler
			-- 		if not servers[server_name] then
			-- 			require("lspconfig")[server_name].setup({})
			-- 		end
			-- 	end,
			-- })

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					local params = vim.lsp.util.make_range_params()
					params.context = { only = { "source.organizeImports" } }
					-- buf_request_sync defaults to a 1000ms timeout. Depending on your
					-- machine and codebase, you may want longer. Add an additional
					-- argument after params if you find that you have to write the file
					-- twice for changes to be saved.
					-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
					for cid, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
								vim.lsp.util.apply_workspace_edit(r.edit, enc)
							end
						end
					end
					-- vim.lsp.buf.format({ async = false })
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- UFO (Folding)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

			require("mason-lspconfig").setup({
				automatic_installation = true,
				-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
				ensure_installed = vim.tbl_keys(servers),
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}

						-- Early exit if disabled
						if server.enabled == false then
							return
						end

						require("lspconfig")[server_name].setup({
							cmd = server.cmd,
							settings = server.settings,
							filetypes = server.filetypes,
							handlers = server.handlers,
							-- This handles overriding only values explicitly passed
							-- by the server configuration above. Useful when disabling
							-- certain features of an LSP (for example, turning off formatting for tsserver)
							capabilities = capabilities,
							on_attach = function(client, bufnr)
								-- Set up mappings
								map("K", vim.lsp.buf.hover, "Hover Documentation", bufnr)
								-- TODO: Rebind this because it classhes with harpoon
								-- map("<C-k>", vim.lsp.buf.signature_help, "Signature help", bufnr)
								map("gd", require("telescope.builtin").lsp_definitions, "Telescope Definition", bufnr)
								map("grr", require("telescope.builtin").lsp_references, "Telescope References", bufnr)
								map("gra", vim.lsp.buf.code_action, "Code Action", bufnr)
								map(
									"gri",
									require("telescope.builtin").lsp_implementations,
									"Telescope Implementation",
									bufnr
								)
								map("grn", vim.lsp.buf.rename, "Rename symbol", bufnr)

								map("grs", function()
									local lsp_symbols = vim.tbl_map(string.lower, vim.lsp.protocol.SymbolKind)
									-- define a filter function to excl. undesired symbols
									local symbols = vim.tbl_filter(function(symbol)
										return symbol ~= "field"
									end, lsp_symbols)
									require("telescope.builtin").lsp_document_symbols({ symbols = symbols })
									-- require("telescope.builtin").lsp_document_symbols,
								end, "Telescope Document Symbols", bufnr)
								map(
									"grw",
									require("telescope.builtin").lsp_dynamic_workspace_symbols,
									"Telescope Workspace Symbols",
									bufnr
								)

								-- Call the server's on_attach, if it exists
								if server.on_attach then
									server.on_attach(client, bufnr)
								end
							end,
						})
					end,
				},
			})
		end,
	},
}
