local function select_comment_block()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1 -- 0-based index
	-- Get Treesitter parser
	local parser = vim.treesitter.get_parser(bufnr, "lua")
	if not parser then
		vim.notify("No Treesitter parser for Lua", vim.log.levels.WARN)
		return
	end

	local tree = parser:parse()[1]
	if not tree then
		vim.notify("Failed to parse Lua syntax tree", vim.log.levels.WARN)
		return
	end

	local root = tree:root()
	local total_lines = vim.api.nvim_buf_line_count(bufnr)

	-- Get current line content
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	local query = vim.treesitter.query.get("lua", "highlights")
	if not query then
		vim.notify("No highlights query for Lua", vim.log.levels.WARN)
		return
	end

	-- Check if current line is a comment (Treesitter or pattern)
	local is_comment = false
	for id, node in query:iter_captures(root, bufnr, row, row + 1) do
		if query.captures[id] == "comment" then
			local start_row, _, end_row, _ = node:range()
			if start_row <= row and end_row > row then
				is_comment = true
				break
			end
		end
	end
	-- Fallback: check for Lua comment pattern if Treesitter fails
	if not is_comment then
		is_comment = line:match("^%s*%-%-") or line:match("%-%-")
	end

	if not is_comment then
		vim.notify("Cursor not in a comment (checked with Treesitter and pattern)", vim.log.levels.INFO)
		return
	end

	-- Find comment block boundaries
	local start_row = row
	local end_row = row

	-- Expand upwards
	while start_row > 0 do
		local prev_line = vim.api.nvim_buf_get_lines(bufnr, start_row - 1, start_row, false)[1]
		local is_prev_comment = prev_line:match("^%s*%-%-") or prev_line:match("%-%-")
		if not is_prev_comment then
			for id, node in query:iter_captures(root, bufnr, start_row - 1, start_row) do
				if query.captures[id] == "comment" then
					is_prev_comment = true
					break
				end
			end
		end
		if not is_prev_comment then
			break
		end
		start_row = start_row - 1
	end

	-- Expand downwards
	while end_row < total_lines - 1 do
		local next_line = vim.api.nvim_buf_get_lines(bufnr, end_row + 1, end_row + 2, false)[1]
		local is_next_comment = next_line:match("^%s*%-%-") or next_line:match("%-%-")
		if not is_next_comment then
			for id, node in query:iter_captures(root, bufnr, end_row + 1, end_row + 2) do
				if query.captures[id] == "comment" then
					is_next_comment = true
					break
				end
			end
		end
		if not is_next_comment then
			break
		end
		end_row = end_row + 1
	end

	-- Set visual selection
	vim.api.nvim_win_set_cursor(0, { start_row + 1, 0 }) -- 1-based index for cursor
	vim.cmd("normal! V")
	vim.api.nvim_win_set_cursor(0, { end_row + 1, 0 })
end
-- Command and keybinding
vim.api.nvim_create_user_command("SelectCommentBlock", select_comment_block, {})
vim.keymap.set("n", "<leader>cs", select_comment_block, { noremap = true, silent = false })
