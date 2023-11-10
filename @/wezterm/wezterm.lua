local w = require("wezterm")
local act = w.action

local config = {}
if w.config_builder then
	config = w.config_builder()
end

local FONT = "JetBrains Mono Regular"

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
config.font = w.font({ family = FONT, harfbuzz_features = { "calt=0", "clig=0", "liga=0" } })
config.inactive_pane_hsb = { saturation = 1, brightness = 1 }
config.window_background_opacity = 1

config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

-- disable all fancy fonts
config.font_rules = { ft("Bold", true), ft("Bold", false), ft("Normal", true), ft("Half", true), ft("Half", false) }

config.colors = {
	foreground = "#ebdbb2",
	background = "#282828",
	cursor_bg = "#bdae93",
	cursor_fg = "#282828",
	cursor_border = "#bdae93",
	selection_fg = "#282828",
	selection_bg = "#d8a657",
	scrollbar_thumb = "#222222",
	split = "#a9b665",
	ansi = { "#282828", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b48c", "#a89984" },
	brights = { "#928374", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b48c", "#ebdbb2" },
	tab_bar = {
		background = "#181818",
		active_tab = { bg_color = "#333333", fg_color = "#a9b665" },
		inactive_tab = { bg_color = "#181818", fg_color = "#928374" },
		inactive_tab_hover = { bg_color = "#181818", fg_color = "#928374" },
	},
}

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

return config
