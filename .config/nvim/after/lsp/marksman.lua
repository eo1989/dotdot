---@type vim.lsp.Config
return {
  cmd = { 'marksman', 'serve' },
  filetypes = { 'markdown', 'quarto', 'markdown.mdx' },
  root_markers = {
    { '.marksman.toml' },
    '.git',
  },
  single_file_support = true,
}
