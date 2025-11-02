local api, fn = vim.api, vim.fn

---@type LazySpec
return {
  {
    'hat0uma/csvview.nvim',
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
    ft = 'csv',
    ---@module 'csvview'
    ---@type CsvView.Options
    opts = {
      view = { header_lnum = 1 },
      parser = { comments = { '#', '//' } },
      keymaps = {
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        jump_next_field_start = { 'w', mode = { 'n', 'v' } },
        jump_prev_field_start = { 'b', mode = { 'n', 'v' } },
        jump_next_field_end = { 'e', mode = { 'n', 'v' } },
      },
    },
    -- from olimorris, everything above is from dsully/hat0umas defaults
    init = function()
      api.nvim_create_user_command(
        'Csv',
        function()
          require('csvview').toggle(0, {
            parser = {
              delimiter = ',',
              quote_char = '"',
              comment_char = '#',
            },
            view = {
              display_mode = 'border',
              header_lnum = 1,
            },
          })
        end,
        {}
      )
    end,
  },
  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  },
  -- {
  --   'goerz/julia-vim',
  --   -- ft = 'julia',
  --   branch = 'tweaks',
  --   config = function()
  --     -- vim.g.latex_to_unicode_file_types = { 'julia', 'python', 'markdown', 'pandoc', 'human' }
  --     vim.g.latex_to_unicode_tab = 'off' --|> blink-cmp-latex
  --   end,
  -- },
  -- {
  --   'kdheepak/nvim-dap-julia',
  --   ft = { 'julia' },
  --   opts = {},
  -- },

  -- {
  --   --[[ NOTE:  04/05/2025 -> currently errors with blink for some reason. ]]
  --   'lkhphuc/jupyter-kernel.nvim',
  --   enabled = false,
  --   build = ':UpdateRemotePlugins',
  --   -- cmd = 'JupyterAttach',
  --   -- init = function()
  --   -- end,
  --   ft = { 'python', 'julia', 'r', 'markdown', 'quarto' },
  --   config = function()
  --     require('jupyter_kernel').setup {
  --       timeout = 0.5,
  --     }
  --     map('n', '<localleader>k', '<cmd>JupyterInspect<CR>', { buffer = 0, desc = 'Inspect obj in krnl' })
  --   end,
  -- },

  -- { 'vimjas/vim-python-pep8-indent', ft = 'python', lazy = false, priority = 999 },
  -- { 'microsoft/python-type-stubs', ft = 'python', lazy = false, priority = 999 },
  -- {
  --   'linux-cultist/venv-selector.nvim',
  --   enabled = true,
  --   branch = 'regexp',
  --   ft = { 'python', 'quarto' },
  --   cmd = 'VenvSelect',
  --   dependencies = {
  --     'neovim/nvim-lspconfig',
  --     'nvim-telescope/telescope.nvim',
  --     'mfussenegger/nvim-dap',
  --     'mfussenegger/nvim-dap-python',
  --   },
  --   opts = { auto_refresh = true },
  --   config = function(_, opts)
  --     -- this function gets called by the plugin when a new result from fd is received
  --     -- change the filename displayed here to what you need, example: remove the /bin/python part.
  --
  --     -- map('n', '<localleader>vs', '<cmd>VenvSelect<cr>', { buffer = 0, desc = 'Select Virtualenv' })
  --
  --     require('venv-selector').setup(opts)
  --   end,
  --   keys = { { '<localleader>v', '<cmd>VenvSelect<cr>', desc = 'Select Virtualenv', ft = 'python' } },
  -- },
  -- {
  --   'Davidyz/inlayhint-filler.nvim',
  --   ft = 'python',
  --   keys = {
  --     {
  --       '<leader>cp',
  --       function() require('inlayhint-filler').fill() end,
  --       desc = 'Insert the inlay-hint under cursor into the buffer',
  --       mode = { 'n', 'v' },
  --     },
  --   },
  -- },
  -- {
  --   'benomahony/uv.nvim',
  --   cmd = { 'UVInit', 'UVRunFile', 'UVRunSelection', 'UVRunFunction' },
  --   ft = 'python',
  --   opts = {
  --     auto_activate_venv = false,
  --     auto_commands = true,
  --     notify_activate_venv = false,
  --     picker_integration = true,
  --
  --     -- keymaps to register (set to false to disable)
  --     keymaps = {
  --       -- stylua: ignore
  --       prefix = '<leader>v', -- Main prefix for uv commands,
  --       commands = true, -- show uv commands menu (<leader>v)
  --       run_file = true, -- Run current file (<leader>vr)
  --       run_selection = true, -- Run selected code (<leader>vs)
  --       run_function = true, -- Run function (<leader>vf)
  --       venv = true, -- Environment management (<leader>ve)
  --       init = true, -- Initialize uv project (<leader>vi)
  --       add = true, -- Add a package (<leader>va)
  --       remove = true, -- Remove a package (<leader>vd)
  --       sync = true, -- Sync packages (<leader>vc)
  --     },
  --     execution = {
  --       run_command = 'uv run python',
  --       notify_output = true,
  --       notification_timeout = 10000,
  --     },
  --   },
  -- },
}
