return {
  -- {
  --   'folke/styler.nvim',
  --   enabled = false,
  --   event = 'VeryLazy',
  --   config = function()
  --     require('styler').setup {
  --       themes = {
  --         markdown = { colorscheme = 'tokyonight' },
  --         help = { colorscheme = 'tokyonight' },
  --       },
  --     }
  --   end,
  -- },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1003,
    opts = {
      style = 'storm',
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
        sidebars = 'transparent',
        floats = 'transparent',
      },
      sidebars = { 'qf', 'help', 'fzf_lua', 'overseer', 'terminal' },
    },
    config = function(_, opts)
      local tokyonight = require('tokyonight')
      tokyonight.setup(opts)
      tokyonight.load()
    end,
  },
  {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    opts = {
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'underline' },
            warnings = { 'undercurl' },
            information = { 'underline' },
          },
        },
        navic = { enabled = true, custom_bg = 'lualine' },
        neotest = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
  { 'rebelot/kanagawa.nvim', lazy = false, name = 'kanagawa' },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    config = function() require('gruvbox').setup() end,
  },
}
