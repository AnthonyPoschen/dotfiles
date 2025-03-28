return {
	-- NOTE: Hotkeys to use avante - https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua#L361
	-- While Coding keys to bring up avante
	-- <leader>aa - Ask avante
	-- <leader>ae - Edit with query
	-- <leader>as - Stop avante
	-- In Side panel keys
	-- A - Apply all suggestions as diff
	-- a - Apply what is under cursor as diff
	-- r - Retry request
	-- e - edit request
	-- In Avante Diff
	-- co - use ours not Avante's
	-- ca - use Avante's
	-- cc - use whats under cursor from diff
	-- [[ - go to prev diff
	-- ]] - got to next diff
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			provider = "copilot", -- default provider
			-- Uncomment the following lines to switch providers
			-- provider = "claude",
			-- provider = "claude_mcp",
			-- Additional options for Claude
			cursor_applying_provider = nil,
			behaviour = {
				support_paste_from_clipboard = true,
				enable_claude_text_editor_tool_mode = true,
				enable_cursor_planning_mode = false,
				use_cwd_as_project_root = false, -- NOTE: maybe change this to true from default
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"Kaiser-Yang/blink-cmp-avante",
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
				keys = {
					{
						"<leader>ip",
						function()
							return vim.bo.filetype == "AvanteInput" and require("avante.clipboard").paste_image()
								or require("img-clip").paste_image()
						end,
						desc = "clip: paste image",
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
