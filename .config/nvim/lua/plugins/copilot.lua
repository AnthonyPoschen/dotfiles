return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = false,

			-- See Configuration section for options
		},
		config = function()
			require("CopilotChat").setup({
				-- model = "claude-3.7-sonnet", -- Set Claude 3.7 Sonnet as the default model
				-- Optional additional settings:
				-- auto_insert_mode = true, -- Disable auto-insert for chat
				show_help = true, -- Show help in chat window
			})
		end,
		-- See Commands section for default commands if you want to lazy load on them
	},
}
