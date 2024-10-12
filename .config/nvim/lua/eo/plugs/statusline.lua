local catpuss = require('catppuccin.palettes')
local function trunc(trunc_width, trunc_len, hide_width, ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (ellipsis and '' or '…')
    end
    return str
  end
end

local active_formatter = {
  function()
    local formatters = require('conform').list_formatters_for_buffer(0)
    if formatters ~= nil then
      return string:format('  %s', table.concat(formatters, ', '))
    else
      return ''
    end
  end,
  color = { fg = eo.ui.palette.bright_blue },
  fmt = trunc(120, 3, 90, true),
}

return {
  {
    'nvim-lualine/lualine.nvim',
    -- version = '*',
    lazy = false,
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
        -- statusline = { 'alpha' },
        -- refresh = { statusline = 5000, winbar = 5000 },
        refresh = { statusline = 500, winbar = 500 },
        winbar = {
          'help',
          'alpha',
          'fzflua',
        },
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
            separator = { right = '' },
            -- padding = { left = 0, right = 0 },
          },
          {
            'fancy_diff',
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
            color = { fg = 'darkgrey', bg = '#414362', gui = 'italic,bold' },
            padding = { left = 0, right = 0 },
          },
        },
        lualine_x = {
          {
            'fancy_diagnostics',
            symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
            colored = true,
            -- separator = { left = '' },
          },
          {
            'fancy_filetype',
            ts_icon = ' ',
            padding = { left = 0, right = 0 },
            -- separator = { right = '' },
          },
        },
        lualine_y = {
          { 'progress', padding = { left = 0, right = 0 } },
          { 'fancy_location', separator = { left = '│' } },
          { 'fancy_searchcount' },
        },
        lualine_z = {
          -- { "require('weather.lualine').custom(default_f_formatter, require('weather.other_icons').nerd_font)"},
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
        lualine_y = { 'fancy_location', 'fancy_searchcount' },
        lualine_z = {},
      },
      extensions = {
        'toggleterm',
        'quickfix',
        'overseer',
        'neo-tree',
        'fzf',
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
