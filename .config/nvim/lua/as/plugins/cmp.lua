---@diagnostic disable: unused-function, unused-local, redundant-parameter, redundant-parameter
return function()
  local luasnip = require('luasnip')

  local cmp = require('cmp')
  -- local types = require('cmp.types')
  -- local h = require('as.highlights')

  local api,fn = vim.api, vim.fn
  local fmt = string.format
  -- local t = as.replace_termcodes
  local border = as.style.current.border
  local lsp_hls = as.style.lsp.highlights
  local ellipsis = as.style.icons.misc.ellipsis

  -- local format = require('lspkind').cmp_format({ mode = 'symbols_text', maxwidth = 50 })

  -- local function T(string)
  --   return vim.api.nvim_replace_termcodes(string, true, true, true)
  -- end

  -- local feedkey = function(key, mode)
  --   api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
  -- end

  -- local check_bs = function()
  --   local col = vim.fn.col('.') - 1
  --   return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
  -- end

  -- local has_any_words_b4 = function()
  --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  -- end

  -- local kind_hls = as.fold(
  --   function(accum, value, key)
  --     accum[#accum + 1] = { ['cmpItemKind' .. key] = { foreground = { from = value } } }
  --     return accum
  --   end,
  --   lsp_hls,
  --   {
  --     { CmpItemAbbr = { foreground = 'fg', background = 'NONE', italic = false, bold = true } },
  --     { CmpItemAbbrMatch = { foreground = { from = 'Keyword' } } },
  --     { CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' } },
  --     { CmpItemAbbrMatchFuzzy = { italic = true, foreground = { from = 'Keyword' } } },
  --     -- Make the source information less prominent
  --     {
  --       CmpItemMenu = {
  --         fg = { from = 'Pmenu', attr = 'bg', alter = 10 },
  --         italic = true,
  --         bold = false,
  --       },
  --     },
  --   }
  -- )
  -- h.plugin('Cmp', kind_hls)

 --{{{ ---------------------------------------- akinsho back up---------------------------------------
  ----- ***
  -- local function tab(fallback)
  --   if cmp.visible() then
  --     cmp.select_next_item()
  --   elseif luasnip.expand_or_locally_jumpable() then
  --     luasnip.expand_or_jump()
  --   else
  --     fallback()
  --   end
  -- end
  -- local function shift_tab(fallback)
  --   if cmp.visble() then
  --     cmp.select_prev_item()
  --   elseif luasnip.jumpable(-1) then
  --     luasnip.jump(-1)
  --   else
  --     fallback()
  --   end
  -- end
  ----- ***
  -- local function tab(fallback)
  --   -- if cmp.visible() then
  --   --   cmp.select_next_item()
  --   -- elseif luasnip.expandable() then
  --   --   luasnip.expand()
  --   -- elseif luasnip.jumpable(1) then
  --   --   luasnip.jumpable(1)
  --   -- elseif luasnip.expand_or_jumpable() then
  --   if luasnip.expand_or_locally_jumpable() then
  --     luasnip.expand_or_jump()
  --   elseif has_any_words_b4() then
  --     -- feedkey('<Tab>', 'n')
  --     cmp.complete()
  --     -- fallback()
  --   else
  --     -- feedkey('<Plug>(Tabout)', '')
  --     fallback()
  --   end
  -- end
  -- local function shift_tab(fallback)
  --   -- if cmp.visble() then
  --   --   cmp.select_prev_item()
  --   if luasnip.jumpable(-1) then
  --     luasnip.jump(-1)
  --   -- elseif has_any_words_b4() then
  --     -- feedkey('<C-d>', 'i')
  --     -- feedkey('<Plug>(TaboutBack)', '')
  --   else
  --     fallback()
  --   end
  -- end
  ----- *** }}}

  local function tab(fallback)
    if luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    -- elseif has_any_words_b4() then
    --   cmp.complete()
    else
      fallback()
    end
  end

  local function shift_tab(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end


  local cmp_window = {
    border = border,
    winhighlight = table.concat({
      'Normal:NormalFloat',
      -- 'Normal:Pmenu',
      'FloatBorder:FloatBorder',
      -- 'FloatBorder:BorderBG',
      -- 'FloatBorder:Pmenu',
      'CursorLine:CmpCursorLine',
      -- 'CursorLine:PmenuSel',
      'Search:None',
    }, ','),
  }

  cmp.setup({
    performance = {
      debounce = 20,
      throttle = 10,
    },
    view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
    experimental = { ghost_text = false },
    preselect = cmp.PreselectMode.Item, -- or None
    window = {
      -- completion = cmp.config.window.bordered(cmp_window),
      completion = {
        winhighlight =
          'Normal:NormalFloat',
          -- 'FloatBorder:Pmenu',
          'FloatBorder:FloatBorder',
          -- 'CursorLine:PmenuSel',
          'CursorLine:CmpCursorLine',
          'Search:None',
        col_offset = -3,
        side_padding = 0
      },
      -- documentation = cmp.config.window.bordered(cmp_window),
      -- documentation = cmp.config.window.bordered(),
      documentation = {
        border = border,
        winhighlight = "Search:None",
        max_width = 80,
        max_height = 12,
      },
    },
    mapping = {
      -- ['<Tab>'] = cmp.mapping(tab, { 'i', 's', 'c' }),
      -- ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's', 'c' }),
      --------------------------------------------------------------------
      ['<Tab>'] = cmp.mapping(tab, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's' }),
      -- ['<Tab>'] = cmp.mapping({
      --   i = tab,
      --   s = tab,
      -- }),
      -- ['<S-Tab>'] = cmp.mapping({
      --   i = shift_tab,
      --   s = shift_tab,
      -- }),
      -- ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      -- ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      -- ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), --, { "i", "c" },
      ['<C-j>'] = cmp.mapping.select_next_item(), --, { "i", "c" },
      -- ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), --, { "i", "c" },
      ['<C-k>'] = cmp.mapping.select_prev_item(), --, { "i", "c" },
      ['<C-c>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<C-e>'] = cmp.config.disable,
      ['<C-y>'] = cmp.config.disable,
      -- ['<C-d>'] = cmp.mapping.scroll_docs(-3), { 'i', 'c' },
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4), { 'i', 'c' },
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-space>'] = cmp.mapping(cmp.mapping.complete()),
      -- ['<CR>'] = cmp.mapping.confirm({ select = false }), -- If nothing is selected don't complete
      ['<CR>'] = cmp.mapping.confirm(
        {
          select = true,
          behavior = cmp.ConfirmBehavior.Replace
        }
      ),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    formatting = {
      deprecated = true,
      fields = { 'kind', 'abbr', 'menu' }, --, 'menu'
      format = function(entry, vim_item)
        -- local MAX = math.floor(vim.o.columns * 0.55)
        -- if #vim_item.abbr >= MAX then vim_item.abbr = vim_item.abbr:sub(1, MAX) .. ellipsis end
        -- vim_item.kind = fmt('%s %s', as.style.current.lsp_icons[vim_item.kind], vim_item.kind)

        local kind = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
                     -- require('lspkind').cmp_format({ mode = 'symbols_text', maxwidth = 50 })
        -- local kind = format(entry, vim_item)
        local strings = vim.split(kind.kind, '%s', { trimempty = true })
        -- local strings = vim.split(vim_item.kind, '%s', { trimempty = true })
        kind.kind = ' ' .. strings[1] .. ' '
        kind.menu = '    (' .. strings[2] .. ')'
        -- vim_item.kind = " " .. strings[1] .. " "
        -- vim_item.menu = "    (" .. strings[2] .. ")"
        -- kind.kind = strings[1] .. " "
        -- kind.menu = "   " .. strings[2]

        vim_item.dup = ({
          nvim_lsp = 0,
          nvim_lua = 0,
          path = 0,
          cmp_tabnine = 0,
          luasnip = 0,
          cmdline = 0,
          cmdline_history = 0,
          rg = 0,
          norg = 0,
          org = 0,
          buffer = 0,
          cmp_zsh = 0,
          latex_symbols = 0,
          emoji = 0,
          spell = 0,
          cmp_greek = 0,
          pandoc_references = 0
          -- nvim_lsp_document_symbol = 0,
        })
        vim_item.menu = ({
          nvim_lsp = '[Lsp]',
          nvim_lua = '[Lua]',
          emoji = '[E]',
          path = '[Path]',
          neorg = '[Norg]',
          cmp_tabnine = '[T9]',
          luasnip = '[Snip]',
          dictionary = '[Dic]',
          buffer = '[Buf]',
          spell = '[Sp]',
          cmdline = '[Cmd]',
          latex_symbols = '[Latex]',
          cmdline_history = '[Hist]',
          orgmode = '[Org]',
          -- norg = '[Norg]',
          rg = '[Rg]',
          git = '[Git]',
          cmp_zsh = '[Zsh]',
          cmp_greek = '[Greek]',
          pandoc_references = '[🐼 refs]'
          -- nvim_lsp_document_symbol = ['Doc'],
        })[entry.source.name]
        -- return vim_item -- and kind
        return kind
      end
    },
    sources = cmp.config.sources(
      {
        { name = 'nvim_lsp', priority = 1, group_index = 1 },
        { name = 'luasnip', group_index = 1, priority = 1 },
        { name = 'path', priority = 2, group_index = 1 },
        { name = 'cmp_tabnine', group_index = 1, priority = 2 },
      }, {
        -- {
        --   name = 'latex_symbols',
        --   ft = { 'julia', 'markdown' },
        --   group_index = 1,
        -- },
        {
          name = 'buffer', priority = 3, keyword_length = 3, max_item_count = 3, group_index = 1,
          options = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        -- {
        --   name = 'pandoc_references',
        --   ft = { 'qmd', 'markdown' },
        --   priority = 2,
        --   keyword_length = 3,
        --   group_index = 2,
        -- },
        -- {
        --   name = 'cmp_zsh',
        --   ft = { 'zsh' },
        --   group_index = 1,
        --   max_item_count = 5,
        -- },
      }),
    })

  -- cmp.setup.filetype({ 'markdown', 'julia', 'latex' }, {
  --   sources = cmp.config.sources({
  --     { name = 'latex_symbols', group_index = 1, max_item_count = 4 },
  --     -- { name = 'nvim_lsp' },
  --     -- { name = 'luasnip' },
  --     -- { name = 'path' },
  --     -- { name = 'buffer' },
  --     { name = 'cmp_greek', group_index = 2, max_item_count = 4 },
  --   })
  -- })

  -- cmp.setup.filetype("zsh", {
  -- sources = cmp.config.sources({
  --     { name = "cmp_zsh", group_index = 1 },
  --     -- { name = "nvim_lsp", group_index = 1 },
  --     -- { name = "luasnip", group_index = 1 },
  --     -- { name = "path", group_index = 2 },
  --     -- { name = "buffer", group_index = 2 },
  --   })
  -- })

  cmp.setup.cmdline({ '/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(cmp.setup.mapping),
    sources = cmp.config.sources({
      { name = 'nvim_lsp_document_symbol' },
      { name = 'buffer' },
    }),
  })

  cmp.setup.cmdline(':', {
    completion = { keyword_length = 1 },
    mapping = cmp.mapping.preset.cmdline(cmp.setup.mapping),
    -- window = {
    --   completion = {
    --     side_padding = 1,
    --   },
    -- },
    sources = cmp.config.sources({
      { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
      { name = 'path' },-- priority = 11 },
      -- { name = 'cmdline_history', max_item_count = 5 }, -- priority = 10 },
    }),
  })

  require('cmp').setup.filetype({ 'dap-repl', 'dapui_watches' }, {
    sources = { { name = 'dap' } },
  })

  require('cmp').setup.filetype({ 'sql' }, {
    sources = {
      { name = 'vim-dadbod-completion' },
      -- { name = 'nvim_lsp' }
    }
  })

  -- may have to remove some of these ft's and put them in after/ftplugin
  require('cmp').setup.filetype({ 'org', 'norg' }, {
    sources = {
      { name = 'neorg' },
      { name = 'orgmode' },
      -- { name = 'latex_symbols' },
      -- { name = 'nvim_lsp' },
    },
  })

  require('cmp').setup.filetype({'zsh'}, {
    sources = {
      { name = 'cmp_zsh' },
      { name = 'nvim_lsp' },
      {
        { name = 'path' },
        { name = 'buffer' },
      },
    },
  })

  require('cmp').setup.filetype({'julia', 'markdown', 'latex'}, {
    sources = {
      { name = 'latex_symbols', group_index = 1, max_item_count = 4 },
      { name = 'luasnip' },
      { name = 'cmp_greek', group_index = 2, max_item_count = 4 },
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
    },
  })

end
-- vim: fdm=marker fdl=0
