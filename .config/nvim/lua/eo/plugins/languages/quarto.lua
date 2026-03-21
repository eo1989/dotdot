---@type LazySpec
return {
  {
    'jmbuhr/otter.nvim',
    opts = {
      --[[ settings are from dsully: https://github.com/dsully/nvim/blob/main/lua/plugins/otter.lua ]]
      lsp = {
        root_dir = function(_, bufnr)
          -- 'Justfile',
          -- 'pyproject.toml',
          -- 'Makefile',
          return vim.fs.root(bufnr or 0, {
            '.git',
            '_quarto.yml',
            'package.json',
          }) or vim.fn.getcwd(0)
        end,
      },
      -- buffers = {
      --   write_to_disk = true,
      -- },
    },
  },
  {
    'quarto-dev/quarto-nvim',
    ft = { 'quarto' },
    keys = {
      {
        '<localleader>rc',
        function() return require('quarto.runner').run_cell() end,
        ft = 'quarto',
        desc = 'run cell',
      },
      {
        '<localleader>rr',
        function() return require('quarto.runner').run_range() end,
        ft = 'quarto',
        desc = 'run range',
        mode = 'x',
      },
      {
        '<localleader>qp',
        function() require('quarto').quartoPreview() end,
        ft = 'quarto',
        desc = 'Open quarto preview',
      },
      {
        '<localleader>qc',
        function() require('quarto').quartoClosePreview() end,
        ft = 'quarto',
        desc = 'Close quarto preview',
      },
      {
        '<localleader>qw',
        function() require('quarto').quartoPreviewNoWatch() end,
        ft = 'quarto',
        desc = 'Open quarto preview (no watch)',
      },
      {
        '<localleader>qu',
        function() require('quarto').quartoUpdatePreview() end,
        ft = 'quarto',
        desc = 'Update quarto preview',
      },
    },
    dependencies = {
      'nvim-lspconfig',
      'otter.nvim',
    },
    ---@type QuartoConfig
    opts = {
      debug = false,
      closePreviewOnExit = true,
      lspFeatures = {
        enabled = true,
        chunks = 'all',
        languages = { 'python', 'julia', 'r', 'sql' },
        diagnostics = {
          enabled = true,
          triggers = { 'BufWritePost' },
        },
        completion = { enabled = true },
      },
      keymap = {
        hover = 'K',
        definition = 'gd',
        rename = '<leader>rn',
        references = 'gr',
        format = '<M-f>',
      },
      codeRunner = {
        enabled = true,
        default_method = 'slime', -- "molten", "slime", "iron" or <function>
        -- filetype to runner, ie. `{ python = "molten" }`.
        -- ft_runners = {
        --   -- { julia = function() require('smuggler') end },
        --   { python = 'molten' },
        --   { julia = 'molten' },
        -- },
        -- Takes precedence over `default_method`
        -- never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
      },
    },
  },
}
