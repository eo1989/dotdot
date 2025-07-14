return {
  {
    'lifepillar/pgsql.vim',
    lazy = false,
    enabled = true,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    event = 'VeryLazy',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
    end,
  },
  {
    -- 'tpope/vim-dadbod',
    -- lazy = true,
    -- event = 'BufRead *.sql',
    -- opts = {
    --   -- db_completion = function() require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } } end,
    --   -- db_completion = function() require('cmp').setup.filetype { sources = { { name = 'vim-dadbod-completion' } } } end,
    -- },
  },
}
