-- modules/error_handling.lua
-- local naughty = require("naughty")  -- Disabled to use dunst
local awful = require("awful")

local error_handling = {}

function error_handling.init()
    -- Check if awesome encountered an error during startup and fell back to
    -- another config (This code will only ever execute for the fallback config)
    if awesome.startup_errors then
        -- Log to stderr for dunst to potentially pick up
        io.stderr:write("AwesomeWM Startup Error: " .. awesome.startup_errors .. "\n")
        
        -- Send notification via dunst using notify-send
        awful.spawn.with_shell('notify-send -u critical "AwesomeWM Startup Error" "' .. 
            awesome.startup_errors:gsub('"', '\\"') .. '"')
    end

    -- Handle runtime errors after startup
    do
        local in_error = false
        awesome.connect_signal("debug::error", function (err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true

            -- Log to stderr for dunst to potentially pick up
            io.stderr:write("AwesomeWM Runtime Error: " .. tostring(err) .. "\n")
            
            -- Send notification via dunst using notify-send
            awful.spawn.with_shell('notify-send -u critical "AwesomeWM Runtime Error" "' .. 
                tostring(err):gsub('"', '\\"') .. '"')
            
            in_error = false
        end)
    end
end

return error_handling
