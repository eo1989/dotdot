local M = {}

function M.setup()
  as.nnoremap('<localleader>rs', '<Cmd>SnipRun<CR>', 'sniprun: run code snippet')
  -- as.vnoremap('<localleader>rs', ":'<,'>SnipRun<CR>", 'sniprun: run visual selection')
  as.vnoremap('<localleader>rs', function() require('sniprun').run('v') end, 'sniprun: run visual selection')
  -- as.nnoremap('<localleader>rs')
end

-- return function()
function M.config()
  require('sniprun').setup({
    selected_interpreters = {
      'Python3_jupyter',
      'Python3_fifo',
      -- 'Julia_jupyter', -- requires external launch, write script for this
      'Julia_original',
      'GFM_original',
      -- 'Go_original',
      -- 'Cpp_original',
      'Bash_original',
    },
    repl_enable = {
      'Python3_jupyter',
      'Python3_fifo',
      -- 'Julia_jupyter', -- requires external launch, write script for this
      'Julia_original',
      -- 'Go_original',
      -- 'Cpp_original',
    },
    repl_disable = {},
    interpreter_options = {
      Python3_fifo = {
      interpreter = vim.fs.normalize('~/.pyenv/versions/pynvim/bin/python'),
        -- interpreter = 'python3',
        -- venv = { '~/.pyenv/versions/3.9.0/envs/pynvim', '~/.local/pipx/venvs' },
        venv = { '~/.pyenv/versions/3.9.0/envs/pynvim' },
        error_truncate = 'auto',
      },
      Python3_jupyter = {
        interpreter = vim.fs.normalize('~/.local/pipx/venvs/jupyterlab/bin/python'),
        -- interpreter = 'python',
        venv = { '~/.local/pipx/venvs/jupyterlab' },
        error_truncate = 'auto',
      },
      -- Julia_jupyter = {
      --   from the docs:
      --   jupyter-kernel --kernel=julia-1.8 --KernelManager.connection_file=$HOME/.cache/sniprun/julia_jupyter/kernel_sniprun.json
      --   interpreter = os.getenv('HOME') .. '/home/eo/.local/this'
      -- },
      {
        GFM_original = {
          default_filetype = 'python'
        },
      },
    },
    -- show_no_output = {
    --   "TerminalWithCode",
    -- },
    display = {
      "LongTempFloatingWindow",
      "VirtualTextOk",
      -- "VirtualTextErr",
      "TerminalWithCode",
      "NvimNotify",
      -- "Api",
    },
  })
end

-- local M = {}
-- M.config = function()
return M
