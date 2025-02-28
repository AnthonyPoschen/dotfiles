-- fix kitty terminal font map when leaving vim
-- vim.cmd("autocmd VimLeave <cmd>lua os.execute(\"kitty @ --to unix:/tmp/kitty ret-font-size '0'\")<CR>")
local function augroup(name)
	return vim.api.nvim_create_augroup("local" .. name, { clear = true })
end

-- conform doc, autocmd to format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
-- TODO: decide if i want to automatically open file search on vim open
-- -- search for files on startup
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
-- 	callback = function(ev, opts)
-- 		if vim.fn.expand("%") == "" then
-- 			vim.cmd("FileSearch")
-- 		end
-- 	end,
-- })

-- TODO: make alacritty work with this
-- fix kitty on shutdown
vim.api.nvim_create_autocmd({ "VimLeave", "VimLeavePre" }, {
	callback = function(ev, opts)
		os.execute("kitty @ --to $KITTY_LISTEN_ON set-font-size '0'")
		os.execute("tmux set status 2")
		os.execute("tmux list-panes -F '\\#F' | grep -q Z && tmux resize-pane -Z")
	end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
		"fugitive",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Whenever we enter a buffer or save a file lets refresh the codelens
vim.api.nvim_create_autocmd({ "BufEnter", "BufWrite" }, {
	group = augroup("codelens_refresh"),
	callback = function(event)
		if not vim.lsp then
			return
		end
		if not vim.lsp.client then
			return
		end
		if not vim.lsp.client.server_capabilities then
			return
		end
		if vim.lsp.client.server_capabilities.codeLensProvider then
			vim.lsp.codelens.refresh()
		end
	end,
})
