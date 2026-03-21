---@type vim.lsp.Config
return {
  cmd = { 'sqls', '-config', vim.fn.expand('~/.config/sqls/config.yml') },
  ---@param client vim.lsp.Client
  -- filetypes = { 'sql', 'mysql' },
  -- single_file_support = true,
  -- on_attach = function(client, bufnr)
  --   require('sqls').on_attach(client, bufnr) -- requires sqls.nvim for this!
  -- end,
  -- not needed anymore; see [[ https://github.com/nanotee/sqls.nvim/issues/32 ]]
  settings = {
    sqls = {
      connections = {
        {
          driver = 'mysql',
          dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
        },
        {
          driver = 'postgresql',
          dataSourceName = 'host=127.0.0.1 port=15432 user=postgres password=secretpassword dbname=dvdrental sslmode=disable',
        },
      },
    },
  },
}
