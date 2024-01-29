local M = {} -- The module to export
local cmd = vim.cmd

-- We will create a few autogroup, this function will help to avoid
-- always writing cmd('augroup' .. group) etc..
function M.create_augroup(autocmds, name)
	cmd("augroup " .. name)
	cmd("autocmd!")
	for _, autocmd in ipairs(autocmds) do
		cmd("autocmd " .. table.concat(autocmd, " "))
	end
	cmd("augroup END")
end

-- Create an autgroup for a filetype and pre append the filetype
-- definitions to all autocmds in the group. example
--
-- Example:
-- create_ft_augroup("go",{"nnoremap","lhs","rhs"},"gocmds")
---@param ft string
---@param autocmds table
---@param name string
function M.create_ft_augroup(ft, autocmds, name)
	for k, acmd in ipairs(autocmds) do
		local nt = { "FileType", ft }
		for _, v in pairs(acmd) do
			table.insert(nt, v)
		end
		autocmds[k] = nt
	end
	M.create_augroup(autocmds, name)
end

-- Add a apth to the rtp
function M.add_rtp(path)
	local rtp = vim.o.rtp
	rtp = rtp .. "," .. path
end

-- Map a key with optional options
function M.map(mode, lhs, rhs, options)
	if options == nil then
		options = {}
	end
	-- vim.api.nvim_set_keymap(mode, keys, action, options)
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Map a key to a lua callback
function M.map_lua(mode, keys, action, options)
	if options == nil then
		options = {}
	end
	vim.api.nvim_set_keymap(mode, keys, "<cmd>lua " .. action .. "<cr>", options)
end

-- Buffer local mappings
function M.map_buf(mode, keys, action, options, buf_nr)
	if options == nil then
		options = {}
	end
	local buf = buf_nr or 0
	vim.api.nvim_buf_set_keymap(buf, mode, keys, action, options)
end

function M.map_lua_buf(mode, keys, action, options, buf_nr)
	if options == nil then
		options = {}
	end
	local buf = buf_nr or 0
	vim.api.nvim_buf_set_keymap(buf, mode, keys, "<cmd>lua " .. action .. "<cr>", options)
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
	local Config = require("lazy.core.config")
	if Config.plugins[name] and Config.plugins[name]._.loaded then
		fn(name)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end
-- We want to be able to access utils in all our configuration files
-- so we add the module to the _G global variable.
_G.utils = M
return M -- Export the module
