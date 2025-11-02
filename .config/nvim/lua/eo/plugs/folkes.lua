local L = vim.lsp.log_levels
local api, aug, highlight, border = vim.api, eo.augroup, eo.highlight, eo.ui.current.border
local defaults = require('defaults')

---@type LazySpec
return {
  {
    'folke/snacks.nvim',
    priority = 9999,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = { enabled = true },
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dashboard = { enabled = false },
      dim = { enabled = false },
      explorer = { enabled = false },
      git = { enabled = false },
      gitbrowse = { enabled = true },
      indent = { enabled = true },
      input = { enabled = false },
      layout = { enabled = false },
      lazygit = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false }, --[[ needed for Snacks.picker.lsp_definition() & such ]]
      profiler = { enabled = true },
      quickfile = { enabled = true },
      rename = { enabled = false },
      scope = {
        enabled = true,
        underline = true,
      },
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
        -- define these here, so that we don't need to load the image module
        enabled = true,
        wo = {
          winhighlight = 'FloatBorder:WhichKeyBorder',
        },
        doc = {
          inline = false,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          -- float = true,
          max_width = 80,
          max_height = 40,
        },
        math = {
          enabled = true,
          -- in the templates below, `${header}` comes from any section in your document,
          -- between a start/end header comment. Comment syntax is language-specific.
          -- * start comment: `// snacks: header start`
          -- * end comment:   `// snacks: header end`
          -- typst = {
          --   tpl = [[
          --   #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
          --   #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
          --   #set text(size: 12pt, fill: rgb("${color}"))
          --   ${header}
          --   ${content}]],
          -- },
          -- latex = {
          --   font_size = 'large', -- see https://www.sascha-frank.com/latex-font-size.html
          --   -- for latex documents, the doc packages are included automatically,
          --   -- but you can add more packages here. Useful for markdown documents.
          --   packages = { 'amsmath', 'amssymb', 'amsfonts', 'amscd', 'mathtools' },
          --   tpl = [[
          --   \documentclass[preview,border=2pt,varwidth,12pt]{standalone}
          --   \usepackage{${packages}}
          --   \begin{document}
          --   ${header}
          --   { \${font_size} \selectfont
          --     \color[HTML]{${color}}
          --   ${content}}
          --   \end{document}]],
          -- },
        },
      },
    },
    keys = {
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
        '<localleader>.',
        function() Snacks.scratch.select() end,
        desc = 'Scratch buffer',
      },
      {
        ']]',
        function() Snacks.words.jump(1) end,
        -- noremap = true,
        desc = 'Next reference',
        mode = { 'n', 't' },
        silent = true,
        nowait = true,
      },
      {
        '[[',
        function() Snacks.words.jump(-1) end,
        -- noremap = true,
        desc = 'Prev reference',
        mode = { 'n', 't' },
        silent = true,
        nowait = true,
      },
      -- {
      --   '<localleader>z',
      --   function() Snacks.zen() end,
      --   desc = 'Toggle Zen mode',
      -- },
      -- {
      --   '<localleader>Z',
      --   function() Snacks.zen.zoom() end,
      --   desc = 'Toggle Zoom',
      -- },
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

          Snacks.toggle.treesitter():map('<localleader>uT')

          Snacks.toggle
            .option('background', { off = 'light', on = 'dark', name = 'Dark background' })
            :map('<localleader>ub')

          Snacks.toggle.indent():map('<localleader>ug')

          Snacks.toggle.dim():map('<localleader>uD')

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
  -- {
  --   'folke/sidekick.nvim',
  --   enabled = false,
  --   opts = {
  --     -- add any options here
  --     cli = {
  --       mux = {
  --         backend = 'zellij',
  --         enabled = true,
  --       },
  --     },
  --   },
  --   -- keys = {
  --   --   -- {
  --   --   --   '<tab>',
  --   --   --   function()
  --   --   --     -- if there is a next edit, jump to it, otherwise apply it if any
  --   --   --     if not require('sidekick').nes_jump_or_apply() then
  --   --   --       return '<Tab>' -- fallback to normal tab
  --   --   --     end
  --   --   --   end,
  --   --   --   expr = true,
  --   --   --   desc = 'Goto/Apply Next Edit Suggestion',
  --   --   -- },
  --   --   --------------------------------------------------------------------------------------
  --   --   -- {
  --   --   --   '<tab>',
  --   --   --   function()
  --   --   --     -- if there is a next edit, jump to it, otherwise apply it if any
  --   --   --     if not require('sidekick').nes_jump_or_apply() then
  --   --   --       return -- jumped or applied
  --   --   --     end
  --   --   --
  --   --   --     -- if your using neovims native inline completions
  --   --   --     if vim.lsp.inline_completion.get() then
  --   --   --       return
  --   --   --     end
  --   --   --
  --   --   --     -- any other things (like snippets) you want to do on <tab> go here.
  --   --   --
  --   --   --     -- fallback to normal tab
  --   --   --     return "<tab>"
  --   --   --   end,
  --   --   --   expr = true,
  --   --   --   desc = 'Goto/Apply Next Edit Suggestion',
  --   --   -- },
  --   --   --------------------------------------------------------------------------------------
  --   --   {
  --   --     '<c-.>',
  --   --     function() require('sidekick.cli').toggle() end,
  --   --     desc = 'Sidekick Toggle',
  --   --     mode = { 'n', 't', 'i', 'x' },
  --   --   },
  --   --   {
  --   --     '<leader>aa',
  --   --     function() require('sidekick.cli').toggle() end,
  --   --     desc = 'Sidekick Toggle CLI',
  --   --   },
  --   --   {
  --   --     '<leader>as',
  --   --     function() require('sidekick.cli').select() end,
  --   --     -- Or to select only installed tools:
  --   --     -- require("sidekick.cli").select({ filter = { installed = true } })
  --   --     desc = 'Select CLI',
  --   --   },
  --   --   {
  --   --     '<leader>ad',
  --   --     function() require('sidekick.cli').close() end,
  --   --     desc = 'Detach a CLI Session',
  --   --   },
  --   --   {
  --   --     '<leader>at',
  --   --     function() require('sidekick.cli').send { msg = '{this}' } end,
  --   --     mode = { 'x', 'n' },
  --   --     desc = 'Send This',
  --   --   },
  --   --   {
  --   --     '<leader>af',
  --   --     function() require('sidekick.cli').send { msg = '{file}' } end,
  --   --     desc = 'Send File',
  --   --   },
  --   --   {
  --   --     '<leader>av',
  --   --     function() require('sidekick.cli').send { msg = '{selection}' } end,
  --   --     mode = { 'x' },
  --   --     desc = 'Send Visual Selection',
  --   --   },
  --   --   {
  --   --     '<leader>ap',
  --   --     function() require('sidekick.cli').prompt() end,
  --   --     mode = { 'n', 'x' },
  --   --     desc = 'Sidekick Select Prompt',
  --   --   },
  --   --   -- Example of a keybinding to open Claude directly
  --   --   {
  --   --     '<leader>ac',
  --   --     function() require('sidekick.cli').toggle { name = 'claude', focus = true } end,
  --   --     desc = 'Sidekick Toggle Claude',
  --   --   },
  --   -- },
  --   config = function()
  --     require('sidekick').setup {
  --       nes = {
  --         enabled = false,
  --       },
  --     }
  --
  --     eo.command('Sidekick', function(args)
  --       local subcommand = args.fargs[1]
  --
  --       local actions = {
  --         select = function() require('sidekick.cli').select {} end,
  --         toggle = function() require('sidekick.cli').toggle {} end,
  --         close = function() require('sidekick.cli').close {} end,
  --       }
  --
  --       local fn = actions[subcommand or 'toggle']
  --       if not fn then
  --         vim.notify(string.format('No such subcommand %s', subcommand), L.WARN, {})
  --         return
  --       end
  --       fn()
  --     end, { nargs = '*' })
  --   end,
  --   cmd = 'Sidekick',
  -- },
  -- {
  --   'folke/edgy.nvim',
  --   enabled = false,
  --   event = 'VeryLazy',
  --   init = function()
  --     vim.opt.laststatus = 3
  --     vim.opt.splitkeep = 'screen'
  --   end,
  --   opts = {
  --     bottom = {
  --       {
  --         ft = 'toggleterm',
  --         size = { height = 0.3 },
  --         filter = function(buf, win) return vim.api.nvim_win_set_config(win).relative == '' end,
  --       },
  --       -- {
  --       --   ft = 'lazyterm',
  --       --   title = 'LazyTerm',
  --       --   size = { height = 0.3 },
  --       --   filter = function(buf) return not vim.b[buf].lazyterm_cmd end,
  --       -- },
  --       'Trouble',
  --       { ft = 'qf', title = 'QuickFix' },
  --       {
  --         ft = 'help',
  --         size = { height = 20 },
  --         filter = function(buf) return vim.bo[buf].buftype == 'help' end,
  --       },
  --       { ft = 'spectre_panel', size = { height = 0.4 } },
  --       {
  --         title = 'Neo-Tree Git',
  --         ft = 'neo-tree',
  --         filter = function(buf) return vim.b[buf].neo_tree_source == 'git_status' end,
  --         pinned = true,
  --         collapsed = true, -- show window as closed/collapsed on start
  --         open = 'Neotree position=bottom git_status',
  --       },
  --       {
  --         title = 'Neo-Tree Buffers',
  --         ft = 'neo-tree',
  --         filter = function(buf) return vim.b[buf].neo_tree_source == 'buffers' end,
  --         pinned = true,
  --         collapsed = true, -- show window as closed/collapsed on start
  --         open = 'Neotree position=bottom buffers',
  --       },
  --     },
  --     left = {
  --       -- {
  --       --   title = 'Neo-Tree',
  --       --   ft = 'neo-tree',
  --       --   filter = function(buf) return vim.b[buf].neo_tree_source == 'filesystem' end,
  --       --   size = { height = 0.5 }, -- half the screen?
  --       -- },
  --       {
  --         title = function()
  --           local buf_name = vim.api.nvim_buf_get_name(0) or '[No Name]'
  --           return vim.fn.fnamemodify(buf_name, ':t')
  --         end,
  --         ft = 'Outline',
  --         pinned = true,
  --         open = 'SymbolsOutlineOpen',
  --       },
  --       -- any other neo-tree windows
  --       -- 'neo-tree',
  --     },
  --     right = {
  --       {
  --         title = 'Neo-Tree Files',
  --         ft = 'neo-tree',
  --         filter = function(buf) return vim.b[buf].neo_tree_source == 'filesystem' end,
  --         size = { height = 0.25 },
  --         open = 'NeoTree position=right toggle',
  --       },
  --       -- 'neo-tree',
  --     },
  --   },
  -- },
  {
    'folke/trouble.nvim',
    -- event = 'VeryLazy',
    lazy = true,
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      -- {
      --   '<leader>xx',
      --   '<cmd>Trouble diagnostics toggle<cr>',
      --   desc = 'Diagnostics (Trouble)',
      -- },
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<localleader>cs',
        '<cmd>Trouble symbols toggle focus=false win.position=bottom<cr>',
        desc = 'Symbols',
      },
      {
        '<localleader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>',
        desc = 'LSP Defs|refs ..',
      },
      {
        '<leader>xL',
        '<cmdle loclist toggle<cr>',
        desc = 'LocList',
      },
      -- { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'QfList' },
    },
  },
  {
    'folke/noice.nvim',
    enabled = true,
    event = { 'BufReadPost', 'VimEnter' },
    -- lazy = true,
    dependencies = {
      { 'MunifTanjim/nui.nvim' },
      { 'rcarriga/nvim-notify' },
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
        hover = {
          enabled = true,
          silent = false, -- set to true to not show a message if hover isnt available
          ---@type NoiceViewOptions
          opts = {
            border = {
              style = defaults.ui.border.name,
            },
            position = { row = 2, col = 2 },
          },
        },
        progress = {
          enabled = true,
          -- dont show the language server client
          ---@type NoiceFormat|string
          format = {
            {
              '{progress}',
              key = 'progress.percentage',
              contents = {
                { '{data.progress.message} ' },
              },
            },
            '({data.progress.percentage}%) ',
            { '{spinner} ', hl_group = 'NoiceLspProgressSpinner' },
            { '{data.progress.title} ', hl_group = 'NoiceLspProgressTitle' },
          },
          ---@type NoiceFormat|string
          format_done = {
            { '✔ ', hl_group = 'NoiceLspProgressSpinner' },
            { '{data.progress.title} ', hl_group = 'NoiceLspProgressTitle' },
          },
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        documentation = {
          enabled = true,
          opts = {
            border = { style = border },
            position = { row = 2 },
          },
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
          opts = {
            position = { row = 1, col = 2 },
          },
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
          position = { row = 10, col = '50%' },
          size = { width = 60, height = 10 },
          border = { style = border, padding = { 1, 1 } },
          -- border = { style = 'rounded', padding = { 1, 1 } },
          win_options = { winhighlight = { Normal = 'NormalFloat', FloatBorder = 'FloatBorder' } },
        },
      },
      redirect = { view = 'popup', filter = { event = 'msg_show' } },
      commands = {
        history = { view = 'split' },
      },
      presets = {
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
    },
    --   return opts
    -- end,
    config = function(_, opts)
      map({ 'n', 'i', 's' }, '<c-d>', function()
        if not require('noice.lsp').scroll(4) then return '<c-d>' end
      end, { silent = true, expr = true })

      map({ 'n', 'i', 's' }, '<c-u>', function()
        if not require('noice.lsp').scroll(-4) then return '<c-u>' end
      end, { silent = true, expr = true })

      map('n', '<localleader>n', function() require('noice').cmd('Errors') end, { silent = true })

      map(
        'n',
        '<ESC>',
        function() require('notify').dismiss() end,
        { desc = 'Dismiss popup & clear hlsearch', nowait = true, silent = true }
      )

      -- map('n', '<esc>', function()
      --   -- if not require('copilot-lsp.nes').clear() then
      --   --   require('noice')['cmd']('dismiss')
      --   if not require('noice').cmd('dismiss') then
      --     require('notify').dismiss()
      --     return
      --   end
      -- end, { desc = 'clear copilot and everything else or fallback', nowait = true, silent = true })

      require('noice').setup(opts)
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
}
