-- {
--   'nolleh/sqlflick.nvim',
--   ft = { 'sql', 'mysql', 'plsql' },
--   lazy = true,
--   enabled = false,
-- },
-- {
--   'mportdata/squealer.nvim',
--   ft = { 'sql', 'mysql', 'plsql' },
--   lazy = true,
--   enabled = false,
-- },
-- {
--   'lifepillar/pgsql.vim',
--   ft = { 'sql', 'mysql', 'plsql' },
--   lazy = false,
--   enabled = false,
-- },

local sql_ft = { 'sql', 'mysql', 'plsql' }

---@type LazyPluginSpec
return {
  {
    ---@module "sqls"
    'nanotee/sqls.nvim',
    -- ft = { 'sql', 'mysql' },
    -- event = { 'VeryLazy' },
    enabled = true,
    version = false,
  },
  {
    'tpope/vim-dadbod',
    lazy = true,
    version = false,
    dependencies = {
      { 'kristijanhusak/vim-dadbod-ui' },
      { 'kristijanhusak/vim-dadbod-completion' },
    },
    config = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_save_location = '~/Dev/dbui'
      vim.g.db_ui_tmp_query_location = '~/Dev/queries'
      vim.g.db_ui_execute_on_save = false
      vim.g.db_ui_use_nvim_notify = true
    end,
    cmd = { 'DBUI', 'DBUIFindBuffer' },
  },
  {
    'Maxteabag/sqlit.nvim',
    build = 'uv tool install sqlit-tui --with psycopg2-binary --with PyMySQL --with duckdb --with snowflake-connector-python --with adbc-driver-flightsql',
    opts = {},
    keys = {
      {
        '<leader>D',
        function() require('sqlit').open() end,
        desc = 'DB (sqlit)',
        ft = sql_ft,
      },
    },
  },
}
