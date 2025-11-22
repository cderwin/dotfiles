local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.color_scheme = "ForestBlue"
config.font_size = 12

local home = os.getenv("HOME")
config.default_prog = { string.format("%s/.cargo/bin/nu", home) }
config.set_environment_variables = {
    XDG_CONFIG_HOME = string.format("%s/.config", home),
    XDG_DATA_HOME = string.format("%s/.config", home),
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
