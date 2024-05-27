return {
  {
    'linux-cultist/venv-selector.nvim',
    ft = { 'python', 'ipynb' },
    event = 'VeryLazy',
    priority = 1001,
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap-python',
    },
    opts = { auto_refresh = false },
    config = function(_, opts)
      map('n', '<localleader>vs', '<cmd>VenvSelect<cr>', { buffer = 0, desc = 'Select Virtualenv' })
      require('venv-selector').setup(opts)
    end,
    -- keys = { { '<localleader>vs', '<cmd>VenvSelect<cr>', desc = 'Select Virtualenv' } },
  },
}
