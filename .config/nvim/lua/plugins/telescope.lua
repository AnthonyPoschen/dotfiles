local Util = require("util")
return {
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{ "olacin/telescope-cc.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				enabled = vim.fn.executable("make") == 1,
				config = function()
					Util.on_load("telescope.nvim", function()
						require("telescope").load_extension("fzf")
					end)
				end,
			},
		},
		-- replace all Telescope keymaps with only one mapping
		keys = function()
			return {
				{ "<leader>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
				-- { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
				-- { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
				{ "<space><space>", Util.telescope("files"), desc = "Find files" },
				-- { "<leader>r", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
				-- git
				-- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
				-- search
				{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
				{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
				{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
				{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
				{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
				{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
				-- { "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
				-- { "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
				{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
				{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
				{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
				{ "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
				{ "<leader>sM", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
				{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
				{ '<leader>sr"', "<cmd>Telescope registers<cr>", desc = "Registers" },
				-- { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
				-- { "<leader>sw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
				-- {
				-- 	"<leader>sW",
				-- 	Util.telescope("grep_string", { cwd = false, word_match = "-w" }),
				-- 	desc = "Word (cwd)",
				-- },
				-- -- { "<leader>sw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
				-- { "<leader>sW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
				-- {
				-- 	"<leader>uC",
				-- 	Util.telescope("colorscheme", { enable_preview = true }),
				-- 	desc = "Colorscheme with preview",
				-- },
				{
					"<leader>ss",
					function()
						require("telescope.builtin").lsp_document_symbols({
							symbols = require("config").get_kind_filter(),
						})
					end,
					desc = "Goto Symbol",
				},
				{
					"<leader>sS",
					function()
						require("telescope.builtin").lsp_dynamic_workspace_symbols({
							symbols = require("config").get_kind_filter(),
						})
					end,
					desc = "Goto Symbol (Workspace)",
				},
			}
		end,
		opts = function()
			local actions = require("telescope.actions")
			local actions_set = require("telescope.actions.set")
			local fb_actions = require("telescope").extensions.file_browser.actions
			local cc = require("conventional_commits")

			local open_with_trouble = function(...)
				return require("trouble.providers.telescope").open_with_trouble(...)
			end
			local open_selected_with_trouble = function(...)
				return require("trouble.providers.telescope").open_selected_with_trouble(...)
			end
			local find_files_no_ignore = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Util.telescope("find_files", { no_ignore = true, default_text = line })()
			end
			local find_files_with_hidden = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Util.telescope("find_files", { hidden = true, default_text = line })()
			end

			local config_result_prompt = {
				-- theme = "dropdown",
				hidden = true,
				previewer = false,
				layout_strategy = "vertical",
				sorting_strategy = "descending",
				layout_config = {
					prompt_position = "bottom",
					width = 130,
					height = 0.75,
				},
				show_line = false,
				results_title = false,
				-- preview_title = false,
			}

			return {
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					conventional_commits = {
						action = cc.prompt,
					},
					-- file_browser = {
					-- 	theme = "dropdown",
					-- 	hijack_netrw = true,
					-- 	mappings = {
					-- 		n = {
					-- 			N = fb_actions.create,
					-- 			h = fb_actions.goto_parent_dir,
					-- 			l = fb_actions.open,
					-- 			g = false,
					-- 		},
					-- 	},
					-- },
				},
				pickers = {
					find_files = config_result_prompt,
					git_files = config_result_prompt,
					help_tags = config_result_prompt,
					oldfiles = config_result_prompt,
					command_history = config_result_prompt,
					commands = config_result_prompt,
					diagnostics = config_result_prompt,
					git_commits = {
						git_command = {
							"git",
							"log",
							"-i --pretty=format:'%<(5)%C(auto,yellow)%h %ad %C(auto,blue)%><(20)[ %cn ] %Creset%-s %C(dim blue)(%ar)%-C(auto,bold red)%-d' --decorate --date=short\" -",
						},
					},
				},
				defaults = {
					prompt_prefix = " ",
					layout_strategy = "horizontal",
					layout_config = { prompt_position = "top" },
					previewer = false,
					sorting_strategy = "ascending",
					file_ignore_patterns = { ".git/", "vendor/", "node_modules/" },
					selection_caret = " ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<c-t>"] = open_with_trouble,
							["<C-s>"] = open_selected_with_trouble,
							-- ["<a-i>"] = find_files_no_ignore,
							-- ["<a-h>"] = find_files_with_hidden,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							-- ["<C-f>"] = actions.preview_scrolling_down,
							-- ["<C-b>"] = actions.preview_scrolling_up,
							["<c-j>"] = actions.move_selection_next,
							["<c-k>"] = actions.move_selection_previous,
							["<c-d>"] = function(bufnr)
								actions_set.shift_selection(bufnr, 10)
							end,
							["<c-u>"] = function(bufnr)
								actions_set.shift_selection(bufnr, -10)
							end,
							["<c-c>"] = actions.close,
						},
						n = {
							["<c-k>"] = actions.preview_scrolling_up,
							["<c-j>"] = actions.preview_scrolling_down,
							["<c-c>"] = actions.close,
							["q"] = actions.close,
						},
					},
				},
			}
		end,
	},
	{
		"telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			build = "make",
			config = function(_, opts)
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("conventional_commits")
				-- require("telescope").load_extension("file_browser")
				local actions = require("telescope.actions")
				local fb_actions = require("telescope").extensions.file_browser.actions
				local cc = require("conventional_commits")
				opts.extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = false, -- override the generic sorter
						override_file_sorter = false, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					conventional_commits = {
						action = cc.prompt,
					},
					file_browser = {
						theme = "dropdown",
						hijack_netrw = true,
						mappings = {
							["n"] = {
								["N"] = fb_actions.create,
								["h"] = fb_actions.goto_parent_dir,
								["l"] = fb_actions.open,
								["g"] = false,
							},
						},
					},
				}
			end,
		},
	},
}
