-- ~/.config/wezterm/herdr_tabs.lua
--
-- Resolves the herdr session name for a WezTerm tab and formats its title.
-- Loaded by wezterm.lua; kept as a separate module so the argv parser can be
-- exercised directly (see the test harness note at the bottom).
--
-- Why process argv and not $HERDR_SESSION: herdr exports HERDR_SESSION into the
-- shells running inside its panes, but those shells are children of the herdr
-- client rather than of the WezTerm pane, so WezTerm cannot see that env. OSC
-- sequences from inside herdr are consumed by herdr rather than forwarded. The
-- herdr client's own command line is the one thing WezTerm can read directly.

local wezterm = require 'wezterm'
local mux = wezterm.mux

local M = {
  -- basename of the herdr client executable
  exe = 'herdr',

  -- marker shown between the [N] prefix and the session name
  icon = '🐑',

  -- name to show for the unnamed session that bare `herdr` attaches; this is
  -- herdr's own name for it, as printed by `herdr session list`
  default_session = 'default',

  -- when true, `herdr --remote box --session dev` renders as 'box:dev'
  show_remote_host = false,

  -- seconds to trust a previously resolved session name for a given pane
  cache_ttl = 2,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function basename(path)
  if type(path) ~= 'string' or path == '' then
    return nil
  end
  return path:match '([^/\\]+)$' or path
end

-- Match on the resolved executable path, not argv[1]: herdr clients report a
-- bare 'herdr' in argv[1] while `herdr server` reports the full path.
local function is_herdr(path)
  return basename(path) == M.exe
end

-- 'user@host:2222' -> 'host'
local function ssh_host(target)
  if type(target) ~= 'string' or target == '' then
    return nil
  end
  local host = target:match '@([^@]+)$' or target
  return host:match '^([^:]+)' or host
end

--------------------------------------------------------------------------------
-- argv -> session name
--------------------------------------------------------------------------------

-- Flags that consume the following argument. These MUST be skipped, otherwise
-- `herdr --remote-keybindings local` looks like the positional subcommand
-- 'local'. `false` means "takes a value we do not care about".
local VALUE_FLAGS = {
  ['--session'] = 'session',
  ['--remote'] = 'remote',
  ['--remote-keybindings'] = false,
}

-- Returns one of three states, and the distinction matters downstream:
--   string : the herdr session this process is attached to
--   false  : it is herdr, but not an attached session client
--            (`--no-session`, `herdr status`, `herdr session list`, `herdr server`)
--   nil    : undeterminable (empty argv, a race with exec, not herdr at all)
function M.parse_argv(argv, executable)
  if type(argv) ~= 'table' or #argv == 0 then
    return nil
  end
  if not is_herdr(executable or argv[1]) then
    return nil
  end

  local session, remote, no_session = nil, nil, false
  local positional = {}

  local i = 2
  while i <= #argv do
    local a = argv[i]
    if type(a) ~= 'string' then
      -- defensive: ignore anything that is not a string
    elseif a == '--' then
      break
    elseif a == '--no-session' then
      no_session = true
    elseif VALUE_FLAGS[a] ~= nil then
      local slot = VALUE_FLAGS[a]
      if slot == 'session' then
        session = argv[i + 1]
      elseif slot == 'remote' then
        remote = argv[i + 1]
      end
      i = i + 1 -- consume the flag's value
    elseif a:match '^%-%-session=' then
      session = a:match '^%-%-session=(.*)$'
    elseif a:match '^%-%-remote=' then
      remote = a:match '^%-%-remote=(.*)$'
    elseif a:sub(1, 1) == '-' then
      -- valueless flag we do not care about: --handoff, --version, --help, ...
    else
      positional[#positional + 1] = a
    end
    i = i + 1
  end

  if no_session then
    return false
  end

  local name
  if #positional == 0 then
    -- bare `herdr`, `herdr --session NAME`, `herdr --remote T [--session NAME]`
    name = session or M.default_session
  elseif positional[1] == 'session' and positional[2] == 'attach' then
    -- `herdr session attach NAME`
    name = positional[3] or session or M.default_session
  else
    -- any other subcommand is not an attached session client
    return false
  end

  if type(name) ~= 'string' or name == '' then
    return nil
  end

  if remote and M.show_remote_host then
    local host = ssh_host(remote)
    if host then
      name = host .. ':' .. name
    end
  end

  return name
end

--------------------------------------------------------------------------------
-- Per-pane resolution, cheapest tier first
--------------------------------------------------------------------------------

-- [pane_id] = { at = <os.time()>, value = string | false | nil }
-- Reset on config reload, which is what we want.
local cache = {}

local function session_for_pane(p)
  -- (1) Free: user vars are already part of the PaneInformation snapshot. Set by
  -- the zsh wrapper in wezterm.lua, and the only tier that works when herdr is
  -- on the far side of a boundary WezTerm cannot see through: an ssh, or a WSL
  -- distro on Windows (where tiers 2 and 3 see wsl.exe rather than herdr).
  local uv = p.user_vars
  if type(uv) == 'table' then
    local s = uv.HERDR_SESSION
    if type(s) == 'string' and s ~= '' then
      return s
    end
  end

  -- (2) Cheap gate: WezTerm caches foreground_process_name, so non-herdr panes
  -- cost one string compare per tab-bar repaint and stop here.
  local pane_id = p.pane_id
  if not is_herdr(p.foreground_process_name) then
    -- herdr exited, was suspended, or this is a remote/mux pane (where
    -- foreground_process_name is ""). Drop any stale entry so a later attach to
    -- a *different* session re-resolves cleanly, without comparing pids.
    if pane_id ~= nil then
      cache[pane_id] = nil
    end
    return nil
  end
  if pane_id == nil then
    return nil
  end

  local now = os.time()
  local hit = cache[pane_id]
  if hit and (now - hit.at) < M.cache_ttl then
    return hit.value
  end

  -- (3) Expensive: walk to the mux pane and read the foreground process argv.
  local value
  local pane = mux.get_pane(pane_id)
  if pane then
    local info = pane:get_foreground_process_info()
    if info then
      value = M.parse_argv(info.argv, info.executable)
    end
  end

  -- nil means "undeterminable" rather than "not a session", so prefer the last
  -- known good answer over blanking the tab.
  if value == nil and hit then
    value = hit.value
  end

  cache[pane_id] = { at = now, value = value }
  return value
end

function M.session_for_tab(tab)
  local active = tab.active_pane
  if active then
    local s = session_for_pane(active)
    if s ~= nil then
      return s
    end
  end

  -- If the tab is split and herdr is not the active pane, still try to find it.
  -- tab.panes is not confirmed present in every WezTerm version; the type guard
  -- makes this a no-op rather than an error if it is missing.
  if type(tab.panes) == 'table' then
    for _, p in ipairs(tab.panes) do
      if not active or p.pane_id ~= active.pane_id then
        local s = session_for_pane(p)
        if s ~= nil then
          return s
        end
      end
    end
  end

  return nil
end

--------------------------------------------------------------------------------
-- Rendering
--------------------------------------------------------------------------------

-- WezTerm's own fallback order, so `wezterm cli set-tab-title` still wins.
local function stock_title(tab)
  if type(tab.tab_title) == 'string' and tab.tab_title ~= '' then
    return tab.tab_title
  end
  local active = tab.active_pane
  if active and type(active.title) == 'string' and active.title ~= '' then
    return active.title
  end
  return ''
end

-- '[2] 🐑 dev' for a herdr tab, '[4] zsh' otherwise.
function M.format(tab, max_width)
  local prefix = '[' .. tostring(tab.tab_index + 1) .. '] '

  local body
  if type(tab.tab_title) == 'string' and tab.tab_title ~= '' then
    -- An explicitly set tab title always wins over the herdr session name.
    body = tab.tab_title
  else
    -- Never let a tab-bar repaint throw.
    local ok, session = pcall(M.session_for_tab, tab)
    if not ok then
      wezterm.log_error('herdr tab title: ' .. tostring(session))
      session = nil
    end
    -- A string is a session name. `false` means herdr-but-not-a-session, and
    -- nil means not herdr; both fall back to the stock title.
    if type(session) == 'string' and session ~= '' then
      body = M.icon .. ' ' .. session
    else
      body = stock_title(tab)
    end
  end

  local title = prefix .. body
  if type(max_width) == 'number' and max_width > 0 then
    title = wezterm.truncate_right(title, max_width)
  end
  return title
end

-- Exercise the argv parser without launching a GUI, e.g. (or dofile the
-- tools/wezterm/herdr_tabs.lua copy in the configurator repo):
--   wezterm --config 'font_size=(function()
--     local m = dofile(os.getenv("HOME") .. "/.config/wezterm/herdr_tabs.lua")
--     return tostring(m.parse_argv({"herdr","session","attach","dev"}, "/opt/homebrew/bin/herdr"))
--   end)()' show-keys
-- The deliberate type error prints the value in wezterm's stderr.

return M
