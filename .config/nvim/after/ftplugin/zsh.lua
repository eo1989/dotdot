if not as then return end

-- copilot intentionall omitted to see if cmp works properly
as.ftplugin_conf('cmp', function(cmp)
  cmp.setup.filetype('zsh', {
    sources = cmp.config.sources({
      { name = 'cmp_zsh' },
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'cmp_tabnine' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
    }),
  })
end)
