local env, fn, fs = vim.env, vim.fn, vim.fs

-- local capabilities = require('eo.lsp.capabilities').capabilities

-- vim.lsp.config('*', {
--   capabilities = capabilities,
--   root_markers = { '*.git' },
-- } --[[@as vim.lsp.Config]])

-- local disabled = {
--   emmylua_ls = true,
--   sith_lsp = true,
--   zubanls = true,
--   ty = true,
--   ['ltex-lsp_plus'] = true,
--   pyright = true,
--   pyrefly = true,
--   typos_lsp = true,
--   codebook = true,
--   taplo = true,
-- }

-- local configured = {
--   'basedpyright',
--   'bashls',
--   'biome',
--   'gopls',
--   'dotls',
--   'jsonls',
--   'jetls',
--   'julials',
--   'lua_ls',
--   'marksman',
--   'markdown-oxide',
--   'pyrefly',
--   'pytest-language-server',
--   'ruff',
--   'rumdl',
--   'rust_analyzer',
--   'sqls',
--   'sqlls',
--   'taplo',
--   'tombi',
--   'ty',
--   'postgres_lsp', -- supabase-common/postgres-language-server
--   'yamlls',
--   'zubanls',
-- }

-- local function init()
--   vim.iter(configured):each(vim.schedule_wrap(function(server_name)
--     if disabled[server_name] then return end
--     vim.lsp.enable(server_name)
--   end))
-- end

-- if vim.g.did_very_lazy ~= nil then
--   vim.schedule(init)
-- else
--   vim.api.nvim_create_autocmd('User', {
--     pattern = 'VeryLazy',
--     once = true,
--     callback = vim.schedule_wrap(init),
--   })
-- end

-- vim.api.nvim_create_autocmd({ 'FileType', 'User' }, {
--   pattern = { '*' },
--   once = true,
--   callback = vim.schedule_wrap(init),
-- })

-- return M
