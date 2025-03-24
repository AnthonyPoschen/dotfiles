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
		keys = {
			m = { -- example of a custom action that toggles the active view filter
				action = function(view)
					view:filter({ buf = 0 }, { toggle = true })
				end,
				desc = "Toggle Current Buffer Filter",
			},
			s = { -- example of a custom action that toggles the severity
				action = function(view)
					local f = view:get_filter("severity")
					local severity = ((f and f.filter.severity or 0) + 1) % 5
					view:filter({ severity = severity }, {
						id = "severity",
						template = "{hl:Title}Filter:{hl} {severity}",
						-- del = severity == 0,
					})
				end,
				desc = "Toggle Severity Filter",
			},
		},
	},
	keys = {
		{ "ge", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "gl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
		{ "gq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
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
