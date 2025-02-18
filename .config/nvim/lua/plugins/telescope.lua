return {
	{
		"danielfalk/smart-open.nvim",
		branch = "0.2.x",
		dependencies = {
			"kkharji/sqlite.lua",
			-- Only required if using match_algorithm fzf
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			-- Optional.  If installed, native fzy will be used when match_algorithm is fzy
			{ "nvim-telescope/telescope-fzy-native.nvim" },
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope.nvim",
		-- tag = "0.1.8",
		branch = "0.1.x",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "danielfalk/smart-open.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				enabled = vim.fn.executable("make") == 1,
				config = function()
					--Util.on_load("telescope.nvim", function()
					--	require("telescope").load_extension("fzf")
					--	require("telescope").load_extension("smart_open")
					--end)
					local name = "telescope.nvim"
					local Config = require("lazy.core.config")
					if Config.plugins[name] and Config.plugins[name]._.loaded then
						require("telescope").load_extension("fzf")
						require("telescope").load_extension("smart_open")
					else
						vim.api.nvim_create_autocmd("User", {
							pattern = "LazyLoad",
							callback = function(event)
								if event.data == name then
									require("telescope").load_extension("fzf")
									require("telescope").load_extension("smart_open")
									return true
								end
							end,
						})
					end
				end,
			},
		},
		-- replace all Telescope keymaps with only one mapping
		keys = function()
			return {
				{ "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (root dir)" },
				-- search
				{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
				{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
				{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
				{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
				{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
				{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
				{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
				{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
				{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
				{ "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
				{ "<leader>sM", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
				{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
				{ '<leader>sr"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			}
		end,
		-- opts = function()
		-- 	local actions = require("telescope.actions")
		-- 	local actions_set = require("telescope.actions.set")
		-- 	local fb_actions = require("telescope").extensions.file_browser.actions
		-- 	-- local cc = require("conventional_commits")
		--
		-- 	local open_with_trouble = function(...)
		-- 		return require("trouble.providers.telescope").open_with_trouble(...)
		-- 	end
		-- 	local open_selected_with_trouble = function(...)
		-- 		return require("trouble.providers.telescope").open_selected_with_trouble(...)
		-- 	end
		-- 	local config_result_prompt = {
		-- 		-- theme = "dropdown",
		-- 		hidden = true,
		-- 		previewer = false,
		-- 		layout_strategy = "vertical",
		-- 		sorting_strategy = "descending",
		-- 		layout_config = {
		-- 			prompt_position = "bottom",
		-- 			width = 130,
		-- 			height = 0.75,
		-- 		},
		-- 		show_line = false,
		-- 		results_title = false,
		-- 		git_command = {
		-- 			"git",
		-- 			"ls-files",
		-- 			"--exclude-standard",
		-- 			"--cached",
		-- 			":!:*.meta", -- unity
		-- 			":!:*.asset", -- unity
		-- 			":!:*.prefab", -- unity
		-- 			":!:*.unity", -- unity
		-- 		},
		-- 		-- preview_title = false,
		-- 	}
		--
		-- 	return {
		-- 		extensions = {
		-- 			fzf = {
		-- 				fuzzy = true, -- false will only do exact matching
		-- 				override_generic_sorter = true, -- override the generic sorter
		-- 				override_file_sorter = true, -- override the file sorter
		-- 				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		-- 				-- the default case_mode is "smart_case"
		-- 			},
		-- 			-- conventional_commits = {
		-- 			-- 	action = cc.prompt,
		-- 			-- },
		-- 			-- file_browser = {
		-- 			-- 	theme = "dropdown",
		-- 			-- 	hijack_netrw = true,
		-- 			-- 	mappings = {
		-- 			-- 		n = {
		-- 			-- 			N = fb_actions.create,
		-- 			-- 			h = fb_actions.goto_parent_dir,
		-- 			-- 			l = fb_actions.open,
		-- 			-- 			g = false,
		-- 			-- 		},
		-- 			-- 	},
		-- 			-- },
		-- 		},
		-- 		pickers = {
		-- 			find_files = config_result_prompt,
		-- 			git_files = config_result_prompt,
		-- 			help_tags = config_result_prompt,
		-- 			oldfiles = config_result_prompt,
		-- 			command_history = config_result_prompt,
		-- 			commands = config_result_prompt,
		-- 			diagnostics = config_result_prompt,
		-- 			git_commits = {
		-- 				git_command = {
		-- 					"git",
		-- 					"log",
		-- 					"-i --pretty=format:'%<(5)%C(auto,yellow)%h %ad %C(auto,blue)%><(20)[ %cn ] %Creset%-s %C(dim blue)(%ar)%-C(auto,bold red)%-d' --decorate --date=short\" -",
		-- 				},
		-- 			},
		-- 		},
		-- 		defaults = {
		-- 			prompt_prefix = " ",
		-- 			layout_strategy = "horizontal",
		-- 			layout_config = { prompt_position = "top" },
		-- 			previewer = false,
		-- 			sorting_strategy = "ascending",
		-- 			file_ignore_patterns = { ".git/", "vendor/", "node_modules/" },
		-- 			selection_caret = " ",
		-- 			-- open files in the first window that is an actual file.
		-- 			-- use the current window if no other window is available.
		-- 			get_selection_window = function()
		-- 				local wins = vim.api.nvim_list_wins()
		-- 				table.insert(wins, 1, vim.api.nvim_get_current_win())
		-- 				for _, win in ipairs(wins) do
		-- 					local buf = vim.api.nvim_win_get_buf(win)
		-- 					if vim.bo[buf].buftype == "" then
		-- 						return win
		-- 					end
		-- 				end
		-- 				return 0
		-- 			end,
		-- 			mappings = {
		-- 				i = {
		-- 					["<c-t>"] = open_with_trouble,
		-- 					["<C-s>"] = open_selected_with_trouble,
		-- 					-- ["<a-i>"] = find_files_no_ignore,
		-- 					-- ["<a-h>"] = find_files_with_hidden,
		-- 					["<C-Down>"] = actions.cycle_history_next,
		-- 					["<C-Up>"] = actions.cycle_history_prev,
		-- 					-- ["<C-f>"] = actions.preview_scrolling_down,
		-- 					-- ["<C-b>"] = actions.preview_scrolling_up,
		-- 					["<c-j>"] = actions.move_selection_next,
		-- 					["<c-k>"] = actions.move_selection_previous,
		-- 					["<c-d>"] = function(bufnr)
		-- 						actions_set.shift_selection(bufnr, 10)
		-- 					end,
		-- 					["<c-u>"] = function(bufnr)
		-- 						actions_set.shift_selection(bufnr, -10)
		-- 					end,
		-- 					["<c-c>"] = actions.close,
		-- 				},
		-- 				n = {
		-- 					["<c-k>"] = actions.preview_scrolling_up,
		-- 					["<c-j>"] = actions.preview_scrolling_down,
		-- 					["<c-c>"] = actions.close,
		-- 					["q"] = actions.close,
		-- 				},
		-- 			},
		-- 		},
		-- 	}
		-- end,
	},
	{
		"telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			-- "ThePrimeagen/git-worktree.nvim",
			build = "make",
			config = function(_, opts)
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("conventional_commits")
				-- require("telescope").load_extension("git_worktree")
				-- require("telescope").load_extension("file_browser")
				-- local actions = require("telescope.actions")
				local fb_actions = require("telescope").extensions.file_browser.actions
				local cc = require("conventional_commits")
				opts.extensions = {
					smart_open = {
						filename_first = false,
						cwd_only = true,
					},
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
