local actions = require("telescope.actions")
local cc = require("conventional_commits")
require("telescope").setup({
	conventional_commits = {
		action = cc.prompt,
	},
})
require("telescope").load_extension("conventional_commits")