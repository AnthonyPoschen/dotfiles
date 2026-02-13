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
				templ = {},
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

			require("mason").setup({
				max_concurrent_installers = 10,
			})

			-- local mason_registry = require("mason-registry")
			-- local primary_servers = vim.tbl_keys(servers)
			-- local secondary_servers = { "gotests", "jsonls", "yamlls", "jqls", "pylsp", "docker_compose_language_service",
			-- 	"ts_ls", "dockerls", "rust_analyser", "bashls", "arduino_language_server", "docker_language_server",
			-- 	"tailwindcss", "lua_ls", "html" }
			-- local combined = {}
			-- for _, name in ipairs(primary_servers) do combined[name] = true end
			-- for _, name in ipairs(secondary_servers) do combined[name] = true end
			--
			-- for _, pkg in ipairs(mason_registry.get_installed_packages()) do
			-- 	local name = pkg.name
			-- 	if combined[name] == nil then
			-- 		vim.notify("Uninstalling unused LSP: " .. name)
			-- 		pkg:uninstall()
			-- 	end
			-- end
			-- require("mason-lspconfig").setup({
			-- 	automatic_enable = false,
			-- 	automatic_installation = true,
			-- 	ensure_installed = vim.tbl_keys(combined),
			-- })

			---
			---

			local mason_registry = require("mason-registry")
			local lsp_to_pkg = require("mason-lspconfig.mappings").get_all().lspconfig_to_package

			-- Your server keys
			local primary_servers = vim.tbl_keys(servers)
			local secondary_servers = {
				"jsonls",
				"yamlls",
				"jqls",
				"pylsp",
				"docker_compose_language_service",
				"ts_ls",
				"dockerls",
				"rust_analyzer",
				"bashls",
				"arduino_language_server",
				"docker_language_server",
				"tailwindcss",
				"lua_ls",
				"html",
			}
			local non_lsp_installs = { "gotests" }

			-- Combine and deduplicate LSP server names
			local combined_lsp_servers = {}
			for _, name in ipairs(primary_servers) do
				combined_lsp_servers[name] = true
			end
			for _, name in ipairs(secondary_servers) do
				combined_lsp_servers[name] = true
			end

			local ensure_installed = vim.tbl_keys(combined_lsp_servers)

			-- Convert LSP server names to Mason package names for uninstalling
			local valid_packages = {}
			for lsp_name, _ in pairs(combined_lsp_servers) do
				local pkg_name = lsp_to_pkg[lsp_name]
				if pkg_name then
					valid_packages[pkg_name] = true
				end
			end

			-- Uninstall unused Mason packages
			for _, pkg in ipairs(mason_registry.get_installed_packages()) do
				local name = pkg.name
				if not valid_packages[name] and not vim.tbl_contains(non_lsp_installs, name) then
					vim.notify("Uninstalling unused LSP: " .. name)
					pkg:uninstall()
				end
			end

			-- Setup Mason with correct LSP server names
			require("mason-lspconfig").setup({
				automatic_enable = false,
				automatic_installation = true,
				ensure_installed = ensure_installed,
			})
		end,
	},
}
