local api, fn = vim.api, vim.fn
local icons, highlight, border, palette = eo.ui.icons, eo.highlight, eo.ui.current.border, eo.ui.palette

local keymap = api.nvim_set_keymap
local bufmap = api.nvim_buf_set_keymap
local autocmd = api.nvim_create_autocmd

eo.debug = { layout = { ft = { python = 2 } } }

---@type LazySpec
return {
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
      function() require('dap').set_breakpoint(fn.input('breakpoint condition: ')) end,
      desc = 'dap: set conditional breakpoint',
    },
    {
      '<localleader>dc',
      function() require('dap').continue() end,
      desc = 'dap: continue or start debugging',
    },
    { '<localleader>dt', function() require('dap').repl.toggle() end, desc = 'dap: toggle repl' },
    -- { '<localleader>de', function() require('dap').step_out() end, desc = 'dap: step out' },
    -- { '<localleader>di', function() require('dap').step_into() end, desc = 'dap: step into' },
    -- { '<localleader>do', function() require('dap').step_over() end, desc = 'dap: step over' },
    { '<localleader>dl', function() require('dap').run_last() end, desc = 'dap REPL: run last' },
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
    local dap = require('dap')
    local dapui = require('dapui')

    -- require('dapui').setup()
    -- require('dap-view').setup {
    --   winbar = {
    --     sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl', 'console' },
    --   },
    --   windows = {
    --     height = math.ceil(vim.o.lines / 3),
    --   },
    -- }

    -- local dv = require('dap-view')

    -- require('nvim-dap-virtual-text').setup()

    require('nvim-dap-julia').setup()
    require('dap-python').setup('debugpy-adaptor') -- debugpy-adaptor | uv

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

    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end

    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    -- dap.listeners.before.attach['dap-view-config'] = dv.open()

    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    -- dap.listeners.before.launch['dap-view-config'] = function() dv.open() end

    -- dap.listeners.before.event_terminated['dap-view-config'] = function() dv.close() end

    -- dap.listeners.before.event_exited['dap-view-config'] = function() dv.close() end

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open(eo.debug.layout.ft[vim.bo.ft]) end

    local opts = function(desc) return { noremap = true, desc = desc } end

    --[[
      <S-F5> = <F17> <-
      <S-F8> = <F20>
      <S-F9> = <F21> <-
      <S-F10> = <F22>
      <S-F11> = <F23>
      ]]
    keymap('n', '<F5>', '<cmd>lua require("dap").continue()<CR>', opts('dap continue'))
    keymap('n', '<F6>', '<cmd>lua require("dap").pause()<CR>', opts('dap pause'))
    keymap('n', '<S-F5>', '<cmd>lua require("dap").close()<CR>', opts('dap close'))
    keymap('n', '<F8>', '<cmd>lua require("dap").run_to_cursor()', opts('dap run to cursor'))
    keymap('n', '<F9>', '<cmd>lua require("dap").toggle_breakpoint()<CR>', opts('dap breakpoint'))
    keymap(
      'n',
      '<S-F9>',
      '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
      opts('dap conditional breakpoint')
    )

    keymap('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', opts('dap step over'))
    keymap('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', opts('dap step into'))
    keymap('n', '<S-F11>', '<cmd>lua require"dap".step_out()<CR>', opts('dap step out'))

    -- iterminal special keysequence
    --[[
      <S-F5> = <F17> <-
      <S-F6> = <F18>
      <S-F7> = <F19>
      <S-F8> = <F20>
      <S-F9> = <F21>
      <S-F10> = <F22>
      <S-F11> = <F23> <-
      ]]
    keymap('n', '<F17>', '<cmd>lua require"dap".close()<CR>', opts('dap close'))
    keymap('n', '<F23>', '<cmd>lua require"dap".step_out()<CR>', opts('dap step out'))
    keymap(
      'n',
      '<F21>',
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      opts('dap conditional breakpoint')
    )

    -- dapview

    -- keymap('n', '<localleader>dt', '<cmd>DapViewToggle<CR>', opts('dap view toggle'))
    -- keymap('n', '<localleader>dw', '<cmd>DapViewWatch<CR>', opts('dap view watch symbol under cursor'))
    -- keymap('n', '<localleader>djr', '<cmd>DapViewJump repl<CR>', opts('dap view jump to repl'))
    -- keymap('n', '<localleader>djs', '<cmd>DapViewJump scopes<CR>', opts('dap view jump to scopes'))
    -- keymap('n', '<localleader>dje', '<cmd>DapViewJump exceptions<CR>', opts('dap view jump to exceptions'))
    -- keymap('n', '<localleader>djb', '<cmd>DapViewJump breakpoints<CR>', opts('dap view jump to breakpoints'))
    -- keymap('n', '<localleader>djw', '<cmd>DapViewJump watches<CR>', opts('dap view jump to watches'))
    -- keymap('n', '<localleader>djt', '<cmd>DapViewJump threads<CR>', opts('dap view jump to threads'))
    -- keymap('n', '<localleader>djc', '<cmd>DapViewJump console<CR>', opts('dap view jump to console'))

    -- api.nvim_create_autocmd('FileType', {
    --   group = autocmd,
    --   pattern = { 'dap-view', 'dap-repl', 'dap-view-term' },
    --   desc = 'set dapview keymap',
    --   callback = function()
    --     bufmap(0, 'n', ']r', '<cmd>DapViewJump repl<CR>', opts('dap view jump to repl'))
    --     bufmap(0, 'n', ']s', '<cmd>DapViewJump scopes<CR>', opts('dap view jump to scopes'))
    --     bufmap(0, 'n', ']e', '<cmd>DapViewJump exceptions<CR>', opts('dap view jump to exceptions'))
    --     bufmap(0, 'n', ']b', '<cmd>DapViewJump breakpoints<CR>', opts('dap view jump to breakpoints'))
    --     bufmap(0, 'n', ']w', '<cmd>DapViewJump watches<CR>', opts('dap view jump to watches'))
    --     bufmap(0, 'n', ']t', '<cmd>DapViewJump threads<CR>', opts('dap view jump to threads'))
    --     bufmap(0, 'n', ']c', '<cmd>DapViewJump console<CR>', opts('dap view jump to console'))
    --   end,
    -- })
  end,
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      -- event = 'VeryLazy',
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
    { 'kdheepak/nvim-dap-julia' },
    {
      'mfussenegger/nvim-dap-python',
      keys = {
        {
          '<localleader>dPt',
          function() require('dap-python').test_method() end,
          desc = 'Debug Method',
          ft = 'python',
        },
        {
          '<localleader>dPc',
          function() require('dap-python').test_class() end,
          desc = 'Debug Method',
          ft = 'python',
        },
      },
    },
    { 'theHamsta/nvim-dap-virtual-text', opts = { all_frames = true } },
  },
}
-- {'igorlfs/nvim-dap-view'},
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
