-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- fix kitty terminal font map when leaving vim
-- vim.cmd("autocmd VimLeave <cmd>lua os.execute(\"kitty @ --to unix:/tmp/kitty ret-font-size '0'\")<CR>")
vim.api.nvim_create_autocmd({ "VimLeave" }, {
	callback = function(ev, opts)
		os.execute("kitty @ --to unix:/tmp/kitty set-font-size '0'")
	end,
})
