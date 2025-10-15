local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.color_scheme = "ForestBlue"
config.font_size = 12

config.leader = { key = '`' }
config.keys = {
    {
	key = '`',
	mods = 'LEADER',
	action = wezterm.action.SendKey { key = '`' },
    },
    {
	key = '%',
	mods = 'LEADER',
	action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
	key = '"',
	mods = 'LEADER',
	action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
}

return config
