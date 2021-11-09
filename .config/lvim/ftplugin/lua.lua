local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { exe = "stylua", filetypes = { "lua" } } }

-- lvim.lang.lua.formatters = {
--   {
--     exe = "stylua",
--     -- args = {"-s", "-"},
--   },
-- }
-- lvim.lang.lua.linters = {
--   {
--     exe = "selene",
--     -- args = {"--quiet"},
--   },
-- }

-- lvim.lang.lua.linters = {
--   {
--     exe = "luacheck",
--     args = {},
--   }
-- }
