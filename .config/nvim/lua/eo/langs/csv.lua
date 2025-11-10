---@module "lazy"
---@type LazySpec
return {
  {
    'hat0uma/csvview.nvim',
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
    ft = 'csv',
    ---@module 'csvview'
    ---@type CsvView.Options
    opts = {
      view = { header_lnum = 1 },
      parser = { comments = { '#', '//' } },
      keymaps = {
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        jump_next_field_start = { 'w', mode = { 'n', 'v' } },
        jump_prev_field_start = { 'b', mode = { 'n', 'v' } },
        jump_next_field_end = { 'e', mode = { 'n', 'v' } },
      },
    },
    -- from olimorris, everything above is from dsully/hat0umas defaults
    init = function()
      vim.api.nvim_create_user_command(
        'Csv',
        function()
          require('csvview').toggle(0, {
            parser = {
              delimiter = ',',
              quote_char = '"',
              comment_char = '#',
            },
            view = {
              display_mode = 'border',
              header_lnum = 1,
            },
          })
        end,
        {}
      )
    end,
  },
}
