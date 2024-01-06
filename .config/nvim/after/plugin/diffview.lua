-- TODO: move this out of after
local actions = require("diffview.actions")
require("diffview").setup({
	keymaps = {
		view = {
			["<c-c>"] = "<cmd>tabc<cr>",
		},
		file_history_panel = {
			["<c-c>"] = "<cmd>tabc<cr>",
		},
		file_panel = {
			["<c-c>"] = "<cmd>tabc<cr>",
		},
	},
	view = {
		-- Available layouts:
		--  'diff1_plain'
		--    |'diff2_horizontal'
		--    |'diff2_vertical'
		--    |'diff3_horizontal'
		--    |'diff3_vertical'
		--    |'diff3_mixed'
		--    |'diff4_mixed'
		default = {
			-- layout = "diff2_horizontal", -- Default
			layout = "diff2_horizontal",
		},
		merge_tool = {
			-- Config for conflicted files in diff views during a merge or rebase.
			layout = "diff3_horizontal",
		},
		file_history = {
			-- Config for changed files in file history views.
			layout = "diff2_horizontal",
		},
	},
})
