--------------------------------------------------------------------------------
-- Streamlined AwesomeWM Theme Configuration
-- This file defines the appearance of your Awesome window manager, including
-- fonts, colors, borders, gaps, icons, and more.
--------------------------------------------------------------------------------

-- WezTerm Colors from your configuration:
local gh = {
  gh_fg         = "#d0d7de",
  gh_bg         = "#0d1117",
  gh_comment    = "#8b949e",
  gh_red        = "#ff7b72",
  gh_green      = "#3fb950",
  gh_yellow     = "#d29922",
  gh_blue       = "#539bf5",
  gh_magenta    = "#bc8cff",
  gh_cyan       = "#39c5cf",
  gh_selection  = "#415555",
  gh_highlight  = "#4DFFDA",
  gh_caret      = "#58a6ff",
  gh_invisibles = "#2f363d",
}

local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi

local gears        = require("gears")
local gfs          = require("gears.filesystem")
local themes_path  = gfs.get_themes_dir()

local theme = {}

--------------------------------------------------------------------------------
-- Fonts and Colors
--------------------------------------------------------------------------------
theme.font          = "Roboto Mono Nerd Font 12"

-- Use our WezTerm colors:
theme.bg_normal     = gh.gh_bg         -- "#0d1117"
theme.fg_normal     = gh.gh_fg         -- "#d0d7de"

-- For focused elements, we choose a bright highlight for the background and
-- a dark text color for contrast.
theme.bg_focus      = gh.gh_blue  	   -- "#539bf5"
theme.fg_focus      = gh.gh_bg         -- "#0d1117"

theme.bg_urgent     = gh.gh_red        -- "#ff7b72"
theme.fg_urgent     = "#ffffff"        -- white for urgency
theme.bg_minimize   = gh.gh_comment    -- "#8b949e"
theme.fg_minimize   = gh.gh_fg         -- "#d0d7de"
theme.bg_systray    = gh.gh_bg

--------------------------------------------------------------------------------
-- Window Borders and Gaps
--------------------------------------------------------------------------------
theme.useless_gap   = dpi(8)
theme.border_width  = dpi(4)
theme.border_normal = "#1a1a1a"   -- you might change this to gh.gh_invisibles if preferred
theme.border_focus  = gh.gh_blue
theme.border_marked = gh.gh_blue

--------------------------------------------------------------------------------
-- Taglist Shape (Rounded corners for tag items)
--------------------------------------------------------------------------------
theme.border_radius = dpi(4)
theme.taglist_shape = function(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, theme.border_radius)
end

--------------------------------------------------------------------------------
-- Menu Settings
--------------------------------------------------------------------------------
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(18)
theme.menu_width  = dpi(100)

--------------------------------------------------------------------------------
-- Titlebar Buttons
--------------------------------------------------------------------------------
theme.titlebar_close_button_normal       = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus        = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal    = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus     = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active    = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active     = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active     = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active      = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active     = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active      = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active     = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active      = themes_path.."default/titlebar/maximized_focus_active.png"

--------------------------------------------------------------------------------
-- Wallpaper (Optional)
--------------------------------------------------------------------------------
-- Uncomment and set the path to use your custom wallpaper:
-- theme.wallpaper = "~/.config/backgrounds/your_wallpaper.png"

--------------------------------------------------------------------------------
-- Layout Icons
--------------------------------------------------------------------------------
theme.layout_fairh         = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv         = themes_path.."default/layouts/fairvw.png"
theme.layout_floating      = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier     = themes_path.."default/layouts/magnifierw.png"
theme.layout_max           = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen    = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom    = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft      = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile          = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop       = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral        = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle       = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw      = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne      = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw      = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse      = themes_path.."default/layouts/cornersew.png"

--------------------------------------------------------------------------------
-- Awesome Icon
--------------------------------------------------------------------------------
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

--------------------------------------------------------------------------------
-- Application Icon Theme
--------------------------------------------------------------------------------
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
