if not as then return end

-- NOTE: should cmp.setup.filetype() be 'quarto' or 'qmd'??
as.ftplugin_conf('cmp', function (cmp)
  cmp.setup.filetype('quarto', {
    sources = cmp.config.sources({
      { name = 'otter' },
      { name = 'latex_symbols' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
      { name = 'pandoc_references' },
    }),
  })
end)
