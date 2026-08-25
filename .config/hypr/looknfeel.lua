-- Center-master on the 49", left-master on the ROG.

hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 1,
    layout = "master",
    allow_tearing = true,
  },

  master = {
    -- Last assignment in the old conf won: new windows join the slave stack.
    new_status = "slave",
    orientation = "center",
    mfact = 0.5,
    -- Always keep the master centered, even with a single window.
    slave_count_for_center_master = 0,
    center_master_fallback = "center",
  },

  cursor = {
    hide_on_key_press = false,
    inactive_timeout = 0,
  },
})

-- 49" (DP-1): workspaces 0-4, centered master. Workspace 0 is the login default.
for workspace = 0, 4 do
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = "DP-1",
    default = workspace == 0,
    layout_opts = { orientation = "center" },
  })
end

-- ROG on top (HDMI-A-1): workspaces 5-9, left master.
for workspace = 5, 9 do
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = "HDMI-A-1",
    layout_opts = { orientation = "left" },
  })
end

-- Omarchy multiplies default windows to 0.985 / 0.96 and browsers to 1.0 / 0.985.
-- override makes these absolute so later (or earlier) multipliers cannot leak through.
o.window(".*", { opacity = "1.0 override 1.0 override" })
