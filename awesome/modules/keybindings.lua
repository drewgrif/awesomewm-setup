-- modules/keybindings.lua
local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local variables = require("modules.variables")

local keybindings = {}

-- Define client keybindings at the module level so they're accessible to rules.lua
keybindings.clientkeys = gears.table.join(
    -- Close window with Super+Q
    awful.key({ variables.modkey }, "q", function(c) c:kill() end,
              {description = "close", group = "client"}),
    
    -- Toggle fullscreen
    awful.key({ variables.modkey, "Control" }, "f", function(c) 
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {description = "toggle fullscreen", group = "client"}),
    
    -- Toggle floating and center the window
    awful.key({ variables.modkey, "Shift" }, "space", function(c)
        c.floating = not c.floating
        if c.floating then
            awful.placement.centered(c, {honor_workarea = true})
        end
    end, {description = "toggle floating", group = "client"}),
    
    -- Move window to master position
    awful.key({ variables.modkey, "Control" }, "Return", function(c) 
        c:swap(awful.client.getmaster()) 
    end, {description = "move to master", group = "client"}),
    
    -- Move window to another screen
    awful.key({ variables.modkey }, "o", function(c) 
        c:move_to_screen() 
    end, {description = "move to screen", group = "client"}),
    
    -- Toggle "keep on top"
    awful.key({ variables.modkey }, "t", function(c) 
        c.ontop = not c.ontop 
    end, {description = "toggle keep on top", group = "client"}),
    
    -- Minimize window
    awful.key({ variables.modkey }, "n", function(c) 
        c.minimized = true 
    end, {description = "minimize", group = "client"}),
    
    -- Maximize window
    awful.key({ variables.modkey }, "m", function(c) 
        c.maximized = not c.maximized
        c:raise()
    end, {description = "(un)maximize", group = "client"}),
    
    -- Maximize vertically
    awful.key({ variables.modkey, "Control" }, "m", function(c) 
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, {description = "(un)maximize vertically", group = "client"}),
    
    -- Maximize horizontally
    awful.key({ variables.modkey, "Shift" }, "m", function(c) 
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, {description = "(un)maximize horizontally", group = "client"})
)

-- Define client mouse bindings
keybindings.clientbuttons = gears.table.join(
    awful.button({}, 1, function(c) 
        c:emit_signal("request::activate", "mouse_click", {raise = true}) 
    end),
    awful.button({ variables.modkey }, 1, function(c) 
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ variables.modkey }, 3, function(c) 
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Initialize keybindings
function keybindings.init()
    -- Define modkey from variables
    local modkey = variables.modkey
    
    -- Global keybindings
    local globalkeys = gears.table.join(
        -- Awesome control
        awful.key({ modkey, "Shift" }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
        awful.key({ modkey, "Shift" }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),
        awful.key({ modkey }, "h", hotkeys_popup.show_help,
                  {description = "show help", group = "awesome"}),
        
        -- Terminal
        awful.key({ modkey }, "Return", function() awful.spawn(variables.terminal) end,
                  {description = "open a terminal", group = "launcher"}),
        
        -- Layout manipulation
        awful.key({ modkey, "Control" }, "Right", function() awful.tag.incmwfact(0.05) end,
                  {description = "increase master width factor", group = "layout"}),
        awful.key({ modkey, "Control" }, "Left", function() awful.tag.incmwfact(-0.05) end,
                  {description = "decrease master width factor", group = "layout"}),
        awful.key({ modkey, "Control" }, "Down", function() awful.client.incwfact(0.05) end,
                  {description = "increase client height", group = "layout"}),
        awful.key({ modkey, "Control" }, "Up", function() awful.client.incwfact(-0.05) end,
                  {description = "decrease client height", group = "layout"}),

        -- Layout switching
        awful.key({ "Control", "Shift" }, "1", function()
            awful.layout.set(awful.layout.layouts[1])
            awful.spawn.with_shell("notify-send 'Layout' 'Tile'")
        end, {description = "set tile layout", group = "layout"}),
        awful.key({ "Control", "Shift" }, "2", function()
            awful.layout.set(awful.layout.layouts[2])
            awful.spawn.with_shell("notify-send 'Layout' 'Tile Left'")
        end, {description = "set tile.left layout", group = "layout"}),
        awful.key({ "Control", "Shift" }, "3", function()
            awful.layout.set(awful.layout.layouts[3])
            awful.spawn.with_shell("notify-send 'Layout' 'Fair'")
        end, {description = "set fair layout", group = "layout"}),
        awful.key({ "Control", "Shift" }, "4", function()
            awful.layout.set(awful.layout.layouts[4])
            awful.spawn.with_shell("notify-send 'Layout' 'Fair Horizontal'")
        end, {description = "set fair.horizontal layout", group = "layout"}),
        awful.key({ "Control", "Shift" }, "5", function()
            awful.layout.set(awful.layout.layouts[5])
            awful.spawn.with_shell("notify-send 'Layout' 'Spiral'")
        end, {description = "set spiral layout", group = "layout"}),
        
-- Focus control
awful.key({ modkey }, "Left", function() awful.client.focus.byidx(1) end,
          {description = "focus next by index", group = "client"}),
awful.key({ modkey }, "Right", function() awful.client.focus.byidx(-1) end,
          {description = "focus previous by index", group = "client"}),
awful.key({ modkey }, "Up", function() awful.client.focus.bydirection("up") end,
          {description = "focus window above", group = "client"}),
awful.key({ modkey }, "Down", function() awful.client.focus.bydirection("down") end,
          {description = "focus window below", group = "client"}),

-- Window movement (swap clients)
awful.key({ modkey, "Shift" }, "Left", function() 
    if client.focus then awful.client.swap.byidx(1) end
end, {description = "swap with next client", group = "client"}),
awful.key({ modkey, "Shift" }, "Right", function() 
    if client.focus then awful.client.swap.byidx(-1) end
end, {description = "swap with previous by index", group = "client"}),
awful.key({ modkey, "Shift" }, "Up", function() 
    if client.focus then awful.client.swap.bydirection("up") end
end, {description = "swap with client above", group = "client"}),
awful.key({ modkey, "Shift" }, "Down", function() 
    if client.focus then awful.client.swap.bydirection("down") end
end, {description = "swap with client below", group = "client"})
)
    
    -- Tag navigation (1-9)
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys,
            awful.key({ modkey }, "#" .. i + 9, function()
                local tag = awful.screen.focused().tags[i]
                if tag then tag:view_only() end
            end, {description = "view tag #"..i, group = "tag"}),
            
            awful.key({ modkey, "Control" }, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) tag:view_only() end
                end
            end, {description = "move client to tag #"..i.." and view", group = "tag"}),
            
            awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end, {description = "move client to tag #"..i, group = "tag"})
        )
    end
    
    -- Tags 10-12 on keys 0, -, =
    local extra_tags = { [10] = "0", [11] = "-", [12] = "=" }
    for i, key in pairs(extra_tags) do
        globalkeys = gears.table.join(globalkeys,
            awful.key({ modkey }, key, function()
                local tag = awful.screen.focused().tags[i]
                if tag then tag:view_only() end
            end, {description = "view tag #" .. i, group = "tag"}),
            
            awful.key({ modkey, "Control" }, key, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) tag:view_only() end
                end
            end, {description = "move client to tag #" .. i .. " and view", group = "tag"}),
            
            awful.key({ modkey, "Shift" }, key, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end, {description = "move client to tag #" .. i, group = "tag"})
        )
    end
    
    -- Application keybindings
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "b", function() awful.util.spawn(variables.browser) end,
                  {description = "open browser", group = "launcher"}),
                  
        awful.key({ modkey }, "f", function() awful.util.spawn(variables.file_manager) end,
                  {description = "open file manager", group = "launcher"}), 
                  
        awful.key({ modkey }, "space", function() awful.util.spawn("rofi -show drun -modi drun -line-padding 4 -hide-scrollbar -show-icons -theme ~/.config/awesome/rofi/config.rasi") end,
                  {description = "rofi menu", group = "launcher"}),
                  
        -- Removed default Print binding as it's now defined below
                  
        -- Added keybindings
        awful.key({ modkey }, "e", function() awful.util.spawn("geany") end,
                  {description = "open geany", group = "launcher"}),
                  
        -- Scratchpad keybindings
        awful.key({ modkey, "Shift" }, "Return", function() 
            local scratchpad = require("modules.scratchpad")
            scratchpad.terminal:toggle()
        end,
        {description = "toggle terminal scratchpad", group = "scratchpad"}),
        
        awful.key({ modkey, "Shift" }, "f", function() 
            local scratchpad = require("modules.scratchpad")
            scratchpad.ranger:toggle()
        end,
        {description = "toggle ranger scratchpad", group = "scratchpad"}),
        
        awful.key({ modkey, "Shift" }, "v", function() 
            local scratchpad = require("modules.scratchpad")
            scratchpad.pulsemixer:toggle()
        end,
        {description = "toggle pulsemixer scratchpad", group = "scratchpad"}),
        
        awful.key({ modkey, "Shift" }, "n", function() 
            awful.spawn.with_shell("bash -ic 'note clip && notify-send \" Clipboard saved to notes\"'")
        end,
        {description = "paste to note (bashrc note)", group = "system"}),
        
        awful.key({ modkey, "Shift" }, "m", function() 
            local scratchpad = require("modules.scratchpad")
            scratchpad.music:toggle()
        end,
        {description = "toggle music player scratchpad", group = "scratchpad"}),
        
        awful.key({ modkey, "Shift" }, "p", function() 
            local scratchpad = require("modules.scratchpad")
            scratchpad.pavucontrol:toggle()
        end,
        {description = "toggle pavucontrol scratchpad", group = "scratchpad"}),
                  
        awful.key({ modkey, "Shift" }, "b", function() awful.util.spawn("firefox --private-window") end,
                  {description = "open firefox in private mode", group = "launcher"}),
        
        -- Volume control
        awful.key({ modkey }, "Insert", function() awful.spawn.with_shell("~/.config/awesome/scripts/changevolume up") end,
                  {description = "increase volume", group = "media"}),
                  
        awful.key({ modkey }, "Delete", function() awful.spawn.with_shell("~/.config/awesome/scripts/changevolume down") end,
                  {description = "decrease volume", group = "media"}),
                  
        -- Note: Super + m is already used for maximize, so I'm using Super + End for mute
        awful.key({ modkey }, "End", function() awful.spawn.with_shell("~/.config/awesome/scripts/changevolume mute") end,
                  {description = "mute volume", group = "media"}),
                  
        -- Screenshots
        awful.key({ modkey }, "Print", function() awful.spawn.with_shell("flameshot gui --path ~/Screenshots/") end,
                  {description = "screenshot region", group = "media"}),
                  
        -- Replacing your existing Print binding with this one
        awful.key({}, "Print", function() awful.spawn.with_shell("flameshot full --path ~/Screenshots/") end,
                  {description = "screenshot fullscreen", group = "media"}),
                  
        -- Redshift controls
        awful.key({ modkey, "Mod1" }, "r", function() awful.spawn.with_shell("~/.config/awesome/scripts/redshift-on") end,
                  {description = "enable redshift", group = "system"}),
                  
        awful.key({ modkey, "Mod1" }, "b", function() awful.spawn.with_shell("~/.config/awesome/scripts/redshift-off") end,
                  {description = "disable redshift", group = "system"})
    )
    
    -- Set keys
    root.keys(globalkeys)
end

return keybindings
