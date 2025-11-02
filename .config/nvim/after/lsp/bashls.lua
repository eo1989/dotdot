---@type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'zsh', 'sh', 'bash' },
  single_file_support = true,
  on_attach = function(client)
    if client.server_capabilities then
      -- bashls comes with shellcheck and shfmt iirc..but we're using conform \m/
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
  root_markers = {
    {
      'info.plist',
      '.zsh',
      '.zshrc',
      '.bashrc',
    },
    '.git',
  },
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
      includeAllWorkspaceSymbols = false, -- prevents var-renaming affecting other files
      shfmt = { spaceRedirects = true },
      -- shellcheckArguments = '--shell=bash',
    },
  },
}
