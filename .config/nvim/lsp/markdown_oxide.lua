local api = vim.api
return {
  root = { '.git', '.obisidian', '.moxide.toml' },
  filetypes = { 'markdown' },
  cmd = { 'markdown-oxide' },
  on_attach = function(_, bufnr)
    api.nvim_buf_create_user_command(
      bufnr,
      'LspToday',
      function() vim.lsp.buf.execute_command { command = 'jump', arguments = { 'today' } } end,
      {
        desc = "Open today's daily note",
      }
    )
    api.nvim_buf_create_user_command(
      bufnr,
      'LspTomorrow',
      function() vim.lsp.buf.execute_command { command = 'jump', arguments = { 'tomorrow' } } end,
      {
        desc = "Open tomorrow's daily note",
      }
    )
    api.nvim_buf_create_user_command(
      bufnr,
      'LspYesterday',
      function() vim.lsp.buf.execute_command { command = 'jump', arguments = { 'yesterday' } } end,
      {
        desc = "Open yesterday's daily note",
      }
    )
  end,
}
