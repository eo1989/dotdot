return function()
  -- This option, which currently doesn't work upstream, disables linking treesitter highlights
  -- to the new capture highlights which color schemes and plugins depend on. By toggling it
  -- I can see which highlights still need to be supported in upstream plugins.
  -- NOTE: this is currently broken, do not set to true
  vim.g.skip_ts_default_groups = false

  require('nvim-treesitter.parsers').filetype_to_parsername['zsh'] = 'bash'

  -- local parsers = require('nvim-treesitter.parsers')
  -- local ft_to_parser = parsers.filetype_to_parsername -- ()
  -- ft_to_parser['zsh'] = 'bash'

  -- local parser_configs = parsers.get_parser_configs()
  -- parser_configs['norg_table'] = {
  --   install_info = {
  --     url = 'https://github.com/nvim-neorg/tree-sitter-norg-table',
  --     files = { 'src/parser.c' },
  --     branch = 'main'
  --   }
  -- }

  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'awk',
      'cpp',
      'json',
      'http',
      'query',
      'diff',
      'lua',
      'go',
      'julia',
      'python',
      'perl',
      'bash',
      'norg',
      'make',
      'org',
      'help',
      'sql',
      'rst',
      'latex',
      'markdown',
      'markdown_inline',
      'scheme',
      'yaml',
      'toml',
      'regex',
      'gitignore',
    },
    auto_install = true,
    highlight = {
      enable = true,
      use_languagetree = true,
      additional_vim_regex_highlighting = { 'org' },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = '<CR>', -- maps in normal mode to init the node/scope selection
        node_incremental = '<CR>', -- increment to the upper named parent
        node_decremental = '<M-CR>', -- decrement to the previous node
        -- scope_incremental = '<TAB>', -- increment to the upper scope (as defined in locals.scm)
        -- scope_decremental = '<S-TAB>', -- increment to the upper scope (as defined in locals.scm)
      },
    },
    indent = {
      enable = true,
      disable = { 'yaml', 'python' },
    },
    textobjects = {
      select = {
        enable = true,
        include_surrounding_whitespace = false,
        keymaps = {
          ['af'] = { query = '@function.outer', desc = 'ts: all function' },
          ['if'] = { query = '@function.inner', desc = 'ts: inner function' },

          ['ac'] = { query = '@class.outer', desc = 'ts: all class' },
          ['ic'] = { query = '@class.inner', desc = 'ts: inner class' },

          -- ['aC'] = '@conditional.outer',
          -- ['iC'] = '@conditional.inner',

          ['am'] = { query = '@parameter.outer', desc = 'ts: all parameter' },
          ['im'] = { query = '@parameter.inner', desc = 'ts: inner parameter'},
          -- FIXME: this is unusable
          -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133 is resolved
          -- ['ax'] = '@comment.outer',
          ['as'] = { '@statement.outer', desc = 'ts: all statement' },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['[w'] = '@parameter.inner',
          ['<localleader>sf'] = '@function.outer',
        },
        swap_previous = {
          [']w'] = '@parameter.inner',
          ['<localleader>sF'] = '@function.outer',
        },
      },
      -- move = {
      --   enable = true,
      --   set_jumps = true, -- whether to set jumps in the jumplist
      --   goto_next_start = {
      --     [']m'] = '@function.outer',
      --     [']M'] = '@class.outer',
      --   },
      --   goto_previous_start = {
      --     ['[m'] = '@function.outer',
      --     ['[M'] = '@class.outer',
      --   },
      -- },
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
      -- colors = {
      --   'RoyalBlue2',
      --   'DarkOrange1',
      --   'SeaGreen2',
      --   'Firebrick',
      --   'DarkOrchid2',
      -- },
    },
    autopairs = { enable = true },
    endwise = { enable = true },
    matchup = {
      enable = true,
      disable = { 'julia' },
      disable_virtual_text = false,
    },
    playground = {
      enable = true,
      disable = {},
      persist_queries = true,
      updatetime = 25,
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { 'BufWrite', 'CursorHold' },
    },
  })
end
