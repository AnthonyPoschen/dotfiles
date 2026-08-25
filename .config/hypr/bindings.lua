-- Personal binding overrides. Stock Omarchy binds that already match
-- the old bindings.conf (browser, nautilus, etc.) are left alone.

-- SUPER+SHIFT+M is Music / Spotify. Stock omarchy-launch-spotify has no
-- scale flag; CEF on this XWayland screen otherwise draws at 2x.
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", "omarchy-launch-spotify-1x")

-- App launcher. Walker is gone; this is the 4.0 apps menu.
-- SUPER+SPACE stays as the Omarchy root menu (it is no longer the launcher).
o.bind("SUPER + D", "Launch apps", "omarchy-menu toggle apps")

-- SUPER+X was Universal cut.
hl.unbind("SUPER + X")
o.bind("SUPER + X", "Terminal", { omarchy = "terminal" })

-- SUPER+SHIFT+T is free in 4.0 (Activity is also on SUPER+CTRL+T).
o.bind("SUPER + SHIFT + T", "Activity", { tui = "btop" })

-- SUPER+SHIFT+W was Omawrite.
hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "Typora", { launch = "typora --enable-wayland-ime" })

-- Swap the 4.0 ChatGPT / Grok chords back to the old mapping.
hl.unbind("SUPER + SHIFT + A")
hl.unbind("SUPER + SHIFT + ALT + A")
o.bind("SUPER + SHIFT + A", "Grok", { webapp = "https://grok.com" })
o.bind("SUPER + SHIFT + ALT + A", "ChatGPT", { webapp = "https://chatgpt.com" })

-- SUPER+SHIFT+C was Hey Calendar. SUPER+SHIFT+E / SUPER+SHIFT+ALT+E were Hey email.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Calculator", "omacalc")

hl.unbind("SUPER + SHIFT + E")
hl.unbind("SUPER + SHIFT + ALT + E")
o.bind("SUPER + SHIFT + E", "Gmail", { webapp = "https://mail.google.com/", focus = true })

-- SUPER+SHIFT+S was Google Maps.
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot to clipboard", "omarchy-capture-screenshot smart copy")

o.bind(
  "SUPER + SHIFT + CTRL + S",
  "Screenrecording",
  "omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord"
)

-- Official dictation toggle is SUPER+CTRL+X. Use the Home key instead.
-- F9 stays stock push-to-talk. Voxtype's evdev [hotkey] stays disabled.
hl.unbind("SUPER + CTRL + X")
hl.unbind("HOME")
o.bind("Home", "Toggle dictation", "voxtype record toggle")

-- Pass Super+Q through to Ghostty (close tab / Ghostty's own Super+Q).
hl.bind(
  "SUPER + Q",
  hl.dsp.pass({ window = "class:^(com\\.mitchellh\\.ghostty)$" }),
  { description = "Pass Super+Q to Ghostty" }
)

-- Horizontal scroll-wheel tilt → middle click.
o.bind("mouse_left", "Middle click (tilt left)", "ydotool click 0xC2", { locked = true })
o.bind("mouse_right", "Middle click (tilt right)", "ydotool click 0xC2", { locked = true })
