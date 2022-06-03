return function()
  require('as.highlights').plugin('dressing', { FloatTitle = { inherit = 'Visual', bold = true } })
  require('dressing').setup {
    input = {
      insert_only = false,
      winblend = 2,
      border = as.style.current.border,
    },
    select = {
      telescope = require('telescope.themes').get_cursor {
        layout_config = {
          -- limit is half the max lines bc this is the cursor theme
          -- unless cursor is at top/bottom it will only have
          -- the screen available
          height = function(self, _, max_lines)
            local results = #self.finder.results
            local PADDING = 4 -- this represents the size of the telescope window
            local LIMIT = math.floor(max_lines / 2)
            return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
          end,
        },
      },
    },
  }
end
