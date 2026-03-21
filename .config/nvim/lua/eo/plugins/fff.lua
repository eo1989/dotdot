---@type LazySpec
return {
  ---@module 'fff'
  'dmtrKovalenko/fff.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  build = function() require('fff.download').download_or_build_binary() end,
  opts = {
    prompt = '󰅂 ' or eo.ui.icons.misc.chevron_right,
    layout = {
      height = 0.75,
      width = 0.9,
      prompt_position = 'top',
      preview_position = 'bottom',
      preview_size = 0.6,
      flex = {
        size = 144,
        wrap = 'bottom',
      },
    },
    preview = {
      enabled = true,
      max_size = 25 * 1024 * 1024, -- dont read files larger than 10MB, note: change to 25
      line_numbers = true,
      wrap_lines = false,
      filetypes = {
        svg = { wrap_lines = true },
        markdown = { wrap_lines = true },
        quarto = { wrap_lines = true },
        text = { wrap_lines = true },
      },
    },
    keymaps = {
      close = '<Esc>',
      select = '<CR>',
      select_split = '<C-s>',
      select_vsplit = '<C-v>',
      select_tab = '<C-t>',
      -- you can assign multiple keys to any action
      move_up = { '<Up>', '<C-p>' },
      move_down = { '<Down>', '<C-n>' },
      preview_scroll_up = '<C-u>',
      preview_scroll_down = '<C-d>',
      toggle_debug = '<F2>',
      -- goes to the previous query in history
      -- cycle_previous_query = '<C-Up>',
      cycle_previous_query = '<M-Up>',
      -- multi-select keymaps for quickfix
      toggle_select = '<Tab>',
      send_to_quickfix = '<C-q>',
    },
  },
  keys = {
    {
      '<localleader>ff',
      function() require('fff').find_files() end,
      desc = 'FFFind Files',
    },
    {
      '<localleader>fg',
      function() require('fff').find_in_git_root() end,
      desc = 'FFFind Files',
    },
  },
}
