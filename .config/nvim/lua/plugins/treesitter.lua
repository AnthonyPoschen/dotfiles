local treesitter_parsers = {
	"bash",
	"c",
	"comment",
	"diff",
	"dockerfile",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"gowork",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"templ",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
	"zig",
}

local treesitter_filetypes = {
	"c",
	"comment",
	"diff",
	"dockerfile",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"gowork",
	"html",
	"javascript",
	"javascriptreact",
	"jsdoc",
	"json",
	"jsonc",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"python",
	"query",
	"regex",
	"sh",
	"templ",
	"toml",
	"tsx",
	"typescript",
	"typescriptreact",
	"vim",
	"vimdoc",
	"yaml",
	"zig",
	"zsh",
}

local function enable_treesitter(args)
	local ok = pcall(vim.treesitter.start, args.buf)
	if not ok then
		return
	end

	vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local function select_textobject(query)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
	end
end

local function move_textobject(fn_name, query, diff_key)
	return function()
		if diff_key and vim.wo.diff then
			vim.cmd("normal! " .. diff_key)
			return
		end

		require("nvim-treesitter-textobjects.move")[fn_name](query, "textobjects")
	end
end

local function add_mason_bin_to_path()
	local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
	local path = vim.env.PATH or ""
	if vim.uv.fs_stat(mason_bin) and not path:find(mason_bin, 1, true) then
		vim.env.PATH = mason_bin .. ":" .. path
	end
end

local function wait_for_task(task, should_wait)
	if should_wait and task and task.wait then
		task:wait(300000)
	end
end

local function get_missing_treesitter_parsers()
	local installed = {}
	for _, parser in ipairs(require("nvim-treesitter").get_installed("parsers")) do
		installed[parser] = true
	end

	local missing = {}
	for _, parser in ipairs(treesitter_parsers) do
		if not installed[parser] then
			missing[#missing + 1] = parser
		end
	end

	return missing
end

local function install_missing_treesitter_parsers(opts)
	opts = opts or {}
	add_mason_bin_to_path()
	if vim.fn.executable("tree-sitter") == 0 then
		if opts.notify_missing_cli then
			vim.notify("tree-sitter CLI is missing; Mason will install tree-sitter-cli.", vim.log.levels.WARN)
		end
		return
	end

	local missing = get_missing_treesitter_parsers()
	if vim.tbl_isempty(missing) then
		return
	end

	wait_for_task(require("nvim-treesitter").install(missing, { summary = opts.summary }), opts.wait)
end

local function sync_treesitter_parsers(opts)
	opts = opts or {}
	install_missing_treesitter_parsers(opts)

	add_mason_bin_to_path()
	if vim.fn.executable("tree-sitter") == 0 then
		return
	end

	wait_for_task(require("nvim-treesitter").update(treesitter_parsers, { summary = opts.summary }), opts.wait)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false,
		lazy = false,
		build = function()
			sync_treesitter_parsers({ summary = true, wait = true, notify_missing_cli = true })
		end,
		opts = {
			install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
		},
		config = function(_, opts)
			local treesitter = require("nvim-treesitter")
			if treesitter.setup then
				treesitter.setup(opts)
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter.enable", { clear = true }),
				pattern = treesitter_filetypes,
				callback = enable_treesitter,
			})
			vim.api.nvim_create_user_command("TSSyncConfigured", function()
				sync_treesitter_parsers({ summary = true, wait = true, notify_missing_cli = true })
			end, {
				desc = "Install and update configured Treesitter parsers",
			})
			vim.api.nvim_create_user_command("TSInstallConfigured", function()
				install_missing_treesitter_parsers({ summary = true, notify_missing_cli = true })
			end, {
				desc = "Install missing configured Treesitter parsers",
			})
			vim.api.nvim_create_autocmd("VimEnter", {
				group = vim.api.nvim_create_augroup("treesitter.auto-install", { clear = true }),
				once = true,
				callback = function()
					vim.defer_fn(function()
						install_missing_treesitter_parsers({ summary = true })
					end, 1000)
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
			if ok and textobjects.setup then
				textobjects.setup({
					select = {
						lookahead = true,
					},
					move = {
						set_jumps = true,
					},
				})
			end

			vim.keymap.set({ "x", "o" }, "af", select_textobject("@function.outer"), { desc = "Function Outer" })
			vim.keymap.set({ "x", "o" }, "if", select_textobject("@function.inner"), { desc = "Function Inner" })
			vim.keymap.set({ "x", "o" }, "ac", select_textobject("@class.outer"), { desc = "Class Outer" })
			vim.keymap.set({ "x", "o" }, "ic", select_textobject("@class.inner"), { desc = "Class Inner" })
			vim.keymap.set({ "x", "o" }, "ab", select_textobject("@block.outer"), { desc = "Block Outer" })
			vim.keymap.set({ "x", "o" }, "ib", select_textobject("@block.inner"), { desc = "Block Inner" })

			vim.keymap.set(
				{ "n", "x", "o" },
				"]f",
				move_textobject("goto_next_start", "@function.outer"),
				{ desc = "Next Function" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]c",
				move_textobject("goto_next_start", "@class.outer", "]c"),
				{ desc = "Next Class" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]b",
				move_textobject("goto_next_start", "@block.outer"),
				{ desc = "Next Block" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[f",
				move_textobject("goto_previous_start", "@function.outer"),
				{ desc = "Previous Function" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[c",
				move_textobject("goto_previous_start", "@class.outer", "[c"),
				{ desc = "Previous Class" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[b",
				move_textobject("goto_previous_start", "@block.outer"),
				{ desc = "Previous Block" }
			)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		enabled = true,
		opts = { mode = "cursor", max_lines = 3 },
	},

	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			filetypes = {
				"html",
				"templ",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"svelte",
				"vue",
				"tsx",
				"jsx",
				"rescript",
				"xml",
				"php",
				"markdown",
				"astro",
				"glimmer",
				"handlebars",
				"hbs",
			},
		},
	},

	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
}
