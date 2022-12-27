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
vim.g.python3_host_prog = '~/.local/pipx/venvs/jupyterlab/bin/python3'
vim.g.node_host_prog = "~/.config/yarn/global/node_modules/neovim/bin"
vim.g.loaded_perl_provider = 0 -- disable perl support
vim.g.loaded_ruby_provider = 0 -- disable ruby support
vim.g.loaded_python_provider = 0 -- disable py2 support



-- vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

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

-- vim.cmd [[
--   silent! exe 'set background='.$NVIM_COLORSCHEME_BG
--   silent! exe 'colorscheme '.$NVIM_COLORSCHEME
-- ]]

------------------------------------------------------------------------
-- Plugin Configurations
------------------------------------------------------------------------
R('as.globals')
R('as.styles')
R('as.settings')
R('as.highlights')
R('as.plugins')

vim.cmd([[
  filetype on
  filetype plugin on
  filetype indent on
  syntax on
]])
