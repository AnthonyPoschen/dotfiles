-- Center-master on the 49", left-master on the ROG.

hl.config({
  general = {
    -- Norrsken spacing: wider than Omarchy's 5/10.
    gaps_in = 8,
    gaps_out = 16,
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

  decoration = {
    shadow = {
      -- The glow is 9px and the gap is 8px, so it runs under the next window.
      -- That shared edge keeps redrawing on the monitor the cursor just left.
      range = 6,
      color_inactive = "rgba(00000000)",
    },
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

-- Keep ordinary windows solid. This rule is loaded after the theme, so the
-- glass rule has to follow it or the solid override wins.
o.window(".*", { opacity = "1.0 override 1.0 override" })

-- Norrsken glass panes: terminals, About, Omawrite, and Flea.
o.window(
  "^(com.mitchellh.ghostty|Alacritty|kitty|foot|org.omarchy.about|omawrite|com.thisisgm.flea)$",
  { tag = "-default-opacity", opacity = "0.84 override 0.76 override" }
)
