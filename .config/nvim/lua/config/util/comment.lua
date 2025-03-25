--- Selects a block of comments around the current cursor position.
--- This function uses Tree-sitter to identify comments and their boundaries.
--- It supports multiple filetypes and their respective comment patterns.
---
---@return nil
local function select_comment_block()
	--- Get the current buffer number.
	--- @type integer
	local bufnr = vim.api.nvim_get_current_buf()

	--- Get the current cursor position.
	--- @type integer[]
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1 -- 0-based index

	--- Get the filetype of the current buffer.
	--- @type string
	local filetype = vim.bo[bufnr].filetype

	-- Map filetypes to Tree-sitter languages and comment patterns
	--- @type table<string, {ts_lang: string, patterns: string[]}>
	local lang_map = {
		lua = { ts_lang = "lua", patterns = { "^%s*%-%-", "%-%-" } },
		go = { ts_lang = "go", patterns = { "^%s*//", "//" } },
		yaml = { ts_lang = "yaml", patterns = { "^%s*#", "#" } },
		python = { ts_lang = "python", patterns = { "^%s*#", "#" } },
		c = { ts_lang = "c", patterns = { "^%s*//", "//", "^%s*/%*", "%*/" } },
		cpp = { ts_lang = "cpp", patterns = { "^%s*//", "//", "^%s*/%*", "%*/" } },
		cs = { ts_lang = "c_sharp", patterns = { "^%s*//", "//" } },
	}

	--- Get language information for the current filetype.
	--- @type {ts_lang: string, patterns: string[]}
	local lang_info = lang_map[filetype] or { ts_lang = filetype, patterns = { "^%s*//", "//", "^%s*#", "#" } }
	local ts_lang = lang_info.ts_lang
	local patterns = lang_info.patterns

	-- Get Treesitter parser
	--- @type userdata|nil
	local parser = vim.treesitter.get_parser(bufnr, ts_lang)
	if not parser then
		vim.notify("No Treesitter parser for " .. ts_lang, vim.log.levels.WARN)
		return
	end

	--- @type userdata|nil
	local tree = parser:parse()[1]
	if not tree then
		vim.notify("Failed to parse syntax tree for " .. ts_lang, vim.log.levels.WARN)
		return
	end

	--- @type userdata
	local root = tree:root()
	--- @type integer
	local total_lines = vim.api.nvim_buf_line_count(bufnr)

	-- Get current line content
	--- @type string
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	--- @type userdata|nil
	local query = vim.treesitter.query.get(ts_lang, "highlights")
	if not query then
		vim.notify("No highlights query for " .. ts_lang, vim.log.levels.WARN)
	end

	-- Check if current line is a comment
	--- @type boolean
	local is_comment = false
	if query then
		for id, node in query:iter_captures(root, bufnr, row, row + 1) do
			if query.captures[id] == "comment" then
				local start_row, _, end_row, _ = node:range()
				if start_row <= row and end_row > row then
					is_comment = true
					break
				end
			end
		end
	end

	-- Fallback to pattern matching
	if not is_comment then
		for _, pattern in ipairs(patterns) do
			if line:match(pattern) then
				is_comment = true
				break
			end
		end
	end

	if not is_comment then
		vim.notify("Cursor not in a comment for " .. filetype, vim.log.levels.INFO)
		return
	end

	-- Find comment block boundaries
	--- @type integer
	local start_row = row
	--- @type integer
	local end_row = row

	-- Function to check if a line is a comment
	--- @param line_num integer
	--- @return boolean
	local function is_line_comment(line_num)
		--- @type string
		local l = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)[1]
		if query then
			for id, node in query:iter_captures(root, bufnr, line_num, line_num + 1) do
				if query.captures[id] == "comment" then
					local s_row, _, e_row, _ = node:range()
					if s_row <= line_num and e_row > line_num then
						return true
					end
				end
			end
		end
		for _, pattern in ipairs(patterns) do
			if l:match(pattern) then
				return true
			end
		end
		return false
	end

	-- Expand upwards
	while start_row > 0 do
		if not is_line_comment(start_row - 1) then
			break
		end
		start_row = start_row - 1
	end

	-- Expand downwards
	while end_row < total_lines - 1 do
		if not is_line_comment(end_row + 1) then
			break
		end
		end_row = end_row + 1
	end

	-- Handle multi-line comments (/* */)
	if filetype == "c" or filetype == "cpp" then
		--- @type string[]
		local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
		--- @type boolean
		local in_multiline = false
		for i, l in ipairs(lines) do
			if l:match("^%s*/%*") then
				in_multiline = true
			end
			if in_multiline and i <= #lines then
				end_row = start_row + i - 1
				if l:match("%*/") then
					in_multiline = false
					break
				end
			end
		end
		if in_multiline then -- Extend to end if unclosed
			end_row = total_lines - 1
		end
	end

	-- Set visual selection
	vim.api.nvim_win_set_cursor(0, { start_row + 1, 0 })
	vim.cmd("normal! V")
	vim.api.nvim_win_set_cursor(0, { end_row + 1, 0 })
end

-- Command and keybinding
vim.api.nvim_create_user_command("SelectCommentBlock", select_comment_block, {})
vim.keymap.set("n", "<leader>cs", select_comment_block, { noremap = true, silent = false })
