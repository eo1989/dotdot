---@type vim.lsp.Config
return {
  cmd = { 'sith-lsp' },
  filetypes = {
    'python',
  },
  init_options = {
    settings = {
      ruff = {
        path = vim.fn.executable('ruff'),
      },
    },
  },
  root_dir = function(_bufnr, on_dir)
    if vim.env.SITH ~= nil and vim.env.JEDI == nil then on_dir(vim.uv.cwd()) end
  end,
  root_markers = {
    'pyproject.toml',
    'requirements.txt',
  },
  single_file_support = true,
}
