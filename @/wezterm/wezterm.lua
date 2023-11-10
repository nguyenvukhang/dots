local w = require("wezterm")
local act = w.action
local wezterm = w

local config = {}
if w.config_builder then
	config = w.config_builder()
end

config.use_ime = false -- for faster key response
config.font_size = 14
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.font = w.font("JetBrains Mono")
config.cell_width = 0.9

-- gruvbox!
local g = {
	black = "#282828",
	red = "#ea6962",
	green = "#a9b665",
	yellow = "#d8a657",
	blue = "#7daea3",
	magenta = "#d3869b",
	cyan = "#89b48c",
	gray = "#a89984",
}

config.colors = {
	foreground = "#ebdbb2",
	background = "#282828",

	cursor_bg = "#bdae93",
	cursor_fg = "#282828",
	cursor_border = "#bdae93",
	selection_fg = "black",
	selection_bg = "#ebdbb2",
	scrollbar_thumb = "#222222",
	split = "#a9b665",

	ansi = { "#282828", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b48c", "#a89984" },
	brights = { "#928374", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b48c", "#ebdbb2" },

	compose_cursor = "orange",

	copy_mode_active_highlight_bg = { Color = "#000000" },
	copy_mode_active_highlight_fg = { AnsiColor = "Black" },
	copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
	copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

	quick_select_label_bg = { Color = "peru" },
	quick_select_label_fg = { Color = "#ffffff" },
	quick_select_match_bg = { AnsiColor = "Navy" },
	quick_select_match_fg = { Color = "#ffffff" },
	tab_bar = {
		background = "#181818",
		active_tab = {
			bg_color = "#282828",
			fg_color = "#a9b665",
			intensity = "Normal",
			-- "None" | "Single" | "Double"
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},
		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},
	},
}

local function mk_key(k, m, a)
	return { key = k, mods = m, action = a }
end

config.keys = {
	mk_key("d", "CMD", act.SplitHorizontal({ domain = "CurrentPaneDomain" })),
	mk_key("d", "CMD|SHIFT", act.SplitVertical({ domain = "CurrentPaneDomain" })),
	mk_key("h", "CMD", act.ActivatePaneDirection("Left")),
	mk_key("j", "CMD", act.ActivatePaneDirection("Down")),
	mk_key("k", "CMD", act.ActivatePaneDirection("Up")),
	mk_key("l", "CMD", act.ActivatePaneDirection("Right")),
	mk_key("h", "CMD|SHIFT", act.ActivateTabRelative(-1)),
	mk_key("l", "CMD|SHIFT", act.ActivateTabRelative(1)),
	mk_key("n", "CMD", act.SpawnTab("CurrentPaneDomain")),
	mk_key(
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

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "Helvetica", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 12.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#333333",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#ff0000",
}

return config
