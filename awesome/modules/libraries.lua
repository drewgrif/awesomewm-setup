-- modules/libraries.lua

-- Attempt to load LuaRocks (if installed)
pcall(require, "luarocks.loader")

-- Core libraries (globally accessible)
gears = require("gears")
awful = require("awful")
require("awful.autofocus")
wibox = require("wibox")
beautiful = require("beautiful")
-- naughty = require("naughty")  -- Disabled to use dunst
menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Optional libraries
local has_debian, debian = pcall(require, "debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- Expose optional libraries globally if available
if has_debian then
    debian_menu = debian
end

if has_fdo then
    freedesktop_menu = freedesktop
end

-- Optional: Return the loaded libraries for modules that might need direct access
return {
    gears = gears,
    awful = awful,
    wibox = wibox,
    beautiful = beautiful,
    -- naughty = naughty,  -- Disabled to use dunst
    menubar = menubar,
    hotkeys_popup = hotkeys_popup,
    debian_menu = debian_menu,
    freedesktop_menu = freedesktop_menu
}
