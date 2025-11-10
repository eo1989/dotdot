vim.loader.enable()
local cmd, env, fn, fs, g, opt, uv = vim.cmd, vim.env, vim.fn, vim.fs, vim.g, vim.opt, vim.uv

g.python3_host_prog = fn.expand('~/.pyenv/versions/gen/bin/python')

g.mapleader = ' '
g.maplocalleader = ','

-- solves the issue of missing luarocks when running neovim
-- env.DYLD_LIBRARY_PATH = fn.expand('$BREW_PREFIX/lib')

function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local namespace = {
  ui = {
    winbar = { enable = false },
    statuscolumn = { enable = true },
    statusline = { enable = true },
  },
  -- apparently some mappings require a mix of cmd line & function calls
  -- this table is a place to store lua functions to be called in those mappings
  mappings = { enable = true },

  --[[ everything below is thanks to
  --  https://github.com/dhruvmanila/dotfiles/blob/master/config/nvim/init.lua && dsully
  --]]

  -- inlay_hint = { enable = false },
  -- code_action_lightbulb = { enable = false },
  KITTY_SCROLLBACK = env.KITTY_SCROLLBACK ~= nil,

  -- System name
  ---@type 'Darwin'|'Windows_NT'|'Linux'
  OS_UNAME = vim.uv.os_uname().sysname,

  -- Path to the home directory
  ---@type string
  OS_HOMEDIR = assert(uv.os_homedir()),

  -- Path to current working
  ---@type string
  CWD = assert(uv.cwd()),
}

--- NOTE: this table is a globally accessible store to facilitate accessing
--- helper functions and variables throughout the configuration.
_G.eo = eo or namespace
_G.map = vim.keymap.set
_G.P = vim.print

g.os = vim.uv.os_uname().sysname

-- g.open_cmd = g.os == 'Darwin' and 'open' or 'xdg-open'
-- stylua: ignore start
eo.OPEN_CMD = (eo.OS_UNAME == 'Darwin' and 'open')
    or (eo.OS_UNAME == 'Windows_NT' and 'start')
    or 'xdg-open'
-- stylua: ignore end

g.nvim_dir = fn.expand('~/.config/nvim')
env.NVIM_CONFIG = g.nvim_dir
-- g.nvim_dir = fn.expand('~/.config/nvim/')
-- g.vim_dir = g.dotfiles or fn.expand('~/.dotfiles')

require('eo.globals')
require('eo.highlights')
require('eo.ui')
require('eo.options')

g.border = not vim.g.vscode and eo.ui.current.border or 'rounded'
-- g.large_file = true
-- g.large_file_size = 1024 * 512

-- do
local data = fn.stdpath('data')
local lazy_path = fs.joinpath(fn.stdpath('data'), 'lazy', 'lazy.nvim')
-- local lazypath = data .. '/lazy/lazy.nvim'
if not uv.fs_stat(lazy_path) then
  -- vim.notify('Installing the Lazy plugin manager, .. ...')
  -- stylua: ignore
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazy_path,
  })
  vim.notify('Installed lazy.nvim')
end

opt.runtimepath:prepend(lazy_path)
--end

-- add luarocks to rtp
-- TODO: Add before or after sourcing all config files? before lsp? before lazy?
local home = uv.os_homedir()
package.path = package.path .. ';' .. home .. '/.luarocks.share/lua/5.1/?/init.lua;'
package.path = package.path .. ';' .. home .. '/.luarocks.share/lua/5.1/?.lua;'

-- local specs = {
--   { import = 'eo.plugs' },
-- }
-- local lazy = require('lazy')
require('lazy').setup {
  spec = {
    { import = 'eo.plugs' },
    -- { import = 'eo.lsp' },
    -- { import = 'eo.ts_node_action' },
    { import = 'eo.langs' },
  },
  ui = {
    border = 'rounded',
    wrap = true,
  },
  defaults = {
    lazy = false,
    version = '*',
    -- version = false,
    cond = not eo.KITTY_SCROLLBACK, -- disable lazy loading for kitty scrollback
  },
  install = {
    missing = true,
    colorscheme = { 'catppuccin-macchiato', 'tokyonight-storm', 'lunaperche', 'slate' },
  },
  change_detection = {
    notify = false,
  },
  checker = {
    enabled = true,
    frequency = 24 * 60 * 60, -- 24h
    notify = true,
  },
  diff = { cmd = 'diffview.nvim' }, -- terminal git, diffview or browser
  git = {
    throttle = {
      enabled = true,
      rate = 10,
      duration = 150,
    },
    log = { '--since=3 days ago' },
  },
  pkg = {
    enabled = true,
    sources = {
      'lazy',
      'packspec',
      'rockspec',
    },
  },
  rocks = {
    enabled = true,
    hererocks = true,
  },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        -- 'matchit', -- see if matchup will run correctly now
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  readme = {
    root = fn.stdpath('state') .. '/lazy/readme',
    files = { 'README.md', 'lua/**/README.md' },
    -- only generate markdown helptags for plugins that dont have docs
    skip_if_doc_exists = true,
  },
  state = fn.stdpath('state') .. '/lazy/state.json',
}

-- if env.NVIM_CONFIG then return require('lazy').setup { { 'willothy/flatten.nvim', opts = {} } } end

if eo.KITTY_SCROLLBACK then
  require('eo.kitty.scrollback')
  return
end

-- cmd.colorscheme('tokyonight-storm')
cmd.colorscheme('catppuccin-macchiato')

-- require('eo.lsp')

map('n', '<leader>pm', '<cmd>Lazy<cr>', { desc = 'Lazy manage' })

--NOTE: Next time copy down the link you found this at. 😐
map('n', '<leader>U', function()
  return {
    pcall(require('lazy').sync), -- update lazy
    -- pcall(require('nvim-treesitter.install').install { with_sync = true }),

    require('nvim-treesitter.install').update(),
  } -- update ts parsers
end, { desc = 'update plugins & TS parsers', silent = true })

-- doesnt work after nvim-treesitter branch='main' anymore.
-- vim.api.nvim_create_user_command(
--   'TSR',
--   function()
--     vim.cmd([[
--     write
--     edit
--     TSBufEnable highlight
--     ]])
--   end,
--   {}
-- )

-- function SourcePluginFiles()
--   local plugin_path = fn.stdpath('config') .. '/plugin'
--   -- local scandir = uv.fs_scandir(fn.stdpath('config') .. '/plugin')
--   local scandir = uv.fs_scandir(plugin_path)
--   if not scandir then
--     vim.notify_once('Error: Couldnt open plugin directory..?', vim.log.levels.WARN)
--     return
--   end
--   while true do
--     local name, type = uv.fs_scandir_next(scandir)
--     if not name then break end
--     if type == 'file' and name:match('%.lua$') then cmd('luafile ' .. plugin_path .. '/' .. name) end
--   end
--   print('Sourced all the lua files in: ' .. plugin_path)
-- end
