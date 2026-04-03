local cmd, env, fn, fs, g, opt = vim.cmd, vim.env, vim.fn, vim.fs, vim.g, vim.opt
vim.loader.enable()

---@type boolean
g.noice = nil
-- vim.g.noice = true

local namespace = {
  ui = {
    winbar = { enable = true },
    statuscolumn = { enable = true },
    statusline = { enable = false },
  },
  -- apparently some mappings require a mix of cmd line & function calls
  -- this table is a place to store lua functions to be called in those mappings
  mappings = { enable = true },

  --[[ everything below is thanks to
  --   https://github.com/dhruvmanila/dotfiles/blob/master/config/nvim/init.lua
  --   && dsully
  --]]

  -- inlay_hint = { enable = true },

  lightbulb = { enable = true },

  KITTY_SCROLLBACK = env.KITTY_SCROLLBACK ~= nil,

  -- System name
  ---@type 'Darwin'|'Windows_NT'|'Linux'
  OS_UNAME = vim.uv.os_uname().sysname,

  -- Path to the home directory
  ---@type string
  OS_HOMEDIR = assert(vim.uv.os_homedir()),

  -- Path to current working
  ---@type string
  CWD = assert(vim.uv.cwd()),
}

--- NOTE: this table is a globally accessible store to facilitate accessing
--- helper functions and variables throughout the configuration.
_G.eo = eo or namespace
_G.map = vim.keymap.set
_G.P = vim.print

require('eo.globals')
require('eo.highlights')
require('eo.ui')
require('eo.options')

-- _G.ev = require('lib.event')

-- g.open_cmd = g.os == 'Darwin' and 'open' or 'xdg-open'

-- stylua: ignore start
g.open_command = (eo.OS_UNAME == "Darwin" and "open")
    or (eo.OS_UNAME == 'Windows_NT' and 'start')
    or 'xdg-open'
-- stylua: ignore end

-- g.large_file = true
-- g.large_file_size = 1024 * 512

---@diagnostic disable-next-line: param-type-mismatch 'data' always return a `string`
local lazy_path = fs.joinpath(fn.stdpath('data'), 'lazy', 'lazy.nvim')
-- local lazypath = data .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazy_path) then
  fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazy_path,
  }
  vim.notify('Installed lazy.nvim')
end

opt.runtimepath:prepend(lazy_path)

local home = vim.uv.os_homedir()

package.path = package.path .. ';' .. home .. '/.luarocks.share/lua/5.1/?/init.lua;'
package.path = package.path .. ';' .. home .. '/.luarocks.share/lua/5.1/?.lua;'

require('lazy').setup {
  spec = {
    { import = 'eo.plugins' },
    { import = 'eo.plugins.languages' },
  },
  ui = {
    border = eo.ui.current.border or 'rounded',
    -- border = eo.ui.current.border,
    wrap = true,
    title_pos = 'center',
    pills = false,
    backdrop = 60,
    size = {
      width = 0.85,
      height = 0.85,
    },
  },
  defaults = {
    lazy = false,
    version = false,
    -- cond = not eo.KITTY_SCROLLBACK, -- disable lazy loading for kitty scrollback
  },
  install = {
    missing = true,
    colorscheme = { 'catppuccin', 'tokyonight-storm' },
  },
  change_detection = { notify = false },
  checker = {
    enabled = true,
    frequency = 24 * 60 * 60, -- 24h
    notify = true,
  },
  diff = { cmd = 'terminal_git' }, -- views diffs with delta (cursor must be on the hash, tho)
  git = {
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
    hererocks = nil,
  },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        'tohtml',
        'tutor',
        'gzip',
        'health',
        'netrwPlugin',
        'tarPlugin',
        'zip',
      },
    },
  },
}

-- if env.NVIM_CONFIG then return require('lazy').setup { { 'willothy/flatten.nvim', opts = {} } } end

vim.cmd.colorscheme('catppuccin-macchiato')

-- if vim.g.noice == false then require('vim._core.ui2').enable {} end

-- if vim.g.noice == false then require('vim._core.ui2').enable { msg = { pos = 'box' } } end
-- if vim.g.noice == false then require('vim._extui').enable {} end

-- '2html_plugin',
-- 'getscript',
-- 'getscriptPlugin',
-- 'logipat',
-- 'man',
-- 'matchit',
-- 'matchparen',
-- 'netrw',
-- 'netrwFileHandlers',
-- 'netrwSettings',
-- 'rrhelper',
-- 'spellfile',
-- 'tar',
-- 'vimball',
-- 'vimballPlugin',
-- 'zipPlugin',
