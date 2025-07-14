M = {}

local DEBUG_INFO_KINDS = {
  'tokens',
  'nodes',
  'types',
  'cachedtypes',
  'codeflowgraph',
}

---@param kind string
local function dump_file_debug_info(kind)
  local current_lsp_log_level = vim.lsp.log.get_level()
  vim.lsp.set_log_level(vim.log.levels.INFO)
  eo.get_client('basedpyright'):exec_cmd(
    {
      title = 'Pyright: Dump debug info',
      command = 'pyright.dumpFileDebugInfo',
      arguments = { vim.uri_from_bufnr(0), kind },
    },
    nil,
    function()
      vim.cmd.tabedit(vim.fs.joinpath(vim.fn.stdpath('log'), 'lsp.pyright.log'))
      map('n', 'q', '<Cmd>quit<CR>', { buffer = true })
      vim.lsp.set_log_level(current_lsp_log_level)
    end
  )
end

-- setup buffer local commands for the `based|pyright` extension features.
---@param _ vim.lsp.Client
---@param bufnr integer | number | 0
function M.on_attach(_, bufnr)
  vim.api.nvim_buf_create_user_command(
    0,
    'PyrightDumpFileDebugInfo',
    function(data) dump_file_debug_info(data.fargs[1]) end,
    {
      nargs = 1,
      complete = function(arglead)
        return vim.iter(DEBUG_INFO_KINDS):filter(function(kind) return kind:match(arglead) end):totable()
      end,
      desc = 'Pyright: Dump debug info for the current buffer',
    }
  )
end

return M
