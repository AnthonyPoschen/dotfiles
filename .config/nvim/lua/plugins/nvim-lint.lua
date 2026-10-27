return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				fish = { "fish" },
				go = { "golangcilint" },
				css = { "stylelint" },
				scss = { "stylelint" },
				html = { "stylelint" },
				-- Use the "*" filetype to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
				-- ['_'] = { 'fallback linter' },
			},
			-- Override linter options or add custom linters.
			---@type table<string,table>
			linters = {
				-- -- Example of using selene only when a selene.toml file is present
				-- selene = {
				--   -- `condition` dynamically enables/disables linters by context.
				--   condition = function(ctx)
				--     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
				--   end,
				-- },
			},
		},
		config = function(_, opts)
			local M = {}

			local lint = require("lint")
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = opts.linters_by_ft

			-- Project config wins. The dotfiles config is the fallback.
			local home = vim.loop.os_homedir()

			local function project_config(filename, names)
				local start = filename ~= "" and vim.fn.fnamemodify(filename, ":p") or vim.fn.getcwd()
				return vim.fs.find(names, { path = start, upward = true, stop = home })[1]
			end

			local function has_package_stylelint(filename)
				local start = filename ~= "" and vim.fn.fnamemodify(filename, ":p") or vim.fn.getcwd()
				local packages = vim.fs.find("package.json", {
					path = start,
					upward = true,
					stop = home,
					limit = math.huge,
				})
				for _, pkg in ipairs(packages) do
					local lines = vim.fn.readfile(pkg)
					local ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
					if ok and type(decoded) == "table" and decoded.stylelint then
						return true
					end
				end
				return false
			end

			local golangci = lint.linters.golangcilint
			local golangci_names = {
				".golangci.yml",
				".golangci.yaml",
				".golangci.toml",
				".golangci.json",
			}
			-- nvim's cwd is often $HOME, which now has .golangci.yml, so an
			-- unscoped run would always pick the dotfiles config. Pass the
			-- nearest project file, or the dotfiles file when there is none.
			if type(golangci.args) == "table" then
				local golangci_target = table.remove(golangci.args)
				vim.list_extend(golangci.args, {
					"--config",
					function()
						local filename = vim.api.nvim_buf_get_name(0)
						return project_config(filename, golangci_names) or vim.fn.expand("~/.golangci.yml")
					end,
					golangci_target,
				})
			end

			local stylelint = lint.linters.stylelint
			local stylelint_cmd = stylelint.cmd
			-- Custom plugins require("stylelint") from the skill directory.
			-- NODE_PATH is only a fallback after the project's own modules.
			stylelint.env = vim.tbl_extend("force", stylelint.env or {}, {
				NODE_PATH = vim.fn.expand("~/.config/stylelint/node_modules"),
			})
			stylelint.cmd = function()
				local resolved = stylelint_cmd()
				if resolved ~= "stylelint" then
					return resolved
				end
				local home_bin = vim.fn.expand("~/.config/stylelint/node_modules/.bin/stylelint")
				if vim.loop.fs_stat(home_bin) then
					return home_bin
				end
				return "stylelint"
			end
			local stylelint_names = {
				"stylelint.config.js",
				"stylelint.config.cjs",
				"stylelint.config.mjs",
				".stylelintrc",
				".stylelintrc.js",
				".stylelintrc.cjs",
				".stylelintrc.json",
				".stylelintrc.yml",
				".stylelintrc.yaml",
			}
			-- Same cwd problem as golangci-lint. A package.json "stylelint"
			-- key has no file to pass, so repeat the formatter flag and let
			-- Stylelint read that key from the file path.
			vim.list_extend(stylelint.args, {
				function()
					local filename = vim.api.nvim_buf_get_name(0)
					if not project_config(filename, stylelint_names) and has_package_stylelint(filename) then
						return "--formatter"
					end
					return "--config"
				end,
				function()
					local filename = vim.api.nvim_buf_get_name(0)
					local found = project_config(filename, stylelint_names)
					if found then
						return found
					end
					if has_package_stylelint(filename) then
						return "json"
					end
					return vim.fn.expand("~/.config/stylelint/stylelint.config.cjs")
				end,
			})

			function M.debounce(ms, fn)
				local timer = vim.loop.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			function M.lint()
				-- Use nvim-lint's logic first:
				-- * checks if linters exist for the full filetype first
				-- * otherwise will split filetype by "." and add all those linters
				-- * this differs from conform.nvim which only uses the first filetype that has a formatter
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)

				-- Add fallback linters.
				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				-- Add global linters.
				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				-- Filter out linters that don't exist or don't match the condition.
				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				-- Run linters.
				if #names > 0 then
					lint.try_lint(names)
				end
			end

			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = M.debounce(100, M.lint),
			})
		end,
	},
}
