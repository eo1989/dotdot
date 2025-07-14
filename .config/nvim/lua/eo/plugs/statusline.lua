local api, bo, fn = vim.api, vim.bo, vim.fn
-- local catpuss = require('catppuccin.palettes')

-- local function trunc(trunc_width, trunc_len, hide_width, ellipsis)
--   return function(str)
--     local win_width = vim.fn.winwidth(0)
--     if hide_width and win_width < hide_width then
--       return ''
--     elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
--       return str:sub(1, trunc_len) .. (ellipsis and '' or '…')
--     end
--     return str
--   end
-- end

-- local active_tools = {
--   formatters = require('conform').list_formatters_for_buffer(0),
--   linters = require('lint').get_running(0),
--   function(formatters, linters)
--     if formatters ~= nil and linters ~= nil then
--       return string:format('%s %s', table.concat({formatters, linters}, ', '))
--     else
--       return ''
--     end
--   end,
--   color = { fg = eo.ui.palette.bright_blue },
--   fmt = trunc(120, 3, 90, true)
-- }

local function lint_and_format_status()
  local bufnr = api.nvim_get_current_buf()
  local filetype = bo[bufnr].filetype
  local effective_ft = filetype

  -- literate programming handling
  if filetype == 'markdown' or filetype == 'quarto' then
    -- if vim. == "markdown" or filetype == "quarto" then
    local row = api.nvim_win_get_cursor(0)[1]
    local lines = api.nvim_buf_get_lines(bufnr, 0, row, false)

    local in_code_block = false
    local lang_in_block = nil

    -- scan upward to determine if we're in a codeblock
    for i = row - 1, 1, -1 do
      local line = lines[i]

      if filetype == 'quarto' then
        --[[ match quarto code chunks: ```{lang} or ```{lang options} ]]
        local lang = line:match('^```{(%w+)[^}]*}')
        if lang then
          lang_in_block = lang
          in_code_block = true
          break
        elseif line:match('^```') then
          break -- not a code chunk w/ language, exit
        end
      elseif filetype == 'markdown' then
        -- match markdown code block: ```lang
        local lang = line:match('^```(%w+)')
        if lang then
          lang_in_block = lang
          code_block = true
          break
        elseif line:match('^```$') then
          break -- not a code block with language
        end
      end
    end

    if in_code_block and lang_in_block then
      effective_ft = lang_in_block
    else
      effective_ft = filetype -- fallback to markdown/quarto if not in a code cell
    end
  end

  -- linters
  local lint = require('lint')
  local linters = lint.linters_by_ft[effective_ft] or {}

  -- formatters
  local conform = require('conform')
  local formatters = conform.list_formatters(bufnr, { effective_ft })
  local formatter_names = {}
  for _, formatter in ipairs(formatters) do
    table.insert(formatter_names, formatter.name)
  end

  -- display
  local ft_label = (effective_ft ~= filetype) and ('[' .. effective_ft .. '] ') or ''
  local lint_str = #linters > 0 and ('󰦨 ' .. table.concat(linters, ',')) or ''
  local fmt_str = #formatter_names > 0 and (' 󰁨 ' .. table.concat(formatter_names, ',')) or ''

  return ft_label .. lint_str .. fmt_str
end

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    -- lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'meuter/lualine-so-fancy.nvim',
    },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto', -- auto, tokyonight
        -- component_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        refresh = { statusline = 500, winbar = 500 },
        winbar = { 'help' },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            'fancy_mode',
            width = 1,
            separator = { left = '' },
            padding = { left = 0, right = 1 },
          },
        },
        lualine_b = {
          -- { 'filename', shorting_target = 25 },
          {
            'fancy_cwd',
            separator = { right = '' },
            colors = { fg = '#293248', bg = '#' },
          },
          {
            'fancy_branch',
            -- separator = { right = '' },
            separator = { left = '', right = '' },
            padding = { left = 0, right = 0 },
          },
          {
            'fancy_diff',
            separator = { left = '', right = '' },
            symbols = { added = '+', modified = '~', removed = '-' },
            colored = true,
            padding = { left = 1, right = 0 },
          },
        },
        lualine_c = {
          '%=',
          {
            'fancy_lsp_servers',
            separator = { left = '', right = '' },
            -- separator = { left = '' },
            color = { fg = 'darkgrey', bg = '#414362', gui = 'italic,bold' },
            padding = { left = 0, right = 0 },
          },
          {
            'lint_and_format_status',
            separator = { left = '', right = '' },
            -- separator = { right = '' },
            color = { fg = 'darkgrey', bg = '#414362', gui = 'italic' },
            -- padding = { left = 0, right = 0 },
          },
          '%=',
        },
        lualine_x = {
          {
            'fancy_diagnostics',
            symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
            colored = true,
            separator = { left = '' },
          },
          -- {
          --   "swenv",
          --   cond = function()
          --     return vim.bo['filetype'] == 'python'
          --   end,
          -- },
          {
            'fancy_filetype',
            ts_icon = ' ',
            padding = { left = 0, right = 0 },
            -- separator = { right = '' },
          },
          -- { 'progress', padding = { left = 0, right = 0 } },
          { 'fancy_location', separator = { left = '│' } },
          { 'fancy_searchcount' },
        },
        lualine_z = {
          {
            function() return ' ' .. os.date('%R') end,
            separator = { left = '', right = '' },
            padding = { left = 0, right = 0 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'progress', 'fancy_location', 'fancy_searchcount' },
        lualine_z = {},
      },
      extensions = {
        'toggleterm',
        'quickfix',
        'overseer',
        'neo-tree',
        'oil',
        'lazy',
        'man',
        'fugitive',
        'trouble',
        'mason',
        'symbols-outline',
        'nvim-dap-ui',
      },
    },
  },
}
