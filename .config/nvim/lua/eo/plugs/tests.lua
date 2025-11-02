-- local map = vim.api.nvim_set_keymap or vim.keymap.set
-- local misc = eo.ui.icons.misc

---@type LazySpec
return {
  {
    'nvim-neotest/neotest',
    enabled = true,
    version = '*',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-neotest/neotest-python',
      -- 'nvim-neotest/neotest-go',
      'nvim-lua/plenary.nvim',
      'stevearc/overseer.nvim',
    },
    -- keys = {
    --   {
    --     '<localleader>ta',
    --     function()
    --       for _, adaptor_id in ipairs(require('neotest').run.adaptors()) do
    --         require('neotest').run.run { suite = true, adaptor = adaptor_id }
    --       end
    --     end,
    --     mode = 'n',
    --   },
    --   {
    --     '<localleader>tn',
    --     function() require('neotest').run.run {} end,
    --     -- ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
    --     mode = 'n',
    --     desc = 'Run all tests in this file',
    --   },
    --   {
    --     '<localleader>tp',
    --     function() require('neotest').summary.toggle() end,
    --     mode = 'n',
    --     desc = 'Toggle the summary window',
    --   },
    --   {
    --     '<localleader>to',
    --     function() require('neotest').output.open { short = true } end,
    --     mode = 'n',
    --   },
    --   {
    --     '<localleader>tt',
    --     function() require('neotest').run.run { vim.api.nvim_buf_get_name(0) } end,
    --     mode = 'n',
    --     desc = 'Run the nearest test',
    --   },
    --   {
    --     '<localleader>tl',
    --     function() require('neotest').run.run_last() end,
    --     mode = 'n',
    --   },
    --   -- {
    --   --   '<localleader>ts',
    --   --   function() require('neotest').run.stop() end,
    --   --   mode = 'n',
    --   --   desc = 'Stop the test',
    --   -- },
    --   {
    --     '<localleader>td',
    --     function() require('neotest').run.run { strategy = 'dap' } end,
    --     mode = 'n',
    --     desc = 'Debug the nearest test function',
    --   },
    -- },
    config = function()
      local neotest = require('neotest')
      local namespace = vim.api.nvim_create_namespace('neotest')
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local value = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return value
          end,
        },
      }, namespace)
      neotest.setup {
        discovery = { enabled = true },
        diagnostic = { enabled = true },
        -- floating = {
        --   border = eo.ui.current.border,
        -- },
        quickfix = { enabled = false, open = true },
        output = {
          enabled = true,
          open_on_run = false,
        },
        status = {
          enabled = true,
        },
        consumers = { overseer = require('neotest.consumers.overseer') },
        adapters = {
          -- require('neotest-plenary'),
          -- require('neotest-go'),
          require('neotest-python') {
            dap = { justMyCode = false },
            -- Use whatever Python is on the path from the virtualenv.
            python = 'python',
            runner = 'pytest',
            args = {
              '--log-level',
              'DEBUG',
              '-vv',
            },
          },
        },
        summary = {
          mapping = {
            attach = 'a',
            expand = 'l',
            expand_all = 'L',
            jumpto = 'gf',
            output = 'o',
            run = '<C-r>',
            short = 'p',
            stop = 'u',
          },
        },
        icons = {
          -- passed = misc.passed or '󰄴',
          -- running = misc.running or '󰴲',
          -- failed = misc.running or '',
          -- unknown = misc.unknown or '❓',
          passed = '󰄴 ',
          running = '󰴲 ',
          failed = ' ',
          unknown = '❓',
          running_animated = vim.tbl_map(
            function(s) return s .. ' ' end,
            { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
          ),
        },
      }
      map('n', '<localleader>tn', function() neotest.run.run {} end, { desc = 'neotest: run' })
      map(
        'n',
        '<localleader>tt',
        function() neotest.run.run { vim.api.nvim_buf_get_name(0) } end,
        { desc = 'neotest: run buf' }
      )
      map('n', '<localleader>ta', function()
        for _, adaptor_id in ipairs(require('neotest').run.adaptors()) do
          require('neotest').run.run { suite = true, adaptor = adaptor_id }
        end
      end, { desc = 'neotest: run adapter/suite' })
      map('n', '<localleader>tl', function() neotest.run.run_last() end, { desc = 'neotest: run last' })
      map('n', '<localleader>td', function() neotest.run.run { strategy = 'dap' } end, { desc = 'neotest: run w/ dap' })
      map('n', '<localleader>tp', function() neotest.summary.toggle() end, { desc = 'neotest: toggle summary' })
      map(
        'n',
        '<localleader>to',
        function() neotest.output.open { short = true } end,
        { desc = 'neotest: open output' }
      )
      -- map('n', '<localleader>ts', function() neotest.run.stop() end)
    end,
  },
}
