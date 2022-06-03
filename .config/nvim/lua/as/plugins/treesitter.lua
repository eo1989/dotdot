return function()
  local parsers = require 'nvim-treesitter.parsers'
  local rainbow_enabled = { 'dart' }
  -- Flattening a nested list for readability only hopefully 1 day there will be a way to do this
  -- that doesnt req the user to keep track of langs they use or might use.
  -- local langs = vim.tbl_flatten {
  --   { 'c', 'comment', 'make', 'query', 'toml', 'bash', 'regex' },
  --   { 'ruby', 'go', 'gomod', 'markdown', 'help', 'vim', 'css', 'yaml' },
  --   { 'lua', 'teal', 'typescript', 'tsx', 'javascript', 'jsdoc', 'json', 'jsonc' },
  --   { 'dockerfile', 'kotlin', 'dart', 'graphql', 'html', 'ocaml', 'java' },
  --   { 'python', 'julia', 'cpp', 'todotxt', 'rust', 'latex', 'http', 'swift', 'norg', 'org' },
  -- }

  require('nvim-treesitter.configs').setup {
    -- ensure_installed = langs,
    ensure_installed = 'all',
    ignore_installed = { 'phpdoc' },
    highlight = {
      enable = true,
      -- additional_vim_regex_highlighting = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = '<M-v>', -- maps in normal mode to init the node/scope selection
        node_incremental = '<M-n>', -- increment to the upper named parent
        node_decremental = '<M-p>', -- decrement to the previous node
        scope_incremental = 'M-f', -- increment to the upper scope (as defined in locals.scm)
      },
    },
    indent = {
      enable = true,
      disable = { 'python', 'yaml' },
    },
    textobjects = {
      lookahead = true,
      select = {
        enable = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['aC'] = '@conditional.outer',
          ['iC'] = '@conditional.inner',
          -- FIXME: this is unusable
          -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133 is resolved
          -- ['ax'] = '@comment.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['[w'] = '@parameter.inner',
        },
        swap_previous = {
          [']w'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
      },
      lsp_interop = {
        enable = true,
        border = as.style.current.border,
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
          ['<leader>dF'] = '@class.outer',
        },
      },
    },
    endwise = { enable = true, },
    rainbow = {
      enable = true,
      extended_mode = true,
      disable = vim.tbl_filter(function(p)
        local disable = true
        for _, lang in pairs(rainbow_enabled) do
          if p == lang then
            disable = false
          end
        end
        return disable
      end, parsers.available_parsers()),
      colors = {
        'RoyalBlue3',
        'DarkOrange3',
        'SeaGreen3',
        'Firebrick',
        'DarkOrchid3',
        -- 'Orchid',
        -- 'Cornsilk',
        -- 'DodgerBlue',
      },
    },
    autopairs = { enable = true },
    matchup = { enable = true },
    query_linter = {
      enable = true,
      use_virtual_text = false,
      lint_events = { 'BufWrite', 'CursorHold' },
    },
  }
end
