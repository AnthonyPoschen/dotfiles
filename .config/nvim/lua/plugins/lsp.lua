-- TODO: Review mason, all of the lsp config appears to be useless now
-- all related config to lsp should interact with neovim built in funtions now
-- this package seems like it is only useful for installing LSP servers now
return {
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
					-- capabilities = {
					-- 	textDocument = {
					-- 		foldingRange = {
					-- 			dynamicRegistration = false,
					-- 			lineFoldingOnly = true,
					-- 		},
					-- 	},
					-- },
					settings = {
						yaml = {
							editor = {
								formatOnType = false,
							},
							validate = true,
							schemaStore = { enable = false },
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
						},
					},
					on_init = function(client)
						if not client.config.root_uri then
							client.config.root_uri = vim.uri_from_fname(client.config.root_dir or vim.fn.getcwd())
						end
					end,
					root_dir = function(fname)
						return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
					end,
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
								or vim.fs.dirname(vim.fs.find("node_modules", { path = fname, upward = true })[0])
								or vim.fs.dirname(vim.fs.find("package.json", { path = fname, upward = true })[0])
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

			require("mason").setup({
				max_concurrent_installers = 10,
			})

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

			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
			local lspconfig = require("lspconfig")
			for server_name, server in pairs(servers) do
				-- Early exit if disabled
				if server.enabled == false then
					return
				end

				local opts = {
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						if server.on_attach then
							server.on_attach(client, bufnr)
						end
					end,
					cmd = server.cmd,
					settings = server.settings,
					filetypes = server.filetypes,
					handlers = server.handlers,
					root_dir = server.root_dir,
					on_init = server.on_init,
				}
				lspconfig[server_name].setup({ opts })
			end
			require("mason-lspconfig").setup({
				automatic_enable = false,
				automatic_installation = true,
				ensure_installed = vim.tbl_keys(servers),
			})
		end,
	},
}
