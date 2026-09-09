-- ~/.config/wezterm/wezterm.lua
--
-- Tracked in configurator as tools/wezterm/. Install by copying that directory
-- to ~/.config/wezterm/ (%USERPROFILE%\.config\wezterm\ on Windows, which
-- WezTerm honors there too). Runs on macOS, Ubuntu, and Windows + WSL.
--
-- Three jobs:
--
-- 1. On GUI startup, open a tab attached to herdr's default session. Bare
--    `herdr` is create-or-attach, so this works on a fresh boot (no server
--    running yet) and when relaunching WezTerm against an already-running
--    session. If herdr exits nonzero, the tab prints the exit status and drops
--    into an interactive shell instead of closing. Further sessions are opened
--    by hand with `herdr --session <name>`. On Windows the tab spawns inside
--    the first WSL distro, where herdr and zsh live.
--
-- 2. Label every WezTerm tab with its jump number (Cmd-N on macOS,
--    Ctrl+Shift+N elsewhere), and label herdr tabs with the herdr *session*
--    they are attached to:
--
--      [1] 🐑 default   [2] 🐑 dev   [3] zsh
--
--    The `[N]` styling matches the herdr-automatic-rename plugin
--    (https://github.com/qu8n/herdr-automatic-rename), which renames herdr's
--    *internal* tabs. This file only touches WezTerm's *outer* tab bar, so the
--    two are orthogonal. That logic lives in herdr_tabs.lua alongside this
--    file.
--
-- 3. Guard the copy key so it cannot wipe the clipboard when WezTerm's own
--    selection is empty (see the config.keys entry below).
--
-- Beyond herdr's scope, this file also updates WezTerm defaults:
--
--   1. `font`: powerlevel10k's font MesloLGS NF, so the full p10k icon set
--      renders at the correct (narrow) width instead of falling back to
--      double-width emoji. Install it on each host from
--      https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
--      (on Windows into Windows itself, not WSL, since the GUI renders
--      host-side). ccstatusline's powerline separators need the same font.

local wezterm = require 'wezterm'
local mux = wezterm.mux
local herdr_tabs = require 'herdr_tabs'

local is_mac = wezterm.target_triple:find 'apple%-darwin' ~= nil
local is_windows = wezterm.target_triple:find 'windows' ~= nil

-- Assumed on every platform and listed as a prerequisite rather than detected
-- here, because on Windows the host process cannot see WSL's $SHELL.
local SHELL = 'zsh'

local config = wezterm.config_builder()

-- Domain herdr tabs spawn into. nil means WezTerm's local domain. On Windows,
-- herdr runs inside WSL, so pick the first installed distro.
local herdr_domain = nil
if is_windows then
  local wsl = wezterm.default_wsl_domains()
  if #wsl > 0 then
    herdr_domain = wsl[1].name -- e.g. 'WSL:Ubuntu'
    config.default_domain = herdr_domain -- new tabs land in WSL too
  else
    wezterm.log_error 'herdr tabs: no WSL distribution found'
  end
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  return herdr_tabs.format(tab, max_width)
end)

-- Argv for a tab attached to herdr session `session`, or to herdr's unnamed
-- default session when nil.
--
-- -l: login shell so the profile is sourced, e.g. for /opt/homebrew/bin on
--     macOS (GUI-spawned processes do not get the brew PATH otherwise). On
--     Windows this argv runs inside the WSL distro, so zsh, herdr, and base64
--     are the distro's.
--
-- The OSC 1337 SetUserVar sequences label the tab: herdr_tabs.lua reads the
-- HERDR_SESSION pane user var as its first-priority tier. WezTerm cannot see
-- herdr in the foreground-process tiers here (herdr runs inside this shell
-- wrapper's process group, so the tty's foreground process is the wrapper),
-- but the wrapper writes to the WezTerm pty directly, so its escapes are not
-- swallowed the way they would be for a shell inside herdr. The var is
-- cleared on the error path so the fallback shell's tab reverts to stock.
local function herdr_tab_args(session)
  local label = session or herdr_tabs.default_session
  local herdr = session and ('herdr --session ' .. session) or 'herdr'
  local script = table.concat({
    'print -n "\\e]1337;SetUserVar=HERDR_SESSION=$(print -rn -- '
      .. label
      .. ' | base64)\\a"',
    herdr .. ' || { code=$?',
    'print -n "\\e]1337;SetUserVar=HERDR_SESSION=\\a"',
    'print "' .. herdr .. ' exited with status $code"',
    'exec ' .. SHELL .. ' -i; }',
  }, '; ')
  return { SHELL, '-lc', script }
end

-- SpawnCommand for a herdr tab, routed into the WSL domain on Windows.
local function herdr_spawn(session)
  local cmd = { args = herdr_tab_args(session) }
  if herdr_domain then
    cmd.domain = { DomainName = herdr_domain }
  end
  return cmd
end

wezterm.on('gui-startup', function(cmd)
  -- Honor explicit `wezterm start -- <prog>` invocations.
  if cmd then
    mux.spawn_window(cmd)
    return
  end
  if is_windows and not herdr_domain then
    mux.spawn_window {} -- Without WSL a plain window beats a tab that cannot run herdr
    return
  end
  mux.spawn_window(herdr_spawn(nil))
end)

-- Default overrides beyond herdr's scope (see header).
config.font = wezterm.font 'MesloLGS NF'

-- Guarded copy: copy only when WezTerm itself has a selection.
-- Because herdr enables mouse_capture, plain drag-highlights go to herdr
-- rather than WezTerm, and herdr's copy_on_select writes them to the system
-- clipboard itself; only shift+drag creates a WezTerm-level selection. So
-- after a plain drag-highlight, WezTerm's own selection is empty. By default
-- WezTerm binds the copy key to its CopyTo(Clipboard) key assignment, which
-- would overwrite the clipboard with that empty string, wiping what herdr
-- just copied. Ctrl+Shift+C is that binding on every platform; macOS adds
-- Cmd+C.
local guarded_copy = wezterm.action_callback(function(window, pane)
  local sel = window:get_selection_text_for_pane(pane)
  if sel and #sel > 0 then
    window:perform_action(wezterm.action.CopyTo 'Clipboard', pane)
  end
end)

config.keys = { { key = 'c', mods = 'CTRL|SHIFT', action = guarded_copy } }
if is_mac then
  table.insert(config.keys, { key = 'c', mods = 'CMD', action = guarded_copy })
end

return config
