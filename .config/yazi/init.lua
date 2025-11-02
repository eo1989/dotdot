require('auto-layout').setup({
  breakpoint_large = 110,  -- new large window threshold, defaults to 100
  breakpoint_medium = 60,  -- new medium window threshold, defaults to 50
})

require('duckdb').setup()
-- require('full-border'):setup()
-- require('git'):setup()
-- THEME.git = THEME.git or {}

-- if os.getenv("$NVIM") then
--   local toggle_pane = require('toggle-pane')
--   toggle_pane:entry('min-preview')
-- end
