-- vim: set filetype=lua foldenable foldmethod=marker foldlevel=3
--[[ NOTE: Found in /numirias/semshi/issues/109 for dynamic python3_host_prog setting:
 let g:python3_host_prog= substitute(system("which python3"), \n\+$', '', '')
--]]
-- CRAG666/code_runner.nvim
-- sniprun
-- slime/kitty runner
-- magma
-- nvim-ipy
-- chrisamelia/dotfiles
local opt  = vim.opt
local optl = vim.opt_local
local bo   = vim.bo
local b    = vim.b
-- local cmd  = vim.cmd
-- local fn   = vim.fn

vim.g["python3_host_prog"] = "~/.local/pipx/venvs/jupyterlab/bin/python3"


local py3 = vim.g["python3_host_prog"]
vim.b.magma_kernel = py3
-- vim.b.magma_kernel = vim.fn.expand("~/.local/pipx/venvs/jupyterlab/bin/python3")

-- vim.b.magma_kernel = vim.fn.stdpath("~/.pyenv/versions/3.9.0/envs/pynvim/bin/python3")

-- opt.path:append "**"
bo.expandtab = true
optl.smarttab = true
bo.shiftwidth = 4
bo.tabstop = 4
bo.softtabstop = 4
bo.smartindent = true
bo.autoindent = true

vim.opt_local.path:append({ "src/" })
-- vim.opt_local.path:prepend({ "src/" })
as.nnoremap('<localleader>vl', [[<Cmd>MagmaEvaluateLine<CR>]])
as.xnoremap('<localleader>vv', [[<Cmd>MagmaEvaluateVisual<CR>]], { silent = true })

--- TODO: Need to finish the lsp settings for python using pylsp for hover, signature and pyright for autocomplete.
--- NOTE: Find the reddit thread where the guy showed you how to set up both lsps to do different things.

-- - XXX: Trying something a little different, its new until the next label: ("XXX")


-- local function filter_diagnostics(diagnostic)
--   if diagnostic.message == '"kwargs" is not accessed' then
--     return false
--   end
--   if diagnostic.message == '"args" is not accessed' then
--     return false
--   end
--   return true
-- end

-- local function custom_on_pub_diagnostics(a, params, client_id, c, config)
--   filter(params.diagnostics, filter_diagnostics)
--   vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
-- end

-- local pyright = require("lspconfig").pyright
-- pyright.setup {
--   settings = {
--     python = {
--       analysis = {
--         type_checking = "basic", -- off
--         auto_search_paths = true,
--         use_library_code_types = true,
--         -- typeCheckingMode = "basic",
--         -- useLibraryCodeTypes = true,
--         -- autoImportCompletions = true,
--         -- autoSearchPaths = true,
--         -- diagnosticSeverityOverrides = {
--         --   reportUndefinedVariable = "error",
--         --   reportMissingTypeStubs = "none",
--         --   reportIncompleteStub = "none",
--         --   reportInvalidStubStatement = "none"
--         -- },
--       },
--     },
--   },
-- }
---XXX: the return statement below is a part of this also.
-- local pylsp = lspinst
-- bo.magma_kernel = "pynvim"

--- TODO: need to create the whichkey mappings for python.
-- if not as then
--   return
-- end




-- local ok, whichkey = as.safe_require('which-key')
-- if not ok then
--   return
-- end

-- whichkey.register {
--   ['<localleader>P'] = {
--     name = '+Python',
--     -- b = { '<Cmd>Magma', '!python %' },
--     f = {
--       name = '+fix/fill',
--       s = { '<Cmd>lua magma<CR>', 'fill struct' },
--       p = { '<Cmd>GoFixPlurals<CR>', 'fix plurals' },
--     },
--   },
--   ie = { '<Cmd>GoIfErr<CR>', 'if err' },
-- }

-- return {
--   root_dir = function()
--     return vim.fn.getcwd()
--   end,
--   handlers = {
--     ---@diagnostic disable-next-line: unused-vararg
--
--     -- if you want to enable pylint diagnostics, turn on the comments below
--     -- ["textDocument/publishDiagnostics"] = function(...)
--     -- end
--
--     -- if you want to disable pyright from diagnosing unused parameters, turn on the function below
--     ["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_pub_diagnostics, {})
--   },
--   settings = {
--     python = {
--       analysis = {
--         -- type_checking = "basic", -- off
--         -- auto_search_paths = true,
--         -- use_library_code_types = true,
--         typeCheckingMode = "basic",
--         useLibraryCodeTypes = true,
--         autoImportCompletions = true,
--         autoSearchPaths = true,
--         diagnosticSeverityOverrides = {
--           reportUndefinedVariable = "error",
--           reportMissingTypeStubs = "none",
--           reportIncompleteStub = "none",
--           reportInvalidStubStatement = "none"
--         }
--       }
--     }
--   }
-- }

-- python << EOF
-- import os
-- import sys
-- import vim

-- virtualenv = os.environ.get("VIRTUAL_ENV")
-- if virtualenv is not None:
--     sys.path.insert(0, virtualenv)
--     activate_this = os.path.join(virtualenv, 'bin/activate.py')
--     execfile(activate_this, dict(__file__=activate_this))
-- EOF
