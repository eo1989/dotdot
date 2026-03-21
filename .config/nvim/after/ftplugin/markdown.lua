-- local cmd = vim.api.nvim_buf_create_user_command

-- vim.opt_local.conceallevel = 0
-- vim.wo.conceallevel = 0

vim.b.slime_cell_delimiter = '```'
-- local ok, quarto = pcall(require, 'quarto')
-- if ok then quarto.activate() end

-- vim.keymap.set({ 'o', 'x' }, 'il', "<cmd>lua require('various-textobjs').mdlink('inner')<CR>", { buffer = true })
-- vim.keymap.set({ 'o', 'x' }, 'al', "<cmd>lua require('various-textobjs').mdlink('outer')<CR>", { buffer = true })

vim.api.nvim_buf_create_user_command(0, 'MDRun', function()
  local current_file = vim.fn.expand('%:p')
  if vim.fn.expand('%:e') == 'md' then
    vim.fn.system('inlyne ' .. current_file)
  else
    vim.notify("This isn't a markdown file", vim.log.levels.WARN, {})
  end
end, {})

-- TODO: set this up as a auggroup so that you dont need to rely on akinsho's global functions.
-- NOTE: Check out Murderballon or something for their lua "functools" lib
eo.ftplugin_conf {
  ['nvim-surround'] = function(surround)
    local get_input = function(prompt)
      local ok, input = pcall(vim.fn.input, fmt('%s: ', prompt))
      if not ok then return end
      return input
    end
    surround.buffer_setup {
      surrounds = {
        ['~'] = {
          add = function()
            local config = require('nvim-surround.config')
            local result = config.get_input('Markdown code block language: ')
            return {
              { '```\n' .. result, '' },
              { '', '```' },
            }
          end,
        },
      },
    }
  end,
}
