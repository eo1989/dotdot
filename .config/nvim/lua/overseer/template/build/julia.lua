---@module "overseer"
---@type overseer.TemplateFileDefinition
return {
  name = 'julia',
  generator = function(_, cb)
    cb {
      {
        name = 'Run File',
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            name = 'Running ' .. vim.fn.expand('%:t:r'),
            cmd = { 'julia', '--project@.', vim.fn.expand('%:p') },
          }
        end,
        condition = { filetype = 'julia' },
      },
    }
  end,
}
