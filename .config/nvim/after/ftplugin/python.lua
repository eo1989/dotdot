---@diagnostic disable: unused-local
-- let g:python3_host_prog= substitute(system("which python3"), \n\+$', '', '')

-- CRAG666/code_runner.nvim
-- Sniprun
-- slime/kitty-runner
-- Magma
-- Nvim-ipy
-- chrisamelia/dotfiles

if not as then return end

local fn = vim.fn
local fmt = string.format
local opt = vim.opt
local optl = vim.opt_local
local bo = vim.bo

-- vim.b.formatting_disabled = { 'pyright', 'pylsp', 'jedi-language-server', 'pylance'}

local nnoremap = as.nnoremap
local vnoremap = as.vnoremap
local vmap = as.vmap
-- vim.g["python3_host_prog"] = "~/.local/pipx/venvs/jupyterlab/bin/python3"
-- vim.cmd([[ let g:python3_host_prog=substitute(system("which python3"), \n\+$', '', '') ]])


local py3 = vim.g['python3_host_prog']
vim.b.magma_kernel = py3

vim.keymap.set({"n", "v"}, "<F2>", [[:TermExec cmd="!!"<CR>]])
vim.keymap.set({"n", "v"}, "<F3>", [[:TermExec cmd="poetry run pytest"<CR>]])
-- local opts = {expr = true, silent = true, nowait = true }
-- map({ 'n', 'x' }, '<localleader>rp', '<Plug>SnipRun()', opts)

-- optl.magma_kernel = py3
-- vim.g['python_highlight_all'] = true
-- local dap = require('dap')



-- vim.cmd([[
-- try
--     python 'import site'
-- catch
--     finish
-- endtry
--
-- python<<EOF
-- import os
-- import sys
-- import vim
--
-- virtualenv = os.environ.get("VIRTUAL_ENV")
-- if virtualenv is not None:
--     sys.path.insert(0, virtualenv)
--     activate_this = os.path.join(virtualenv, 'bin/activate_this.py')
--     execfile(activate_this, dict(__file__=activate_this))
-- EOF
-- ]])

-- vnoremap('<localleader>mv', [[<Cmd>MagmaEvaluateVisual<CR>]], { silent = true })
-- vnoremap('<localleader>S', [[<Cmd>ToggleTermSendVisualSelection<CR>]])

-- vmap('<localleader>mr', [[<Cmd><C-u>MagmaEvaluateVisual<CR>]])
-- vmap('<localleader>ml', [[<Cmd>MagmaEvaluateLine<CR>]])
-- nnoremap('<localleader>mc', [[<Cmd>MagmaReevaluateCells<CR>]])
-- nnoremap('<localleader>mo', [[<Cmd>MagmaShowOutput<CR>]])
-- nnoremap('<localleader>mi', [[<Cmd>MagmaInit<CR>]])
-- nnoremap('<localleader>mu', [[<Cmd>MagmaDeinit<CR>]])
-- nnoremap('<localleader>md', [[<Cmd>MagmaDelete<CR>]])

-- nnoremap('<localeader>rp', [[<Cmd>TermExec cmd="python %:t"<CR>]])

-- nnoremap('<localleader>ts', [[<Cmd>ToggleTermSendCurrentLine<CR>]])

-- nnoremap('<localeader>r', [[<Cmd><>SnipRun<CR>]])
-- nnoremap('<localeader>rv', [[<Cmd>SnipLive<CR>]])

-- nnoremap('<F5>', ':let b:caret = winsaveview()<CR>:%SnipRun<CR>:call winrestview(b:caret)<CR>')

local wk = require("which-key")
wk.register({
  ['<localleader>'] = {
    k = {
      name = 'pyterm',
      k = {{ [[ ToggleTermSendVisualSelection<CR>]] }, mode = {'x', 'v'}},
    },
    r = {
      name = 'Runner',
        -- s = {{ [[ lua require('sniprun').run('v')<CR> ]], "Run visual Snippets" }, mode = {"v", "x"}},
        s = {{ [[function() require('sniprun').run('v')<CR> end]], "Run visual Snippets"}, mode = {"v", "x"}},
        p = {{ ":<Plug>SnipRunOperator<CR>", 'nRun Snippets'}, mode = 'n'}, -- this might break,
      },
     m = {
        name = 'Magma/Jupyter',
        c = {{'<Cmd>MagmaReevaluateCells<CR>', 'Reevaluate Cells' }, mode = 'n'},
        l = {{'<Cmd>MagmaEvaluateLine<CR>', 'Evaluate Line' }, mode = 'n'},
        v = {{'<Cmd>MagmaEvaluateVisual<CR>', 'Evaluate Visual'}, mode = 'x'},
        d = {{'<Cmd>MagmaDelete<CR>', 'Delete' }, mode = 'n'},
        o = {{'<Cmd>MagmaShowOutput<CR>', 'Show Output' }, mode = 'n'},
      },
    },
  })

-- as.ftplugin_conf('which-key', function(wk)
--   wk.register({
--     {
--       name = 'Magma',
--       c = { '<Cmd>MagmaReevaluateCells<CR>', 'Reevaluate Cells' },
--       l = { '<Cmd>MagmaEvaluateLine<CR>', 'Evaluate Line' },
--       v = { '<Cmd>MagmaEvaluateVisual<CR>', 'Evaluate Visual' },
--       d = { '<Cmd>MagmaDelete<CR>', 'Delete' },
--       o = { '<Cmd>MagmaShowOutput<CR>', 'Show Output' },
--       i = { '<Cmd>MagmaInit<CR>', 'Init' },
--       u = { '<Cmd>MagmaDeinit<CR>', 'Deinit' },
--     },
--     ['<localleader>r'] = {
--       name = 'CodeRun',
--       -- p = { '<Cmd>TermExec cmd="python %:t"<CR>', 'Python run' },
--       r = { "<Cmd>TermExec cmd='python %:t'<CR>", 'python repl run' },
--       s = { ":'<,'>Sniprun % <CR>', 'SnipVisualSelection Python" },
--     },
--   })
-- end)

as.ftplugin_conf('nvim-surround', function(surround)
  local get_input = function(prompt)
    local ok, input = pcall(vim.fn.input, prompt)
    if not ok then
      return
    end
    return input
  end
  surround.buffer_setup({
    surrounds = {
      l = { add = { 'def ():', 'return ' } },
      F = {
        add = function()
          return {
            { fmt('def %s(): ', get_input('Enter a function name: ')) },
            { 'return ' },
          }
        end,
      },
      i = {
        add = function()
          return {
            { fmt('if %s', get_input('Enter a condition') ":") },
            { " else:\n%s"}
          }
        end,
      },
    },
  })
end)

-- v = { '<Cmd>Sniplive<CR>', "SnipLive toggle" },
-- ie = { '<Cmd>SnipRun<CR>', 'if err' },

--NOTE: add this somewhere else
-- To turn one line into title caps, make every first letter of a word
-- uppercase:
-- 	:s/\v<(.)(\w*)/\u\1\L\2/g

--- {{{
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

-- vim.api.nvim_exec([[
-- vim.cmd [[
-- " function! GetKernelFromPoetry()
-- "   let l:kernel = tolower(system('basename $(poetry shell)'))
-- "   " Remove ctrl chars (most importantly newline
-- "   " echo substitute(l:kernel, '[[:cntrl:\]\]', '', 'g')
-- "   return substitute(l:kernel, '[[:cntrl:\]\]', '', 'g')
-- " endfunction
--
-- function! StartConsolePoetry(console)
--   let l:flags = '--kernel ' . GetKernelFromPoetry()
--   let l:command=a:console . ' ' . l:flags
--   call jobstart(l:command)
-- endfunction
--
-- function! AddFilepathToSyspath()
--   let l:filepath = expand('%:p:h')
--   call IPyRun('import sys; sys.path.append("' . l:filepath . '")')
--   echo 'Added ' . l:filepath . ' to pythons sys.path'
-- endfunction
--
-- function! GetPoetryVenv()
--   let l:poetry_config = findfile('pyproject.toml', getcwd().';')
--   let l:root_path = fnamemodify(l:poetry_config, ':p:h')
--   if !empty(l:poetry_config)
--     let l:virtualenv_path = system('cd '.l:root_path.' && poetry env list --full-path')
--     return l:virtualenv_path
--   endif
-- endfunction
--
-- funtion! GetPythonVenv()
--   let l:venv_path = GetPoetryVenv()
--   if empty(l:venv_path)
--     return v:null
--   else
--     return l:venv_path
--   endif
-- endfunction
--
-- " Starts Qt console and connect to an existing ipykernel
-- command! -nargs=0 RunQtConsole call jobstart("jupyter qtconsole --existing")
-- " Starts Poetry kernel
-- command! -nargs=0 RunPoetryKernel terminal /bin/bash -i -c 'poetry run python -m ipykernel'
-- " Connects nvim-ipy to the existing ipykernel (non-/interactive)
-- command! -nargs=0 ConnectConsole terminal /bin/bash -i -c 'jupyter console --existing'
-- command! -nargs=0 AddFilepathToSyspath call AddFilepathToSyspath()
-- ]]
--- }}}
-- vim:ft=lua:fdm=marker:foldlevel=3:
