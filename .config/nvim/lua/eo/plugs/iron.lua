---@type LazySpec
return {
  {
    'Vigemus/iron.nvim',
    enabled = false,
    ft = { 'markdown', 'quarto', 'python', 'julia', 'r', 'ipynb', 'lua', 'sh', 'zsh', 'haskell' },
    lazy = true,
    config = function()
      local common = require('iron.fts.common')

      require('iron.core').setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { 'zsh' },
            },
            python = {
              command = {
                'uv',
                'run',
                '--with=ipython',
                '--with=rich',
                '--',
                'ipython',
                "--profile-dir='~/.ipython/'",
                '--no-autoindent',
              },
              format = common.bracketed_paste_python,
              block_deviders = { '# %%', '#%%' },
            },
            julia = {
              command = {
                'julia',
                '--project=@.',
                '--threads=auto',
                '--banner=no',
                -- '--startup-file=yes',
              },
              format = common.bracketed_paste,
              block_dividers = { '# %%', '#%%' },
            },
          },
          repl_open_cmd = require('iron.view').bottom('30%'),
          -- repl_open_cmd = require('iron.view').split.vertical(0.5, {
          --   winfixwidth = false,
          --   winfixheight = false,
          -- }),
        },
        ignore_blank_lines = true,
      }
    end,
    keys = {
      { '<leader>rr', function() require('iron.core').send_line() end, desc = 'Send line' },
      { '<leader>rr', function() require('iron.core').visual_send() end, desc = 'Send selection', mode = 'x' },
      { '<leader>rR', function() require('iron.core').send_file() end, desc = 'Send file' },
      { '<leader>rm', function() require('iron.core').send_motion() end, desc = 'Send motion' },
      { '<leader>rf', '<cmd>IronFocus<cr>', desc = 'Focus REPL' },
      { '<leader>rq', function() require('iron.core').close_repl() end, desc = 'Close REPL' },
      { '<leader>rQ', function() require('iron.core').repl_restart() end, desc = 'Restart REPL' },
    },
  },
}
