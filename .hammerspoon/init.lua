---@diagnostic disable-next-line: lowercase-global
hs = hs

hs.application.enableSpotlightForNameSearches(true)
local homeMachine = hs.host.localizedName() == "Anthony’s MacBook Pro"

local keybinds = {
	Home = {
		{ "cmd", "1", "Discord" },
		{ "cmd", "2", "Ghostty" },
		{ "cmd", "3", "Brave Browser" },
	},
	Work = {
		{ "cmd", "1", "Microsoft Teams" },
		{ "cmd", "2", "Ghostty" },
		{ "cmd", "3", "Brave Browser" },
	},
}
-- NOTE: use this for debugging to get list of applications, console mode
-- for _, app in pairs(hs.application.runningApplications()) do print(app:title()) end

-- Helper function to cycle through windows
local function cycleWindows(appName)
	local app = hs.application.get(appName)
	if not app then
		return
	end

	local windows = app:allWindows()
	if #windows <= 1 then
		if #windows == 1 then
			windows[1]:focus()
		end
		return
	end -- No need to cycle if 1 or fewer windows

	-- Get the currently focused window
	local focusedWindow = hs.window.focusedWindow()
	local currentApp = focusedWindow and focusedWindow:application():name() == appName

	if currentApp and #windows > 1 then
		-- Find the current window in the list and focus the next one
		for i, win in ipairs(windows) do
			if win:id() == focusedWindow:id() then
				local nextIndex = (i % #windows) + 1 -- Wrap around to first window
				windows[nextIndex]:focus()
				return
			end
		end
	else
		-- If not focused or no match, focus the first window
		if windows[1] then
			windows[1]:focus()
		end
	end
end

-- lua has retarded ternary operator
local keybindGroup = homeMachine and "Home" or "Work"
for _, keybind in ipairs(keybinds[keybindGroup]) do
	hs.hotkey.bind(keybind[1], keybind[2], function()
		hs.application.launchOrFocus(keybind[3])
		cycleWindows(keybind[3])
	end)
end
