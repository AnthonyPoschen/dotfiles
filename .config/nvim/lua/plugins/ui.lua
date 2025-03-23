-- local Util = require("util")
local function realpath(path)
	if path == "" or path == nil then
		return nil
	end
	path = vim.loop.fs_realpath(path) or path

	local LazyUtil = require("lazy.core.util")
	return LazyUtil.norm(path)
end
local cache = {}
local detectors = {}
function detectors.cwd()
	return { vim.loop.cwd() }
end
function detectors.pattern(buf, patterns)
	patterns = type(patterns) == "string" and { patterns } or patterns
	local path = realpath(vim.api.nvim_buf_get_name(assert(buf))) or vim.loop.cwd()
	local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]
	return pattern and { vim.fs.dirname(pattern) } or {}
end

local function detect()
	function resolve(spec)
		if detectors[spec] then
			return detectors[spec]
		elseif type(spec) == "function" then
			return spec
		end
		return function(buf)
			return detectors.pattern(buf, spec)
		end
	end
	opts = opts or {}
	opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec
	opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

	local ret = {} ---@type LazyRoot[]
	for _, spec in ipairs(opts.spec) do
		local paths = resolve(spec)(opts.buf)
		paths = paths or {}
		paths = type(paths) == "table" and paths or { paths }
		local roots = {} ---@type string[]
		for _, p in ipairs(paths) do
			local pp = realpath(p)
			if pp and not vim.tbl_contains(roots, pp) then
				roots[#roots + 1] = pp
			end
		end
		table.sort(roots, function(a, b)
			return #a > #b
		end)
		if #roots > 0 then
			ret[#ret + 1] = { spec = spec, paths = roots }
			if opts.all == false then
				break
			end
		end
	end
	return ret
end
local function getroot(opts)
	local buf = vim.api.nvim_get_current_buf()
	local ret = cache[buf]
	if not ret then
		local roots = detect({ all = false })
		ret = roots[1] and roots[1].paths[1] or vim.loop.cwd()
		cache[buf] = ret
	end
	if opts and opts.normalize then
		return ret
	end
	return ret
end
local function cwdf()
	return realpath(vim.loop.cwd()) or ""
end

local icons = {
	misc = {
		dots = "󰇘",
	},
	dap = {
		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = ".>",
	},
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
	},
	kinds = {
		Array = " ",
		Boolean = "󰨙 ",
		Class = " ",
		Codeium = "󰘦 ",
		Color = " ",
		Control = " ",
		Collapsed = " ",
		Constant = "󰏿 ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = "󰊕 ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = "󰊕 ",
		Module = " ",
		Namespace = "󰦮 ",
		Null = " ",
		Number = "󰎠 ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = "󰆼 ",
		TabNine = "󰏚 ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = "󰀫 ",
	},
}
return {
	-- Better `vim.notify()`
	-- This handles fancy notify such as proress counters
	{
		"rcarriga/nvim-notify",
		dependencies = { "folke/tokyonight.nvim" },
		name = "notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss all Notifications",
			},
		},
		config = function(_, opts)
			opts = vim.tbl_deep_extend("force", { background_colour = "#282A36" }, opts)
			require("notify").setup(opts)
		end,
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
	},
	-- better vim.ui
	-- this does the nice popups for `vim.ui.select()` and `vim.ui.input()`
	{
		"stevearc/dressing.nvim",
		lazy = true,
		opts = {
			input = {
				-- 'editor' and 'win' will default to being centered
				-- 'cursor' will be centered on cursor location
				relative = "win",
			},
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			local function fg(name)
				---@type {foreground?:number}?
				---@diagnostic disable-next-line: deprecated
				local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
					or vim.api.nvim_get_hl_by_name(name, true)
				---@diagnostic disable-next-line: undefined-field
				local fg = hl and (hl.fg or hl.foreground)
				return fg and { fg = string.format("#%06x", fg) } or nil
			end

			local function root_dir(opts)
				opts = vim.tbl_extend("force", {
					cwd = false,
					subdirectory = true,
					parent = true,
					other = true,
					icon = "󱉭 ",
					color = fg("Special"),
				}, opts or {})

				local function get()
					local cwd = cwdf()
					local root = getroot()
					-- local root = Util.root.get({ normalize = true })
					local name = vim.fs.basename(root)

					if root == cwd then
						-- root is cwd
						return opts.cwd and name
					elseif root:find(cwd, 1, true) == 1 then
						-- root is subdirectory of cwd
						return opts.subdirectory and name
					elseif cwd:find(root, 1, true) == 1 then
						-- root is parent directory of cwd
						return opts.parent and name
					else
						-- root and cwd are not related
						return opts.other and name
					end
				end
				return {
					function()
						return (opts.icon and opts.icon .. " ") .. get()
					end,
					cond = function()
						return type(get()) == "string"
					end,
					color = opts.color,
				}
			end
			local function pretty_path(opts)
				opts = vim.tbl_extend("force", {
					relative = "cwd",
					modified_hl = "Constant",
				}, opts or {})

				return function(self)
					local path = vim.fn.expand("%:p") --[[@as string]]

					if path == "" then
						return ""
					end
					local root = getroot({ normalize = true })
					local cwd = cwdf()

					if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
						path = path:sub(#cwd + 2)
					else
						path = path:sub(#root + 2)
					end

					local sep = package.config:sub(1, 1)
					local parts = vim.split(path, "[\\/]")
					if #parts > 3 then
						parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
					end

					if opts.modified_hl and vim.bo.modified then
						parts[#parts] = M.format(self, parts[#parts], opts.modified_hl)
					end

					return table.concat(parts, sep)
				end
			end
			return {
				options = {
					theme = "auto",
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
				},
				sections = {
					lualine_a = {
						{ "mode" },
						{
							"harpoon2",
							-- icon = "♥",
							-- indicators = { "a", "s", "q", "w" },
							-- active_indicators = { "A", "S", "Q", "W" },
							color_active = { fg = "#00ff00" },
							-- _separator = " ",
							-- no_harpoon = "Harpoon not loaded",
						},
					},
					lualine_b = { "branch" },
					lualine_c = {
						root_dir(),
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", file_status = true, path = 1 }, -- Shows + for unsaved
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
					},
					lualine_x = {
	           -- stylua: ignore
	           {
	             function() return require("noice").api.status.command.get() end,
	             cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
	             color = fg("Statement"),
	           },
	           -- stylua: ignore
	           {
	             function() return require("noice").api.status.mode.get() end,
	             cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
	             color = fg("Constant"),
	           },
	           -- stylua: ignore
	           {
	             function() return "  " .. require("dap").status() end,
	             cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
	             color = fg("Debug"),
	           },
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = fg("Special"),
						},
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function()
							return vim.bo.filetype .. "  " .. os.date("%R")
						end,
					},
				},
				extensions = { "neo-tree", "lazy" },
			}
		end,
	},
	-- indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = {
				enabled = false,
			},
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
		main = "ibl",
	},

	-- Active indent guide and indent text objects. When you're browsing
	-- code, this highlights the current level of indentation, and animates
	-- the highlighting.
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			-- symbol = "▏",
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		-- edgy
		{
			"folke/edgy.nvim",
			event = "VeryLazy",
			keys = {
				{
					"<leader>ue",
					function()
						require("edgy").toggle()
					end,
					desc = "Edgy Toggle",
				},
        -- stylua: ignore
        { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
			},
			opts = function()
				local opts = {
					bottom = {
						{
							ft = "toggleterm",
							size = { height = 0.4 },
							filter = function(buf, win)
								return vim.api.nvim_win_get_config(win).relative == ""
							end,
						},
						{
							ft = "noice",
							size = { height = 0.4 },
							filter = function(buf, win)
								return vim.api.nvim_win_get_config(win).relative == ""
							end,
						},
						{
							ft = "lazyterm",
							title = "LazyTerm",
							size = { height = 0.4 },
							filter = function(buf)
								return not vim.b[buf].lazyterm_cmd
							end,
						},
						"Trouble",
						{
							ft = "trouble",
							filter = function(buf, win)
								return vim.api.nvim_win_get_config(win).relative == ""
							end,
						},
						{ ft = "qf", title = "QuickFix" },
						{
							ft = "help",
							size = { height = 20 },
							-- don't open help files in edgy that we're editing
							filter = function(buf)
								return vim.bo[buf].buftype == "help"
							end,
						},
						{ title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
						{ title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
					},
					left = {
						{
							title = "Neo-Tree",
							ft = "neo-tree",
							filter = function(buf)
								return vim.b[buf].neo_tree_source == "filesystem"
							end,
							pinned = true,
							open = function()
								vim.api.nvim_input("<esc><space>e")
							end,
							size = { height = 0.5 },
						},
						{ title = "Neotest Summary", ft = "neotest-summary" },
						{
							title = "Neo-Tree Git",
							ft = "neo-tree",
							filter = function(buf)
								return vim.b[buf].neo_tree_source == "git_status"
							end,
							pinned = true,
							open = "Neotree position=right git_status",
						},
						{
							title = "Neo-Tree Buffers",
							ft = "neo-tree",
							filter = function(buf)
								return vim.b[buf].neo_tree_source == "buffers"
							end,
							pinned = true,
							open = "Neotree position=top buffers",
						},
						"neo-tree",
					},
					keys = {
						-- increase width
						["<c-Right>"] = function(win)
							win:resize("width", 2)
						end,
						-- decrease width
						["<c-Left>"] = function(win)
							win:resize("width", -2)
						end,
						-- increase height
						["<c-Up>"] = function(win)
							win:resize("height", 2)
						end,
						-- decrease height
						["<c-Down>"] = function(win)
							win:resize("height", -2)
						end,
					},
				}
				return opts
			end,
		},

		-- use edgy's selection window
		{
			"nvim-telescope/telescope.nvim",
			optional = true,
			opts = {
				defaults = {
					get_selection_window = function()
						require("edgy").goto_main()
						return 0
					end,
				},
			},
		},

		-- prevent neo-tree from opening files in edgy windows
		{
			"nvim-neo-tree/neo-tree.nvim",
			optional = true,
			opts = function(_, opts)
				opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
					or { "terminal", "Trouble", "qf", "Outline", "trouble" }
				table.insert(opts.open_files_do_not_replace_types, "edgy")
			end,
		},

		-- Fix bufferline offsets when edgy is loaded
		{
			"akinsho/bufferline.nvim",
			optional = true,
			opts = function()
				local Offset = require("bufferline.offset")
				if not Offset.edgy then
					local get = Offset.get
					Offset.get = function()
						if package.loaded.edgy then
							local layout = require("edgy.config").layout
							local ret = { left = "", left_size = 0, right = "", right_size = 0 }
							for _, pos in ipairs({ "left", "right" }) do
								local sb = layout[pos]
								if sb and #sb.wins > 0 then
									local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
									ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
									ret[pos .. "_size"] = sb.bounds.width
								end
							end
							ret.total_size = ret.left_size + ret.right_size
							if ret.total_size > 0 then
								return ret
							end
						end
						return get()
					end
					Offset.edgy = true
				end
			end,
		},
	},
}
