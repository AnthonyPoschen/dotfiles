return {
	"echasnovski/mini.comment",
	version = "*",
	-- Module mappings. Use `''` (empty string) to disable one.
	opts = {
		mappings = {
			-- Toggle comment (like `gcip` - comment inner paragraph) for both
			-- Normal and Visual modes
			comment = "<leader>cc",

			-- Toggle comment on current line
			comment_line = "<leader>cc",

			-- Toggle comment on visual selection
			comment_visual = "<leader>cc",

			-- Define 'comment' textobject (like `dgc` - delete whole comment block)
			textobject = "<leader>cc",
		},
	},
}
