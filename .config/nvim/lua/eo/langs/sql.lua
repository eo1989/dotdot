---@module "lazy"
---@type LazySpec
return {
  {
    ---@module "sqls"
    'nanotee/sqls.nvim',
    ft = { 'sql', 'mysql' },
    event = { 'VeryLazy' },
    enabled = true,
  },
  {
    'nolleh/sqlflick.nvim',
    ft = { 'sql', 'mysql', 'plsql' },
    lazy = true,
    enabled = false,
  },
  {
    'mportdata/squealer.nvim',
    ft = { 'sql', 'mysql', 'plsql' },
    lazy = true,
    enabled = false,
  },
  {
    'lifepillar/pgsql.vim',
    ft = { 'sql', 'mysql', 'plsql' },
    lazy = false,
    enabled = false,
  },
  {
    ---@module "vim_dadbod_completion"
    'kristijanhusak/vim-dadbod-ui',
    event = 'VeryLazy',
    dependencies = {
      { 'tpope/vim-dadbod' },
      -- { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
      { 'kristijanhusak/vim-dadbod-completion' },
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
}
