-- if not eo then return end

vim.lsp.config('*', {
  ---@diagnostic disable-next-line: param-type-mismatch
  capabilities = require('eo.lsp.capabilities').make_capabilities(),
})

vim.lsp.set_log_level(vim.log.levels.OFF)

local disabled = {
  emmylua_ls = true,
}

local configured = {
  'basedpyright',
  'bashls',
  'biome',
  'cmake',
  'dockerls',
  'gopls',
  'jsonls',
  'julials',
  'ltex-lsp-plus',
  'lua_ls',
  'marksman',
  'pyright',
  'ruff',
  'rust_analyzer',
  'sith-lsp',
  'sqlls',
  'tailwindcss',
  'taplo',
  'tombi',
  'ts_ls',
  'postgres_lsp', -- supabase-common/postgres-language-server
  'yamlls',
}

local function init()
  vim.iter(configured):each(vim.schedule_wrap(function(server_name)
    if disabled[server_name] then return end
    -- do
    vim.lsp.enable { server_name }
    -- vim.lsp.start { server_name }
    -- end
  end))
end

--[[ ---@param did_very_lazy boolean
---@return boolean ]]

-- vim.g.did_very_lazy = 1

-- if vim.g.did_very_lazy ~= nil then
vim.schedule(init)
-- else
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = '*',
  once = true,
  callback = function() vim.schedule_wrap(init) end,
})

-- vim.api.nvim_create_autocmd({ 'FileType', 'User' }, {
--   pattern = '*',
--   once = true,
--   callback = vim.schedule_wrap(init),
-- })
-- end
