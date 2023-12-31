-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- fix kitty terminal font map when leaving vim
-- vim.cmd("autocmd VimLeave <cmd>lua os.execute(\"kitty @ --to unix:/tmp/kitty ret-font-size '0'\")<CR>")
vim.api.nvim_create_autocmd({ "VimLeave", "VimLeavePre" }, {
	callback = function(ev, opts)
		os.execute("kitty @ --to $KITTY_LISTEN_ON set-font-size '0'")
		os.execute("tmux set status 2")
		os.execute("tmux list-panes -F '\\#F' | grep -q Z && tmux resize-pane -Z")
	end,
})
