local Util = require("lazyvim.util")
return {
	-- {
	-- 	"nvim-telescope/telescope-file-browser.nvim",
	-- 	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	-- },
	{ "olacin/telescope-cc.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		-- replace all Telescope keymaps with only one mapping
		keys = function()
			return {
				{
					"<leader>,",
					"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
					desc = "Switch Buffer",
				},
				{ "<leader>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
				{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
				-- { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
				-- find
				{ "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
				{ "<leader>fc", Util.telescope.config_files(), desc = "Find Config File" },
				{ "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
				{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
				{ "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
				{ "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
				-- git
				{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
				-- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
				-- search
				{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
				{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
				{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
				{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
				{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
				{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
				{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
				{ "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
				{ "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
				{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
				{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
				{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
				{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
				{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
				{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
				{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
				{ "<leader>sw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
				{
					"<leader>sW",
					Util.telescope("grep_string", { cwd = false, word_match = "-w" }),
					desc = "Word (cwd)",
				},
				{ "<leader>sw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
				{ "<leader>sW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
				{
					"<leader>uC",
					Util.telescope("colorscheme", { enable_preview = true }),
					desc = "Colorscheme with preview",
				},
				{
					"<leader>ss",
					function()
						require("telescope.builtin").lsp_document_symbols({
							symbols = require("lazyvim.config").get_kind_filter(),
						})
					end,
					desc = "Goto Symbol",
				},
				{
					"<leader>sS",
					function()
						require("telescope.builtin").lsp_dynamic_workspace_symbols({
							symbols = require("lazyvim.config").get_kind_filter(),
						})
					end,
					desc = "Goto Symbol (Workspace)",
				},
				{
					"-",
					function()
						local telescope = require("telescope")
						local function telescope_buffer_dir()
							return vim.fn.expand("%:p:h")
						end

						telescope.extensions.file_browser.file_browser({
							path = "%:p:h",
							cwd = telescope_buffer_dir(),
							respect_gitignore = true,
							hidden = true,
							grouped = true,
							previewer = false,
							initial_mode = "normal",
							layout_config = { height = 40 },
						})
					end,
					desc = "File Browser",
				},
			}
		end,
		opts = function()
			local actions = require("telescope.actions")
			-- local fb_actions = require("telescope").extensions.file_browser.actions
			local cc = require("conventional_commits")

			local open_with_trouble = function(...)
				return require("trouble.providers.telescope").open_with_trouble(...)
			end
			local open_selected_with_trouble = function(...)
				return require("trouble.providers.telescope").open_selected_with_trouble(...)
			end
			-- local find_files_no_ignore = function()
			-- 	local action_state = require("telescope.actions.state")
			-- 	local line = action_state.get_current_line()
			-- 	Util.telescope("find_files", { no_ignore = true, default_text = line })()
			-- end
			-- local find_files_with_hidden = function()
			-- 	local action_state = require("telescope.actions.state")
			-- 	local line = action_state.get_current_line()
			-- 	Util.telescope("find_files", { hidden = true, default_text = line })()
			-- end

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
					find_files = {
						theme = "dropdown",
						hidden = true,
					},
					file_browser = {
						hidden = true,
					},
				},
				defaults = {
					prompt_prefix = " ",
					layout_strategy = "horizontal",
					layout_config = { prompt_position = "top" },
					winblend = 0,
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
							["<a-t>"] = open_selected_with_trouble,
							-- ["<a-i>"] = find_files_no_ignore,
							-- ["<a-h>"] = find_files_with_hidden,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
							["<c-j>"] = actions.move_selection_next,
							["<c-k>"] = actions.move_selection_previous,
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
			-- "nvim-telescope/telescope-file-browser.nvim",
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
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
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
