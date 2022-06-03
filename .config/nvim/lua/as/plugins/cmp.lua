---@diagnostic disable: unused-local
return function()
  local texsym, _ = require("nvim-web-devicons").get_icon("main.text", "tex")
  local cmp = require('cmp')
  local h = require('as.highlights')

  local fn = vim.fn
  local api = vim.api
  local fmt = string.format
  local t = as.replace_termcodes
  local border = as.style.current.border
  local lsp_hls = as.style.lsp.kind_highlights

  -- Make the source information less prominent
  local faded = h.alter_color(h.get_hl('Pmenu', 'bg'), 70)
  local kind_hls = {
    CmpItemAbbr = { foreground = 'fg', background = 'NONE', italic = false, bold = false },
    CmpItemMenu = { foreground = faded, italic = true, bold = false },
    CmpItemAbbrMatch = { foreground = { from = 'Keyword' } },
    CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' },
    CmpItemAbbrMatchFuzzy = { italic = true, foreground = { from = 'Keyword' } },
  }
  for key, _ in pairs(lsp_hls) do
    kind_hls['CmpItemKind' .. key] = { foreground = { from = lsp_hls[key] } }
  end

  h.plugin('Cmp', kind_hls)

  local function tab(fallback)
    local ok, luasnip = as.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_next_item()
    elseif ok and luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end

  local function shift_tab(fallback)
    local ok, luasnip = as.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_prev_item()
    elseif ok and luasnip.jumpable(-1) then
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
      'CursorLine:Visual',
      'Search:None',
    }, ','),
  }
  cmp.setup({
    preselect = cmp.PreselectMode.None,
    window = {
      completion = cmp.config.window.bordered(cmp_window),
      documentation = cmp.config.window.bordered(cmp_window),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<Tab>'] = cmp.mapping(tab, { 'i', 's', 'c' }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's', 'c' }),
      -- ['<C-n>'] = cmp.mapping(tab, { 'i', 's', 'c' }),
      -- ['<C-p>'] = cmp.mapping(shift_tab, { 'i', 's', 'c' }),
      -- ['<c-h>'] = cmp.mapping(function()
      --   api.nvim_feedkeys(fn['copilot#Accept'](t('<Tab>')), 'n', true)
      -- end),
      -- ['<C-q>'] = cmp.mapping({
      --   i = cmp.mapping.abort(),
      --   c = cmp.mapping.close(),
      -- }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- If nothing is selected don't complete
    },
    formatting = {
      deprecated = true,
      fields = { 'abbr', 'kind', 'menu' },
      duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        cmp_tabnine = 0,
        nvim_lua = 0,
        luasnip = 1,
        latex_symbols = 1
      },
      format = function(entry, vim_item)
        vim_item.kind = fmt('%s %s', vim_item.kind, as.style.lsp.codicons[vim_item.kind], vim_item.kind)
        -- FIXME: automate this using a regex to normalise names
        local menu = ({
          nvim_lsp = '[lsp]',
          nvim_lua = '[lua]',
          emoji = '[E]',
          path = '[P]',
          neorg = '[Nrg]',
          orgmode = '[O]',
          cmp_tabnine = '[T9]',
          luasnip = '[SN]',
          dictionary = '[Dic]',
          buffer = '[B]',
          spell = '[SP]',
          cmdline = '[Cmd]',
          cmdline_history = '[Hist]',
          rg = '[Rg]',
          cmp_git = '[Git]',
          latex_symbols = texsym .. ""
        })[entry.source.name]
        if entry.source.name == 'cmp_tabnine' then
          if entry.completion_item.data and entry.completion_item.data.detail then
            menu = entry.completion_item.data.detail .. ' ' .. menu
          end
          vim_item.kind = ' '
        end
        vim_item.menu = menu
        return vim_item
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lua' },
      { name = 'nvim_lsp' },
      { name = 'cmp_tabnine' },
      { name = 'luasnip' },
      { name = 'path' },
    }, {
      { name = 'latex_symbols' },
      {
        name = 'buffer',
        options = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(api.nvim_list_wins()) do
              bufs[api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      -- { name = 'spell' },
    }),
  })

  local search_sources = {
    view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
    sources = cmp.config.sources({
      { name = 'nvim_lsp_document_symbol' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.setup.cmdline('/', search_sources)
  cmp.setup.cmdline('?', search_sources)
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
      { name = 'cmdline_history', max_item_count = 6 },
      { name = 'path', max_item_count = 5 },
    }),
  })

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
end
