return {
  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'goerz/julia-vim',
    -- ft = 'julia',
    branch = 'tweaks',
    config = function()
      -- vim.g.latex_to_unicode_file_types = { 'julia', 'python', 'markdown', 'pandoc', 'human' }
      vim.g.latex_to_unicode_tab = 'off' --|> blink-cmp-latex
    end,
  },
  {
    --[[ NOTE:  04/05/2025 -> currently errors with blink for some reason. ]]
    'lkhphuc/jupyter-kernel.nvim',
    enabled = false,
    build = ':UpdateRemotePlugins',
    -- cmd = 'JupyterAttach',
    -- init = function()
    -- end,
    ft = { 'python', 'julia', 'r', 'markdown', 'quarto' },
    config = function()
      require('jupyter_kernel').setup {
        timeout = 0.5,
      }
      map('n', '<localleader>k', '<cmd>JupyterInspect<CR>', { buffer = 0, desc = 'Inspect obj in krnl' })
    end,
  },
  { 'vimjas/vim-python-pep8-indent', ft = 'python', lazy = false, priority = 999 },
  { 'microsoft/python-type-stubs', ft = 'python', lazy = false, priority = 999 },
  {
    'linux-cultist/venv-selector.nvim',
    enabled = true,
    branch = 'regexp',
    ft = 'python',
    cmd = 'VenvSelect',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
    },
    opts = { auto_refresh = true },
    config = function(_, opts)
      -- this function gets called by the plugin when a new result from fd is received
      -- change the filename displayed here to what you need, example: remove the /bin/python part.

      -- map('n', '<localleader>vs', '<cmd>VenvSelect<cr>', { buffer = 0, desc = 'Select Virtualenv' })

      require('venv-selector').setup(opts)
    end,
    keys = { { '<localleader>v', '<cmd>VenvSelect<cr>', desc = 'Select Virtualenv', ft = 'python' } },
  },
}
