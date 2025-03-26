---@diagnostic disable-next-line: lowercase-global
hs = hs

local homeMachine = hs.host.localizedName() == "TBD"

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

-- Keybind for Discord or Microsoft Teams
hs.hotkey.bind({ "cmd" }, "1", function()
	if homeMachine then
		hs.application.launchOrFocus("Discord")
	else
		local teams = hs.application.get("Microsoft Teams")
		if not teams then
			hs.application.launchOrFocus("Microsoft Teams")
			return
		end

		-- If Teams is running, ensure all windows are raised and cycle
		local allWindows = hs.window.allWindows()
		for _, win in pairs(allWindows) do
			if win:application():name() == "Microsoft Teams" then
				win:raise() -- Raise above other apps
				win:focus() -- Ensure it’s focused
			end
		end

		-- Cycle windows if already focused
		cycleWindows("Microsoft Teams")
	end
end)

-- Keybind for Ghostty
hs.hotkey.bind({ "cmd" }, "2", function()
	hs.application.launchOrFocus("Ghostty")
end)

-- Keybind for Brave Browser
hs.hotkey.bind({ "cmd" }, "3", function()
	local brave = hs.application.get("Brave Browser")
	if not brave then
		hs.application.launchOrFocus("Brave Browser")
		return
	end

	-- Cycle windows if already focused
	cycleWindows("Brave Browser")
end)
