_G.luasnip = {}
_G.luasnip.vars = {
  username = 'eo1989',
  github = 'https://github.com/eo1989',
  realname = 'Ernest Orlowski',
  date_format = '%m-%d-%y',
}
_G.luasnip._cache = {}

local M = {}

M = vim.tbl_extend('error', M, require('util.snippets.comment'))
M = vim.tbl_extend('error', M, require('util.snippets.treesitter'))

M.tex = require('util.snippets.tex')

return M
