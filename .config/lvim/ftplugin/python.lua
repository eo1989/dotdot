local manager = require "lvim.lsp.manager"
manager.setup "pylsp"

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { exe = "black", filetypes = { "python" } } }
-- lvim.lang.python.formatters = {
--   {
--     exe = "black",
--   },
-- }

-- lvim.lang.python.linters = {
--   {
--     exe = "flake8",
--   },
-- }
