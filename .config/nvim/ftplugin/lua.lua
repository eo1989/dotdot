-- if not as then return end
-- local nnoremap = as.nnoremap
-- local fn = vim.fn
-- local fmt = string.format

-- local function find(word, ...)
--   for _, str in ipairs({ ... }) do
--     local match_start, match_end = string.find(word, str)
--     if match_start then
--       return str, match_start, match_end
--     end
--   end
-- end

-- local function open_help(tag)
--   as.wrap_err(vim.cmd.help, tag)
-- end

--- Stolen from nlua.nvim this function attempts to open
--- vim help docs if an api or vim.fn function otherwise it
--- shows the lsp hover doc
--- @param word string
--- @param callback function
-- local function kw(word, callback)
--   local original_iskeyword = vim.bo.iskeyword
--
--   vim.bo.iskeyword = vim.bo.iskeyword .. ',.'
--   word = word or fn.expand('<cword>')
--
--   vim.bo.iskeyword = original_iskeyword
--
--   local match, _, end_idx = find(word, 'api.', 'vim.api.')
--   if match and end_idx then
--     return open_help(word:sub(end_idx + 1))
--   end
--
--   match, _, end_idx = find(word, 'fn.', 'vim.fn.')
--   if match and end_idx then
--     return open_help(word:sub(end_idx + 1) .. '()')
--   end
--
--   match, _, end_idx = find(word, '^vim.(%w+)')
--   if match and end_idx then
--     return open_help(word:sub(1, end_idx))
--   end
--
--   if callback then
--     return callback()
--   end
--
--   vim.lsp.buf.hover()
-- end

-- nnoremap('gK', kw, { buffer = 0 })
-- nnoremap('<leader>so', function()
--   vim.cmd.luafile('%')
--   vim.notify('Sourced ' .. fn.expand('%'))
-- end)


vim.bo.textwidth = 100
vim.opt_local.formatoptions:remove({ 'o', 't', 'c', 'r' })
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.opt_local.path:append('lua/,**')
