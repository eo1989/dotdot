---@diagnostic disable: unused-function, unused-local, redundant-parameter, redundant-parameter
--- [1]: https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/nvim-cmp.lua
return function()
  local luasnip = require('luasnip')

  local cmp = require('cmp')
  -- local types = require('cmp.types')
  -- local h = require('as.highlights')

  local api,fn = vim.api, vim.fn
  local fmt = string.format
  local t = as.replace_termcodes
  local border = as.style.current.border
  local lsp_hls = as.style.lsp.highlights
  local ellipsis = as.style.icons.misc.ellipsis

  -- {{{
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
  --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(col, col):match("%s") == nil

  -- local has_any_words_b4 = function()
  --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --   return col ~= 0 and vim.api.nvim_buf_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
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
  --         fg = { from = 'Normal', attr = 'bg', alter = 10 },
  --         italic = true,
  --         bold = true,
  --       },
  --     },
  --   }
  -- )
  -- h.plugin('Cmp', kind_hls)
  -- }}}

 --{{{ ----------------------------------------back up --------------------------------------
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
  --[[ ['<Tab>'] = cmp.mapping(function(fallback)
    local col = vim.fn.col('.') - 1
    if cmp.visble() then
      cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      fallback()
    else
      cmp.complete()
    end
  end, {'i', 's'})
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visble() then
      cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
    else
      fallback()
    end
  end, {'i', 's'}) ]]

  -- local has_words_bfour = function()
  --   if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then return false end
  --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --   return col ~= 0 and vim.api.nvim_buf_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
  -- end
  -- local function tab(fallback)
  --   if cmp.visible() and has_words_bfour() then
  --     cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
  --   elseif luasnip.expand_or_locally_jumpable() then
  --     luasnip.expand_or_jump()
  --   else
  --     fallback()
  --   end
  -- end

  ----- *** }}}


  local function tab(fallback)
    if luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
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
      'FloatBorder:FloatBorder',
      'CursorLine:CmpCursorLine',
      'Search:None',
    }, ','),
  }

  cmp.setup({
    performance = {
      debounce = 50,
      throttle = 10,
    },
    view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
    experimental = { ghost_text = true },
    preselect = cmp.PreselectMode.None, -- or None
    window = {
      completion = {
        winhighlight =
          'Normal:CmpPmenu',
          'FloatBorder:FloatBorder',
          'CursorLine:PmenuSel',
          'Search:None',
        col_offset = -3,
        side_padding = 0
      },
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
      -- ['<Tab>'] = cmp.mapping(tab, { 'i', 's' }),
      -- ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's' }),
      -- ['<C-h>'] = cmp.mapping(
      --   function(_) api.nvim_feedkeys(fn['copilot#Accept'](t('<Tab>')), 'n', true) end
      -- ),
      ['<Tab>'] = cmp.mapping({
        i = tab,
        s = tab,
      }),
      ['<S-Tab>'] = cmp.mapping({
        i = shift_tab,
        s = shift_tab,
      }),
      ['<C-j>'] = cmp.mapping.select_next_item(), --, { "i", "c" },
      ['<C-k>'] = cmp.mapping.select_prev_item(), --, { "i", "c" },
      ['<C-c>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- ['<C-e>'] = cmp.config.disable,
      -- ['<C-e>'] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.close()
      --     fallback()
      --   else
      --     cmp.complete()
      --   end
      -- end),
      ------------------------ lukas-reineke dotfiles [1] -----------------------------------
      ['<C-n>'] = function(fallback)
        if cmp.visible() then
          return cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }(fallback)
        else
          return cmp.mapping.complete { reason = cmp.ContextReason.Auto }(fallback)
        end
      end,
      ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      ['<CR>'] = function(fallback)
        if cmp.visible() then
          return cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }(fallback)
        else
          return fallback()
        end
      end,
      ---------------------------------------------------------------------
      ['<C-y>'] = cmp.config.disable,
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-space>'] = cmp.mapping(cmp.mapping.complete()),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end
    },
    formatting = {
      deprecated = true,
      fields = { 'kind', 'abbr', 'menu' }, --, 'menu'
      format = function(entry, vim_item)
        local kind = require('lspkind').cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          symbol_map = { Copilot = '[]' }
        })(entry, vim_item)
        local strings = vim.split(kind.kind, '%s', { trimempty = true })
        kind.kind = ' ' .. strings[1] .. ' '
        kind.menu = '    (' .. strings[2] .. ')'
        vim_item.dup = ({
          otter = 1,
          nvim_lsp = 1,
          nvim_lua = 1,
          path = 0,
          cmp_tabnine = 1,
          copilot = 0,
          luasnip = 1,
          cmdline = 0,
          cmdline_history = 0,
          rg = 0,
          norg = 0,
          orgmode = 0,
          buffer = 1,
          cmp_zsh = 0,
          latex_symbols = 0,
          emoji = 0,
          spell = 0,
          cmp_pandoc_references = 0
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
          otter = '[Otter]',
          rg = '[Rg]',
          git = '[Git]',
          cmp_zsh = '[Zsh]',
          cmp_pandoc_references = '[🐼 refs]',
          -- copilot = '[]',
          -- nvim_lsp_document_symbol = ['Doc'],
        })[entry.source.name]
        -- return vim_item -- and kind
        return kind
      end
    },
    sources = cmp.config.sources(
      {
        { name = 'nvim_lsp', group_index = 2 },
        -- { name = 'nvim_lsp', priority = 1, group_index = 1 },
        { name = 'luasnip', group_index = 2 },
        -- { name = 'luasnip', group_index = 1, priority = 1 },
        { name = 'path', group_index = 2 },
        -- { name = 'path', priority = 2, group_index = 1 },
        -- { name = 'copilot', group_index = 2 },
        { name = 'cmp_tabnine', group_index = 2 },
        -- { name = 'cmp_tabnine', group_index = 1, priority = 2 },
      }, {
        {
          name = 'otter',
          ft = { 'quarto' }
        },
        {
          name = 'orgmode'
        },
        {
          name = 'neorg'
        },
        {
          name = 'latex_symbols',
          ft = { 'julia', 'markdown', 'quarto' },
        },
        {
          name = 'buffer',
          keyword_length = 2,
          options = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        {
          name = 'pandoc_references',
          ft = { 'quarto', 'markdown' },
          priority = 2,
          keyword_length = 3,
          group_index = 2,
        },
        {
          name = 'cmp_zsh',
          ft = { 'zsh' },
          group_index = 1,
          max_item_count = 5,
        },
      }),
    })


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
      { name = 'nvim_lsp' }
    }
  })

  -- may have to remove some of these ft's and put them in after/ftplugin
  -- require('cmp').setup.filetype({ 'org', 'norg' }, {
  --   sources = {
  --     { name = 'neorg' },
  --     { name = 'orgmode' },
  --     -- { name = 'latex_symbols' },
  --     -- { name = 'nvim_lsp' },
  --   },
  -- })

  -- require('cmp').setup.filetype({'zsh'}, {
  --   sources = {
  --     { name = 'cmp_zsh' },
  --     { name = 'nvim_lsp' },
  --     {
  --       { name = 'path' },
  --       { name = 'buffer' },
  --     },
  --   },
  -- })

  -- require('cmp').setup.filetype({'julia', 'markdown', 'latex'}, {
  --   sources = {
  --     { name = 'latex_symbols', group_index = 1, max_item_count = 4 },
  --     { name = 'luasnip' },
  --     { name = 'nvim_lsp' },
  --     { name = 'path' },
  --     { name = 'buffer' },
  --   },
  -- })

end
-- vim:set fdm=marker fdl=0
