local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.color_scheme = "ForestBlue"
config.font_size = 12

config.default_prog = { "/Users/cderwin/.local/bin/nu" }
config.set_environment_variables = {
    XDG_CONFIG_HOME = "/Users/cderwin/.config",
    XDG_DATA_DIR = "/Users/cderwin/.lcal/share",
}

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
    {
        key = 'm',
        mods = 'LEADER',
        action = wezterm.action.TogglePaneZoomState,
    },
    {
        key = '[',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = ']',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = 'p',
        mods = 'LEADER',
        action = wezterm.action.PaneSelect,
    },
    {
        key = 'r',
        mods = 'LEADER',
        action = wezterm.action.PaneSelect { mode = 'SwapWithActiveKeepFocus' },
    },
    {
        key = 'p',
        mods = 'LEADER',
        action = wezterm.action.PaneSelect { mode = 'MoveToNewTab' },
    },
}

return config
