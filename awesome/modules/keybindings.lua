local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

local M = {}
local modkey = "Mod4"

-- Global keybindings
M.globalkeys = gears.table.join(
    -- Awesome controls
    awful.key({ modkey, "Shift"   }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "s", hotkeys_popup.show_help,
              {description = "show help", group = "awesome"}),
    awful.key({ modkey,           }, "w", function() mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Tag navigation
    awful.key({ modkey,           }, "Left", awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right", awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    -- Add window switching with Super+Shift+Left/Right
    awful.key({ modkey, "Shift"   }, "Left", function() 
                                                awful.client.focus.byidx(-1)
                                                if client.focus then client.focus:raise() end
                                             end,
              {description = "focus previous window", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Right", function() 
                                                awful.client.focus.byidx(1)
                                                if client.focus then client.focus:raise() end
                                              end,
              {description = "focus next window", group = "client"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Client focus
    awful.key({ modkey,           }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}
    ),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function() awful.client.swap.byidx(1) end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function() awful.client.swap.byidx(-1) end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),

    -- Layout adjustments
    awful.key({ modkey, "Control" }, "Right", function() awful.tag.incmwfact(0.05) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Left", function() awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Down", function() awful.client.incwfact(0.05) end,
              {description = "increase client height", group = "layout"}),
    awful.key({ modkey, "Control" }, "Up", function() awful.client.incwfact(-0.05) end,
              {description = "decrease client height", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h", function() awful.tag.incnmaster(1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function() awful.layout.inc(1) end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),

    -- Restore minimized
    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}),

    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- Terminal applications
    awful.key({ modkey }, "Return", function() awful.spawn("wezterm") end,
              {description = "open wezterm", group = "applications"}),
    awful.key({ modkey, "Shift" }, "Return", function() awful.spawn("tilix --quake") end,
              {description = "open tilix in quake mode", group = "applications"}),
              
    -- Application shortcuts
    awful.key({ modkey }, "e", function() awful.spawn("geany") end,
              {description = "open geany", group = "applications"}),
    awful.key({ modkey }, "b", function() awful.spawn("firefox-esr") end,
              {description = "open firefox", group = "applications"}),
    awful.key({ modkey }, "f", function() awful.spawn("thunar") end,
              {description = "open file manager", group = "applications"}),
    awful.key({ modkey }, "d", function() awful.spawn("discord") end,
              {description = "open discord", group = "applications"})
)

-- Client keybindings
M.clientkeys = gears.table.join(
    -- Close window with Super+q
    awful.key({ modkey }, "q", function(c) c:kill() end,
              {description = "close", group = "client"}),
              
    awful.key({ modkey,           }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o", function(c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t", function(c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind keys to tags 1-9
for i = 1, 9 do
    M.globalkeys = gears.table.join(M.globalkeys,
        -- View tag only
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #" .. i, group = "tag"}),
        
        -- Toggle tag display
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),
        
        -- Move client to tag
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}),
        
        -- Toggle tag on focused client
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Bind keys to tags 10-12
local extra_tags = {
    { key = "0", index = 10 },
    { key = "-", index = 11 },
    { key = "=", index = 12 }
}

for _, tag_info in ipairs(extra_tags) do
    M.globalkeys = gears.table.join(M.globalkeys,
        -- View tag only
        awful.key({ modkey }, tag_info.key,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[tag_info.index]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #" .. tag_info.index, group = "tag"}),
        
        -- Toggle tag display
        awful.key({ modkey, "Control" }, tag_info.key,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[tag_info.index]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. tag_info.index, group = "tag"}),
        
        -- Move client to tag
        awful.key({ modkey, "Shift" }, tag_info.key,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[tag_info.index]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. tag_info.index, group = "tag"}),
        
        -- Toggle tag on focused client
        awful.key({ modkey, "Control", "Shift" }, tag_info.key,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[tag_info.index]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. tag_info.index, group = "tag"})
    )
end

-- Mouse bindings for clients
M.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

return M
