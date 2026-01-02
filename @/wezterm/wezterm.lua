local w = require("wezterm")
local act = w.action

local config = {}
if w.config_builder then
	config = w.config_builder()
end

local FONT = "JetBrains Mono NL"

local function key(k, m, a)
	return { key = k, mods = m, action = a }
end
local ft = function(y, c)
	return { intensity = y, italic = c, font = w.font(FONT) }
end

config.disable_default_key_bindings = true

config.use_ime = false -- for faster key response
config.font_size = 14
config.cell_width = 0.9
config.window_decorations = "RESIZE"
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.font = w.font({ family = FONT })
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.inactive_pane_hsb = { saturation = 1, brightness = 1 }
config.window_background_opacity = 0.97
config.window_background_opacity = 1
config.macos_window_background_blur = 8

config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
-- config.use_fancy_tab_bar = false
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

-- disable all fancy fonts
config.font_rules = { ft("Bold", true), ft("Bold", false), ft("Normal", true), ft("Half", true), ft("Half", false) }

config.keys = {
	key("d", "CMD", act.SplitHorizontal({ domain = "CurrentPaneDomain" })),
	key("d", "CMD|SHIFT", act.SplitVertical({ domain = "CurrentPaneDomain" })),
	key("h", "CMD", act.ActivatePaneDirection("Left")),
	key("j", "CMD", act.ActivatePaneDirection("Down")),
	key("k", "CMD", act.ActivatePaneDirection("Up")),
	key("l", "CMD", act.ActivatePaneDirection("Right")),
	key("o", "CMD", act.RotatePanes("Clockwise")),
	key("r", "CMD", act.ReloadConfiguration),
	key("q", "CMD", act.QuitApplication),
	key("v", "CMD", act.PasteFrom("Clipboard")),
	key("w", "CMD", act.CloseCurrentPane({ confirm = true })),
	key("h", "CMD|SHIFT", act.ActivateTabRelative(-1)),
	key("l", "CMD|SHIFT", act.ActivateTabRelative(1)),
	key("h", "LEADER", act.MoveTabRelative(-1)),
	key("l", "LEADER", act.MoveTabRelative(1)),
	key("n", "CMD", act.SpawnTab("CurrentPaneDomain")),
	key(
		",",
		"CMD",
		act.PromptInputLine({
			description = "Enter new name for tab",
			action = w.action_callback(function(window, _, line)
				return line and window:active_tab():set_title(line)
			end),
		})
	),
}

local gruvbox = {}
gruvbox.bg = "#090909"
gruvbox.fg = "#e5d2aa"
gruvbox.c1 = "#ea6962"
gruvbox.c2 = "#a9b665"
gruvbox.c3 = "#d8a657"
gruvbox.c4 = "#7daea3"
gruvbox.c5 = "#d3869b"
gruvbox.c6 = "#89b48c"
gruvbox.c7 = "#a89984"
gruvbox.c8 = "#928374"

gruvbox.ansi = {
	gruvbox.bg,
	gruvbox.c1,
	gruvbox.c2,
	gruvbox.c3,
	gruvbox.c4,
	gruvbox.c5,
	gruvbox.c6,
	gruvbox.c7,
}

config.colors = {
	background = gruvbox.bg,
	foreground = gruvbox.fg,
	cursor_bg = "#bdae93",
	cursor_fg = gruvbox.bg,
	selection_bg = gruvbox.c3,
	selection_fg = gruvbox.bg,
	split = "6D7B32",
	ansi = {
		gruvbox.bg,
		gruvbox.c1,
		gruvbox.c2,
		gruvbox.c3,
		gruvbox.c4,
		gruvbox.c5,
		gruvbox.c6,
		gruvbox.c7,
	},
	brights = {
		gruvbox.c8,
		gruvbox.c1,
		gruvbox.c2,
		gruvbox.c3,
		gruvbox.c4,
		gruvbox.c5,
		gruvbox.c6,
		gruvbox.fg,
	},
}

return config
