return function()
  require('sniprun').setup({
    selected_interpreters = {
      'lua_nvim',
      'python3_jupyter',
      -- 'Python3_fifo',
      -- 'Julia_jupyter', -- requires external launch, write script for this
      'julia_original',
      'GFM_original',
    },
    repl_enable = {
      'Python3_jupyter',
      'Python3_fifo',
      -- 'Julia_jupyter', -- requires external launch, write script for this
      'Julia_original',
    },
    -- repl_disable = {},
    interpreter_options = {
      Python3_fifo = {
        interpreter = vim.fs.normalize('~/.local/pipx/venvs/jupyterlab/bin/python'),
        -- venv = { '~/.pyenv/versions/3.9.0/envs/pynvim', '~/.local/pipx/venvs' },
        venv = {
          '~/.local/pipx/venvs/jupyterlab',
          '~/.local/pipx/venvs',
          '~/.pyenv/versions/3.10.9/envs',
          '~/.pyenv/versions/3.9.0/envs',
          '~/.pyenv/versions/3.9.7/envs'
        },
        error_truncate = 'auto',
      },
      Python3_jupyter = {
        interpreter = vim.fs.normalize('~/.local/pipx/venvs/jupyterlab/bin/python'),
        venv = { '~/.local/pipx/venvs/jupyterlab' },
        error_truncate = 'auto',
      },
      Julia_original = {
        project = ".", -- either a fixed abs path, or a "." for nvims current directory (pwd)
                       -- directory must contain a {Project,Manifest}.toml
        interpreter = "/usr/local/bin/julia",
      },
     -- Julia_jupyter = {
     --   from the docs:
     --   jupyter-kernel --kernel=julia-1.8 --KernelManager.connection_file=$HOME/.cache/sniprun/julia_jupyter/kernel_sniprun.json
     --   interpreter = os.getenv('HOME') .. '/home/eo/.local/this'
     -- },

      GFM_original = {
        default_filetype = 'python'
      },
    },
    -- borders = as.style.current.border,
    display = {
      "LongTempFloatingWindow",
      -- "TempFloatingWindow",
      -- "VirtualText",
      "Terminal",
      -- "NvimNotify",
      -- "Api",
    }
  })
end
-- vim: set fdm=marker fdl=0:
