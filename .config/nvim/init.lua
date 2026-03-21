local cmd, env, fn, fs, g, opt = vim.cmd, vim.env, vim.fn, vim.fs, vim.g, vim.opt
vim.loader.enable()

---@type boolean
g.noice = false
-- vim.g.noice = true

local namespace = {
  ui = {
    winbar = { enable = false },
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
-- end

-- add luarocks to rtp
-- TODO: Add before or after sourcing all config files? before lsp? before lazy?
local home = vim.uv.os_homedir()

package.path = package.path .. ';' .. home .. '/.luarocks.share/lua/5.1/?/init.lua;'
package.path = package.path .. ';' .. home .. '/.luarocks.share/lua/5.1/?.lua;'

require('lazy').setup {
  spec = {
    { import = 'eo.plugins' },
    { import = 'eo.plugins.languages' },
  },
  ui = {
    -- border = eo.ui.current.border or 'rounded',
    border = vim.o.winborder or eo.ui.current.border,
    wrap = true,
    title_pos = 'center',
    pills = false,
    backdrop = 60,
    size = {
      width = 0.85,
      height = 0.85,
    },
    custom_keys = {
      ['gi'] = {
        function(plugin)
          local repo = plugin.url:gsub('%.git$', '')
          local line = api.nvim_get_current_line()
          local issue = line:match('#(%d+)')
          local commit = line:match(('%x'):rep(6) .. '+') -- `%x` = hex/hash char
          if not issue and not commit then return end
          local url = repo .. (issue and '/issues/' .. issue or '/commit/' .. commit)
          vim.ui.open(url)
        end,
        desc = '  Open issue/commit',
      },
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
  -- diff = { cmd = 'diffview.nvim' }, -- terminal git, diffview or browser
  diff = { cmd = 'terminal_git' }, -- views diffs with delta (cursor must be on the hash, tho)
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
  rocks = { hererocks = nil },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      -- reset = true,
      disabled_plugins = {
        'tohtml',
        'tutor',
        -- '2html_plugin',
        -- 'getscript',
        -- 'getscriptPlugin',
        'gzip',
        'health',
        -- 'logipat',
        -- 'man',
        -- 'matchit',
        -- 'matchparen',
        -- 'netrw',
        -- 'netrwFileHandlers',
        'netrwPlugin',
        -- 'netrwSettings',
        -- 'rrhelper',
        -- 'spellfile',
        -- 'tar',
        'tarPlugin',
        -- 'vimball',
        -- 'vimballPlugin',
        'zip',
        -- 'zipPlugin',
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

vim.deprecate = function() end

if env.NVIM_CONFIG then return require('lazy').setup { { 'willothy/flatten.nvim', opts = {} } } end

-- if eo.KITTY_SCROLLBACK then
--   require('eo.kitty.scrollback')
--   return
-- end

vim.cmd.colorscheme('catppuccin-macchiato')

-- vim.notify = require('notify')

-- require('vim._core.ui2').enable { msg = { pos = 'box' } }

if vim.g.noice == false then require('vim._core.ui2').enable { msg = { pos = 'box' } } end
-- if vim.g.noice == false then require('vim._extui').enable {} end
