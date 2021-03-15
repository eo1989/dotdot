require('nvim-treesitter.configs').setup(
    {
        ensure_installed = "maintained",
        rainbow = {enable = true, disable = {'bash'}},
        highlight = {
          enable = true,
          use_languagetree = false,
          disable = {"python", "cpp"}
        },
        incremental_selection = {enable = true},
        indent = {enable = true, disable = {'julia', 'rst'}},
        query_linter = {
          disable = {},
          enable = true,
          lint_events = {"BufWrite", "CursorHold"},
          module_path = "nvim-treesitter-playground.query_linter",
          use_virtual_text = true
        },
        textobjects = {enable = true},
        playground = {
          disable = {},
          enable = false,
          module_path = "nvim-treesitter-playground.internal",
          persist_queries = false,
          updatetime = 25
        }
    }
)
require('nvim-treesitter.highlight').setup({
    local vim.treesitter
    local hlmap = highlighter.hl_map()
    local hlmap = vim.treesitter.highlighter.hl_map
    hlmap.error = nil
    hlmap["punctuation.delimiter"] = "Delimiter"
    hlmap["punctuation.bracket"] = nil
    }
)

-- local query = [[

-- ]]
--     local hlmap = vim.treesitter.highlighter.hl_map
-- --Misc
--     hlmap.error = nil
--     hlmap["punctuation.delimiter"] = "Delimiter"
--     hlmap["punctuation.bracket"] = nil
-- require("nvim-treesitter.highlight")
