-- local highlight = eo.highlight

local api = vim.api
local languagess = {
  'angular',
  'astro',
  'awk',
  'bash',
  'c',
  'caddy',
  'c_sharp',
  'cmake',
  'cpp',
  'css',
  'csv',
  'cue',
  'diff',
  'dockerfile',
  'dot',
  'doxygen',
  'fsharp',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'gotmpl',
  'gpg',
  'graphql',
  'html',
  'html_tags',
  'htmldjango',
  'http',
  'haskell',
  'ini',
  'javascript',
  'jinja',
  'jinja_inline',
  'jq',
  'jsdoc',
  'json',
  'json5',
  'jsx',
  'julia',
  'just',
  'kitty',
  'latex',
  'lua',
  'luadoc',
  'luap',
  'make',
  'markdown',
  'markdown_inline',
  'mermaid',
  'ocaml',
  'pem',
  'perl',
  'pkl',
  'prql',
  'printf',
  'pymanifest',
  'python',
  'qmldir',
  'qmljs',
  'query',
  'r',
  'rnoweb',
  'racket',
  'regex',
  'requirements',
  'rst',
  'ruby',
  'rust',
  'scala',
  'scheme',
  'scss',
  'sql',
  'soql',
  'ssh_config',
  'swift',
  'svelte',
  'superhtml',
  'todotxt',
  'terraform',
  'toml',
  'typst',
  'tsv',
  'tsx',
  'typescript',
  'v',
  'vim',
  'vimdoc',
  'vhs',
  'vue',
  'xml',
  'yaml',
  'zig',
  'zsh',
}

--[[
  The should_disable logic and subsequent settings are applied after reviewing stevearc/dotfiles
  specifically: github.com/stevearc/dotfiles/blob/master/nvim/lua/plugins/treesitter.lua
--]]

---@type LazyPluginSpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    -- build = { ':TSInstall all', ':TSUpdate', ':TSUninstall comment' },
    build = { ':TSUpdate' },
    -- opts = {
    --   highlight = {
    --     enable = true,
    --     additional_vim_regex_highlighting = false,
    --   },
    --   indent = {
    --     enable = true,
    --     disable = { 'python', 'yaml' },
    --   },
    --   incremental_selection = {
    --     enable = true,
    --     keymaps = {
    --       -- due to blink, it cant be Tab.
    --       init_selection = '<CR>',
    --       node_incremental = '<CR>',
    --       -- scope_incremental = false,
    --       scope_incremental = '<M-CR>',
    --       node_decremental = '<BS>',
    --     },
    --     query_linter = {
    --       enable = true,
    --       use_virtual_text = true,
    --       lint_events = { 'BufWrite', 'CursorHold' },
    --     },
    --   },
    -- },
    opts_extend = { 'ensure_installed' },
    main = 'nvim-treesitter.configs',
    config = function(_, opts)
      -- require('nvim-treesitter').setup(opts)
      require('nvim-treesitter').update(languagess)
      vim.treesitter.language.register('markdown', 'quarto')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    branch = 'main',
    lazy = false,
    keys = {
      {
        'af',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
        desc = 'Select outer function',
        mode = { 'x', 'o', 'n' },
      },
      {
        'if',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
        desc = 'Select inner function',
        mode = { 'x', 'o', 'n' },
      },
      {
        'ab',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@block.outer', 'textobjects') end,
        desc = 'Select outer code cell',
        mode = { 'x', 'o', 'n' },
        ft = { 'quarto', 'markdown', 'julia', 'r' },
      },
      {
        'ib',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@block.inner', 'textobjects') end,
        desc = 'Select inner code cell',
        mode = { 'x', 'o', 'n' },
        ft = { 'quarto', 'markdown', 'julia', 'r' },
      },
      {
        'ac',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
        desc = 'Select outer class',
        mode = { 'x', 'o', 'n' },
      },
      {
        'ic',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
        desc = 'Select inner class',
        mode = { 'x', 'o', 'n' },
      },
      {
        'as',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end,
        desc = 'Select local scope',
        mode = { 'x', 'o', 'n' },
      },
      {
        ']f',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.inner', 'textobjects') end,
        desc = 'Next function',
        mode = { 'n', 'x', 'o' },
      },
      {
        '[f',
        function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.inner', 'textobjects') end,
        desc = 'Prev function',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']c',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@class.inner', 'textobjects') end,
        desc = 'Next class',
        mode = { 'n', 'x', 'o' },
      },
      {
        '[c',
        function() require('nvim-treesitter-textobjects.move').goto_previous_start('@class.inner', 'textobjects') end,
        desc = 'Prev class',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']b',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@block.inner', 'textobjects') end,
        desc = 'Next code cell',
        mode = { 'n', 'x', 'o' },
        ft = { 'markdown', 'quarto', 'julia', 'r' },
      },
      {
        '[b',
        function() require('nvim-treesitter-textobjects.move').goto_previous_start('@block.inner', 'textobjects') end,
        desc = 'Prev code cell',
        mode = { 'n', 'x', 'o' },
        ft = { 'markdown', 'quarto', 'julia', 'r' },
      },
    },
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
  },
  {
    -- 'PriceHiller/nvim-treesitter-endwise',
    -- 'RRethy/nvim-treesitter-endwise',
    ---@module 'nvim-treesitter-endwise'
    'AbaoFromCUG/nvim-treesitter-endwise', -- finally a fork that supports nvim-ts main!
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    branch = 'main',
    version = false,
    -- 'brianhuster/treesitter-endwise.nvim',
    -- branch = 'fix/iter-matches',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- event = { 'InsertEnter' },
    -- event = 'VeryLazy',
    lazy = false,
    ft = { 'ruby', 'lua', 'vim', 'bash', 'elixir', 'fish', 'julia' }, -- only langs currently supported anyway
    config = function()
      -- vim.g.treesitter_endwise_filetypes = { 'ruby', 'lua', 'vim', 'bash', 'elixir', 'fish', 'julia' }
      -- manually trigger `FileType` event to make sure nvim-treesitter-endwise attaches to current file when loaded
      api.nvim_exec_autocmds('FileType', {})
    end,
  },
  {
    ---@module 'match-up'
    'andymass/vim-matchup',
    enabled = true,
    -- lazy = false,
    version = false,
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ---@type matchup.Config
    config = function()
      vim.g['matchup_enabled'] = true
      vim.g['matchup_surround_enabled'] = true
      vim.g['matchup_transmute_enabled'] = false
      vim.g['matchup_matchparen_deferred'] = true
      vim.g['matchup_matchparen_hi_surround_always'] = true
      vim.g['matchup_matchparen_offscreen'] = { method = 'popup', scrolloff = 1 }
      vim.g['matchup_matchparen_nomode'] = 'is'
      vim.g['matchup_matchparen_pumvisible'] = true
      -- dont recognize anything in comments
      vim.g['matchup_delim_noskips'] = 2
      vim.g['matchup_motion_cursor_end'] = false
      vim.g['matchup_matchpref'] = { html = { nolists = 1 } }
      -----------------------------------------------------------------------
    end,
  },
  {
    ---@module 'rainbow-delimiters'
    'https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git',
    submodules = false,
    version = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    -- lazy = false,
    ---@type rainbow_delimiters.config
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy.global,
          commonlisp = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow_delimiters',
          -- lua = 'rainbow-blocks',
          lua = 'rainbow-delimiters',
          latex = 'rainbow-blocks',
          julia = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },
  {
    'CKolkey/ts-node-action',
    version = false,
    dependencies = { 'tpope/vim-repeat' },
    opts = function()
      return {
        julia = require('eo.ts_node_action.fts.julia'),
      }
    end,
    keys = {
      { 'gA', function() require('ts-node-action').node_action() end, desc = 'Node Action' },
    },
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    version = false,
    cmd = { 'TSJSplit', 'TSJJoin' },
    opts = {
      use_default_keymaps = false,
      cursor_behavior = 'start',
      max_join_length = 160,
    },
    keys = {
      {
        'gS',
        '<cmd>TSJSplit<cr>',
        desc = 'Toggle Split to multiple lines',
      },
      {
        'gJ',
        '<cmd>TSJJoin<cr>',
        desc = 'Toggle Join to single line',
      },
    },
  },
  {
    'Wansmer/sibling-swap.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'tpope/vim-repeat' },
    version = false,
    opts = {
      max_join_length = 120,
      check_syntax_error = true,
      cursor_behavior = 'hold',
      dot_repeat = true,
      highlight_node_at_cursor = true,
      use_default_keymaps = false,
    },
    keys = {
      {
        '[w',
        [[<cmd>lua require('sibling-swap').swap_with_left()<CR>]],
        { desc = 'Swap with Left', silent = true },
      },
      {
        ']w',
        [[<cmd>lua require('sibling-swap').swap_with_right()<CR>]],
        { desc = 'Swap with Right', silent = true },
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    version = false,
    -- lazy = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'JoosepAlviste/nvim-ts-context-commentstring' },
    opts = function(opts)
      local ok, integration = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if ok then opts.pre_hook = integration.create_pre_hook() end
    end,
    keys = { 'gcc', { 'gc', mode = { 'x', 'n', 'o', 'v' } } },
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    version = false,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    -- lazy = true,
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre', 'VeryLazy' },
    version = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable = false,
      multiwindow = true,
      max_lines = 6,
      patterns = {
        json = { 'object', 'pair' },
        markdown = { 'section' },
        toml = { 'table', 'pair' },
        yaml = {
          'block_mapping_pair',
          'block_sequence_item',
        },
      },
    },
  },
  {
    ---@module "treesorter"
    'maxbol/treesorter.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    version = false,
    cmd = 'TSort',
  },
  {
    ---@module "treesitter-jump"
    'dsully/treesitter-jump.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    lazy = false,
    version = false,
    enabled = true,
    keys = {
      { '%', function() require('treesitter-jump').jump() end },
    },
    opts = {},
  },
  {
    'MeanderingProgrammer/treesitter-modules.nvim',
    enabled = true,
    version = false,
    lazy = false,
    priority = 1000,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      auto_install = true,
      ensure_installed = languagess,
      fold = { enable = true },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = {
        enable = true,
        disable = { 'python', 'yaml' },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          scope_incremental = '<M-CR>',
          node_decremental = '<BS>',
        },
      },
    },
  },
}
-- {
--   ---@module 'hlargs'
--   'm-demare/hlargs.nvim',
--   enabled = false,
--   lazy = false,
--   version = false,
--   -- priority = 1000,
--   -- event = 'VeryLazy',
--   dependencies = { 'nvim-treesitter/nvim-treesitter' },
--   ---@type HLArgs
--   opts = {
--     hl_priority = 1001,
--     extras = {
--       named_parameters = true,
--     },
--     exclude_argnames = {
--       usages = {
--         lua = { 'self', 'use' },
--       },
--     },
--   },
-- },
-- {
--   ---@module "hmts"
--   'calops/hmts.nvim',
--   enabled = false,
--   version = false,
--   lazy = true,
--   opts = {},
-- },
