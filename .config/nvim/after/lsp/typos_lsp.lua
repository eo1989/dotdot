local env, fn = vim.env, vim.fn
local xdg_config = env.XDG_CONFIG_HOME or (env.HOME .. '/.config')

---@type vim.lsp.Config
return {
  cmd = { 'typos-lsp' },
  filetypes = { 'markdown', 'quarto' },
  root_dir = {
    'typos.toml',
    '_typos.toml',
    '.typos.toml',
  },
  cmd_env = { RUST_LOG = 'error' },
  ---@param client vim.lsp.Client
  init_options = {
    -- config = xdg_config .. '/typos/.typos.toml',
    config = fn.stdpath('config') .. '/after/lsp/typos_lsp_global_config.toml',
    diagnosticSeverity = 'Error',
  },
}
