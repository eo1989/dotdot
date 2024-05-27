-- local cmd = vim.api.nvim_buf_create_user_command
vim.api.nvim_buf_create_user_command(0, 'MDRun', function()
  local current_file = vim.fn.expand('%:p')
  if vim.fn.expand('%:e') == 'md' then
    vim.fn.system('inlyne ' .. current_file)
  else
    vim.notify("This isn't a markdown file", vim.log.levels.WARN, {})
  end
end, {})
