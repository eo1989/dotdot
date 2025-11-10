-- require('auto-layout').setup({
--   breakpoint_large = 110,  -- new large window threshold, defaults to 100
--   breakpoint_medium = 60,  -- new medium window threshold, defaults to 50
-- })

th.git = th.git or {}
th.git.modified = ui.Style():fg("blue")
th.git.deleted = ui.Style():fg("red"):bold()
require('git'):setup()

require('duckdb').setup({
  mode = "standard",              -- Default: "summarized"
  cache_size = 1000,              -- Default: 500
  row_id = false,             -- Default: false
  -- minmax_column_width = 21,       -- Default: 21
  column_fit_factor = 10.0,       -- Default: 10.0
})

require('full-border'):setup()

require('zoxide'):setup{
  update_db = true
}


-- require('git'):setup()
-- THEME.git = THEME.git or {}

-- if os.getenv("$NVIM") then
--   local toggle_pane = require('toggle-pane')
--   toggle_pane:entry('min-preview')
-- end
