---@module "lazy"
---@type LazySpec
return {
  {
    -- Fix python indent
    -- Without this plugin:
    -- a = [|] -> press <Enter> ->
    -- a = [
    --         |
    --         ]
    -- With this plugin:
    -- a =  [
    --     |
    -- ]
    'vimjas/vim-python-pep8-indent',
    ft = 'python',
    lazy = false,
    -- priority = 999,
  },
  -- {
  --   'microsoft/python-type-stubs',
  --   ft = 'python',
  --   lazy = false,
  --   -- priority = 999,
  -- },
  {
    'linux-cultist/venv-selector.nvim',
    enabled = true,
    branch = 'main',
    ft = { 'python', 'quarto', 'markdown' },
    cmd = 'VenvSelect',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
    },
    opts = {
      auto_refresh = true,
      settings = {
        options = {
          notify_user_on_venv_activation = false,
        },
      },
    },
    config = function(_, opts)
      -- this function gets called by the plugin when a new result from fd is received
      -- change the filename displayed here to what you need, example: remove the /bin/python part.

      -- map('n', '<localleader>vs', '<cmd>VenvSelect<cr>', { buffer = 0, desc = 'Select Virtualenv' })

      require('venv-selector').setup(opts)
    end,
    keys = { { '<localleader>v', '<cmd>VenvSelect<cr>', desc = 'Select Virtualenv', ft = 'python' } },
  },
  {
    'Davidyz/inlayhint-filler.nvim',
    ft = 'python',
    keys = {
      {
        '<leader>cp',
        function() require('inlayhint-filler').fill() end,
        desc = 'Insert the inlay-hint under cursor into the buffer',
        mode = { 'n', 'v' },
      },
    },
  },
  {
    --[[
      Is venv-selector needed anymore?
    --]]
    'benomahony/uv.nvim',
    cmd = { 'UVInit', 'UVRunFile', 'UVRunSelection', 'UVRunFunction' },
    ft = 'python',
    opts = {
      auto_activate_venv = false,
      auto_commands = true,
      notify_activate_venv = false,
      picker_integration = true,

      -- keymaps to register (set to false to disable)
      keymaps = {
        -- stylua: ignore
        prefix = '<leader>v', -- Main prefix for uv commands,
        commands = true, -- show uv commands menu (<leader>v)
        run_file = true, -- Run current file (<leader>vr)
        run_selection = true, -- Run selected code (<leader>vs)
        run_function = true, -- Run function (<leader>vf)
        venv = true, -- Environment management (<leader>ve)
        init = true, -- Initialize uv project (<leader>vi)
        add = true, -- Add a package (<leader>va)
        remove = true, -- Remove a package (<leader>vd)
        sync = true, -- Sync packages (<leader>vc)
      },
      execution = {
        run_command = 'uv run python',
        notify_output = true,
        notification_timeout = 10000,
      },
    },
  },
  -- {
  --   'lkhphuc/jupyter-kernel.nvim',
  --   init = function()
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = 'python',
  --       callback = function() end,
  --       group = vim.api.nvim_create_augroup('jupyter_kernel_setup', {}),
  --     })
  --   end,
  --   cmd = { 'JupyterAttach' },
  --   build = ':UpdateRemotePlugins',
  --   opts = {},
  -- },
}
