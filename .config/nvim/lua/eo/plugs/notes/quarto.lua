return {
  'quarto-dev/quarto-nvim',
  ft = { 'quarto', 'markdown', 'norg' },
  dependencies = {
    {
      'jmbuhr/otter.nvim',
      -- dependencies = 'neovim/nvim-lspconfog',
      opts = {
        lsp = {
          hover = {
            border = eo.ui.current.border,
          },
        },
        bufers = {
          --[[
          -- if set to true, the filetype of the otterbuffers will be set.
          -- otherwise only the autocommand of lspconfig that attaches
          -- the language server will be executed w/o setting the filetype.
          --]]
          set_filetype = true,
        },
      },
    },
    'hrsh7th/nvim-cmp',
    -- 'neovim/nvim-lspconfig',
    -- 'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    closePreviewOnExit = true,
    lspFeatures = {
      enabled = true,
      languages = { 'r', 'julia', 'python', 'bash', 'dot' },
      chunks = 'curly',
      completion = { enabled = true },
      diagnostics = {
        enabled = true,
        triggers = { 'BufWritePost' },
      },
    },
    keymaps = {
      hover = 'H',
      definition = 'gd',
      rename = '<leader>rn',
      references = 'gr',
      format = '<leader>rf',
    },
    codeRunner = {
      enabled = true,
      ft_runners = { bash = 'slime' },
      default_method = 'molten',
      never_run = { "yaml", "lua" },
    },
  },
  config = function(_, opts)
    local opps = vim.{ noremap = true, silent = true }
    local map = vim.keymap.set
    local quarto = require('quarto')
    quarto.setup(opts)

    map("n", "<localleader>qp", quarto.quartoPreview, {desc = 'Preview the Quarto Doc', opps })


  end
}
