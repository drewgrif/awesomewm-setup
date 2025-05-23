-- rc.lua
-- AwesomeWM modular configuration
-- Release naughty's hold on notifications D-Bus interface

-- Error handling should be loaded first
local error_handling = require("modules.error_handling")
error_handling.init()

-- Core libraries and variables
require("modules.libraries")
local variables = require("modules.variables")
local theme = require("modules.theme")
theme.init()

-- UI components
local menu = require("modules.menu")
menu.init()

local layouts = require("modules.layouts")
layouts.init()

local widgets = require("modules.widgets")
widgets.init()

local wibar = require("modules.wibar")
wibar.init()

-- Window management
local rules = require("modules.rules")
rules.init()

local signals = require("modules.signals")
signals.init()

local screens = require("modules.screens")
screens.init()

-- User interaction
local keybindings = require("modules.keybindings")
keybindings.init()

local mousebindings = require("modules.mousebindings")
mousebindings.init()

-- Disabled to use dunst instead
-- local notifications = require("modules.notifications")
-- notifications.init()

-- Release D-Bus interface so dunst can handle notifications
-- Disabled naughty completely to allow dunst to work
-- local naughty = require("naughty")
-- naughty.destroy_all_notifications()
-- naughty.config.notify_callback = function() return false end

-- User applications and startup
local autostart = require("modules.autostart")
autostart.init()

-- Optional modules
-- local titlebars = require("modules.titlebars")
-- titlebars.init()

-- local wallpaper = require("modules.wallpaper")
-- wallpaper.init()

-- local custom_widgets = require("modules.custom_widgets")
-- custom_widgets.init()

-- local dpi_scaling = require("modules.dpi_scaling")
-- dpi_scaling.init()
