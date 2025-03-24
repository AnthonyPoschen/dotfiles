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
				volar = {},
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
								-- library = {
								-- 	"${3rd}/luv/library",
								-- 	"/Users/ap/.local/factorio",
								-- 	unpack(vim.api.nvim_get_runtime_file("", true)),
								-- },
							},
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
				-- csharp_ls = {
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
								-- console = "internalConsole",
								-- enableStepFiltering = true,
								expressionEvaluationOptions = {
									-- allowFastEvaluate = true,
									-- allowImplicitFuncEval = true,
									-- allowToString = true,
									-- showRawValues = false,
								},
								-- justMyCode = true,
								logging = {
									-- browserStdOut = true,
									-- consoleUsageMessage = true,
									diagnosticsLog = {
										-- debugEngineAPITracing = "none",
										-- debugRuntimeEventTracing = false,
										-- dispatcherMessages = "none",
										-- expressionEvaluationTracing = false,
										-- protocolMessages = false,
										-- startDebuggingTracing = false,
									},
									-- elapsedTiming = false,
									-- engineLogging = false,
									-- exceptions = true,
									-- moduleLoad = true,
									-- processExit = true,
									-- programOutput = true,
									-- threadExit = false,
								},
								-- requireExactSource = true,
								-- sourceFileMap = {},
								-- stopAtEntry = false,
								-- suppressJITOptimizations = false,
								symbolOptions = {
									-- cachePath = "",
									moduleFilter = {
										-- excludedModules = {},
										-- includeSymbolsNextToModules = true,
										-- includeSymbolsOnDemand = true,
										-- includedModules = {},
										-- mode = "loadAllButExcluded",
									},
									searchMicrosoftSymbolServer = true,
									searchNuGetOrgSymbolServer = true,
									-- searchPaths = {},
								},
							},
							format = {
								-- enable = true,
							},
							-- maxProjectFileCountForDiagnosticAnalysis = 1000,
							referencesCodeLens = {
								-- filteredSymbols = {},
							},
							-- semanticHighlighting.enabled = true,
							-- showOmnisharpLogOnError = true,
							-- suppressBuildAssetsNotification = false,
							-- suppressDotnetInstallWarning = false,
							-- suppressDotnetRestoreNotification = false,
							-- suppressHiddenDiagnostics = true,
							-- suppressProjectJsonWarning = false,
						},
						dotnet = {
							-- defaultSolution = "",
							backgroundAnalysis = {
								-- analyzerDiagnosticsScope = "openFiles",
								-- compilerDiagnosticsScope = "openFiles",
							},
							codeLens = {
								-- enableReferencesCodeLens = true,
								-- enableTestsCodeLens = true,
							},
							completion = {
								-- provideRegexCompletions = "true",
								-- showCompletionItemsFromUnimportedNamespaces = true,
								-- showNameCompletionSuggestions = "true",
							},
							highlighting = {
								-- highlightRelatedJsonComponents = "true",
								-- highlightRelatedRegexComponents = "true",
							},
							implementType = {
								-- insertionBehavior = "withOtherMembersOfTheSameKind",
								-- propertyGenerationBehavior = "preferThrowingProperties",
							},
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
							-- navigation.navigateToDecompiledSources = "true",
							-- quickInfo.showRemarksInQuickInfo = "true",
							-- symbolSearch.searchReferenceAssemblies = true,
							-- unitTestDebuggingOptions = {},
							-- unitTests.runSettingsPath = "",
							-- dotnetPath = "",
							-- enableXamlTools = true,
							-- preferCSharpExtension = false,
							-- projects.binaryLogPath = "",
							-- projects.enableAutomaticRestore = true,
							-- server.componentPaths = {},
							-- server.crashDumpPath = "",
							-- server.extensionPaths = {},
							-- server.path = "",
							-- server.startTimeout = 30000,
							-- server.suppressLspErrorToasts = false,
							-- server.trace = "Information",
							-- server.waitForDebugger = false,
						},
						omnisharp = {
							enableAsyncCompletion = true,
							enableDecompilationSupport = true,
							-- enableEditorConfigSupport = true,
							enableLspDriver = true,
							-- enableMsBuildLoadProjectsOnDemand = false,
							-- loggingLevel = "information",
							-- maxFindSymbolsItems = 1000,
							-- maxProjectResults = 250,
							-- minFindSymbolsFilterLength = 0,
							-- monoPath = "",
							organizeImportsOnFormat = true,
							-- projectFilesExcludePattern = "**/node_modules/**,**/.git/**,**/bower_components/**",
							-- projectLoadTimeout = 60,
							sdkIncludePrereleases = true,
							-- sdkPath = "",
							-- sdkVersion = "",
							-- useEditorFormattingSettings = true,
							-- useModernNet = true,
						},
						razor = {
							-- languageServer.debug = false,
							-- languageServer.directory = "",
							-- languageServer.forceRuntimeCodeGeneration = false,
							-- server.trace = "Information",
							-- completion.commitElementsWithSpace = "false",
							-- devmode = false,
							-- format.codeBlockBraceOnNextLine = false,
							-- format.enable = true,
							-- plugin.path = "",
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
						map("gr", require("omnisharp_extended").telescope_lsp_references, "Telescope References", bufnr)
						map(
							"gi",
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

			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler
					if not servers[server_name] then
						require("lspconfig")[server_name].setup({})
					end
				end,
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

			-- Capabilities
			-- local capabilities = vim.tbl_deep_extend(
			-- 	"force",
			-- 	vim.lsp.protocol.make_client_capabilities(),
			-- 	require("blink.cmp").default_capabilities()
			-- )
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
								if client.server_capabilities.inlayHintProvider then
									map("<leader>ih", function()
										vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
									end, "Inlay Hints", bufnr)
								end

								-- Set up mappings
								map("gd", require("telescope.builtin").lsp_definitions, "Telescope Definition", bufnr)
								-- map("gd", vim.lsp.buf.definition, "LSP Definition", bufnr)
								--
								-- vim.keymap.set("n", "gd", function()
								-- 	require("telescope.builtin").lsp_definitions({ reuse_win = true })
								-- end, { desc = "Goto Definition", silent = true })
								map(
									"gy",
									require("telescope.builtin").lsp_type_definitions,
									"Telescope Type Definition",
									bufnr
								)
								map("gr", require("telescope.builtin").lsp_references, "Telescope References", bufnr)
								map(
									"gi",
									require("telescope.builtin").lsp_implementations,
									"Telescope Implementation",
									bufnr
								)

								-- Common mappings
								-- map("<leader>f", function()
								-- 	vim.lsp.buf.format({ async = true })
								-- end, "Format", bufnr)
								-- map("gD", vim.lsp.buf.declaration, "Goto Declaration", bufnr)

								map("gs", function()
									local lsp_symbols = vim.tbl_map(string.lower, vim.lsp.protocol.SymbolKind)
									-- define a filter function to excl. undesired symbols
									local symbols = vim.tbl_filter(function(symbol)
										return symbol ~= "field"
									end, lsp_symbols)
									require("telescope.builtin").lsp_document_symbols({ symbols = symbols })
									-- require("telescope.builtin").lsp_document_symbols,
								end, "Telescope Document Symbols", bufnr)
								map(
									"<leader>ws",
									require("telescope.builtin").lsp_dynamic_workspace_symbols,
									"Telescope Workspace Symbols",
									bufnr
								)
								map("K", vim.lsp.buf.hover, "Hover Documentation", bufnr)
								-- map("<C-k>", vim.lsp.buf.signature_help, "Signature documentation", bufnr)

								-- Navigation
								-- TODO: Evaluate if this is needed, recently commented out 24-03-2025
								-- map("<C-p>", "<C-t>", "Navigate Previous", bufnr)
								-- map("<C-n>", "<CMD>tag<CR>", "Navigate Next", bufnr)

								-- -- Set up signature help overloads
								-- if client.server_capabilities.signatureHelpProvider then
								-- 	require("lsp-overloads").setup(client, {})
								-- end

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
