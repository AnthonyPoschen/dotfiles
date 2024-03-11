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
		-- function works unless you are root of bare repo
		-- it has no concept of branches in a bare repository
		-- unless you are already in a worktree
		{
			"<leader>gf",
			function()
				-- fetch all git branches
        --TODO: just switched to ls-remote need to make it grab the right string
        --to represent all branches available
				local result = vim.fn.systemlist("git ls-remote")
				---@class branch
				---@field name string
				---@field remote string
				local branches = {}
				for k, i in ipairs(result) do
          if k == 0 then
            goto continue
          end
					result[k] = string.gsub(i, " ", "")
					-- branch = string.gsub(branch, " ", "")
					-- table.insert(branches, { name = name, remote = branch })
          ::continue::
				end
				print(vim.inspect(branches))
				vim.ui.select(result, {}, function(selection)
					local branch = string.gsub(selection, ".*/", "")
					local remote = string.gsub(selection, "/.*", "")
					require("git-worktree").create_worktree("code/" .. branch, branch, remote)
				end)
			end,
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
