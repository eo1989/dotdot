---@diagnostic disable: need-check-nil, undefined-field
vim.wo.spell = false
-- no distractions in markdown files
vim.wo.number = true
vim.wo.relativenumber = false

local args = { buffer = 0 }

if not as then
  return
end

-- as.onoremap('ih', [[:<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>]], args)
-- as.onoremap('ah', [[:<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>]], args)
-- as.onoremap('aa', [[:<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>]], args)
-- as.onoremap('ia', [[:<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>]], args)

as.nmap('<localleader>mp', '<Plug>MarkdownPreviewToggle<CR>', args)

as.nmap('<localleader>qp', '<Plug>QuartoPreview<CR>', args)

as.nmap('<localleader>mf', '<Plug>FeMaco<CR>', { desc = 'edit code block' })



as.ftplugin_conf('cmp', function(cmp)
  cmp.setup.filetype('markdown', {
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'cmp_tabnine' },
      { name = 'copilot' },
      { name = 'latex_symbols' },
      { name = 'nvim_lsp' },
    }, {
      { name = 'otter' },
      { name = 'cmp_pandoc_references' },
      { name = 'path' },
      { name = 'buffer' },
    }),
  })
end)

as.ftplugin_conf('nvim-surround', function(surround)
  surround.buffer_setup({
    surrounds = {
      l = {
        add = function()
          return {
            { '[' },
            { '](' .. vim.fn.getreg('*') .. ')' },
          }
        end,
      },
    },
  })
end)

-- local md_paste = function(link)
--   local curl = require('plenary.curl')
--
--   link = link or vim.fn.getreg "+"
--   if not vim.startswith(link, "https://") then return end
--
--   local request = curl.get(link)
--   if not request.status == 200 then
--     print('Failed to get link')
--     return
--   end
--
--   local html_parser = vim.treesitter.get_string_parser(request.body, "html")
--   if not html_parser then
--     print("must have html parser installed")
--     return
--   end
--
--   local tree = (html_parser:parse() or ())[1]
--   if not tree then
--     print('Failed to parse tree')
--     return
--   end
--
--   local query = vim.treesitter.parse_query(
--     "html",
--     [[
--       (
--         (element
--           (start_tag
--             (tag_name) @tag)
--           (text) @text
--         )
--
--         (#eq? @tag "title")
--       )
--     ]]
--   )
--
--   for id, node in query:iter_captures(tree:root(), request.body, 0, -1) do
--     local name = query.captures[id]
--     if name == "text" then
--       local title = vim.treesitter.get_node_text(node, request.body)
--       vim.api.nvim_input(string.format('a[%s](%s)', title, link))
--       return
--     end
--   end
-- end

-- as.nmap("<localleader>mdp", md_paste)
