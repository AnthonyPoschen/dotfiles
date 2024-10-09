-- Used in telescope definition and maybe git fugitive
local format_commit_message = require("telescope._extensions.conventional_commits.utils.format_commit_message")
local actions = {}
actions.commit = function(t, inputs)
	local body = inputs.body or ""
	local footer = inputs.footer or ""

	local cmd = ""

	local commit_message = format_commit_message(t, inputs)

	if vim.g.loaded_fugitive then
		cmd = string.format(':G commit --edit -m "%s" | :call feedkeys("A ")', commit_message)
	else
		print(commit_message)
		cmd = string.format(':!git commit -m "%s"', commit_message)
	end

	if body ~= nil and body ~= "" then
		cmd = cmd .. string.format(' -m "%s"', body)
	end

	if footer ~= nil and footer ~= "" then
		cmd = cmd .. string.format(' -m "%s"', footer)
	end

	print(cmd)

	vim.cmd(cmd)
end

actions.prompt = function(entry, include_extra_steps)
	vim.ui.input({ prompt = "scope? (optional) " }, function(input)
		--@param scope string
		--@param msg string
		local inputs = {}
		inputs.msg = ""
		inputs.scope = input
		-- ccinput("Enter a description: ", "msg", inputs)
		-- ccinput("Enter commit message: ", "msg", inputs)
		actions.commit(entry.value, inputs)
	end)
end

return actions
