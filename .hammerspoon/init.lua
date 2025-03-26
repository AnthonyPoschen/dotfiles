---@diagnostic disable-next-line: lowercase-global
hs = hs

local homeMachine = hs.host.localizedName() == "TBD"

-- NOTE: use this for debugging to get list of applications
-- for _, app in pairs(hs.application.runningApplications()) do
-- 	print(app:title())
-- end

hs.hotkey.bind({ "cmd" }, "1", function()
	if homeMachine then
		hs.application.launchOrFocus("Discord")
	else
		hs.application.launchOrFocus("Microsoft Teams")
	end
end)

hs.hotkey.bind({ "cmd" }, "2", function()
	hs.application.launchOrFocus("Ghostty")
end)
hs.hotkey.bind({ "cmd" }, "3", function()
	hs.application.launchOrFocus("Brave Browser")
end)
