--------------------------------------------------------------------------------
--   ~~Akin Sowemimo's~~ eo dotfiles tailored for myself need to give credit to everyone ive taken bits of code from!
--           (https://github.com/akinsho)
---------------------------------------------------------------------------------

vim.g.os = vim.loop.os_uname().sysname
vim.g.open_command = vim.g.os == 'Darwin' and 'open' or 'xdg-open'
vim.g.dotfiles = vim.env.DOTFILES or vim.fn.expand('~/.dotfiles')
-- vim.g.vim_dir = vim.g.dotfiles .. '.config/nvim'
vim.g.vim_dir = '/Users/eo/.config/nvim'

-- Stop loading built in plugins
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.logipat = 1

-- vim.g.python3_host_prog = os.getenv('HOME') .. '/.local/pipx/venvs/jupyterlab/bin/python3'
vim.g.python3_host_prog = vim.fs.normalize('~/.local/pipx/venvs/jupyterlab/bin/python')
vim.g.node_host_prog = '/usr/local/bin/neovim-node-host'
vim.g.ruby_host_prog = 'usr/local/lib/ruby/gems/3.1.0/bin/neovim-ruby-host'
vim.g.loaded_perl_provider = 0 -- disable perl support
vim.g.loaded_python_provider = 0 -- disable py2 support

-- Ensure all autocommands are cleared
vim.api.nvim_create_augroup('vimrc', {})

------------------------------------------------------------------------
-- Leader bindings
------------------------------------------------------------------------
vim.g.mapleader = ' ' -- Remap leader key
vim.g.maplocalleader = ',' -- Local leader is <Space>

local ok, reload = pcall(require, 'plenary.reload')
RELOAD = ok and reload.reload_module or function(...)
  return ...
end

function R(name)
  RELOAD(name)
  return require(name)
end

-- global namespace
local namespace = {
  ui = {
    winbar = { enable = true },
    foldtext = { enable = false },
  },
  mappings = {},
}

_G.as = as or namespace

------------------------------------------------------------------------
-- Plugin Configurations
------------------------------------------------------------------------
R('as.globals')
R('as.styles')
R('as.settings')
R('as.plugins')
R('as.highlights')


vim.api.nvim_create_user_command('TSReload', function()
  vim.cmd([[
  write
  edit
  TSBufToggle highlight
  TSBufToggle rainbow
  TSBufToggle endwise
  TSBufToggle iswap
  TSBufToggle matchup
  TSBufToggle indent
  ]])
end,
  {})

-- vim.cmd([[
--   filetype on
--   filetype plugin on
--   filetype indent on
--   syntax on
-- ]])
-- vim: ft=lua fdm=marker ts=2 sts=2 sw=2 nospell
