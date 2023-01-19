local optl = vim.opt_local
local bo = vim.bo
vim.wo.spell = false
-- optl.commentstring = '#%s '
optl.foldmethod = "syntax"
-- optl.foldexpr = "nvim_treesitter#foldexpr()"

bo.shiftwidth = 4
bo.tabstop = 4
bo.softtabstop = 4
bo.textwidth = 80
bo.expandtab = true
bo.smartindent = true
optl.indentkeys = optl.indentkeys - { '0#' }
optl.indentkeys = optl.indentkeys - { '<:>' }
-- optl.path = optl.path + { 'src/,**' }
-- vim.opt.path:append({ 'src/,$PWD/**' })

vim.g['python_highlight_all'] = 1
-- vim.g['python_recommended_style'] = 0

-- vim.cmd([[
--   iabbrev improt import
--   iabbrev teh the
-- ]])

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
