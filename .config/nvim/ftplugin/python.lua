local optl = vim.opt_local
vim.wo.spell = false
-- optl.commentstring = '#%s '
optl.foldmethod = "syntax"
-- optl.foldexpr = "nvim_treesitter#foldexpr()"

optl.shiftwidth = 4
optl.tabstop = 4
optl.smartindent = true
optl.expandtab = true
optl.softtabstop = 4
optl.expandtab = true
optl.textwidth = 80
optl.indentkeys = optl.indentkeys - { '0#' }
optl.indentkeys = optl.indentkeys - { '<:>' }
-- optl.path = optl.path + { 'src/,**' }
-- vim.opt.path:append({ 'src/,$PWD/**' })

vim.g['python_highlight_all'] = 1
vim.g['python_recommended_style'] = 0

vim.cmd([[
  iabbrev improt import
  iabbrev teh the
]])

-- local wk = require("which-key")
-- with leader
-- wk.register({
--   -- r = { "<Plug>(SniprRunOperator)", "Run snip operator" },
--   r = { "<Plug>SniprRunOperator", "Run snip operator" },
--   s = {
--     name = "Runner/Py", -- optional?
--     s = { "<Plug>SnipRun<CR>", "Run snippet" },
--   }
-- }, { prefix = "<localleader>", mode = 'n' })

-- wk.register({
--   s = {
--     name = "Runner/Py", -- optional?
--     v = { "<cmd>lua require('sniprun').run('v')<CR>", "Sniprun visual selection"} -- :'<,'>SnipRun
--     },
--   }, { prefix = '<localleader>', mode = 'v' }
-- )

-- vim.cmd([[
-- highlight rightMargin term=bold ctermfg=blue guifg=blue
-- match rightMargin /.\%>80v/
--
-- higlight col8 ctermbg=grey guibggrey
-- match col8 /\%<8v.\%>7v/
-- ]])
