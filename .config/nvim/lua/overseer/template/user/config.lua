local overseer = require('overseer')
local env = vim.env

return {
  condition = {
    dir = vim.fn.expand('~') .. '/.config',
  },
  generator = function(_, cb)
    local ret = {
      {
        name = 'Source File',
        builder = function()
          vim.cmd.source(vim.fn.expand('%'))
          return {
            cmd = '',
            name = '',
            components = { 'user.dispose_now' },
          }
        end,
        priority = 59,
        params = {},
        conditions = { filetype = 'lua' },
      },
      {
        name = 'Source Nvim Init',
        builder = function()
          vim.cmd.source('/Users/eo/.config/nvim/init.lua')
          return {
            cmd = '',
            name = '',
            components = { 'user.dispose_now' },
          }
        end,
        priority = 59,
        params = {},
      },
      {
        name = 'Reload Kitty',
        builder = function()
          return {
            name = 'Reload Kitty',
            cmd = 'pkill -10 kitty',
            components = { 'default', 'unique' },
          }
        end,
        priority = 60,
        params = {},
      },
    }
    cb(ret)
  end,
}
