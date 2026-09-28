-- Omarchy writes the active theme to neovim.lua. Use that when the file is
-- present. Otherwise keep Tokyo Night, including on machines without Omarchy.

local tokyo_night = {
	style = "night",
	light_style = "moon",
	dim_inactive = true,
	lualine_bold = true,
}

local function theme_file()
	local paths = {
		vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua"),
		vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua"),
	}
	for _, path in ipairs(paths) do
		if vim.fn.filereadable(path) == 1 then
			return path
		end
	end
end

local function read_theme(path)
	local ok, spec = pcall(dofile, path)
	if ok == false or type(spec) ~= "table" then
		return nil
	end
	if type(spec[1]) == "string" then
		return { spec }
	end
	return spec
end

local function colorscheme_name(spec)
	for _, entry in ipairs(spec) do
		if type(entry) == "table" and entry[1] == "LazyVim/LazyVim" then
			local opts = entry.opts
			if type(opts) == "table" and type(opts.colorscheme) == "string" and opts.colorscheme ~= "" then
				return opts.colorscheme
			end
		end
	end
end

local function theme_plugins(spec)
	local plugins = {}
	for _, entry in ipairs(spec) do
		if type(entry) == "table" and entry[1] ~= "LazyVim/LazyVim" and type(entry[1]) == "string" then
			table.insert(plugins, entry)
		end
	end
	return plugins
end

local function setup_tokyonight()
	local ok, tokyonight = pcall(require, "tokyonight")
	if ok == false then
		pcall(vim.cmd.colorscheme, "habamax")
		return
	end

	tokyonight.setup(tokyo_night)
	if pcall(vim.cmd.colorscheme, "tokyonight") == false then
		pcall(vim.cmd.colorscheme, "habamax")
	end
end

local function apply_tokyonight()
	if package.loaded["tokyonight"] == nil then
		pcall(function()
			require("lazy").load({ plugins = { "tokyonight.nvim" } })
		end)
	end
	setup_tokyonight()
end

local function setup_plugin(plugin, opts)
	if type(opts) ~= "table" or next(opts) == nil then
		return
	end

	local main = require("lazy.core.loader").get_main(plugin)
	if main == nil then
		return
	end

	local ok, mod = pcall(require, main)
	if ok and type(mod) == "table" and type(mod.setup) == "function" then
		pcall(mod.setup, opts)
	end
end

local function apply_omarchy(plugin, name)
	plugin.lazy = false
	plugin.priority = 1000
	local user_config = plugin.config
	plugin.config = function(loaded, opts)
		if type(user_config) == "function" then
			pcall(user_config, loaded, opts)
		else
			setup_plugin(loaded, opts)
		end
		if pcall(vim.cmd.colorscheme, name) == false then
			apply_tokyonight()
		end
	end
end

local function has_plugin(plugins, repo)
	for _, plugin in ipairs(plugins) do
		if plugin[1] == repo then
			return true
		end
	end
	return false
end

local function omarchy_spec()
	local path = theme_file()
	if path == nil then
		return nil
	end

	local spec = read_theme(path)
	if spec == nil then
		return nil
	end

	local name = colorscheme_name(spec)
	local plugins = theme_plugins(spec)
	if name == nil or plugins[1] == nil then
		return nil
	end

	apply_omarchy(plugins[1], name)
	if has_plugin(plugins, "folke/tokyonight.nvim") == false then
		table.insert(plugins, {
			"folke/tokyonight.nvim",
			lazy = true,
		})
	end
	return plugins
end

local function tokyonight_spec()
	return {
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				setup_tokyonight()
			end,
		},
	}
end

return omarchy_spec() or tokyonight_spec()
