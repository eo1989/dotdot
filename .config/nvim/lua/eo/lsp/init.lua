-- if not eo then return end
local env, fn, fs = vim.env, vim.fn, vim.fs

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

vim.lsp.config('*', {
  -- -@diagnostic disable-next-line: param-type-mismatch
  capabilities = require('eo.lsp.capabilities').make_capabilities(),
} --[[@as vim.lsp.Config]])

local disabled = {
  emmylua_ls = true,
  sith_lsp = true,
  zuban = true,
  ty = true,
  ['ltex-lsp_plus'] = true,
  pyright = true,
}

local configured = {
  'basedpyright',
  'bashls',
  'biome',
  'dockerls',
  'gopls',
  'jsonls',
  'julials',
  'lua_ls',
  'marksman',
  'markdown_oxide',
  'ltex-lsp-plus',
  'pyright',
  'ruff',
  'rust_analyzer',
  'sqlls',
  'tailwindcss',
  'taplo',
  'tombi',
  'ty',
  'postgres_lsp', -- supabase-common/postgres-language-server
  'yamlls',
  'zuban',
}

local function init()
  vim.iter(configured):each(vim.schedule_wrap(function(servers)
    if disabled[configured] then return end

    vim.lsp.enable(configured, true)
  end))
end

if vim.g.did_very_lazy ~= nil then
  vim.schedule(init)
else
  vim.api.nvim_create_autocmd({ 'User' }, {
    -- pattern = 'VeryLazy',
    once = true,
    buffer = 0,
    callback = vim.schedule_wrap(init),
  })
end

-- vim.api.nvim_create_autocmd({ 'FileType', 'User' }, {
--   -- pattern = { '' },
--   once = true,
--   callback = vim.schedule_wrap(init),
-- })
-- end
