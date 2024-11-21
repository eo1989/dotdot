---@diagnostic disable: missing-fields
local api, ui = vim.api, eo.ui

return {
  {
    'kawre/neotab.nvim',
    event = 'InsertEnter',
    opts = {},
  },
  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      -- { 'hrsh7th/cmp-path' },
      'https://codeberg.org/FelipeLema/cmp-async-path',
      { 'onsails/lspkind.nvim' },
      { 'folke/lazydev.nvim' },
      { 'rcarriga/cmp-dap' },
      { 'theHamsta/nvim-dap-virtual-text' },
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
      { 'lukas-reineke/cmp-rg' },
      { 'hrsh7th/cmp-cmdline' },
      { 'petertriho/cmp-git', ft = { 'git' } },
      { 'amarakon/nvim-cmp-lua-latex-symbols' },
      { 'jmbuhr/otter.nvim' },
    },
    config = function()
      local cmp = require('cmp')
      local cmp_context = require('cmp.config.context')
      local cmp_types_lsp = require('cmp.types.lsp')
      local types = require('cmp.types')
      local lspkind = require('lspkind')
      local neotab = require('neotab')
      local luasnip = require('luasnip')

      local function has_words_before()
        unpack = unpack or table.unpack
        if api.nvim_get_option_value(0, 'buftype') == 'prompt' then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
        -- return col ~= 0 and api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
      end

      cmp.setup {
        experimental = { ghost_text = false, native_menu = false },
        performance = {
          debounce = 60,
          throttle = 30,
          fetching_timeout = 100,
          filtering_context_budget = 3,
          confirm_resolve_timeout = 80,
          async_budget = 1,
          max_view_entries = 50,
        },
        completion = {
          -- keyword_length = 1,
          completeopt = 'menu,menuone,noselect,preview',
          autocomplete = {
            types.cmp.TriggerEvent.TextChanged,
          },
          -- autocomplete = {
          --   'TextChanged',
          --   'TextChangedI',
          --   'TextChangedT',
          -- },
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        view = {
          entries = {
            name = 'custom',
            selection_order = 'near_cursor',
          },
          docs = { auto_open = true },
        },
        matching = {
          disallow_fuzzy_matching = true,
          disallow_fullfuzzy_matching = true,
          disallow_partial_fuzzy_matching = true,
          disallow_partial_matching = true,
          disallow_prefix_unmatching = true,
        },
        preselect = cmp.PreselectMode.Item, -- Item | None
        sources = cmp.config.sources {
          { name = 'lazydev', group_index = 0 },
          {
            { name = 'async_path' },
            { name = 'luasnip', option = { show_autosnippets = true } },
            {
              name = 'nvim_lsp',
              priority = 10,
              ---@param ctx cmp.Context
              entry_filter = function(entry, ctx)
                local kind = entry:get_kind()
                local line = ctx.cursor_line

                local is_string_like = function()
                  return cmp_context.in_treesitter_capture('string')
                    or cmp_context.in_treesitter_capture('comment')
                    or cmp_context.in_syntax_group('Comment')
                    or cmp_context.in_syntax_group('String')
                end
                -- if is_string_like() or entry:is_deprecated() then return false end
                if is_string_like() then return false end

                if vim.tbl_contains({ cmp_types_lsp.CompletionItemKind.Text }, kind) then return false end

                if string.match(line, '^%s+%w+$') then
                  return kind == cmp_types_lsp.CompletionItemKind.Function
                    or kind == cmp_types_lsp.CompletionItemKind.Variable
                end

                return true
              end,
            },
            { name = 'copilot', max_item_count = 2 },
          },
          {
            { name = 'rg', keyword_length = 2 },
            { name = 'buffer', keyword_length = 2, keyword_pattern = [[\k\+]], max_item_count = 3, group_index = 3 },
          },
        },
        window = {
          documentation = {
            winblend = 10,
            border = 'rounded',
            zindex = 52,
          },
          completion = cmp.config.window.bordered {
            col_offset = -3,
            side_padding = 0,
            zindex = 52,
          },
        },
        mapping = cmp.mapping.preset.insert {
          -- ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }, { 'i' }),
          -- ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }, { 'i' }),
          -- ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luansip.expand_or_jump()
            elseif has_words_before then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          -- ['<C-n>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
          --   elseif has_words_before then
          --     cmp.complete()
          --   else
          --     fallback()
          --     -- neotab.tabout()
          --   end
          -- end),
          ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif leasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          -- ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          -- ['<C-p>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }
          --   else
          --     fallback()
          --   end
          -- end, { 'i', 'c' }),

          -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({reason = 'auto'})),
          -- ['<C-Space>'] = cmp.mapping(cmp.complete()),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-x>'] = cmp.mapping.close(),
          -- ['<C-g>'] = function(fallback)
          --   if cmp.core.view:visible() then
          --     if cmp.visible_docs() then
          --       cmp.close_docs()
          --     else
          --       cmp.open_docs()
          --     end
          --   else
          --     fallback()
          --   end
          -- end,

          ['<CR>'] = cmp.mapping {
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm { select = false },
          },

          -- ['<CR>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     if cmp.get_selected_entry() then
          --       cmp.confirm { select = false, cmp.ConfirmBehavior.Insert }
          --     else
          --       cmp.close()
          --     end
          --   else
          --     fallback()
          --   end
          -- end),
          -- ['<CR>'] = cmp.mapping(cunfirm()),

          -- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          -- ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
          ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4)),

          --[[ from copilot-cmp docs ]]
          -- ['<Tab>'] = vim.schedule_wrap()

          ['<Tab>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            -- elseif luasnip.locally_jumpable(1) then
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
              -- neotab.tabout()
            else
              neotab.tabout()
              -- fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        formatting = {
          deprecated = true,
          expandable_indicator = true,
          fields = { 'kind', 'abbr', 'menu' },
          format = lspkind.cmp_format {
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '…',
            symbol_map = { Copilot = '' },
            before = function(entry, item)
              local menu_icon = {
                otter = '🦦',
                jupyter = '🪐',
                Copilot = ' ',
                nvim_lsp = ' ',
                nvim_lua = ' ',
                lazydev = ' ',
                luasnip = ' ',
                buffer = '֎ ',
                latex_symbols = ' ',
                ['lua-latex-symbols'] = ' ',
                dictionary = '⎘ ',
                spell = '󰓆 ',
                snippets = ' ',
                emoji = '󰞅 ',
                dap = '◌ ',
                path = ' ',
                pandoc_references = ' ',
                git = '',
                norg = ' ',
                cmp_zsh = ' ', -- 
                env = ' ', -- 
                async_path = ' ',
                neorg = ' ',
                cmdline = ' ',
              }
              item.menu = menu_icon[entry.source.name]
              return item
            end,
          },
        },
      }

      cmp.setup.filetype({ 'markdown', 'quarto' }, {
        sources = cmp.config.sources {
          { name = 'lua-latex-symbols' },
          -- { name = 'otter' },
        },
      })

      cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
        sources = cmp.config.sources {
          { name = 'dap' },
        },
      })

      cmp.setup.filetype({ 'sql' }, {
        sources = cmp.config.sources {
          { name = 'vim-dadbod-completion' },
        },
      })

      -- cmp.setup.cmdline('/', {
      --   sources = cmp.config.sources({
      --     { name = 'nvim_lsp_document_symbol' },
      --   }, {
      --     { name = 'buffer' },
      --   }),
      -- })

      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources {
      --     {
      --       name = 'cmdline',
      --       keyword_pattern = [=[[^[:blank:]\!]*]=],
      --       option = { ignore_cmds = {} },
      --     },
      --     { name = 'path' },
      --     matching = { disallow_symbol_nonprefix_matching = false },
      --   },
      -- })
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    event = { 'InsertEnter', 'LspAttach' },
    opts = {
      fix_pairs = true,
    },
    -- init = function() api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' }) end,
    dependencies = {
      {
        'zbirenbaum/copilot.lua',
        build = ':Copilot auth',
        opts = {
          panel = { enabled = false },
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 250,
            keymap = {
              accept = false,
              accept_word = '<M-w>',
              accept_line = '<M-l>',
              next = '<M-]>',
              prev = '<M-[>',
            },
          },
          filetypes = {
            ['*'] = true,
            quarto = true,
            norg = false,
            gitcommit = false,
            ['dap-repl'] = false,
            ['FzfLua'] = false,
            DressingInput = false,
            TelescopePrompt = false,
            ['neo-tree-popup'] = false,
            NeogitCommitMessage = false,
          },
        },
      },
    },
  },
}
