local L = vim.lsp.log_levels
local api, augroup, highlight, ui = vim.api, eo.augroup, eo.highlight, eo.ui
local border = eo.ui.current.border
-- local lspkind = require('lspkind')

return {
  {
    'folke/noice.nvim',
    -- enabled = true,
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      -- opts = function(_, opts)
      -- opts.routes = opts.routes or {}
      cmdline = {
        format = {
          IncRename = { title = ' Rename ' },
          substitute = { pattern = '^:%%?s/', icon = ' ', ft = 'regex', title = '' },
          input = { icon = ' ', lang = 'text', view = 'cmdline_popup', title = '' },
        },
      },
      popupmenu = { backend = 'nui' },
      lsp = {
        documentation = {
          enabled = true,
          opts = {
            border = { style = border },
            position = { row = 2 },
          },
        },
        signature = {
          enabled = true, --| |> blink
          opts = {
            position = { row = 2 },
          },
        },
        hover = {
          enabled = true,
          silent = true,
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      views = {
        vsplit = { size = { width = 'auto' } },
        split = { win_options = { winhighlight = { Normal = 'Normal' } } },
        popup = {
          border = { style = 'rounded', padding = { 0, 1 } },
        },
        cmdline_popup = {
          position = { row = 5, col = '50%' },
          size = { width = 'auto', height = 'auto' },
          border = { style = 'rounded', padding = { 0, 1 } },
        },
        confirm = {
          border = { style = 'rounded', padding = { 0, 1 }, text = { top = '' } },
        },
        popupmenu = {
          relative = 'editor',
          position = { row = 9, col = '50%' },
          size = { width = 60, height = 10 },
          -- border = { style = border, padding = { 1, 1 } },
          border = { style = 'rounded', padding = { 1, 1 } },
          win_options = { winhighlight = { Normal = 'NormalFloat', FloatBorder = 'FloatBorder' } },
        },
      },
      redirect = { view = 'popup', filter = { event = 'msg_show' } },
      routes = {
        {
          opts = { skip = true },
          filter = {
            any = {
              { event = 'notify', find = 'No Information available' }, --folke dotfiles
              { event = 'msg_show', find = 'written' },
              { event = 'msg_show', find = '%d+ lines, %d+ bytes' },
              { event = 'msg_show', kind = 'search_count' },
              { event = 'msg_show', find = '%d+L, %d+B' },
              { event = 'msg_show', find = '^Hunk %d+ of %d' },
              { event = 'msg_show', find = '%d+ change' },
              { event = 'msg_show', find = '%d+ line' },
              { event = 'msg_show', find = '%d+ more line' },
            },
          },
        },
        {
          view = 'vsplit',
          filter = { event = 'msg_show', min_height = 20 },
        },
        {
          view = 'notify',
          filter = {
            any = {
              { event = 'msg_show', min_height = 10 },
              { event = 'msg_show', find = 'Treesitter' },
            },
          },
          opts = { timeout = 10000 },
        },
        {
          view = 'notify',
          filter = { event = 'notify', find = 'Type%-checking' },
          opts = { replace = true, merge = true, title = 'TSC' },
          stop = true,
        },
        {
          view = 'mini',
          filter = {
            any = {
              { event = 'msg_show', find = '^E486:' },
              { event = 'notify', max_height = 1 },
            },
          }, -- minimise pattern not found messages
        },
        {
          view = 'notify',
          filter = {
            any = {
              { warning = true },
              { event = 'msg_show', find = '^Warn' },
              { event = 'msg_show', find = '^W%d+:' },
              { event = 'msg_show', find = '^No hunks$' },
            },
          },
          opts = { title = 'Warning', level = L.WARN, merge = false, replace = false },
        },
        {
          view = 'notify',
          opts = { title = 'Error', level = L.ERROR, merge = true, replace = false },
          filter = {
            any = {
              { error = true },
              { event = 'msg_show', find = '^Error' },
              { event = 'msg_show', find = '^E%d+:' },
            },
          },
        },
        {
          view = 'notify',
          opts = { title = '' },
          filter = { kind = { 'emsg', 'echo', 'echomsg' } },
        },
      },

      -- table.insert(opts.routes, 1, {
      --   filter = {
      --     ['not'] = {
      --       event = 'lsp',
      --       kind = 'progress',
      --     },
      --     cond = function() return not focused and false end,
      --   },
      --   view = 'notify_send',
      --   opts = { stop = false, replace = true },
      -- }),
      -- vim.api.nvim_create_autocmd('FileType', {
      --   pattern = 'markdown',
      --   callback = function(event)
      --     vim.schedule(function() require('noice.text.markdown').keys(event.buf) end)
      --   end,
      -- }),
      -- local focused = true
      -- vim.api.nvim_create_autocmd('FocusGained', {
      --   callback = function() focused = true end,
      -- }),
      -- vim.api.nvim_create_autocmd('FocusLost', {
      --   callback = function() focused = false end,
      -- }),
      commands = {
        history = { view = 'vsplit' },
      },
      presets = {
        inc_rename = false,
        long_message_to_split = true,
        lsp_doc_border = false,
      },
    },
    --   return opts
    -- end,
    config = function(_, opts)
      require('noice').setup(opts)

      -- highlight.plugin('noice', {
      --   { NoiceMini = { inherit = 'MsgArea', bg = { from = 'Normal' } } },
      --   { NoicePopupBaseGroup = { inherit = 'NormalFloat', fg = { from = 'DiagnosticSignInfo' } } },
      --   { NoicePopupWarnBaseGroup = { inherit = 'NormalFloat', fg = { from = 'Float' } } },
      --   { NoicePopupInfoBaseGroup = { inherit = 'NormalFloat', fg = { from = 'Conditional' } } },
      --   { NoiceCmdlinePopup = { bg = { from = 'NormalFloat' } } },
      --   { NoiceCmdlinePopupBorder = { link = 'FloatBorder' } },
      --   { NoiceCmdlinePopupTitle = { link = 'FloatTitle' } },
      --   { NoiceCmdlinePopupBorderCmdline = { link = 'NoicePopupBaseGroup' } },
      --   { NoiceCmdlinePopupBorderSearch = { link = 'NoicePopupWarnBaseGroup' } },
      --   { NoiceCmdlinePopupBorderFilter = { link = 'NoicePopupWarnBaseGroup' } },
      --   { NoiceCmdlinePopupBorderHelp = { link = 'NoicePopupInfoBaseGroup' } },
      --   { NoiceCmdlinePopupBorderSubstitute = { link = 'NoicePopupWarnBaseGroup' } },
      --   { NoiceCmdlinePopupBorderIncRename = { link = 'NoicePopupWarnBaseGroup' } },
      --   { NoiceCmdlinePopupBorderInput = { link = 'NoicePopupBaseGroup' } },
      --   { NoiceCmdlinePopupBorderLua = { link = 'NoicePopupBaseGroup' } },
      --   { NoiceCmdlineIconCmdline = { link = 'NoicePopupBaseGroup' } },
      --   { NoiceCmdlineIconSearch = { link = 'NoicePopupWarnBaseGroup' } },
      --   { NoiceCmdlineIconFilter = { link = 'NoicePopupWarnBaseGroup' } },
      --   { NoiceCmdlineIconHelp = { link = 'NoicePopupInfoBaseGroup' } },
      --   { NoiceCmdlineIconIncRename = { link = 'NoicePopupWarnBaseGroup' } },
      --   { NoiceCmdlineIconSubstitute = { link = 'NoicePopupWarnBaseGroup' } },
      --   { NoiceCmdlineIconInput = { link = 'NoicePopupBaseGroup' } },
      --   { NoiceCmdlineIconLua = { link = 'NoicePopupBaseGroup' } },
      --   { NoiceConfirm = { bg = { from = 'NormalFloat' } } },
      --   { NoiceConfirmBorder = { link = 'NoicePopupBaseGroup' } },
      -- })

      map({ 'n', 'i', 's' }, '<c-d>', function()
        if not require('noice.lsp').scroll(4) then return '<c-d>' end
      end, { silent = true, expr = true })

      map({ 'n', 'i', 's' }, '<c-u>', function()
        if not require('noice.lsp').scroll(-4) then return '<c-u>' end
      end, { silent = true, expr = true })

      map(
        'n',
        '<ESC>',
        function() require('notify').dismiss() end,
        { desc = 'Dismiss popup & clear hlsearch', nowait = true, silent = true }
      )
      -- map('n', '<leader>n', function()
      --   require('noice.commands').dismiss()
      -- end)

      -- map({ 'n', 'i', 'v' }, '<ESC>', function()
      --   if not vim.cmd.NoiceDismiss then return '<ESC>' end
      -- end, { desc = 'Clear Noice Popups', expr = true, silent = true })

      -- map({ 'n', 'v', 'i' }, '<D-0>', vim.cmd.NoiceDismiss, { desc = 'All notifications', silent = true })

      -- map('n', '<ESC>', function()
      --   if not require('noice').disable() then return vim.keycode('<ESC>') end
      -- end, { silent = true, expr = true })

      -- map('c', '<M-CR>', function() require('noice').redirect(fn.getcmdline()) end, {
      --   desc = 'redirect Cmdline',
      -- })
    end,
  },
  {
    'lukas-reineke/virt-column.nvim',
    enabled = true,
    -- version = '*',
    -- event = { 'BufNewFile', 'BufReadPost' },
    event = { 'VimEnter', 'VeryLazy' },
    opts = { char = '▕' },
    init = function()
      augroup('VirtCol', {
        -- event = { 'VimEnter', 'BufEnter', 'WinEnter', 'UIEnter' },
        event = { 'VimEnter', 'BufEnter', 'WinEnter' },
        command = function(args)
          ui.decorations.set_colorcolumn(
            args.buf,
            function(virtcolumn) require('virt-column').setup_buffer { virtcolumn = virtcolumn } end
          )
        end,
      })
    end,
  },
  -- {
  --   'lukas-reineke/indent-blankline.nvim',
  --   enabled = false,
  --   version = '*',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'HiPhish/rainbow-delimiters.nvim' },
  --   -- event = { 'BufNewFile', 'BufReadPost' },
  --   event = 'UIEnter',
  --   main = 'ibl',
  --   opts = {
  --     exclude = {
  --       -- stylua: ignore start
  --       filetypes = {
  --         'dbout', 'neo-tree', 'neo-tree-popup', 'log', 'gitcommit',
  --         'txt', 'help', 'NvimTree', 'git', 'undotree', 'checkhealth',
  --         'quarto', 'markdown', 'norg', 'org', 'orgagenda','lspinfo',
  --       },
  --       buftypes = {
  --         'terminal', 'nofile', 'quickfix', 'prompt', 'Lazy',
  --         'Mason', 'fzf', 'FzfLua', 'overseer', 'fzf-lua',
  --       },
  --       -- stylua: ignore end
  --     },
  --     debounce = 500,
  --     indent = {
  --       smart_indent_cap = true,
  --       char = '│', -- ▏┆ ┊ 
  --     },
  --     scope = {
  --       enabled = true,
  --       show_start = true,
  --       show_exact_scope = true, -- default 'false'
  --       show_end = false,
  --       char = '▎', -- 🮇
  --       include = {
  --         node_type = {
  --           lua = { 'return_statement', 'table_constructor' },
  --         },
  --       },
  --       highlight = {
  --         'RainbowDelimiterRed',
  --         'RainbowDelimiterYellow',
  --         'RainbowDelimiterBlue',
  --         'RainbowDelimiterOrange',
  --         'RainbowDelimiterGreen',
  --         'RainbowDelimiterViolet',
  --         'RainbowDelimiterCyan',
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     require('ibl').setup(opts)
  --     local hooks = require('ibl.hooks')
  --     hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  --     hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
  --     hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
  --   end,
  -- },
  {
    'rcarriga/nvim-notify',
    enabled = true,
    lazy = true,
    version = '*',
    opts = {
      -- background_colour = '#000000',
      stages = 'fade_in_slide_out',
      top_down = false,
      timeout = 1500,
      -- max_height = function() return math.floor(vim.o.lines * 0.8) end,
      -- max_width = function() return math.floor(vim.o.columns * 0.6) end,
      on_open = function(win)
        if not api.nvim_win_is_valid(win) then return end
        api.nvim_win_set_config(win, { border = 'rounded', focusable = false })
      end,
      -- render = function(...)
      --   local notification = select(2, ...)
      --   local style = falsy(notification.title[1]) and 'minimal' or 'default'
      --   require('notify.render')[style](...)
      -- end,
      render = 'wrapped-compact',
    },
  },
}
