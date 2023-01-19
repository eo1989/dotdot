if not as then
  return
end

-- as.ftplugin_conf('which-key', function(wk)
--   wk.register({
--     g = {
--       name = '+todos',
--       t = {
--         name = '+status',
--         u = 'task undone',
--         p = 'task pending',
--         d = 'task done',
--         h = 'task on_hold',
--         c = 'task cancelled',
--         r = 'task recurring',
--         i = 'task important',
--       },
--     },
--     ['<localleader>t'] = { name = '+gtd', c = 'capture', v = 'views', e = 'edit' },
--   })
-- end)

as.ftplugin_conf( 'cmp', function(cmp)
  cmp.setup.filetype('norg', {
    sources = cmp.config.sources({
      { name = 'neorg' },
      { name = 'latex_symbols' },
      -- { name = 'greek' },
      { name = 'spell' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
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
            { ']{' .. vim.fn.getreg('*') .. '}' },
          }
        end,
      },
    },
  })
end)
