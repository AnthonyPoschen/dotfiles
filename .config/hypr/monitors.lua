-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- 1x on both displays. The 49" is 5120x1440 physical, not a retina panel.
hl.env("GDK_SCALE", "1")

-- 49" MSI MPG491CX OLED. Origin of the layout; ROG sits centered above it.
hl.monitor({ output = "DP-1", mode = "5120x1440@240", position = "0x0", scale = 1 })

-- ROG PG348Q stacked above the 49". x=840 is (5120 - 3440) / 2 so it centers.
hl.monitor({ output = "HDMI-A-1", mode = "3440x1440@50", position = "840x-1440", scale = 1 })
