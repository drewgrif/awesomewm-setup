-- modules/scratchpad.lua
-- Flexible scratchpad/dropdown functionality for AwesomeWM

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local scratchpad = {}

-- Store all scratchpad instances
scratchpad.instances = {}

-- Find existing scratchpad client
local function find_scratchpad_client(instance_name)
    for _, c in ipairs(client.get()) do
        if c.instance == instance_name then
            return c
        end
    end
    return nil
end

-- Create a scratchpad instance
function scratchpad.create(args)
    args = args or {}
    
    local scratch = {}
    scratch.cmd = args.cmd or "st"
    scratch.name = args.name or "scratchpad"
    scratch.class = args.class or "St"
    scratch.instance = args.instance or "scratchpad"
    scratch.width = args.width or 0.8  -- 80% of screen width
    scratch.height = args.height or 0.6  -- 60% of screen height
    scratch.sticky = args.sticky ~= false  -- default true
    scratch.position = args.position or "top"  -- top, center, bottom
    scratch.hidden = true
    scratch.client = nil
    
    -- Function to toggle the scratchpad
    function scratch:toggle()
        -- First, try to find an existing scratchpad client
        self.client = find_scratchpad_client(self.instance)
        
        if not self.client or not self.client.valid then
            -- Build the command
            local spawn_cmd = self.cmd
            -- print("Spawning scratchpad:", spawn_cmd, "Instance:", self.instance)
            
            -- Create the scratchpad
            awful.spawn(spawn_cmd)
            -- Wait for the client to be managed
            local signal_handler
            signal_handler = function(c)
                -- Debug logging
                -- print("New client:", c.class, c.instance, c.name)
                
                -- Check if this is our scratchpad
                if c.instance == self.instance and not self.client then
                    self.client = c
                    self:setup(c)
                    self:show()
                    -- Disconnect this specific signal handler after use
                    client.disconnect_signal("manage", signal_handler)
                end
            end
            client.connect_signal("manage", signal_handler)
        else
            if self.hidden or self.client.hidden then
                self:show()
            else
                self:hide()
            end
        end
    end
    
    -- Setup the scratchpad client
    function scratch:setup(c)
        -- Force floating state
        awful.client.floating.set(c, true)
        
        -- Set properties
        c.floating = true
        c.sticky = self.sticky
        c.ontop = true
        c.skip_taskbar = true
        c.requests_no_titlebar = true
        c.size_hints_honor = false
        
        -- Apply rounded corners
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 10)
        end
        
        -- Connect signals
        c:connect_signal("unmanage", function()
            self.client = nil
            self.hidden = true
        end)
        
        -- Prevent tiling
        c:connect_signal("property::floating", function()
            if not c.floating then
                c.floating = true
            end
        end)
    end
    
    -- Show the scratchpad
    function scratch:show()
        if self.client and self.client.valid then
            local c = self.client
            c.hidden = false
            c.minimized = false
            
            -- Calculate position and size
            local s = awful.screen.focused()
            local sg = s.geometry
            local width = sg.width * self.width
            local height = sg.height * self.height
            local x = sg.x + (sg.width - width) / 2
            local y
            
            -- Position based on preference
            if self.position == "top" then
                y = sg.y + 30  -- Small offset from top
            elseif self.position == "center" then
                y = sg.y + (sg.height - height) / 2
            elseif self.position == "bottom" then
                y = sg.y + sg.height - height - 30  -- Small offset from bottom
            end
            
            c:geometry({
                x = x,
                y = y,
                width = width,
                height = height
            })
            
            -- Ensure it's on top and focused
            c.ontop = true
            c:raise()
            client.focus = c
            
            self.hidden = false
        end
    end
    
    -- Hide the scratchpad
    function scratch:hide()
        if self.client and self.client.valid then
            self.client.hidden = true
            self.client.minimized = true
            self.hidden = true
        end
    end
    
    return scratch
end

-- Create predefined scratchpads
scratchpad.terminal = scratchpad.create({
    cmd = "st -n scratchpad-terminal",
    name = "terminal-scratchpad",
    class = "St",
    instance = "scratchpad-terminal",
    width = 0.8,
    height = 0.6,
    position = "top"
})

scratchpad.ranger = scratchpad.create({
    cmd = "st -n scratchpad-ranger -c St-scratchpad -e ranger",
    name = "ranger-scratchpad",
    class = "St",
    instance = "scratchpad-ranger",
    width = 0.9,
    height = 0.8,
    position = "center"
})

scratchpad.pulsemixer = scratchpad.create({
    cmd = "st -n scratchpad-pulsemixer -c St-scratchpad -e pulsemixer",
    name = "pulsemixer-scratchpad",
    class = "St",
    instance = "scratchpad-pulsemixer",
    width = 0.7,
    height = 0.5,
    position = "center"
})

scratchpad.music = scratchpad.create({
    cmd = "st -n scratchpad-music -c St-scratchpad -e ncmpcpp",
    name = "music-scratchpad",
    class = "St",
    instance = "scratchpad-music",
    width = 0.8,
    height = 0.7,
    position = "center"
})

-- You can also create scratchpads for GUI apps
scratchpad.pavucontrol = scratchpad.create({
    cmd = "pavucontrol",
    name = "pavucontrol-scratchpad",
    class = "Pavucontrol",
    instance = "pavucontrol",
    width = 0.6,
    height = 0.7,
    position = "center"
})

-- Function to create custom scratchpad on the fly
function scratchpad.custom(cmd, opts)
    opts = opts or {}
    opts.cmd = cmd
    opts.instance = opts.instance or "scratchpad-custom-" .. os.time()
    local custom = scratchpad.create(opts)
    custom:toggle()
    return custom
end

-- Store instances for easy access
scratchpad.instances.terminal = scratchpad.terminal
scratchpad.instances.ranger = scratchpad.ranger
scratchpad.instances.pulsemixer = scratchpad.pulsemixer
scratchpad.instances.music = scratchpad.music
scratchpad.instances.pavucontrol = scratchpad.pavucontrol

return scratchpad