local env, fn, fs = vim.env, vim.fn, vim.fs

vim.lsp.config('*', {
  capabilities = require('eo.lsp.capabilities').make_capabilities(),
})

-- local code_actions = {
--   'quickfix',
--   'refactor.rewrite',
--   'source',
--   'source.fixAll',
--   'source.organizeImports',
-- }

-- Return the stem part of the path, ie: without any extension
---@param path string
---@return string
-- local function file_stem(path)
--   local filename = fs.basename(path)
--   local last_dot = filename:reverse():find('%.')
--
--   return filename:sub(1, last_dot and -last_dot - 1 or #filename)
-- end

---Return the XDG config path to a file
---@param path string
---@return string
-- local function xdg_config(path)
--   return fs.joinpath(vim.env.XDG_CONFIG_HOME or fs.abspath(fn.expand('~') .. '/.config/'), path)
-- end

local disabled = {
  emmylua_ls = true,
  sith_lsp = true,
  zuban = true,
  ty = true,
  ['ltex-lsp_plus'] = true,
  pyright = true,
  pyrefly = true,
  -- basedpyright = false,
  typos_lsp = true,
  codebook = true,
}

local configured = {
  'basedpyright',
  'bashls',
  'biome',
  'gopls',
  'dotls',
  'jsonls',
  'julials',
  'lua_ls',
  'marksman',
  -- 'pyright',
  'ruff',
  'rumdl',
  'rust_analyzer',
  'sqlls',
  -- 'tailwindcss',
  'taplo',
  'tombi',
  'ty',
  'postgres_lsp', -- supabase-common/postgres-language-server
  'yamlls',
  'zuban',
}

local function init()
  vim.iter(configured):each(vim.schedule_wrap(function(server_name)
    if disabled[server_name] then return end
    vim.lsp.enable(server_name)
  end))
end

if vim.g.did_very_lazy ~= nil then
  vim.schedule(init)
else
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    once = true,
    callback = vim.schedule_wrap(init),
  })
end

-- vim.api.nvim_create_autocmd({ 'FileType', 'User' }, {
--   pattern = { '*' },
--   once = true,
--   callback = vim.schedule_wrap(init),
-- })

-- return M
