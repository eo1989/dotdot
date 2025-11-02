local env, fn, fs = os.getenv('HOME'), vim.fn, vim.fs

---@type vim.lsp.Config
return {
  name = 'ts_query_ls',
  cmd = fn.expand('~') .. '/Dev/scripts/ts_query_ls/target/release/ts_query_ls', -- not in $PATH
  filetypes = { 'query' },
  root_dir = fs.root(0, { '.tsqueryrc.json', 'queries' }),
  root_markers = { '.tsqueryrc.json', '.git' },
  ---@param client vim.lsp.Client
  on_attach = function(_, bufnr) vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc' end,
  init_options = {
    parser_install_directories = {
      -- fs.joinpath(fn.stdpath('data'), '/lazy/nvim-treesitter/parser/'),
      fn.expand('~') .. '/.local/share/nvim/site/parser/',
    },
    parser_aliases = {
      ecma = 'javascript',
      jsx = 'javascript',
      php_only = 'php',
    },
    language_retrieval_patterns = {
      'languages/src/([^/]+)/[^/]+\\.scm$',
    },
  },
}
