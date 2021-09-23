vim.g.indentLine_enabled = 1
vim.g.indent_blankline_char = "▏"
vim.g.indent_blankline_filetype_exclude = {
  "help",
  "terminal",
  "dashboard",
  "gitcommit",
  "packer",
  "NvimTree",
  "git",
  "TelescopePrompt",
  "undotree",
  "Trouble",
  "Neogitstatus",
  "log",
  "txt",
  ""
}
vim.g.indent_blankline_buftype_exclude = { "terminal", "help" }
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_trailing_blankline_indent = true
vim.g.indent_blankline_show_first_indent_level = false
vim.g.indent_blankline_show_foldtext = false
vim.g.indent_blankline_context_patterns = {
  'class',
  'function',
  'method',
  '^object',
  'return',
  '^if',
  'while',
  'dictionary',
  'block',
  'list_literal',
  'selector',
  '^table',
  'if_statement',
  'for',
  'else_clause',
}
