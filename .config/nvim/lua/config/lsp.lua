vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
		-- format = function(diagnostic)
		-- 	return string.format("%s %s", diagnostic.source or "LSP", diagnostic.message)
		-- end,
	},
	virtual_test = false,
	signs = {
		active = true,
		values = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignInfo", text = "" },
			{ name = "DiagnosticSignHint", text = "" },
		},
	},
	update_in_insert = false,
	float = { border = "rounded" },
	severity_sort = true,
})
vim.lsp.config("*", {
	root_markers = { ".git", ".hg" },
	update_in_insert = false,
	float = { border = "rounded" },
	severity_sort = true,
})

-- Keymaps
-- https://neovim.io/doc/user/lsp.html#lsp-config
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp.config.attach", {}),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		local bufname = vim.api.nvim_buf_get_name(args.buf)
		if bufname == "" or bufname == nil or bufname == "null" then
			-- Skip attaching to buffers with invalid names
			return
		end
		-- global defaults
		-- https://neovim.io/doc/user/lsp.html
		-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
		-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
		-- "grr" is mapped in Normal mode to vim.lsp.buf.references()
		-- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
		-- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
		-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()
		local map = vim.keymap.set
		map("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to Definition" })
		map("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to Declaration" })
		map("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "Hover" })
		map("n", "gk", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "Signature Help" })
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		-- vim.lsp.buf.format({ async = false })
	end,
})
