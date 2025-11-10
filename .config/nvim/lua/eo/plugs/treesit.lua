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
  'jsonc',
  'jsx',
  'julia',
  'just',
  'latex',
  'lua',
  'luadoc',
  'luap',
  'make',
  'markdown',
  'markdwon_inline',
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
  'todotext',
  'terraform',
  'toml',
  'todotext',
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

---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- priority = 1000,
    lazy = false,
    -- lazy = vim.fn.argc(-1) == 0,
    branch = 'main',
    -- main = 'nvim-treesitter.configs',
    version = false,
    build = ':TSUpdate',
    config = function() require('nvim-treesitter').update(languagess) end,
    -- opts_extend = { 'ensure_installed' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        opts = {},
        keys = {
          {
            'af',
            function()
              require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
            end,
            desc = 'Select outer function',
            mode = { 'n', 'v', 'x', 'o' },
          },
          {
            'if',
            function()
              require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
            end,
            desc = 'Select inner function',
            -- mode = { 'x', 'o' },
            mode = { 'n', 'v', 'x', 'o' },
          },
          {
            'ab',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@block.outer', 'textobjects') end,
            desc = 'Select outer code cell',
            -- mode = { 'n', 'x', 'o' },
            mode = { 'n', 'v', 'x', 'o' },
            -- ft = { 'python', 'quarto', 'markdown', 'julia', 'r' },
            ft = { 'quarto', 'markdown', 'julia', 'r' },
          },
          {
            'ib',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@block.inner', 'textobjects') end,
            desc = 'Select inner code cell',
            -- mode = { 'n', 'x', 'o' },
            -- ft = { 'python', 'quarto', 'markdown', 'julia', 'r' },
            ft = { 'quarto', 'markdown', 'julia', 'r' },
            mode = { 'n', 'v', 'x', 'o' },
          },
          {
            'ac',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
            desc = 'Select outer class',
            mode = { 'n', 'v', 'x', 'o' },
            -- mode = { 'n', 'x', 'o' },
          },
          {
            'ic',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
            desc = 'Select inner class',
            mode = { 'n', 'v', 'x', 'o' },
            -- mode = { 'n', 'x', 'o' },
          },
          {
            'as',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end,
            desc = 'Select local scope',
            mode = { 'n', 'v', 'x', 'o' },
            -- mode = { 'n', 'x', 'o' },
          },
          {
            ']b',
            function()
              -- require('nvim-treesitter-textobjects.move').goto_next('@code_cell.inner', 'textobjects')
              require('nvim-treesitter-textobjects.move').goto_next('@block.inner', 'textobjects')
            end,
            desc = 'Next code cell',
            mode = { 'n', 'v', 'x', 'o' },
            -- mode = { 'n', 'x', 'o' },
            -- ft = { 'markdown', 'quarto', 'julia', 'python', 'r' },
            ft = { 'markdown', 'quarto', 'julia', 'r' },
          },
          {
            '[b',
            function()
              -- require('nvim-treesitter-textobjects.move').goto_next('@code_cell.inner', 'textobjects')
              require('nvim-treesitter-textobjects.move').goto_previous('@block.inner', 'textobjects')
            end,
            desc = 'Prev code cell',
            mode = { 'n', 'v', 'x', 'o' },
            -- mode = { 'n', 'x', 'o' },
            -- ft = { 'markdown', 'quarto', 'julia', 'python', 'r' },
            ft = { 'markdown', 'quarto', 'julia', 'r' },
          },
        },
      },
      'JoosepAlviste/nvim-ts-context-commentstring',
      {
        -- 'PriceHiller/nvim-treesitter-endwise',
        -- 'RRethy/nvim-treesitter-endwise',
        'AbaoFromCUG/nvim-treesitter-endwise', -- finally a fork that supports nvim-ts main!
        branch = 'main',
        -- 'brianhuster/treesitter-endwise.nvim',
        -- branch = 'fix/iter-matches',
        -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
        -- event = { 'InsertEnter' },
        event = 'VeryLazy',
        ft = { 'ruby', 'lua', 'vim', 'bash', 'elixir', 'fish', 'julia' }, -- only langs currently supported anyway
        config = function()
          -- vim.g.treesitter_endwise_filetypes = { 'ruby', 'lua', 'vim', 'bash', 'elixir', 'fish', 'julia' }
          -- manually trigger `FileType` event to make sure nvim-treesitter-endwise attaches to current file when loaded
          api.nvim_exec_autocmds('FileType', {})
        end,
      },
      {
        'andymass/vim-matchup',
        enabled = true,
        -- lazy = true,
        event = 'VeryLazy',
        -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
        'm-demare/hlargs.nvim',
        -- lazy = false,
        -- priority = 1000,
        event = 'VeryLazy',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
          hl_priority = 1001,
          extras = {
            named_parameters = true,
          },
          exclude_argnames = {
            usages = {
              lua = { 'self', 'use' },
            },
          },
        },
      },
      {
        'https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git',
        submodules = false,
        version = false,
        event = 'VeryLazy',
        -- lazy = false,
        -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
          local rainbow_delimiters = require('rainbow-delimiters')

          ---@type rainbow_delimiters.config
          vim.g.rainbow_delimiters = {
            strategy = {
              [''] = rainbow_delimiters.strategy.global,
            },
            query = {
              [''] = rainbow_delimiters.strategy['local'],
            },
            -- blacklist = { 'txt', 'c', 'cpp' },
          }
          rainbow_delimiters.enable(0)
          if rainbow_delimiters.is_enabled(0) ~= 0 then rainbow_delimiters.toggle(0) end
        end,
      },
      {
        'CKolkey/ts-node-action',
        lazy = true,
        dependencies = { 'tpope/vim-repeat' },
        opts = function() return { julia = require('eo.ts_node_action.fts.julia') } end,
        keys = {
          { 'gA', function() require('ts-node-action').node_action() end, desc = 'Node Action' },
        },
      },
      {
        'Wansmer/treesj',
        lazy = true,
        -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
        -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
            -- function() require('sibling-swap').swap_with_left() end,
            [[:lua require('sibling-swap').swap_with_left()<CR>]],
            { desc = 'Swap with Left', silent = true },
          },
          {
            ']w',
            [[:lua require('sibling-swap').swap_with_right()<CR>]],
            -- [[<cmd>lua require('sibling-swap').swap_with_right()<CR>]],
            { desc = 'Swap with Right', silent = true },
          },
        },
      },
      {
        'numToStr/Comment.nvim',
        lazy = false,
        -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = function(opts)
          local ok, integration = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
          if ok then opts.pre_hook = integration.create_pre_hook() end
        end,
        keys = { 'gcc', { 'gc', mode = { 'x', 'n', 'o' } } },
      },
    },
  },
  {
    'maxbol/treesorter.nvim',
    cmd = 'TSort',
  },
  {
    'dsully/treesitter-jump.nvim',
    lazy = false,
    enabled = true,
    keys = {
      { '%', function() require('treesitter-jump').jump() end },
    },
    opts = {},
  },
  {
    ---@module 'treesitter-modules'
    'MeanderingProgrammer/treesitter-modules.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ---@type ts.mod.UserConfig
    opts = function(_, opts)
      opts = vim.tbl_deep_extend('force', {
        auto_install = vim.tbl_values { languagess },
        ensure_installed = vim.tbl_values { languagess },
        fold = { enable = true },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        autopairs = { enable = true },
        indent = {
          enable = true,
          disable = { 'python', 'yaml' },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            -- due to blink, it cant be Tab.
            init_selection = '<CR>',
            node_incremental = '<CR>',
            scope_incremental = false,
            node_decremental = '<BS>',
          },
        },
      }, opts)
    end,
  },
}
