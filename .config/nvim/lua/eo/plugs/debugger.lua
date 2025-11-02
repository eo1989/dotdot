local fn = vim.fn
local icons, highlight, border, palette = eo.ui.icons, eo.highlight, eo.ui.current.border, eo.ui.palette

eo.debug = { layout = { ft = { dart = 2 } } }

---@type LazySpec
return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    keys = {
      {
        '<localleader>dL',
        function() require('dap').set_breakpoint(nil, nil, fn.input('Log point message: ')) end,
        desc = 'dap: log breakpoint',
      },
      {
        '<localleader>db',
        function() require('dap').toggle_breakpoint() end,
        desc = 'dap: toggle breakpoint',
      },
      {
        '<localleader>dB',
        function() require('dap').set_breakpoint(fn.input('Breakpoint condition: ')) end,
        desc = 'dap: set conditional breakpoint',
      },
      {
        '<localleader>dc',
        function() require('dap').continue() end,
        desc = 'dap: continue or start debugging',
      },
      {
        '<localleader>duc',
        function() require('dapui').close(eo.debug.layout.ft[vim.bo.ft]) end,
        desc = 'dap ui: close',
      },
      {
        '<localleader>dut',
        function() require('dapui').toggle(eo.debug.layout.ft[vim.bo.ft]) end,
        desc = 'dap ui: toggle',
      },
      { '<localleader>dt', function() require('dap').repl.toggle() end, desc = 'dap: toggle repl' },
      { '<localleader>de', function() require('dap').step_out() end, desc = 'dap: step out' },
      { '<localleader>di', function() require('dap').step_into() end, desc = 'dap: step into' },
      { '<localleader>do', function() require('dap').step_over() end, desc = 'dap: step over' },
      { '<localleader>dl', function() require('dap').run_last() end, desc = 'dap REPL: run last' },
      {
        '<localleader>duh',
        function() require('dap.ui.widgets').hover() end,
        mode = { 'n', 'v' },
        desc = 'dap-ui widgets: hover',
      },
      {
        '<localleader>dup',
        function() require('dap.ui.widgets').preview() end,
        mode = { 'n', 'v' },
        desc = 'dap-ui widgets: preview',
      },
      {
        '<localleader>duf',
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.frames)
        end,
        mode = { 'n' },
        desc = 'dap-ui centered widget frames',
      },
      {
        '<localleader>dus',
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.scopes)
        end,
        mode = { 'n' },
        desc = 'dap-ui centered widget scopes',
      },
    },
    config = function()
      local dap = require('dap') -- NOTE: must be loaded before the signs can be tweaked
      local dapui = require('dapui')
      require('dapui').setup()
      require('nvim-dap-virtual-text').setup()
      require('dap-python').setup('uv')

      highlight.plugin('dap', {
        { DapBreakpoint = { fg = palette.light_red } },
        { DapStopped = { fg = palette.green } },
      })

      fn.sign_define {
        { name = 'DapBreakpoint', texthl = 'DapBreakpoint', text = icons.misc.bug, linehl = '', numhl = '' },
        { name = 'DapStopped', texthl = 'DapStopped', text = icons.misc.bookmark, linehl = '', numhl = '' },
      }

      -- DON'T automatically stop at exceptions
      -- dap.defaults.fallback.exception_breakpoints = {}

      -- if not ui_ok then return end
      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open(eo.debug.layout.ft[vim.bo.ft]) end
    end,
    dependencies = {
      {
        {
          'rcarriga/nvim-dap-ui',
          event = 'VeryLazy',
          opts = {
            windows = { indent = 2 },
            floating = { border = border },
            layouts = {
              {
                elements = {
                  { id = 'scopes', size = 0.25 },
                  { id = 'breakpoints', size = 0.25 },
                  { id = 'stacks', size = 0.25 },
                  { id = 'watches', size = 0.25 },
                },
                position = 'left',
                size = 20,
              },
              { elements = { { id = 'repl', size = 0.9 } }, position = 'bottom', size = 12 },
            },
          },
        },
        { 'LiadOz/nvim-dap-repl-highlights', enabled = false },
        {
          'mfussenegger/nvim-dap-python',
          ft = 'python',
          lazy = false,
        },
        { 'theHamsta/nvim-dap-virtual-text', event = 'VeryLazy', opts = { all_frames = true } },
      },
    },
  },
  -- {
  --   'mxsdev/nvim-dap-vscode-js',
  --   ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  --   dependencies = { 'mfussenegger/nvim-dap' },
  --   opts = {
  --     adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'node-terminal', 'pwa-extensionHost' },
  --     node_path = 'node',
  --     debugger_cmd = { 'js-debug-adapter' },
  --   },
  --   config = function(_, opts)
  --     require('dap-vscode-js').setup(opts)
  --     for _, language in ipairs { 'typescript', 'typescriptreact', 'javascript' } do
  --       require('dap').configurations[language] = {
  --         {
  --           type = 'chrome',
  --           request = 'launch',
  --           name = 'Launch Chrome against localhost',
  --           url = 'http://localhost:3000',
  --           webRoot = '${workspaceFolder}',
  --         },
  --         {
  --           type = 'pwa-node',
  --           request = 'attach',
  --           name = 'Attach',
  --           processId = require('dap.utils').pick_process,
  --           cwd = '${workspaceFolder}',
  --         },
  --       }
  --     end
  --   end,
  -- },
}
