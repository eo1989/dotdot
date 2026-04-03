local L = vim.lsp.log_levels
local map = _G.map or vim.keymap.set
local api, aug, highlight, border = vim.api, eo.augroup, eo.highlight, eo.ui.current.border or 'rounded'
local defaults = require('defaults')
local defborder = defaults.ui.border.name

---@type LazySpec[]
return {
  {
    ---@module "todo-comments"
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    ---@type TodoConfig
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 12, -- sign priority 8 default
      lang = {
        typst = { '// %s', '/* %s */' },
      },
    },
  },
  {
    ---@module "snacks"
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = {
        enabled = false,
        ---@field style? "out"|"up_down"|"down"|"up"
        style = 'out',
        duration = {
          step = 5, -- ms per step, default = 20
          total = 100, -- max. duration, default = 500
        },
      },
      indent = {
        enabled = false,
        -- only_scope = false, -- only show indent guides of the scope
        -- only_current = false, -- only show indent guides in the current window
      },
      scope = {
        enabled = false,
      },
      -- bigfile = {
      --   enabled = true,
      --   --[[
      --   -- from:
      --   -- https://github.com/hat0uma/dotfiles/blob/main/.config/nvim/lua/plugins/snacks/init.lua
      --   -- ]]
      --   notify = true,
      --   size = 1 * 1024 * 1024,
      --   -- Enable or disable features when big file detected
      --   ---@param ctx {buf: number, ft:string}
      --   setup = function(ctx)
      --     vim.cmd([[NoMatchParen]])
      --     Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
      --     vim.schedule(function() vim.bo[ctx.buf].syntax = ctx.ft end)
      --     -- if pcall(require, 'ibl') then require('indent_blankline.commands').disable() end
      --   end,
      -- },
      bufdelete = { enabled = true },
      dashboard = { enabled = false },
      dim = { enabled = false },
      explorer = { enabled = false },
      git = { enabled = true },
      gitbrowse = { enabled = false },
      input = { enabled = true },
      layout = { enabled = true },
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
        layout = {
          preset = 'ivy',
          cycle = false,
        },
        layouts = {
          -- [[ https://github.com/linkarzu/dotfiles-latest/blob/2d71edd6b20ead339b00c73daf13e014531816ab/neovim/neobean/lua/plugins/snacks.lua#L251 ]]
          -- [[ https://github.com/folke/snacks.nvim/discussions/468 ]]
          ivy = {
            layout = {
              box = 'vertical',
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.5,
              border = 'top',
              title = ' {title} {live} {flags}',
              title_pos = 'left',
              { win = 'input', height = 1, border = 'bottom' },
              {
                box = 'horizontal',
                { win = 'list', border = 'none' },
                { win = 'preview', title = '{preview}', width = 0.7, border = 'left' },
              },
            },
          },
          -- want to modify layout width
          vertical = {
            layout = {
              backdrop = false,
              box = 'veritcal',
              border = defborder or 'rounded',
              width = 0.8,
              min_width = 80,
              height = 0.8,
              min_height = 30,
              title = '{title} {live} {flags}',
              title_pos = 'center',
              { win = 'input', height = 1, border = 'bottom' },
              { win = 'list', border = 'none' },
              { win = 'preview', title = '{preview}', height = 0.6, border = 'top' },
            },
          },
        },
        matcher = { frecency = true },
        win = {
          input = {
            keys = {
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to the config
              ['<ESC>'] = { 'close', mode = { 'n', 'i' } },
              ['J'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['K'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['H'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
              ['L'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true,
            truncate = 80,
          },
        },
      },
      lazygit = {
        theme = {
          selectedLineBgColor = { bg = 'CursorLine' },
        },
        win = {
          -- -- The first option was to use the "dashboard" style, which uses a
          -- -- 0 height and width, see the styles documentation
          -- -- https://github.com/folke/snacks.nvim/blob/main/docs/styles.md
          -- style = "dashboard",
          -- width = 0,
          -- height = 0,
          position = 'float',
        },
        config = { os = { editPreset = 'nvim-remote' }, gui = { nerdFontsVersion = '3' } },
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
          -- Apparently, all the images that you preview in neovim are converted
          -- to .png and they're cached, original image remains the same, but
          -- the preview you see is a png converted version of that image
          --
          -- Where are the cached images stored?
          -- This path is found in the docs
          -- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
          -- For me returns `~/.cache/neobean/snacks/image`
          -- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
          inline = false,
          -- float = true,
          max_width = 120,
          max_height = 40,
        },
        math = {
          enabled = true,
          -- in the templates below, `${header}` comes from any section in your document,
          -- between a start/end header comment. Comment syntax is language-specific.
          -- * start comment: `// snacks: header start`
          -- * end comment:   `// snacks: header end`
          typst = {
            tpl = [[
            #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
            #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
            #set text(size: 12pt, fill: rgb("${color}"))
            ${header}
            ${content}]],
          },
          latex = {
            font_size = 'Large', -- see https://www.sascha-frank.com/latex-font-size.html
            -- for latex documents, the doc packages are included automatically,
            -- but you can add more packages here. Useful for markdown documents.
            -- packages = { 'amsmath', 'amssymb', 'amsfonts', 'amscd', 'mathtools' },
            packages = { 'amsmath', 'amssymb', 'amsfonts', 'amscd', 'mathtools', 'unicode-math' },
            tpl = [[
            \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
            \usepackage{${packages}}
            \begin{document}
            ${header}
            { \${font_size} \selectfont
              \color[HTML]{${color}}
            ${content}}
            \end{document}]],
          },
        },
      },
    },
    keys = {
      {
        '<leader>ff',
        function()
          -- Snacks.picker.files { layout = 'ivy' }
          Snacks.picker.files()
        end,
        desc = 'Smart(?) Find Files',
        mode = { 'n' },
      },
      {
        '<leader>fb',
        function() Snacks.picker.buffers() end,
        desc = 'Find Buffers',
        mode = { 'n' },
      },
      {
        '<leader>fc',
        function() Snacks.picker.files { cwd = vim.g.nvim_dir } end,
        desc = 'Config files',
        mode = { 'n' },
      },
      {
        '<leader>fd',
        function() Snacks.picker.diagnostics_buffer() end,
        desc = 'Search diagnostics (buffer)',
        mode = { 'n' },
      },
      {
        '<leader>fh',
        function() Snacks.picker.help() end,
        desc = 'Search help',
        mode = { 'n' },
      },
      {
        '<leader>fk',
        function() Snacks.picker.keymaps() end,
        desc = 'Search Keymaps',
        mode = { 'n' },
      },
      {
        '<leader>fs',
        function() Snacks.picker.grep() end,
        desc = 'search Word',
        mode = { 'n' },
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
        mode = { 'n' },
      },
      {
        '<leader>fgb',
        function() Snacks.picker.git_branches() end,
        desc = 'git branches',
        mode = { 'n' },
      },
      {
        '<leader>fgc',
        function() Snacks.picker.git_log() end,
        desc = 'git commits',
        mode = { 'n' },
      },
      {
        '<leader>qq',
        function() Snacks.bufdelete() end,
        desc = 'Delete buffer',
        mode = { 'n' },
      },
      {
        '<localleader>.',
        function() Snacks.scratch() end,
        desc = 'Scratch buffer',
        mode = { 'n' },
      },
      {
        ']]',
        function() Snacks.words.jump(vim.v.count1) end,
        desc = 'Next reference',
        mode = { 'n' },
        silent = true,
        nowait = true,
      },
      {
        '[[',
        function() Snacks.words.jump(-vim.v.count1) end,
        desc = 'Prev reference',
        mode = { 'n' },
        silent = true,
        nowait = true,
      },
      -- {
      --   '<localleader>lg',
      --   function() Snacks.lazygit() end,
      --   desc = 'Lazygit',
      -- },
      -- {
      --   '<localleader>lG',
      --   function() Snacks.gitbrowse() end,
      --   desc = 'gitbrowse',
      --   mode = { 'n', 'v' },
      -- },
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
        mode = { 'n' },
      },
    },
    -- init = function()
    config = function(_, opts)
      -- local notify = vim.notify

      local snacks = require('snacks')

      snacks.setup(opts)

      -- Restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      -- vim.notify = notify

      -- _G.notify = snacks.notify

      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        once = true,
        callback = function()
          -- _G.dd = function(...) Snacks.debug.inspect(...) end
          -- _G.bt = function() Snacks.debug.backtrace() end
          -- _G.P = vim.print

          Snacks.toggle.option('spell', { name = 'Spelling' }):map('<localleader>us')

          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<localleader>uw')

          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<localleader>uL')

          Snacks.toggle.diagnostics():map('<localleader>uD')

          Snacks.toggle.line_number():map('<localleader>ul')

          Snacks.toggle
            .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map('<localleader>uc')

          Snacks.toggle.treesitter():map('<localleader>ut')

          Snacks.toggle
            .option('background', { off = 'light', on = 'dark', name = 'Dark background' })
            :map('<localleader>ub')

          -- Snacks.toggle.indent():map('<localleader>ug')

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

          Snacks.toggle
            .new({
              id = 'line diagnostics',
              name = 'Line Diagnostics',
              get = function()
                local d = vim.diagnostic.config().virtual_lines
                return d and true or false
              end,
              set = function(state)
                if state then
                  vim.diagnostic.config { virtual_lines = true }
                  require('tiny-inline-diagnostic').disable()
                else
                  vim.diagnostic.config { virtual_lines = false }
                  require('tiny-inline-diagnostic').enable()
                end
              end,
            })
            :map('<localleader>ud')
        end,
      })
    end,
  },
  {
    ---@module "noice"
    'folke/noice.nvim',
    enabled = true,
    version = false,
    event = { 'VimEnter', 'BufReadPost' },
    dependencies = {
      {
        'MunifTanjim/nui.nvim',
        version = false,
        event = 'VeryLazy',
      },
      {
        'rcarriga/nvim-notify',
        enabled = true,
        version = false,
        event = 'VeryLazy',
        ---@type notify.Config
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
    ---@type NoiceConfig
    opts = {
      notify = {
        enabled = false,
        -- view = 'notify',
      },
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
        progress = { enabled = true },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = false,
        },
        hover = {
          enabled = true,
          silent = false,
          opts = {
            border = {
              -- style = defaults.ui.border.name,
              style = border,
            },
            position = { row = 2, col = 2 },
          },
        },
        documentation = {
          enabled = true,
          view = 'hover',
        },
        signature = {
          enabled = false,
          auto_open = {
            enabled = false,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = false, -- Will open signature help when jumping to Luasnip insert nodes
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
      ---@type NoicePresets
      presets = {
        bottom_search = false,
        command_palette = true,
        inc_rename = false,
        long_message_to_split = true,
        lsp_doc_border = false,
      },
      ---@type NoiceRouteConfig
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
      signature = { enabled = false },
    },
    config = function(_, opts)
      map({ 'n', 'i', 's' }, '<c-d>', function()
        if not require('noice.lsp').scroll(4) then return '<c-d>' end
      end, { silent = true, expr = true })

      map({ 'n', 'i', 's' }, '<c-u>', function()
        if not require('noice.lsp').scroll(-4) then return '<c-u>' end
      end, { silent = true, expr = true })

      map(
        'n',
        '<localleader>n',
        function() require('noice').cmd('Errors') end,
        { desc = 'Noice Errors', silent = true }
      )

      map('n', '<ESC>', function()
        return {
          require('notify').dismiss(),
          require('noice').cmd('dismiss'),
        }
        -- vim.cmd([[NoiceDismiss]])
      end, { desc = 'Dismiss popup & clear hlsearch', silent = true })

      -- map('n', '<localleader>m', function() require('noice').cmd('dismiss') end)

      require('noice').setup(opts)
    end,
  },
  {
    ---@module 'dressing'
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    -- lazy = true,
    init = function()
      ---@diagnostic disable-next-line:duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line:duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        enabled = true,
        relative = 'editor',
      },
      -- 'cursor', 'win', 'editor'
      select = {
        enabled = true,
        backend = { 'nui', 'fzf', 'builtin', 'fzf_lua' },
        trim_prompt = true,
        builtin = {
          border = 'rounded',
          min_height = { 10, 0.2 },
          win_options = { winblend = 15 },
          mappings = {
            n = { ['q'] = 'Close', ['<ESC>'] = 'Close' },
          },
        },
        get_config = function(opts)
          if opts.kind == 'codeaction' then
            return {
              backend = 'nui',
              nui = {
                relative = 'editor',
                position = '50%',
                border = { style = border or 'rounded' },
                win_options = { winblend = 15 },
                max_width = 40,
                -- min_height = 30,
                -- max_width  = 40,
                -- min_width  = vim.o.columns - 2,
              },
            }
          end
        end,
        format_item_override = {
          code_action = function(action_tuple)
            local title = action_tuple[2].title:gsub('\r\n', '\\r\\n')
            local client = vim.lsp.get_client_by_id(action_tuple[1])
            return string.format('%s\t[%s]', title:gsub('\n', '\\n'), client.name)
          end,
        },
        nui = {
          min_height = 25,
          win_options = {
            winhighlight = table.concat({
              'Normal:Italic',
              'FloatBorder:PickerBorder',
              'FloatTitle:Title',
              'CursorLine:Visual',
            }, ','),
          },
        },
      },
    },
  },
}
