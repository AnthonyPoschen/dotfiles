-- multi line comment explaining all the plugins
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					debounce = 50,
					auto_trigger = true,
					keymap = {
						-- -- Accept the suggestion
						-- accept = "<C-y>",
						-- accept_word = false,
						-- accept_line = false,
						accept = false,
					},
				},
			})
			vim.keymap.set("i", "<C-y>", function()
				require("copilot.suggestion").accept()
				require("copilot.suggestion").next()
			end, {
				desc = "[copilot] accept suggestion",
				silent = true,
			})
		end,
	},
	-- {
	-- 	"CopilotC-Nvim/CopilotChat.nvim",
	-- 	dependencies = {
	-- 		{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
	-- 		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
	-- 	},
	-- 	build = "make tiktoken", -- Only on MacOS or Linux
	-- 	opts = {
	-- 		debug = false,
	--
	-- 		-- See Configuration section for options
	-- 	},
	-- 	config = function()
	-- 		require("CopilotChat").setup({
	-- 			-- model = "claude-3.7-sonnet", -- Set Claude 3.7 Sonnet as the default model
	-- 			-- Optional additional settings:
	-- 			auto_insert_mode = true,
	-- 			show_help = true, -- Show help in chat window
	-- 		})
	-- 		local opts = { noremap = true, silent = true }
	--
	-- 		-- Open Copilot Chat
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<leader>co",
	-- 			":CopilotChat<CR>",
	-- 			{ noremap = true, silent = true, desc = "Open Copilot Chat" }
	-- 		)
	--
	-- 		-- Quick Chat with Prompt Input
	-- 		vim.keymap.set("n", "<leader>cq", function()
	-- 			local input = vim.fn.input("Quick Chat: ")
	-- 			if input ~= "" then
	-- 				vim.cmd("CopilotChat " .. input)
	-- 			end
	-- 		end, { noremap = true, silent = true, desc = "Quick Chat with Prompt Input" })
	--
	-- 		-- Explain selected code
	-- 		vim.keymap.set(
	-- 			"v",
	-- 			"<leader>ce",
	-- 			":CopilotChatExplain<CR>",
	-- 			{ noremap = true, silent = true, desc = "Explain Selected Code" }
	-- 		)
	--
	-- 		-- Generate tests for selected code
	-- 		vim.keymap.set(
	-- 			"v",
	-- 			"<leader>ct",
	-- 			":CopilotChatTests<CR>",
	-- 			{ noremap = true, silent = true, desc = "Generate Tests for Selected Code" }
	-- 		)
	--
	-- 		-- Toggle Copilot Chat window
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<leader>cg",
	-- 			":CopilotChatToggle<CR>",
	-- 			{ noremap = true, silent = true, desc = "Toggle Copilot Chat Window" }
	-- 		)
	--
	-- 		-- Reset Copilot Chat session
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<leader>cr",
	-- 			":CopilotChatReset<CR>",
	-- 			{ noremap = true, silent = true, desc = "Reset Copilot Chat Session" }
	-- 		)
	--
	-- 		-- Fix diagnostics using Copilot
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<leader>cf",
	-- 			":CopilotChatFixDiagnostic<CR>",
	-- 			{ noremap = true, silent = true, desc = "Fix Diagnostics with Copilot" }
	-- 		)
	--
	-- 		-- Generate commit message with Copilot
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<leader>cm",
	-- 			":CopilotChatCommit<CR>",
	-- 			{ noremap = true, silent = true, desc = "Generate Commit Message with Copilot" }
	-- 		)
	-- 	end,
	-- 	-- See Commands section for default commands if you want to lazy load on them
	-- },
}
