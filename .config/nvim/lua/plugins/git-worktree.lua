return {
	"ThePrimeagen/git-worktree.nvim",
	opts = {
		change_directory_command = "cd", -- default: "cd",
		update_on_change = true, -- default: true,
		update_on_change_command = "e .", -- default: "e .",
		clearjumps_on_change = true, -- default: true,
		autopush = false, -- default: false,
	},
	config = function(_, opts)
		require("git-worktree").setup(opts)
	end,
	keys = {
		{
			"<leader>ga",
			function()
				vim.ui.input({ prompt = "Git Worktree Name" }, function(input)
					if input == nil or input == "" then
						return
					end
					input = string.gsub(input, " ", "-")
					require("git-worktree").create_worktree("code/" .. input, input, "origin")
				end)
			end,
			desc = "Git Worktree add",
		},
		-- TODO: implement worktree fetch
		-- the idea is it will see all remote branches
		-- and create it locally if it doesn't exist
		-- So this list needs to be remote branches minus local worktrees
		{
			"<leader>gf",
			function() end,
		},
		{
			"<leader>gc",
			function()
				require("telescope").extensions.git_worktree.git_worktrees()
			end,
			desc = "Git Worktree change",
		},
		-- TODO: implement workspace delete
		-- This requires listing all the workspaces
		{
			"<leader>gd",
			function()
				require("git-worktree").delete_worktree()
				-- vim.ui.select()
			end,
		},
	},
}
