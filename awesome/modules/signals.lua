-- modules/signals.lua
-- Signal handling for AwesomeWM

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
-- local naughty = require("naughty")  -- Disabled to use dunst
local variables = require("modules.variables")

local signals = {}

-- Function to set up client signals
local function setup_client_signals()
    -- Signal function to execute when a new client appears
    client.connect_signal("manage", function(c)
        -- Set the windows at the slave (not master)
        if not awesome.startup then
            awful.client.setslave(c)
        end

        -- Prevent clients from being unreachable after screen count changes
        if awesome.startup
            and not c.size_hints.user_position
            and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes
            awful.placement.no_offscreen(c)
        end
    end)

    -- Add a titlebar if titlebars_enabled is set to true in the rules
    client.connect_signal("request::titlebars", function(c)
        -- Custom titlebar setup
        awful.titlebar(c):setup {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                layout = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                layout = wibox.layout.flex.horizontal
            },
            { -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end)

    -- Enable sloppy focus (focus follows mouse)
    client.connect_signal("mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end)

    -- Change border color when client gets focus
    client.connect_signal("focus", function(c)
        c.border_color = beautiful.border_focus
    end)
    
    -- Reset border color when client loses focus
    client.connect_signal("unfocus", function(c)
        c.border_color = beautiful.border_normal
    end)
end

-- Function to set up screen signals
local function setup_screen_signals()
    -- Re-set wallpaper when a screen's geometry changes
    screen.connect_signal("property::geometry", function(s)
        -- Wallpaper
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end)
end

-- Function to set up tag signals
local function setup_tag_signals()
    -- Update tag properties when layout changes
    tag.connect_signal("property::layout", function(t)
        -- You can add custom logic here when a tag's layout changes
    end)
    
    -- Update tag properties when selected state changes
    tag.connect_signal("property::selected", function(t)
        -- You can add custom logic here when a tag is selected/unselected
    end)
end

-- Initialize all signals
function signals.init()
    setup_client_signals()
    setup_screen_signals()
    setup_tag_signals()
    
    -- You can add more signal setups here
end

return signals
