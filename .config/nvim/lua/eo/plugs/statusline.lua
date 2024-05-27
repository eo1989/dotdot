-- local components = require('eo.plugs.components')
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'meuter/lualine-so-fancy.nvim',
    },
    lazy = false,
    opts = {
      -- local components = require('eo.plugs.components')
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        statusline = { 'alpha', '' },
        refresh = { statusline = 100, winbar = 100 },
        winbar = {
          'help',
          'alpha',
        },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          { 'fancy_mode', { width = 1 } },
        },
        lualine_b = {
          { 'fancy_branch' },
          { 'fancy_diff' },
        },
        -- lualine_b = { components.git_repo, 'branch' },
        lualine_c = {
          { 'fancy_filename' },
          { 'fancy_cwd', { substitute_home = true } },
          -- components.diff,
          { 'fancy_diagnostics' },
          -- components.noice_command,
          -- components.noice_mode,
          -- { require("NeoComposer.ui").status_recording },
          -- components.separator,
          -- components.lsp_client,
        },
        -- lualine_x = { components.spaces, 'encoding', 'fileformat', 'filetype', 'progress' },
        -- lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_x = {
          -- 'fileformat',
          -- { 'filetype', icon_only = true, padding = { left = 1, right = 1 } },
          { 'fancy_filetype', { icon_only = true, ts_icon = ' ' } },
          { 'fancy_lsp_servers' },
        },
        lualine_y = {
          -- { 'progress', separator = { left = '', right = '' }, padding = { left = 1, right = 0 } },
          -- { 'location', separator = { left = '', right = '' }, padding = { left = 0, right = 1 } },
          { 'progress', padding = { left = 0, right = 0 } },
          { 'fancy_location', padding = { left = 0, right = 1 } },
          { 'fancy_searchcount' },
        },
        lualine_z = {
          function() return ' ' .. os.date('%R') end,
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        'ToggleTerm',
        'Quickfix',
        'Overseer',
        'Neo-Tree',
        'fzf',
        'Lazy',
        'Man',
        'Trouble',
        'Aerial',
        'Symbols-Outline',
        'Nvim-Dap-UI',
      },
    },
  },
}
