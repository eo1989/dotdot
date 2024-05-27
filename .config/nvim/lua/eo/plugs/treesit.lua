--[[
  The should_disable logic and subsequent settings are applied after reviewing stevearc/dotfiles
  specifically: github.com/stevearc/dotfiles/blob/master/nvim/lua/plugins/treesitter.lua
]]

local map = _G.map or vim.keymap.set

-- local function should_disable(lang, bufnr)
--   local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr or 0))
--   -- size will be -2 if it doesnt fit into a number
--   local disable_max_size = 2000000  -- 2MB
--   if size > disable_max_size or size == -2 then
--     return true
--   end
--   if lang == 'zig' then
--     return true
--   end
--   return false
-- end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    -- event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
    -- version = false,
    build = ':TSUpdate',
    -- cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    -- keys = {
    --   { '<C-space>', desc = 'increment selection' },
    --   { '<bs>', desc = 'Decrement selectino', mode = 'x' },
    -- },
    -- init = function(plugin)
    --   -- From Lazyvim: Add nvim-treesitter queries to the rtp and it's custom query predicates early
    --   -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    --   -- no longer trigger the **nvim-treeitter** module to be loaded in time.
    --   -- Luckily, the only thins that those plugins need are the custom queries, which we make available during startup.
    --   require('lazy.core.loader').add_to_rtp(plugin)
    --   require('nvim-treesitter.query_predicates')
    -- end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      -- { 'JoosepAlviste/nvim-ts-context-commentstring' },
      { 'RRethy/nvim-treesitter-endwise' },
      -- { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
      {
        'andymass/vim-matchup',
        -- event = { 'BufReadPost', 'BufNewFile' },
        event = 'VeryLazy',
        init = function()
          vim.opt.matchpairs = { '(:)', '{:}', '[:]' }
          vim.g['matchup_surround_enabled'] = 1
          vim.g['matchup_matchparen_deferred'] = 2
          vim.g['matchup_matchparen_nomode'] = 'i'
          -- dont recognize anything in comments
          vim.g['matchup_delim_noskips'] = 2
          vim.g['matchup_motion_cursor_end'] = 1
          vim.g['matchup_matchparen_deferred_show_delay'] = 400
          vim.g['matchup_matchparen_deferred_hide_delay'] = 400
          -- vim.g.matchup_matchparen_hi_surround_always = 1
          vim.g['matchup_matchparen_offscreen'] = {
            method = 'popup',
            -- scrolloff = true,
            -- fullwidth = 0,
            -- highlight = 'OffscreenPopup',
          }
          vim.g['matchup_matchpref'] = { html = { nolists = 1 } }
        end,
      },
    },
    opts = {
      sync_install = true,
      auto_install = false,
      ensure_installed = {
        'julia',
        'python',
        'lua',
        'luap',
        'luadoc',
        'bash',
        'c',
        'cpp',
        'rst',
        'go',
        'mermaid',
        'rust',
        'html',
        'json',
        'jsonc',
        'json5',
        'hjson',
        'markdown',
        'markdown_inline',
        'requirements',
        'diff',
        'query',
        'regex',
        'latex', -- requires Mason install tree-sitter-cli??
        'vim',
        'vimdoc',
        'yaml',
        'toml',
        'sql',
        'http',
        'scheme',
        'ini',
        'todotxt',
        'gitcommit',
        'git_rebase',
        'gitignore',
        'git_config',
        'gitattributes',
        'typst',
      },
      highlight = { enable = true, additional_vim_regex_highlighting = { 'typst' } },
      indent = {
        enable = true,
        disable = { 'yaml', 'python', 'lua' },
        -- disable = function(lang, bufnr)
        --   if lang == "lua" or lang == "python" then
        --     return true
        --   else
        --     return should_disable(lang, bufnr)
        --   end
        -- end,
      },
      incremental_selection = {
        enable = false,
        disable = { 'help' },
        keymaps = {
          -- trial keymaps from lkhphuc/dotfiles
          -- trial keymaps from LazyVim/LazyVim <<=
          init_selection = '<C-Space>',
          node_incremental = '<CR>',
          node_decremental = '<BS>',
          scope_incremental = false,
        },
      },
      textobjects = {
        -- lookbehind = true,
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = { query = '@parameter.outer', desc = 'ts: outer param' },
            ['ia'] = { query = '@parameter.inner', desc = 'ts: inner param' },
            ['af'] = { query = '@function.outer', desc = 'ts: all function' },
            ['if'] = { query = '@function.inner', desc = 'ts: inner function' },
            ['ac'] = { query = '@class.outer', desc = 'ts: all class' },
            ['ic'] = { query = '@class.inner', desc = 'ts: inner class' },
            ['aC'] = { query = '@conditional.outer', desc = 'ts: all conditional' },
            ['iC'] = { query = '@conditional.inner', desc = 'ts: inner conditional' },
            -- ['aL'] = { query = '@assignment.lhs', desc = 'ts: assignment lhs' },
            -- ['iR'] = { query = '@assignment.rhs', desc = 'ts: assignment rhs' },

            -- for notebook/markdown code blocks
            ['ib'] = { query = '@code_cell.inner', desc = 'ts: inner code_cell' },
            ['ab'] = { query = '@code_cell.outer', desc = 'ts: outer code_cell' },
          },
        },
        move = {
          enable = true,
          set_jumps = false, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = { query = '@function.outer', desc = 'next function' },
            [']M'] = { query = '@class.outer', desc = 'next class' },
            [']b'] = { query = '@code_cell.inner', desc = 'next code block' },
          },
          goto_previous_start = {
            ['[m'] = { query = '@function.outer', desc = 'previous function' },
            ['[M'] = { query = '@class.outer', desc = 'previous class' },
            ['[b'] = { query = '@code_cell.inner', desc = 'previous code block' },
          },
        },
        -- swap = {
        --   enable = true,
        --   swap_next = {
        --     ['<leader>sal'] = '@parameter.inner',
        --     -- ["<leader>sfl"] = "@function.outer",
        --     ['<leader>sbl'] = '@code_cell.outer',
        --     -- ["<leader>snl"] = "@number.outer",
        --   },
        --   swap_previous = {
        --     ['<leader>sah'] = '@parameter.inner',
        --     -- ["<leader>sfh"] = "@function.outer",
        --     ['<leader>sbh'] = '@code_cell.outer',
        --     -- ["<leader>snh"] = "@number.outer",
        --   },
        -- },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
      },
      matchup = {
        enable = true,
        -- disable = { 'latex', 'markdown', 'norg', 'quarto', 'markdown_inline' },
        -- disable = should_disable,
        -- include_match_words = true,
        -- disable_virtual_text = true,
      },
      endwise = {
        enable = true,
        disable = { 'bash', 'sh', 'zsh' },
      },
      autopairs = { enable = true },
      rainbow = { enable = true },
    },
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- lazy = false,
    event = 'VeryLazy',
    config = function()
      local rb = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rb.strategy['global'],
        },
        query = {
          [''] = 'rainbow-delimiters',
        },
      }
    end,
  },
  {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'tpope/vim-repeat' },
    opts = {},
    keys = {
      {
        'gA',
        function() require('ts-node-action').node_action() end,
        -- [[<cmd>lua require('ts-node-action').node_action()<cr>]],
        desc = 'Node Action',
      },
    },
  },
  {
    'Wansmer/treesj',
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
    -- event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      {
        '[w',
        -- function() require('sibling-swap').swap_with_left() end,
        [[:lua require('sibling-swap').swap_with_left()<CR>]],
        desc = 'Swap with Left',
      },
      {
        ']w',
        [[:lua require('sibling-swap').swap_with_right()<CR>]],
        -- [[<cmd>lua require('sibling-swap').swap_with_right()<CR>]],
        desc = 'Swap with Right',
      },
    },
    opts = {
      max_join_length = 120,
      check_syntax_error = true,
      cursor_behavior = 'hold',
      dot_repeat = true,
      highlight_node_at_cursor = true,
      use_default_keymaps = false,
      -- keymaps = {
      --   ['[w'] = 'swap_with_left',
      --   ['<M-,>'] = 'swap_with_left',
      --   [']w'] = 'swap_with_right',
      --   ['<M-.'] = 'swap_with_right',
      -- },
    },
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    config = function()
      require('various_textobjs').setup {
        lookForwardLines = 8, -- default 5
      }
      map(
        { 'o', 'x' },
        'is',
        ":lua require('various-textobjs').sub_word(true)<CR>",
        { silent = true, desc = 'inner subword' }
      )
      map(
        { 'o', 'x' },
        'as',
        ":lua require('various-textobjs').sub_word(false)<CR>",
        { silent = true, desc = 'around subword' }
      )
    end,
  },
  {
    'ziontee113/query-secretary',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      {
        '<leader>fQ',
        function() require('query-secretary').query_window_initiate() end,
        desc = 'Find TS Query',
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = { 'gcc', { 'gc', mode = { 'x', 'n', 'o' } } },
    opts = function(_, opts)
      local ok, integration = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if ok then opts.pre_hook = integration.create_pre_hook() end
    end,
  },
}
