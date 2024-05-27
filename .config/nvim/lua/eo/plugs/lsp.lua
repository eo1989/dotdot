local borrder, icons = eo.ui.current.border, eo.ui.icons
local highlight = eo.highlight
return {
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    event = { 'BufReadPre', 'BufNewFile', 'LspAttach' },
    dependencies = {
      -- 'mason.nvim',
      -- 'hrsh7th/cmp-nvim-lsp',
      {
        'williamboman/mason.nvim',
        lazy = false,
        build = ':MasonUpdate',
        cmd = 'Mason',
        opts = { ui = { border = borrder, height = 0.7 } },
      },
      -- {
      --   'SmiteshP/nvim-navic',
      --   event = 'LspAttach',
      --   opts = {},
      -- },
      {
        'j-hui/fidget.nvim',
        enabled = true,
        -- branch = 'Legacy',
        event = 'LspAttach',
        opts = {
          progress = {
            ignore_done_already = true, -- ignore new tasks that are already complete
            -- how many lsp messages to show at once
            display = { render_limit = 3 },
          },
        },
      },
      {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
          'folke/neodev.nvim',
          lazy = false,
          opts = {},
        },
        config = function()
          highlight.plugin('lspconfig', { { LspInfoBorder = { link = 'FloatBorder' } } })
          require('lspconfig.ui.windows').default_options.border = border
          -- require('lspconfig').pyright.setup(require('eo.servers')('pyright'))
        end,
      },
    },
    --@eo from skimask9/astronvim_config/blob/main/plugins/mason.lua
    -- maybe this is also why the wsl config is having an issue with inlay_hints??
    -- inlay_hints = { enabled = true },
    opts = {
      automatic_installation = true,
      handlers = {
        function(name)
          local config = require('eo.servers')(name)
          -- local config = require('eo.servers')
          if config then require('lspconfig')[name].setup(config) end
        end,
      },
    },
  },
  -- {
  --   'DNLHC/glance.nvim',
  --   event = 'LspAttach',
  --   opts = {
  --     preview_win_opts = { relativenumber = false },
  --     theme = { enable = true, mode = 'auto' },
  --   },
  --   keys = {
  --     { 'gD', '<Cmd>Glance definitions<CR>', desc = 'lsp: glance definitions' },
  --     { 'gR', '<Cmd>Glance references<CR>', desc = 'lsp: glance references' },
  --     { 'gY', '<Cmd>Glance type_definitions<CR>', desc = 'lsp: glance type definitions' },
  --   },
  -- },
  { 'onsails/lspkind.nvim', event = 'LspAttach' },
  { 'b0o/schemastore.nvim', event = 'LspAttach' },
  { 'mrjones2014/lua-gf.nvim', ft = 'lua' },
  -- {
  --   'kosayoda/nvim-lightbulb',
  --   enabled = false,
  --   event = 'VeryLazy',
  --   opts = {
  --     autocmd = { enabled = true },
  --     sign = { enabled = false },
  --     float = { text = icons.misc.lightbulb, enabled = true, win_opts = { border = 'none' } },
  --   },
  -- },
  {
    'utilyre/barbecue.nvim',
    enabled = true,
    event = 'LspAttach',
    dependencies = {
      'neovim/nvim-lspconfig',
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
}
