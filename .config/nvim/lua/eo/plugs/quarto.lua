-- 'vim-pandoc/vim-pandoc-syntax',
return {
  {
    'jmbuhr/otter.nvim',
    -- ft = { 'markdown', 'quarto' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'neovim/nvim-lspconfig' },
    config = function()
      local otter = require('otter')
      otter.setup {
        set_filetype = true,
      }
      -- vim.g.markdown_fenced_languages = {
      --   'lua',
      --   'python',
      --   'julia',
      --   'sql',
      --   'bash',
      --   'r',
      --   'rust',
      -- }
    end,
  },
  {
    'quarto-dev/quarto-nvim',
    -- enabled = true,
    event = { 'BufNewFile', 'BufReadPre' },
    -- event = { 'VeryLazy' },
    ft = { 'quarto', 'markdown' },
    keys = {
      {
        '<localleader>rA',
        function() require('quarto.runner').run_all(true) end,
        desc = 'quarto run all cells',
        ft = 'quarto',
      },
      {
        '<M-CR>',
        function() require('quarto.runner').run_cell() end,
        desc = 'quarto run cell',
        ft = 'quarto',
      },
      {
        '<M-CR>',
        function() require('quarto.runner').run_range() end,
        ft = 'quarto',
        mode = { 'v', 'x' },
        desc = 'quarto run visual range',
      },
      {
        '<localleader>qp',
        function() require('quarto').quartoPreview() end,
        ft = 'quarto',
        desc = 'quarto preview',
        noremap = true,
      },
      {
        '<localleader>rs',
        function() require('quarto.runner').run_range() end,
        mode = { 'v', 'x' },
        ft = 'quarto',
        desc = 'quarto run visual range',
      },
    },
    dependencies = {
      'jmbuhr/otter.nvim',
      'vim-pandoc/vim-pandoc-syntax',
      'nvim-lspconfig',
      'nvim-treesitter',
    },
    opts = {
      closePreviewOnExit = true,
      lspFeatures = {
        enabled = true,
        chunks = 'all', -- 'all', 'curly'
        languages = { 'python', 'julia', 'bash', 'lua' },
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
      -- try iron soon.
      codeRunner = {
        enabled = true,
        default_method = 'slime', -- "molten", "slime", "iron" or <function>
        -- filetype to runner, ie. `{ python = "molten" }`.
        ft_runners = {
          -- { julia = function() require('smuggler') end },
          { python = 'slime' },
          { julia = 'slime' },
        },
        -- Takes precedence over `default_method`
        never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
      },
    },
    config = function(_, opts)
      vim.g['pandoc#syntax#conceal#use'] = false
      vim.g['pandoc#syntax#codeblock#embeds#use'] = true
      vim.g['pandoc#syntax#conceal#blacklist'] = { 'codeblock_delim', 'codeblock_start' }
      vim.g['tex_conceal'] = 'gm'
      require('quarto').setup(opts)
    end,
  },
}
