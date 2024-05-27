local border = eo.ui.current.border
-- local map = map or vim.keymap.set

--@param env: string
--@return string[]
local function py_env()
  local ok, venv = pcall(require, 'venv-selector')
  if ok then
    -- return require('venv-selector.venv').current_venv()
    -- return require("venv-selector.system").getenv
    return require('venv-selector.venv').activate_venv()
  else
    return os.getenv('VIRTUAL_ENV')
  end
end

return {
  {
    'michaelb/sniprun',
    build = 'sh ./install.sh',
    branch = 'dev',
    cmd = { 'SnipRun', 'SnipInfo', 'SnipReset', 'SnipClose' },
    lazy = false,
    keys = {
      {
        '<localleader>rs',
        function() require('sniprun').run('v') end,
        desc = 'Run Selection',
        expr = true,
        mode = 'v',
      },
      {
        mode = 'n',
        '<F2>',
        [[<cmd>b:caret=winsaveview()<CR>|:%SnipRun<CR>|call winrestview(b:caret)<CR>]],
        { silent = true, expr = true },
      },
      { mode = 'n', '<F3>', [[<cmd>SnipClose<CR>]] },
      { mode = 'n', '<F4>', [[<cmd>SnipReset<CR>]] },
      { mode = 'n', '<F10>', [[<cmd>SnipInfo<CR>]] },
    },
    opts = {
      selected_interpreters = {
        'lua_nvim',
        'Python3_fifo',
        'GFM_original',
      },
      repl_enable = {
        'Python3_jupyter',
        'Julia_original',
      },
      repl_disable = { 'lua_nvim' },
      interpreter_options = {
        Python3_fifo = {
          interpreter = vim.fn.expand('~') .. '/.pyenv/versions/gen/bin/python',
          -- venv = vim.fn.expand('~/.local/pipx/venvs/jupyterlab'),
          venv = py_env or vim.fn.expand('~') .. '/.pyenv/versions',
          error_truncate = 'auto',
        },
        Python3_jupyter = {
          -- interpreter = vim.fn.expand('~') .. '/.local/pipx/venvs/jupyterlab/bin/python',
          venv = vim.fn.expand('~') .. '/.local/pipx/venvs/jupyterlab',
          error_truncate = 'auto',
        },
        -- TODO: make this from a function
        -- Julia_jupyter = {
        --   from the docs:
        --   jupyter-kernel --kernel=julia-1.8 --KernelManager.connection_file=$HOME/.cache/sniprun/julia_jupyter/kernel_sniprun.json
        --   interpreter = os.getenv('HOME') .. '/home/eo/.local/this'
        -- },
        julia_original = {
          interpreter = 'julia',
          project = '.',
        },
        GFM_original = {
          default_filetype = 'python',
        },
      },
      borders = border,
      display = {
        -- 'VirtualTextOk',
        'VirtualTextError',
        'LongTempFloatingWindow',
        -- 'NvimNotify',
        -- 'TerminalWithCode',
      },
      display_options = {
        terminal_widths = 20,
        notification_timeout = 10,
      },
    },
  },
}
