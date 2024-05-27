local cmd, env, fn, g, opt, uv = vim.cmd, vim.env, vim.fn, vim.g, vim.opt, vim.uv

function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

-- g.python3_host_prog = fn.expand('~') .. '/.pyenv/versions/nvim/bin/python3'
local my_py_host = os.getenv('HOME') .. '/.pyenv/versions/nvim/bin/python3'
-- g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/versions/nvim/bin/python3'
g.python3_host_prog = my_py_host

-- solves the issue of missing luarocks when running neovim
env.DYLD_LIBRARY_PATH = '$BREW_PREFIX/lib'

-- add luarocks to rtp
-- TODO: Add before or after sourcing all config files? before lsp? before lazy?
local home = uv.os_homedir()
package.path = package.path .. ';' .. home .. '/.luarocks.share/lua/5.1/?/init.lua;'
package.path = package.path .. ';' .. home .. '/.luarocks.share/lua/5.1/?.lua;'

vim.loader.enable()

g.os = uv.os_uname().sysname
g.open_cmd = g.os == 'Darwin' and 'open' or 'xdg-open'
g.nvim_dir = fn.expand('~/.config/nvim/')
-- g.vim_dir = g.dotfiles or fn.expand('~/.dotfiles')

g.mapleader = ' '
g.maplocalleader = ','

local namespace = {
  ui = {
    winbar = { enable = false },
    statuscolumn = { enable = true },
    statusline = { enable = true },
  },
  -- apparently some mappings require a mix of cmd line & function calls
  -- this table is a place to store lua functions to be called in those mappings
  mappings = { enable = true },
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

-- g.defaults = {
--   lazyfile = { { 'BufReadPost', 'BufNewFile', 'BufWritePre' } },
-- }

g.large_file = false
g.large_file_size = 1024 * 512

local data = fn.stdpath('data')
local lazypath = data .. '/lazy/lazy.nvim'

local borrder = eo.ui.current.border

if not uv.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  vim.notify('Installed Lazy.vim')
end
opt.runtimepath:prepend(lazypath)

if env.NVIM then return require('lazy').setup { { 'willothy/flatten.nvim', config = true } } end

require('lazy').setup {
  spec = { import = 'eo.plugs' },
  defaults = { lazy = true, version = false },
  install = {
    colorscheme = { 'catppuccin-mocha', 'tokyonight-storm', 'kanagawa-dragon', 'vscode' },
    missing = true,
  },
  -- dev = { patterns = jit.os:find('Windows') and {} or { vim.fn.expand('~') .. '/.config/luatools' } },
  ui = { border = borrder },
  change_detection = {
    enabled = true,
    notify = false,
  },
  checker = {
    enabled = true,
    concurrency = 8,
    frequency = 24 * 60 * 60, -- 24h
    notify = false,
  },
  performance = {
    cache = { enabled = true },
    rtp = {
      -- paths = { data .. '/site' },
      disabled_plugins = {
        '2html_plugin',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'health',
        'man',
        'spellfile',
        'spellfilePlugin',
        'logipat',
        'rplugin',
        'rrhelper',
        -- 'matchit',
        -- 'matchparen',
        'netrw',
        'netrwFileHandlers',
        'netrwSettings',
        'netrwPlugin',
        'tohtml',
        'tutor',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
}

-- vim.keymap.set('n', '<leader>pm', '<cmd>Lazy<cr>', { desc = 'Manage plugins' })
-- stylua: ignore start
vim.keymap.set('n', '<leader>pi', require('lazy').show,    { desc = '  Plugin Info'     })
vim.keymap.set('n', '<leader>pp', require('lazy').profile, { desc = '  Profile Plugins' })
vim.keymap.set('n', '<leader>ps', require('lazy').sync,    { desc = '  Sync Plugins'    })
-- stylua: ignore end

if env.SSH_CONNECTION then
  g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.clipboard.osc52').copy,
      ['*'] = require('vim.clipboard.osc52').copy,
    },
    paste = {
      ['+'] = require('vim.clipboard.osc52').paste,
      ['*'] = require('vim.clipboard.osc52').paste,
    },
  }
elseif g.os == 'Darwin' then
  g.clipboard = {
    name = 'pbcopy',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = false,
  }
end

cmd.packadd('cfilter')
-- Generate helptags after startup
-- vim.defer_fn(function()
--   if not vim.bo.filetype:match('^git') then cmd.helptags { args = { 'ALL' } } end
-- end, 1000)

-- builtin ftplugins shouldnt change keybindings -- stevearc dots
-- vim.g.no_plugin_maps = true
-- vim.cmd.filetype { args = { 'plugin', 'on' } }
-- vim.cmd.filetype { args = { 'plugin', 'indent', 'on' } }

vim.api.nvim_create_user_command(
  'TSR',
  function()
    vim.cmd([[
    write
    edit
    TSBufEnable highlight
    ]])
  end,
  {}
)
