-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()


-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

-- Set the window background opacity to 50%
config.window_background_opacity = 0.5

-- Configure key bindings
config.keys = {
    {key="v", mods="ALT|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="h", mods="ALT|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
}

-- and finally, return the configuration to wezterm
return config
