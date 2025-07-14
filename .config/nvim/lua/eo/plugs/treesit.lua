-- local highlight = eo.highlight
local api = vim.api

--[[
  The should_disable logic and subsequent settings are applied after reviewing stevearc/dotfiles
  specifically: github.com/stevearc/dotfiles/blob/master/nvim/lua/plugins/treesitter.lua
--]]

return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- event = 'BufRead',
    -- lazy = false,
    -- priority = 500,
    branch = 'main',
    build = ':TSUpdate',
    init = function()
      vim.treesitter.language.register('bash', 'zsh')
      vim.treesitter.language.register('ruby', 'brewfile')
      vim.treesitter.language.register('gotmpl', 'gotexttmpl')
      -- https://github.com/MeanderingProgrammer/render-markdown.nvim#vimwiki
      vim.treesitter.language.register('markdown', 'vimwiki')

      -- vim.hl.priorities.semantic_tokens = 100
      -- vim.hl.priorities.treesitter = 125

      -- https://github.com/neovim/neovim/issues/32660
      vim.g._ts_force_sync_parsing = true
    end,
    ---@class TSConfig
    config = function()
      require('nvim-treesitter').install {
        'angular',
        'bash',
        'css',
        'csv',
        'diff',
        'dot',
        'doxygen',
        'dockerfile',
        'gitattributes',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'go',
        'gomod',
        'graphql',
        'http',
        'ini',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'json5',
        'latex',
        'lua',
        'luap',
        'luadoc',
        'julia',
        'make',
        'markdown',
        'markdwon_inline',
        'mermaid',
        'python',
        'pymanifest',
        'query',
        'qmljs',
        'qmldir',
        'query',
        'requirements',
        'regex',
        'rust',
        'ruby',
        'ssh_config',
        'sql',
        'svelte',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'vhs',
        'vue',
        'yaml',
      }

      -- if opts.ensure_installed and #opts.ensure_installed > 0 then
      --   require('nvim-treesitter').install(opts.ensure_installed)
      --   -- register & start parsers
      --   for _, parser in ipairs(opts.ensure_installed) do
      --     local filetypes = parser -- == 'lua' and { 'lua', 'luap' } or { parser }
      --     vim.treesitter.language.register(parser, filetypes)
      --     vim.api.nvim_create_autocmd({ 'FileType' }, {
      --       pattern = filetypes,
      --       callback = function(event)
      --         vim.treesitter.start(event.buf, parser)
      --         -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      --         -- vim.o.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
      --       end,
      --     })
      --   end
      -- end

      -- auto-install & start parsers for any buffer
      api.nvim_create_autocmd({ 'FileReadPre', 'FileType' }, {
        group = api.nvim_create_augroup('treesitter_stuff', { clear = true }),
        -- callback = function(args)
        --   -- local ft = args.buf
        --   local ft = args.match
        --   -- vim.treesitter.start(ft, '*')
        --   -- vim.bo[ft].syntax = 'on'
        --
        --   local ts = require('nvim-treesitter')
        --   local available = ts.get_available()
        --   local lang = vim.treesitter.language.get_lang(ft)
        --
        --   if vim.list_contains(available, lang) then
        --     ts.install(lang):await(function()
        --       vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        --       local excluded = { 'python', 'markdown', 'yaml', 'julia', 'bash', 'zsh' }
        --       if not vim.list_contains(excluded, ft) then
        --         vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        --       end
        --       pcall(vim.treesitter.start)
        --     end)
        --   end
        -- end,
        pattern = { '*' },
        callback = function()
          if vim.o.filetype == 'bigfile' then return end

          if pcall(vim.treesitter.start) then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
    branch = 'main',
    config = true,
    keys = {
      {
        'af',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
        desc = 'Select outer function',
        mode = { 'x', 'o' },
      },
      {
        'if',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
        desc = 'Select inner function',
        mode = { 'x', 'o' },
      },
      -- {
      --   'ab',
      --   function() require('nvim-treesitter-textobjects.select').select_textobject('@code_cell.outer', 'textobjects') end,
      --   desc = 'Select outer code cell',
      --   mode = { 'x', 'o' },
      -- },
      -- {
      --   'ib',
      --   function() require('nvim-treesitter-textobjects.select').select_textobject('@code_cell.inner', 'textobjects') end,
      --   desc = 'Select inner code cell',
      --   mode = { 'x', 'o' },
      -- },
      -- {
      --   'a=',
      --   function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.outer', 'textobjects') end,
      --   desc = 'Select outer assignment',
      --   mode = { 'x', 'o' },
      -- },
      -- {
      --   'i=',
      --   function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.inner', 'textobjects') end,
      --   desc = 'Select inner assignment',
      --   mode = { 'x', 'o' },
      -- },
      -- {
      --   'ac',
      --   function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
      --   desc = 'Select outer class',
      --   mode = { 'x', 'o' },
      -- },
      -- {
      --   'ic',
      --   function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
      --   desc = 'Select inner class',
      --   mode = { 'x', 'o' },
      -- },
      {
        'as',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end,
        desc = 'Select local scope',
        mode = { 'x', 'o' },
      },
      {
        ']b',
        function()
          -- require('nvim-treesitter-textobjects.move').goto_next('@code_cell.inner', 'textobjects')
          require('nvim-treesitter-textobjects.move').goto_next('@block.inner', 'textobjects')
        end,
        desc = 'Next code cell',
        mode = { 'n', 'x', 'o' },
        ft = { 'markdown', 'quarto', 'julia', 'python' },
      },
      {
        '[b',
        function() require('nvim-treesitter-textobjects.move').goto_previous('@block.inner', 'textobjects') end,
        desc = 'Prev code cell',
        mode = { 'n', 'x', 'o' },
        ft = { 'markdown', 'quarto', 'julia', 'python' },
      },
    },
  },
  {
    'maxbol/treesorter.nvim',
    cmd = 'TSort',
  },
  {
    'dsully/treesitter-jump.nvim',
    enabled = true,
    keys = {
      { '%', function() require('treesitter-jump').jump() end },
    },
    opts = {},
  },
  -- {
  --   'JoosepAlviste/nvim-ts-context-commentstring',
  --   event = { 'VeryLazy' },
  -- },
  -- {
  --   'LiadOz/nvim-dap-repl-highlights',
  --   enabled = false,
  --   lazy = true,
  --   -- config = function() require('nvim-dap-repl-highlights').setup() end,
  -- },
  {
    -- 'PriceHiller/nvim-treesitter-endwise',
    -- 'RRethy/nvim-treesitter-endwise',
    'AbaoFromCUG/nvim-treesitter-endwise', -- finally a fork that supports nvim-ts main!
    branch = 'main',
    -- 'brianhuster/treesitter-endwise.nvim',
    -- branch = 'fix/iter-matches',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'InsertEnter' },
    ft = { 'ruby', 'lua', 'vim', 'bash', 'elixir', 'fish', 'julia' }, -- only langs currently supported anyway
    -- config = function()
    --   vim.g.treesitter_endwise_filetypes = { 'ruby', 'lua', 'vim', 'bash', 'elixir', 'fish', 'julia' }
    -- end,
  },
  {
    'andymass/vim-matchup',
    lazy = true,
    -- event = { 'BufReadPost' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    init = function() vim.o.matchpairs = '(:),{:},[:]' end,
    config = function()
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = "BlinkCmpMenuOpen",
      --   callback =
      -- })
      -- local ko, blink_event = pcall(require, 'blink.compat.event')
      -- if ko then
      --   blink_event:on('menu_opened', function() vim.b['matchup_matchparen_enabled'] = false end)
      --   blink_event:on('menu_closed', function() vim.b['matchup_matchparen_enabled'] = true end)
      -- end
      -- local ok, cmp = pcall(require, 'cmp')
      -- if ok then
      --   cmp.event:on('menu_opened', function() vim.b['matchup_matchparen_enabled'] = false end)
      --   cmp.event:on('menu_closed', function() vim.b['matchup_matchparen_enabled'] = true end)
      -- end
      -----------------------------------------------------------------------
      -- vim.o.matchpairs = '(:),{:},[:],<:>'
      vim.g['matchup_enabled'] = true
      vim.g['matchup_surround_enabled'] = true
      vim.g['matchup_transmute_enabled'] = false
      vim.g['matchup_matchparen_deferred'] = true
      vim.g['matchup_matchparen_hi_surround_always'] = true
      vim.g['matchup_matchparen_offscreen'] = { method = 'popup', scrolloff = 1 }
      vim.g['matchup_matchparen_nomode'] = 'i'
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
    lazy = false,
    -- priority = 1001,
    -- event = { 'BufReadPost' },
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
    'HiPhish/rainbow-delimiters.nvim',
    submodules = false,
    version = false,
    event = { 'BufReadPost' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      local rb = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rb.strategy['global'],
        },
        query = {
          [''] = rb.strategy['local'],
        },
        blacklist = { 'txt' },
      }
    end,
  },
  {
    'CKolkey/ts-node-action',
    lazy = true,
    -- event = { 'CursorHold', 'FuncUndefined' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'tpope/vim-repeat' },
    opts = {},
    keys = {
      {
        'gA',
        -- function() require('ts-node-action').node_action() end,
        [[<cmd>lua require('ts-node-action').node_action()<cr>]],
        desc = 'Node Action',
      },
    },
  },
  {
    'Wansmer/treesj',
    lazy = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = function(opts)
      local ok, integration = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if ok then opts.pre_hook = integration.create_pre_hook() end
    end,
    keys = { 'gcc', { 'gc', mode = { 'x', 'n', 'o' } } },
  },
}
