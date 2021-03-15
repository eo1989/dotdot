require("nvim-treesitter.higlight")
    local vim.treesitter
    local hlmap = highlighter.hl_map()
-- Misc
    hlmap.error = nil
    hlmap["punctuation.delimiter"] = "Delimiter"
    hlmap["punctuation.bracket"] = nil
