--[[ NOTE: Python3_fifo
      This is a pipe-based implementation that has some quirks:
      You have to run sniprun once before being able to send code snippets
      to it (configure an autocmd?)
      A python REPL is launched in the background and won't quit till you exit neovim.
      This interpreter only works in REPL-mode, and is not the default for Python
      files, so to use it you should configure it as following:

    NOTE: Python3_original
    To get the REPL behaviour (inactive by default) working, you need to install
    the klepto python package: `pip install --user klepto`
    Then, to enable the REPL behavior for python in your config file
    ```lua
    require'sniprun'.setup({
        repl_enable = {'Python3_original'}
    })
    ```
    HOWEVER, if you're interested in a very stable and solid REPL python
    interpreter, to process bigger amount of data or import some exotic
    modules (not supported by klepto), get a look at the Python3_fifo interpreter.
--]]
local border = eo.ui.current.border

local map = vim.keymap.set or vim.api.nvim_set_keymap

-- local function run_sniprun_section()
--   if vim.bo.filetype ~= "python" then
--     vim.notify("Run current cell is only available in Python files.", vim.log.levels.WARN)
--     return
--   end
--
--   local cursor_pos = vim.api.nvim_win_get_cursor(0)
--
--   local current_line = vim.fn.line(".")
--   local start_line = current_line
--   local end_line = current_line
--
--   while start_line > 1 do
--     local line_content = vim.fn.getline(start_line - 1)
--     if line_content:match("^# %%%%") then break end
--     start_line = start_line - 1
--   end
--
--   local total_lines = vim.fn.line("$")
--   while end_line < total_lines do
--     local line_content = vim.fn.getline(end_line + 1)
--     if line_content:match("^# %%%%") then
--       break
--     end
--   end_line = end_line + 1
--   end
--
--   if (end_line - start_line) > 100 then
--     local choice = { "Yes", "No" }
--     vim.ui.select(
--       choice,
--       { prompt = "Cell containing more than 100 lines, do you want to run SnipRun?" },
--       function(chosen)
--         if chosen ~= "Yes" then
--           vim.notify("Cancelled", vim.log.levels.INFO)
--           return
--         end
--
--         -- set the visual selection marks
--         vim.fn.setpos("'<", { 0, start_line, 1, 0 })
--         vim.fn.setpos("'>", { 0, end_line, 1, 0 })
--
--         -- execute sniprun on the visual selection
--         vim.cmd("'<,'>SnipRun")
--
--         -- restore the cursor position
--         vim.api.nvim_win_set_cursor(0, cursor_pos)
--       end
--     )
--   else
--     -- set the visual selection marks
--     vim.fn.setpos("'<", { 0, start_line, 1, 0 })
--     vim.fn.setpos("'>", { 0, end_line, 1, 0 })
--
--     vim.cmd("'<,'>SnipRun")
--
--     vim.api.nvim_win_set_cursor(0, cursor_pos)
--   end
-- end

-- map({ 'v', 'x', 'o' }, '<localleader>rs', function() run_sniprun_section() end, { desc = 'SnipRun Selection' })
-- map('<localleader>rc', run_sniprun_section, {desc = 'SR trial'})

---@type LazySpec
return {
  {
    'michaelb/sniprun',
    enabled = true,
    build = 'sh ./install.sh 1',
    -- event = { 'VeryLazy' },
    cmd = { 'SnipRun', 'SnipInfo', 'SnipReset', 'SnipClose', 'SnipReplMemoryClean' },
    -- cmd = 'SnipRun',
    keys = {
      {
        '<localleader>xx',
        '<Plug>SnipRun',
        -- mode = { 'v', 'x', 'o' },
        desc = 'SR Line',
      },
      {
        '<localleader>x',
        '<Plug>SnipRunOperator',
        desc = 'SR',
      },
      {
        '<localleader>x',
        '<Plug>SnipRun',
        mode = 'x',
        desc = 'SR',
      },
      {
        '<localleader>xQ',
        '<Plug>SnipReset',
        desc = 'SnipRun Reset',
      },
      {
        '<localleader>xX',
        '<Plug>SnipReplMemoryClean',
        desc = 'SnipRun Clean',
      },
      {
        '<localleader>xI',
        '<Plug>SnipInfo',
        desc = 'SnipRun Info',
      },
      {
        '<localleader>xL',
        '<Plug>SnipLive',
        desc = 'SnipRun Live',
      },
      {
        '<localleader>xq',
        '<Plug>SnipClose',
        desc = 'SnipRun Close',
      },
      -- {
      --   '<F2>',
      --   [[<cmd>b:caret=winsaveview()<CR>|:%SnipRun<CR>|call winrestview(b:caret)<CR>]],
      --   expr = true,
      --   silent = true,
      --   desc = 'SR Buffer',
      -- },
    },
    opts = {
      selected_interpreters = {
        'Python3_fifo',
        'GFM_original',
        'Python3_original',
        -- 'Python3_jupyter',
        'Julia_original',
      },
      repl_enable = {
        'Python3_jupyter',
        -- 'Python3_fifo',
        'GFM_original',
        'Julia_original',
        -- 'Python3_jupyter',
        -- 'julia_jupyter',
      },
      -- repl_disable = { 'lua_nvim' },
      interpreter_options = {
        Python3_fifo = {
          interpreter = vim.fn.expand('~/.pyenv/versions/gen/bin/python'),
          -- interpreter = vim.fn.expand('~/.local/pipx/venvs/jupyterlab/bin/python'),
          -- venv = vim.fn.expand('~/.local/pipx/venvs/jupyterlab'),
          venv = { vim.fn.expand('~/.pyenv/versions'), '../.venv', vim.fn.expand('~/Dev/') },
          error_truncate = 'auto',
        },
        Python3_jupyter = {
          interpreter = vim.fn.expand('~/.local/pipx/venvs/jupyterlab/bin/python'),
          venv = vim.fn.expand('~/.local/pipx/venvs/jupyterlab'),
          error_truncate = 'auto',
          use_on_filetypes = { 'quarto', 'markdown', 'markdown.pandoc', 'gfm' },
        },
        -- TODO: make this from a function
        --
        -- Julia_jupyter = {
        --   -- from the docs:
        --   -- jupyter-kernel --kernel=julia-1.8 --KernelManager.connection_file=$HOME/.cache/sniprun/julia_jupyter/kernel_sniprun.json
        --   interpreter = vim.env.HOME .. '/.julia/juliaup/julia-1.11.4+0.aarch64.apple.darwin14/bin/julia',
        -- },
        Julia_original = {
          interpreter = 'julia',
          project = '@.',
        },
        GFM_original = {
          default_filetype = 'python',
          use_on_filetypes = { 'markdown', 'markdown.pandoc', 'gfm', 'quarto' },
        },
      },
      borders = 'rounded',
      display = {
        'TerminalWithCode',
        'LongTempFloatingWindow',
      },
      display_options = {
        terminal_widths = 25,
        terminal_signcolumn = false,
        terminal_line_number = false,
        notification_timeout = 10,
      },
      live_mode_toggle = 'enable',
    },
    config = function(_, opts)
      require('sniprun').setup(opts)
      -- TODO: patch to use Kitty.lua
      -- local sd = require "sniprun.display"
      -- sd.term_close = function() end
      -- sd.term_open = function() end
      -- sd.write_to_term = function(message, ok) end
    end,
  },
}
