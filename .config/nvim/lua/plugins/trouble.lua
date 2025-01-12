-- better diagnostics list and others
return {
	"folke/trouble.nvim",
	cmd = { "TroubleToggle", "Trouble" },
	opts = {
		use_diagnostic_signs = true,
		multiline = false,
		action_keys = { -- key mappings for actions in the trouble list
			-- map to {} to remove a mapping, for example:
			-- close = {},
			close = "q", -- close the list
			cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
			refresh = "r", -- manually refresh
			jump = { "<cr>", "<tab>", "<2-leftmouse>" }, -- jump to the diagnostic or open / close folds
			open_split = { "<c-x>" }, -- open buffer in new split
			open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
			open_tab = { "<c-t>" }, -- open buffer in new tab
			jump_close = { "o" }, -- jump to the diagnostic and close the list
			toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
			switch_severity = "s", -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
			toggle_preview = "P", -- toggle auto_preview
			hover = "K", -- opens a small popup with the full multiline message
			preview = "p", -- preview the diagnostic location
			open_code_href = "c", -- if present, open a URI with more information about the diagnostic error
			close_folds = { "zM", "zm" }, -- close all folds
			open_folds = { "zR", "zr" }, -- open all folds
			toggle_fold = { "zA", "za", "h", ";" }, -- toggle fold of current file
			previous = "k", -- previous item
			next = "j", -- next item
			help = "?", -- help menu
		},
	},
	keys = {
		{ "<leader>xx", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
		{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
		{ "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
		{
			"[q",
			function()
				local trouble = require("trouble")
				if trouble.is_open() then
					trouble.previous({ skip_groups = true, jump = true })
				else
					local ok = pcall(vim.cmd.cprev)
					if not ok then
						ok = pcall(vim.cmd.clast)
						if not ok then
							trouble.open()
						end
					end
				end
			end,
			desc = "Previous trouble/quickfix item",
		},
		{
			"]q",
			function()
				local trouble = require("trouble")
				if trouble.is_open() then
					trouble.next({ skip_groups = true, jump = true })
				else
					local ok = pcall(vim.cmd.cnext)
					if not ok then
						ok = pcall(vim.cmd.cfirst)
						if not ok then
							trouble.open()
						end
					end
				end
			end,
			desc = "Next trouble/quickfix item",
		},
	},
}
