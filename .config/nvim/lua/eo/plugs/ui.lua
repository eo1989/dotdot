local api, fn = vim.api, vim.fn
local highlight, ui, falsy, augroup = eo.highlight, eo.ui, eo.falsy, eo.augroup
local icons, border, rect = ui.icons.lsp, ui.current.border, ui.border.rectangle
local lspkind = require('lspkind')

return {
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      plugins = {
        kitty = { enabled = true, font = '+2' },
        tmux = { enabled = false },
      },
    },
  },
  {
    'lukas-reineke/virt-column.nvim',
    -- event = { 'BufNewFile', 'BufReadPost' },
    event = { 'UIEnter' },
    opts = { char = '▕' },
    init = function()
      augroup('VirtCol', {
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
  {
    'lukas-reineke/indent-blankline.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'HiPhish/rainbow-delimiters.nvim' },
    -- event = { 'BufNewFile', 'BufReadPost' },
    event = 'UIEnter',
    main = 'ibl',
    opts = {
      exclude = {
      -- stylua: ignore start
      filetypes = {
        'dbout', 'neo-tree-popup', 'log', 'gitcommit',
        'txt', 'help', 'NvimTree', 'git', 'flutterToolsOutline',
        'undotree', 'markdown', 'norg', 'org', 'orgagenda', 'neo-tree', 'neo_tree',
        'lazy', 'mason', 'NvimTree', 'fzflua', 'fzf', 'FzfLua', 'overseer',
      },
        -- stylua: ignore end
      },
      debounce = 400,
      indent = {
        smart_indent_cap = false,
        char = '│', -- ▏┆ ┊ 
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
        -- char = '▎',
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      },
    },
    config = function(_, opts)
      require('ibl').setup(opts)
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end,
  },
  -- {
  --   'luukvbaal/statuscol.nvim',
  --   enabled = false,
  --   -- lazy = false,
  --   event = 'BufEnter',
  --   config = function()
  --     local builtin = require('statuscol.builtin')
  --     require('statuscol').setup {
  --       setopt = false,
  --       relculright = false,
  --       bt_ignore = { 'terminal', 'nofile' },
  --       -- stylua: ignore start
  --       ft_ignore = {
  --         'qf', 'toggleterm', 'lazyterm', 'git',
  --         'help', 'notify', 'mason', 'neo-tree',
  --         'neo-tree-popup', 'Trouble', 'bqf',
  --         'LspInfo', 'Lazy', 'cmp_menu', 'cmp_docs',
  --       },
  --       -- stylua: ignore end
  --       segments = {
  --         { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
  --         {
  --           sign = { name = { 'Diagnostic' }, maxwidth = 5, colwidth = 3, auto = false },
  --           click = 'v:lua.ScSa',
  --         },
  --         {
  --           text = { builtin.lnumfunc },
  --           condition = { true, builtin.not_empty },
  --           click = 'v:lua.ScLa',
  --         },
  --         {
  --           sign = { name = { '.*' }, namespace = { '.*' }, maxwidth = 5, colwidth = 3, wrap = true, auto = false },
  --           click = 'v:lua.ScSa',
  --         },
  --         { text = { '┃' }, condition = { true, builtin.not_empty } }, -- '│' '|' "│" "║" '┃' '┃' '｜'
  --         -- { text = { '%s' }, click = 'v:lua.ScSa' },
  --         -- {
  --         --   text = { builtin.lnumfunc, ' ' },
  --         --   condition = { true, builtin.not_empty },
  --         --   click = 'v:lua.ScLa',
  --         -- },
  --       },
  --     }
  --   end,
  -- },
  {
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
      input = { relative = 'cursor' }, -- 'cursor', 'win', 'editor'
      -- input = { enabled = false },
      select = {
        backend = { 'fzf_lua', 'nui', 'fzf', 'builtin' },
        trim_prompt = true,
        builtin = {
          border = border,
          min_height = 20,
          win_options = { winblend = 10 },
          mappings = { n = { ['q'] = 'Close' } },
        },
        get_config = function(opts)
          opts.prompt = opts.prompt and opts.prompt:gsub(':', '')
          if opts.kind == 'codeaction' then
            return {
              backend = 'fzf_lua',
              fzf_lua = eo.fzf.cursor_dropdown {
                winopts = { title = opts.prompt },
              },
            }
          end
          -- if opts.kind == 'orgmode' then
          --   return {
          --     backend = 'nui',
          --     nui = {
          --       position = '97%',
          --       border = { style = rect },
          --       min_width = vim.o.columns - 2,
          --     },
          --   }
          -- end
          return {
            backend = 'fzf_lua',
            fzf_lua = eo.fzf.dropdown {
              winopts = { title = opts.prompt, height = 0.33, row = 0.5 },
            },
          }
        end,
        nui = {
          min_height = 10,
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
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function()
      highlight.plugin('notify', {
        { NotifyERRORBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyWARNBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyINFOBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyDEBUGBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyTRACEBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyERRORBody = { link = 'NormalFloat' } },
        { NotifyWARNBody = { link = 'NormalFloat' } },
        { NotifyINFOBody = { link = 'NormalFloat' } },
        { NotifyDEBUGBody = { link = 'NormalFloat' } },
        { NotifyTRACEBody = { link = 'NormalFloat' } },
      })

      local notify = require('notify')
      notify.setup {
        background_colour = '#000000',
        -- render = 'minimal', -- 'default', 'minimal', 'simple', 'wrapped-compact'
        stages = 'fade_in_slide_out',
        top_down = true,
        timeout = 1200,
        max_height = function() return math.floor(vim.o.lines * 0.8) end,
        max_width = function() return math.floor(vim.o.columns * 0.6) end,
        on_open = function(win)
          if not api.nvim_win_is_valid(win) then return end
          api.nvim_win_set_config(win, { border = 'rounded' })
        end,
        render = function(...)
          local notification = select(2, ...)
          local style = falsy(notification.title[1]) and 'minimal' or 'default'
          require('notify.render')[style](...)
        end,
        vim.keymap.set(
          'n',
          '<esc>',
          function() require('notify').dismiss { silent = true, pending = true } end,
          { desc = 'dismiss notifications' }
        ),
        -- vim.keymap.set(
        --   'n',
        --   '<leader>nd',
        --   function() require('notify').dismiss { silent = true, pending = true } end,
        --   { desc = 'dismiss notifications' }
        -- ),
      }
    end,
  },
}
