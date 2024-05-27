---@diagnostic disable: missing-fields
local api, ui = vim.api, eo.ui
local border = ui.current.border

local is_str_like = function()
  local ctx = require('cmp.config.context')
  return ctx.in_treesitter_capture('comment')
    or ctx.in_treesitter_capture('string')
    or ctx.in_syntax_group('Comment')
    or ctx.in_syntax_group('String')
end

return {
  {
    'zbirenbaum/copilot-cmp',
    enabled = true,
    event = 'InsertEnter',
    opts = {},
    init = function() vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' }) end,
    dependencies = {
      {
        'zbirenbaum/copilot.lua',
        build = ':Copilot auth',
        opts = {
          panel = {
            enabled = true,
            auto_refresh = true,
            layout = {
              position = 'bottom',
              ratio = 0.2,
            },
          },
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 150,
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
            julia = false,
            norg = false,
            quarto = true,
            gitcommit = false,
            NeogitCommitMessage = false,
            DressingInput = false,
            TelescopePrompt = false,
            ['neo-tree-popup'] = false,
            ['dap-repl'] = false,
          },
          server_opts_overrides = {
            settings = {
              advanced = { inlineSuggestCount = 2 },
            },
          },
        },
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      {
        'abecodes/tabout.nvim',
        dependencies = { 'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip' },
        event = 'InsertEnter',
        opts = {
          ignore_beginning = false,
          completion = false,
          tabkey = '',
          backwards_tabkey = '',
          act_as_tab = true,
          act_as_shift_tab = true,
          enable_backwards = true,
        },
      },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'onsails/lspkind.nvim' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'FelipeLema/cmp-async-path' },
      {
        'saadparwaiz1/cmp_luasnip',
        dependencies = 'L3MON4D3/LuaSnip',
      },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
      { 'hrsh7th/cmp-cmdline' },
      { 'petertriho/cmp-git' },
      { 'amarakon/nvim-cmp-lua-latex-symbols' },
      { 'jmbuhr/otter.nvim' },
      {
        'tamago324/cmp-zsh',
        dependencies = { 'Shougo/deol.nvim' },
        opts = {
          zshrc = true,
          filetypes = { '*' },
        },
      },
    },
    config = function()
      local cmp = require('cmp')
      local types = require('cmp.types.lsp')

      local luasnip = require('luasnip')

      ---@type table<integer, integer>
      local modified_priority = {
        [types.CompletionItemKind.Snippet] = 0, -- Top
        [types.CompletionItemKind.Keyword] = 0, -- Top
        [types.CompletionItemKind.Text] = 100, -- bottom
      }

      ---@param kind integer: Kind of completion entry
      local function modified_kind(kind) return modified_priority[kind] or kind end

      vim.keymap.set('s', '<BS>', '<C-O>s')

      -- local function has_words_before()
      --   unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      -- end

      cmp.setup {
        experimental = { ghost_text = false },
        performance = {
          debounce = 40,
          throttle = 40,
          fetching_timeout = 100,
          max_view_entries = 100,
        },
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        view = {
          entries = {
            name = 'custom', -- native | wildmenu
            follow_cursor = false,
            selection_order = 'near_cursor',
          },
        },
        matching = {
          disallow_fuzzy_matching = true,
          disallow_fullfuzzy_matching = true,
          disallow_partial_fuzzy_matching = true,
          disallow_partial_matching = true,
          disallow_prefix_unmatching = false,
        },
        preselect = cmp.PreselectMode.Item, -- Item | None
        sorting = {
          comparators = {
            priority_weight = 1.0,
            cmp.config.compare.locality,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.offset,
            -- function(entry1, entry2)
            --   local a = string.len(string.gsub(entry1.completion_item.label, '[=~()_]', ''))
            --   local b = string.len(string.gsub(entry2.completion_item.label, '[=~()_]', ''))
            --   if a ~= b then return a - b < 0 end
            -- end,
            -- function(entry1, entry2)
            --   local kind1 = modified_kind(entry1.get_kind())
            --   local kind2 = modified_kind(entry2.get_kind())
            --   if kind1 ~= kind2 then return kind1 - kind2 < 0 end
            -- end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.order,
          },
        },
        mapping = cmp.mapping {
          ['<C-CR>'] = cmp.mapping(function(fallback)
            cmp.abort()
            fallback()
          end),
          ['<Up>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ['<Down>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ['<C-n>'] = cmp.mapping(function(fallback)
            if vim.api.nvim_get_mode().mode == 't' then
              fallback()
              return
            end

            -- if vim.api.nvim_get_mode().mode == "s" then
            --   luasnip.jump(1)
            --   return
            -- end

            if cmp.visible() then
              cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }(fallback)
            else
              cmp.mapping.complete()(fallback)
            end
          end),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-c>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ['<CR>'] = cmp.mapping.confirm { behavior = cmp.SelectBehavior.Insert, select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            elseif cmp.visible() then
              -- cmp.select_next_item()
              cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            elseif luasnip.choice_active(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end),
        },
        sources = cmp.config.sources {
          {
            name = 'luasnip',
            priority = 10,
            -- group_index = 1,
            max_item_count = 3,
          },
          {
            name = 'nvim_lsp_siguature_help',
            priority = 9,
            -- group_index = 1,
            keyword_length = 0,
          },
          {
            name = 'otter',
            priority = 8,
            -- group_index = 1,
          },
          {
            name = 'nvim_lsp',
            keyword_length = 0,
            -- group_index = 1,
            -- entry_filter = function(entry, ctx)
            --   local kind = entry:get_kind()
            --   local line = ctx.crsor_line
            --   local col = ctx.cursor_col
            --   local char_before_cursor = string.sub(line, col - 1, col - 1)
            --
            --   if is_str_like() then return false end
            --
            --   if vim.tbl_contains({
            --     types.CompletionItemKind.Text,
            --   }, kind) then
            --     return false
            --   end
            --   if char_before_cursor == '.' then
            --     return vim.tbl_contains({
            --       types.CompletionItemKind.Method,
            --       types.CompletionItemKind.Property,
            --       types.CompletionItemKind.Field,
            --     }, kind)
            --   end
            --   if string.match(line, '^%s+%w+$') then
            --     return kind == types.CompletionItemKind.Function or kind == types.CompletionItemKind.Variable
            --   end
            --
            --   return true
            -- end,
            priority = 7,
          },
          { name = 'async_path', priority = 4, option = { trailing_slash = true } },
          { name = 'copilot', priority = 6 },
          { name = 'nvim_lua', priority = 6 },
          { name = 'neorg', priority = 6 },
          -- { name = 'path', priority = 4 },
          { name = 'jupyter', priority = 5 },
          { name = 'lua_latex_symbols', priority = 5 },
          {
            { name = 'buffer', keyword_length = 5 },
            { name = 'cmp_zsh' },
          },
        },
        window = {
          documentation = cmp.config.window.bordered { border = border },
          completion = {
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            col_offset = -3,
            side_padding = 0,
          },
        },
        formatting = {
          -- deprecated = true,
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require('lspkind').cmp_format {
              maxwidth = 50,
              mode = 'symbol_text',
              -- ellipsis_char = ui.icons.misc.ellipsis -- \U+2026
              -- menu = {
              --   nvim_lsp = 'LSP',
              --   nvim_lua = 'Lua',
              --   luasnip = 'Snip',
              --   buffer = 'Buf',
              --   async_path = 'aPath',
              --   -- path = 'Path',
              --   lua_latex_symbols = 'TeX',
              --   neorg = 'Norg',
              --   git = 'Git',
              --   norg = 'Norg',
              --   env = 'Env',
              --   cmp_zsh = 'Zsh',
              --   dictionary = 'Dict',
              --   spell = 'Spell',
              --   emoji = 'Emoji',
              -- },
            }(entry, vim_item)

            -- if vim.tbl_contains({ 'path' }, entry.source.name) then
            --   local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
            --
            --   if icon then
            --     -- vim_item.kind = string.format(' %s ', icon)
            --     vim_item.kind = icon
            --     vim_item.lspkind_hl_group = hl_group
            --     return vim_item
            --   end
            -- end
            -- if vim_item.kind[entry.source.name] then
            --   vim_item.menu = kind.menu[entry.source.name]
            -- else
            --   vim_item = kind(entry, vim_item)
            -- end
            -- vim_item.menu = kind.menu

            -- local strings = vim.split(kind.kind, "%s", { trimempty = true })
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '    ' .. (strings[2] or '') .. ''
            return kind
          end,
        },
        -- winhighlight = 'Normal:Normal,FloatBorder:VertSplit,CursorLine:FocusedSymbol,Search:None',
      }

      cmp.setup.filetype({ 'bash', 'sh', 'zsh' }, {
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'cmp_zsh' },
          { name = 'luasnip' },
          { name = 'async_path' },
          { name = 'buffer' },
        },
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          {
            name = 'buffer',
            max_item_count = 3,
            keyword_length = 4,
          },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
          { name = 'async_path' },
          {
            name = 'cmdline',
            keyword_length = 1,
            keyword_pattern = [=[[^[:blank:]\!]*]=],
            option = { ignore_cmds = {} },
          },
        },
        matching = { disallow_symbol_nonprefix_matching = false },
      })

      cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done { map_char = { tex = '' } })
      require('cmp_git').setup { filetypes = { 'NeogitCommitMessage' } }

      api.nvim_create_autocmd('CmdWinEnter', {
        callback = function() require('cmp').close() end,
      })
    end,
  },
}
