-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local shape = gears.shape
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- The height of the wibar at the top of the screen.
local menubar_height = 20

local TAGLIST = {
	{ title = "  1  ", map_key = "#10" }, -- raw keycode. See `xmodmap -pke | grep 10`.
	{ title = "  2  ", map_key = "#11" }, -- (the # symbol denotes that it's a raw keycode)
	{ title = "  3  ", map_key = "#12" },
	{ title = "  4  ", map_key = "#13" },
	{ title = "  T  ", map_key = "#19" },
}

local spawn = function(command)
	return function()
		awful.spawn(command)
	end
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "brew.lua")

-- This is used later as the default terminal to run.
local terminal = "alatty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile.left,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.tile.right,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

local mymainmenu = nil
if has_fdo then
	mymainmenu = freedesktop.menu.build({ before = { menu_awesome }, after = { menu_terminal } })
else
	mymainmenu = awful.menu({ items = { menu_awesome, { "Debian", debian.menu.Debian_menu.Debian }, menu_terminal } })
end

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()
local londonclock = wibox.widget.textclock("(%H:%M) ", 60, "Europe/London")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(awful.button({}, 1, function(t)
	t:view_only()
end))

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, false)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	local bg_translucent = "#00000080"
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	local taglist = {}
	for i = 1, #TAGLIST do
		table.insert(taglist, TAGLIST[i].title)
	end
	awful.tag(taglist, s, awful.layout.layouts[1])

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		layout = { layout = wibox.layout.fixed.horizontal },
		style = { bg_normal = bg_translucent },
		widget_template = {
			{
				{ id = "clienticon", widget = awful.widget.clienticon },
				margins = 3,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			create_callback = function(self, c, index, objects) --luacheck: no unused
				self:get_children_by_id("clienticon")[1].client = c
			end,
		},
		placement = awful.placement.centered,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, height = menubar_height, bg = "#00000000" })

	local spacer = function(width)
		return { widget = wibox.container.background, forced_width = width }
	end

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{
			widget = wibox.container.background,
			bg = bg_translucent,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				mylauncher,
				s.mytaglist,
			},
		},
		{
			layout = wibox.layout.fixed.horizontal, -- Middle widget
			{
				layout = wibox.layout.align.horizontal, -- Middle widget
				s.mytasklist,
			},
			{
				widget = wibox.container.background,
				shape = function(cr, width, height)
					return shape
						.transform(shape.isosceles_triangle)
						:rotate_at(width / 2, height / 2, math.pi)(cr, width * 2, height)
				end,
				bg = bg_translucent,
				forced_width = menubar_height,
				spacer(0),
			},
		},
		{
			layout = wibox.layout.align.horizontal,
			{
				widget = wibox.container.background,
				shape = function(cr, width, height)
					return shape
						.transform(shape.isosceles_triangle)
						:rotate_at(width / 2, height / 2, -math.pi / 2)(cr, width * 2, height)
				end,
				bg = bg_translucent,
				forced_width = menubar_height,
				spacer(0),
			},
			{
				widget = wibox.container.background,
				bg = bg_translucent,
				{
					layout = wibox.layout.fixed.horizontal,
					spacer(10),
					londonclock,
					mytextclock,
					spacer(6),
				},
			},
		},
	})
end)
-- }}}

local rofi_fzf = " -matching fuzzy -sort -sorting-method fzf"
-- {{{ Key bindings
local globalkeys = gears.table.join(
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end),

	-- Standard program
	awful.key({ modkey }, "Return", spawn(terminal)),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	-- awful.key({ modkey, "Shift" }, "q", awesome.quit), -- too strong

	-- Prompt
	awful.key({ modkey }, "space", spawn("rofi -show run" .. rofi_fzf)),

	-- Emoji
	awful.key({ modkey, "Control" }, "space", spawn("rofi -modi emoji -show emoji" .. rofi_fzf)),

	-- Menubar
	awful.key({ modkey }, "p", spawn("rofi -modes pdf -show pdf" .. rofi_fzf))
)

local clientkeys = gears.table.join(
	awful.key({ modkey }, "q", function(c)
		c:kill()
	end),
	awful.key({ modkey, "Control", "Shift" }, "i", function()
		awful.client.swap.byidx(1)
	end),
	awful.key({ modkey, "Control", "Shift" }, "o", function()
		awful.client.swap.byidx(-1)
	end),

	awful.key({ modkey, "Control", "Shift" }, "-", function()
		awful.tag.incmwfact(-0.08)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey, "Control", "Shift" }, "=", function()
		awful.tag.incmwfact(0.08)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Control" }, "f", awful.client.floating.toggle),
	awful.key({ modkey, "Control", "Shift" }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, #TAGLIST do
	local z = TAGLIST[i]
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag.
		awful.key({ modkey }, z.map_key, function()
			local tag = awful.screen.focused().tags[i]
			if tag then
				tag:view_only()
			end
		end),
		-- Move focused client to tag.
		awful.key({ modkey, "Shift" }, z.map_key, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end)
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			maximized = false,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	{ rule = { instance = "app.element.io" }, properties = { floating = false, maximized = false } },

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },

	{ rule = { class = "smile" }, properties = { floating = true, placement = awful.placement.centered } },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	{ rule = { class = "firefox" }, properties = { screen = 1, tag = TAGLIST[2].title, maximized = false } },

	{
		rule_any = {
			class = { "discord", "Telegram", "Signal" },
		},
		properties = { screen = 1, tag = TAGLIST[3].title, maximized = false },
	},

	{
		rule = { class = "obs" },
		except = { class = "obsidian" },
		properties = { screen = 1, tag = TAGLIST[4].title, maximized = false },
	},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

client.connect_signal("property::floating", function(c)
	if not c.fullscreen then
		c.ontop = c.floating
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
	c.border_color = "#00000000"
end)
-- }}}

awful.spawn("picom")
awful.spawn("lxpolkit")
