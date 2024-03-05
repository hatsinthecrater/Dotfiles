local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

-- Settings
config.color_scheme = 'ChallengerDeep'
config.window_padding = {
  left = 30,
  right = 30,
  top = 20,
  bottom = 10,
}
-- config.window_background_image = '/Desktop/Images/pyramids.jpg'
config.font_size = 12
config.font = wezterm.font('JetBrainsMono Nerd Font', {weight = 'Bold', italic = false})
config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = true
config.window_background_opacity = 0.9
config.scrollback_lines = 0
config.default_workspace = 'home'
config.macos_window_background_blur = 30
--config.native_macos_fullscreen_mode

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5
}

-- Ctrl-click will open the link under the mouse cursor
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
wezterm.on("update-right-status", function (window, pane)
 -- Workspace Name
  local stat = window:active_workspace()

  if window:active_key_table() then stat = window:active_key_table() end
  if window:leader_is_active() then stat = "LDR" end

  -- Current working directory
  local basename = function(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end
  local cwd = basename(pane:get_current_working_dir())
  -- Current command
  local cmd = basename(pane:get_foreground_process_name())
  -- Time
  local time = wezterm.strftime("%H:%M")

  window:set_right_status(wezterm.format({
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " | " },
    { Foreground = { Color = "FFB86C" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = " | " },
  }))
end)

-- Keys
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- Split Pane 
  { key = '|', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- Navigate Panes
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection("Left") },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection("Down") },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection("Up") },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection("Right") },

  -- Close Current Pane
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },

  -- Tab Keybindings
  { key = 'n', mods = 'LEADER', action = act.SpawnTab("CurrentPaneDomain") },
  { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 't', mods = 'LEADER', action = act.ShowTabNavigator },

}

return config
