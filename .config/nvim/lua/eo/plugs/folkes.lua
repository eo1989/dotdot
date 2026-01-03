local L = vim.lsp.log_levels
local api, aug, highlight, border = vim.api, eo.augroup, eo.highlight, eo.ui.current.border
local defaults = require('defaults')
local defborder = defaults.ui.border.chars

---@type LazySpec
return {
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    opts = {
      lang = {
        typst = { '// %s', '/* %s */' },
      },
    },
  },
  {
    'folke/snacks.nvim',
    priority = 9999,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = {
        enabled = true,
        ---@field style? "out"|"up_down"|"down"|"up"
        style = 'out',
        duration = {
          step = 5, -- ms per step, default = 20
          total = 100, -- max. duration, default = 500
        },
      },
      indent = {
        enabled = true,
        only_scope = false, -- only show indent guides of the scope
        only_current = false, -- only show indent guides in the current window
      },
      scope = {
        enabled = true,
      },
      bigfile = {
        enabled = true,
        --[[
        -- from:
        -- https://github.com/hat0uma/dotfiles/blob/main/.config/nvim/lua/plugins/snacks/init.lua
        -- ]]
        notify = true,
        size = 1 * 1024 * 1024,
        -- Enable or disable features when big file detected
        ---@param ctx {buf: number, ft:string}
        setup = function(ctx)
          vim.cmd([[NoMatchParen]])
          Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
          vim.schedule(function() vim.bo[ctx.buf].syntax = ctx.ft end)
          -- if pcall(require, 'ibl') then require('indent_blankline.commands').disable() end
        end,
      },
      bufdelete = { enabled = true },
      dashboard = { enabled = false },
      dim = { enabled = false },
      explorer = { enabled = false },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      input = { enabled = false },
      layout = { enabled = true },
      lazygit = { enabled = true },
      notifier = {
        enabled = false,
        timeout = 1200,
        style = 'fancy', -- "compact"|"fancy"|"minimal"
        icons = {
          error = eo.ui.icons.lsp.error or ' ' or defaults.icons.diagnostics.error,
          warn = eo.ui.icons.lsp.warn or ' ' or defaults.icons.diagnostics.warn,
          info = eo.ui.icons.lsp.info or ' ' or defaults.icons.diagnostics.info,
          debug = ' ' or defaults.icons.diagnostics.debug,
          trace = ' ' or defaults.icons.diagnostics.trace,
        },
        top_down = false, -- default true
      },
      picker = {
        enabled = true,
        -- config = {},
        layout = {
          cycle = true,
          --[[ $COLUMNS == 71 when terminal takes up half of the vertical screen RE ]]
          -- preset = function() return vim.o.columns >= 150 and 'default' or 'vertical' end,

          preset = function() return vim.o.columns > 60 and 'vertical' or 'default' end,
          -- win = { preview = { vertical = true } },
        },
      },
      profiler = { enabled = false },
      quickfile = { enabled = false },
      rename = { enabled = false },
      scratch = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      terminal = { enabled = false },
      toggle = { enabled = true },
      win = { enabled = true },
      words = { enabled = true },
      zen = { enabled = false },
      styles = {
        enabled = true,
        snacks_image = {
          relative = 'editor',
          col = -1,
        },
      },
      image = {
        enabled = true,
        wo = {
          winhighlight = 'FloatBorder:WhichKeyBorder',
        },
        doc = {
          inline = false,
          -- float = true,
          max_width = 80,
          max_height = 40,
        },
        math = { enabled = true },
      },
    },
    keys = {
      {
        '<leader>ff',
        function()
          Snacks.picker.files { layout = 'ivy' }
          -- Snacks.picker.files()
        end,
        desc = 'Smart(?) Find Files',
      },
      {
        '<leader>fb',
        function() Snacks.picker.buffers() end,
        desc = 'Find Buffers',
      },
      {
        '<leader>fc',
        function() Snacks.picker.files { cwd = vim.g.nvim_dir } end,
        desc = 'Config files',
      },
      {
        '<leader>fd',
        function() Snacks.picker.diagnostics_buffer() end,
        desc = 'Search diagnostics (buffer)',
      },
      {
        '<leader>fh',
        function() Snacks.picker.help() end,
        desc = 'Search help',
      },
      {
        '<leader>fk',
        function() Snacks.picker.keymaps() end,
        desc = 'Search Keymaps',
      },
      {
        '<leader>fs',
        function() Snacks.picker.grep() end,
        desc = 'search Word',
      },
      {
        '<leader>fS',
        function() Snacks.picker.grep_word() end,
        desc = 'search Word',
        mode = { 'v', 'x' },
      },
      {
        '<leader>fp',
        function() Snacks.picker.lazy() end,
        desc = 'Search for Plugin spec',
      },
      {
        '<leader>fgb',
        function() Snacks.picker.git_branches() end,
        desc = 'git branches',
      },
      {
        '<leader>fgc',
        function() Snacks.picker.git_log() end,
        desc = 'git commits',
      },
      {
        '<leader>qq',
        function() Snacks.bufdelete() end,
        desc = 'Delete buffer',
      },
      {
        '<localleader>.',
        function() Snacks.scratch() end,
        desc = 'Scratch buffer',
      },
      {
        ']]',
        function() Snacks.words.jump(vim.v.count1) end,
        desc = 'Next reference',
        mode = { 'n', 't' },
        silent = true,
        nowait = true,
      },
      {
        '[[',
        function() Snacks.words.jump(-vim.v.count1) end,
        desc = 'Prev reference',
        mode = { 'n', 't' },
        silent = true,
        nowait = true,
      },
      -- {
      --   '<localleader>lg',
      --   function() Snacks.lazygit() end,
      --   desc = 'Lazygit',
      -- },
      {
        '<localleader>lG',
        function() Snacks.gitbrowse() end,
        desc = 'gitbrowse',
        mode = { 'n', 'v' },
      },
      {
        '<localleader>uN',
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = 'yes',
              statuscolumn = ' ',
              conceallevel = 3,
            },
          }
        end,
        desc = 'nvim news',
      },
    },
    init = function()
      -- require('snacks').setup(opts)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          _G.P = vim.print

          Snacks.toggle.option('spell', { name = 'Spelling' }):map('<localleader>us')

          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<localleader>uw')

          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<localleader>uL')

          Snacks.toggle.diagnostics():map('<localleader>ud')

          Snacks.toggle.line_number():map('<localleader>ul')

          Snacks.toggle
            .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map('<localleader>uc')

          Snacks.toggle.treesitter():map('<localleader>ut')

          Snacks.toggle
            .option('background', { off = 'light', on = 'dark', name = 'Dark background' })
            :map('<localleader>ub')

          Snacks.toggle.indent():map('<localleader>ug')

          Snacks.toggle.dim():map('<localleader>uD')

          local tsc = require('treesitter-context')
          Snacks.toggle
            .new({
              name = 'Treesitter Context',
              get = tsc.enabled,
              set = function(state)
                if state then
                  tsc.enable()
                else
                  tsc.disable()
                end
              end,
            })
            :map('<localleader>uT')

          local autoformat_toggle = require('snacks').toggle.new {
            name = 'Format on Save',
            get = function() return not vim.g.disable_autoformat end,
            set = function(enabled) vim.g.disable_autoformat = not enabled end,
          }
          autoformat_toggle:map('<localleader>uf', { desc = 'toggle format on save' })
        end,
      })
    end,
  },
  {
    'folke/noice.nvim',
    ---@module "noice"
    enabled = true,
    version = false,
    event = { 'BufReadPost', 'VimEnter' },
    dependencies = {
      {
        'MunifTanjim/nui.nvim',
        version = false,
      },
      {
        'rcarriga/nvim-notify',
        enabled = true,
        version = false,
        opts = {
          stages = 'fade_in_slide_out',
          top_down = false,
          timeout = 1000,
          -- on_open = function(win)
          --   if not api.nvim_win_is_valid(win) then return end
          --   api.nvim_win_set_config(win, { border = 'rounded', focusable = false })
          -- end,
          -- render = function(...)
          --   local notification = select(2, ...)
          --   local style = eo.falsy(notification.title[1]) and 'minimal' or 'default'
          --   require('notify.render')[style](...)
          -- end,
          render = 'wrapped-compact',
        },
      },
    },
    opts = {
      cmdline = {
        format = {
          IncRename = { title = ' Rename ' },
          substitute = { pattern = '^:%%?s/', icon = ' ', ft = 'regex', title = '' },
          input = { icon = ' ', lang = 'text', view = 'cmdline_popup', title = '' },
        },
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
        kind_icons = true,
      },
      lsp = {
        progress = {
          enabled = true,
        },
        -- override = {
        --   ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        --   ['vim.lsp.util.stylize_markdown'] = true,
        --   ['cmp.entry.get_documentation'] = true,
        -- },
        hover = { enabled = false, silent = true },
        documentation = {
          enabled = false,
          view = 'hover',
        },
        signature = {
          enabled = false,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 25ms
          },
        },
      },
      health = { checker = true },
      smart_move = {
        enabled = false, -- disable this behavior here
        excluded_filetypes = { 'cmp_menu', 'cmp_docs', 'notify' },
      },
      views = {
        vsplit = { size = { width = 'auto' } },
        split = { win_options = { winhighlight = { Normal = 'Normal' } } },
        popup = { border = { style = 'rounded', padding = { 0, 1 } } },
        cmdline_popup = {
          position = { row = 5, col = '50%' },
          size = { width = 'auto', height = 'auto' },
          border = { style = 'rounded', padding = { 0, 1 } },
        },
        confirm = { border = { style = 'rounded', padding = { 0, 1 }, text = { top = '' } } },
        popupmenu = {
          relative = 'editor',
          position = { row = 10, col = '50%' },
          size = { width = 60, height = 10 },
          border = { style = border, padding = { 1, 1 } },
          win_options = { winhighlight = { Normal = 'NormalFloat', FloatBorder = 'FloatBorder' } },
        },
      },
      redirect = { view = 'popup', filter = { event = 'msg_show' } },
      presets = {
        bottom_search = false,
        command_palette = true,
        inc_rename = false,
        long_message_to_split = true,
        lsp_doc_border = false,
      },
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
          },
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
    },
    config = function(_, opts)
      map({ 'n', 'i', 's' }, '<c-d>', function()
        if not require('noice.lsp').scroll(4) then return '<c-d>' end
      end, { silent = true, expr = true })

      map({ 'n', 'i', 's' }, '<c-u>', function()
        if not require('noice.lsp').scroll(-4) then return '<c-u>' end
      end, { silent = true, expr = true })

      map('n', '<localleader>n', function() require('noice').cmd('Errors') end, { silent = true })

      map('n', '<ESC>', function()
        require('notify').dismiss()
        vim.cmd('NoiceDismiss')
      end, { desc = 'Dismiss popup & clear hlsearch', nowait = true, silent = true })

      map('n', '<localleader>m', function() require('noice').cmd('dismiss') end)

      require('noice').setup(opts)
    end,
  },
}
