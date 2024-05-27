-- vim.cmd([[call matchadd('TabLineSel', '\%80v', 79)]])
local bo, cmd, optl = vim.bo, vim.cmd, vim.opt_local
-- local options = {
-- stylua: ignore start
bo.tabstop = 4                    -- ts
bo.textwidth = 79                 -- tw
bo.shiftwidth = 4                 -- sw
bo.softtabstop = 4                -- sts
bo.expandtab = true               -- et
bo.autoindent = true              -- ai
optl.smarttab = true                -- 
-- optl.conceallevel = 2             -- cole
-- optl.colorcolumn = '+1'           -- cc
-- optl.foldmethod = 'syntax'        -- fdm  -- syntax?
-- stylua: ignore end

-- https://github.com/echasnovski/nvim/blob/master/after/ftplugin/python.lua
-- g['pyindent_open_paren'] = 'shiftwidth()'
-- g['pyindent_continue'] = 'shiftwidth()'
-- g['pyindent_nested_paren'] = 'shiftwidth()'

-- api.nvim_buf_set_keymap(0, 'i', '<M-i>', ' = ', { noremap = true })
-----------------------------------------------------------------------------
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/config/utils.lua
-- local ft_abbr = function(lhs, rhs)
--   -- cmd('iabbrev <buffer> ' .. lhs .. ' ' .. rhs)
--   vim.keymap.set("!ia", lhs, rhs, { buffer = true})
-- end

cmd.inoreabbrev('<buffer> true True')
cmd.inoreabbrev('<buffer> false False')

cmd.inoreabbrev('<buffer> // #')
cmd.inoreabbrev('<buffer> null None')
cmd.inoreabbrev('<buffer> none None')
cmd.inoreabbrev('<buffer> nil None')

-- eo.ftplugin_conf(require("cmp").filetype)

-----------------------------------------------------------------------------
-- NOTE: Python inline comments are separated by two spaces via `black`, so
-- multispace only adds noise when displaying the dots for them
-- optl.listchars:append { multispace = ' ' }

-- g['magma_automatically_open_output'] = false
-- g['magma_image_provider'] = 'kitty'

-- TODO: Find out where I found these two maps for executing python code
-- map('n', "<C-'>", function() vim.cmd.term("python3 '%'") end, { silent = true, buffer = 0 })

-- map(
--   'n',
--   '<C-CR>',
--   '<Cmd>term time python3 %<input.txt<CR><Cmd>term time ./%:r.out<input.txt<CR>',
--   { silent = true, buffer = true }
-- )

-- require("nvim-surround").buffer_setup({
--   surrounds = {}
--     python = {
--       -- single quotes
--       { name = "single_quotes", start = "'", ends = "'" },
--       -- double quotes
--       { name = "double_quotes", start = '"', ends = '"' },
--       -- triple single quotes
--       { name = "triple_single
-- })
