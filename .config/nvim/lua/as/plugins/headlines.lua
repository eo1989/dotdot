local M = {}

function M.setup()
  ---@EO link -> https://oberservablehq.com/@d3/color-schemes?collection=@d3/d3-scale-chromatic
  -- NOTE: this must be set in the setup function or itll crash nvim!
  require('as.highlights').plugin('Headlines', {
    Headline1 = { background = '#003C30', foreground = 'White' },
    Headline2 = { background = '#00441B', foreground = 'White' },
    Headline3 = { background = '#084081', foreground = 'White' },
    Dash = { background = '#0B60A1', bold = true },
  })
end

function M.config()
  require('Headlines').setup({
    markdown = {
      headline_highlights = { 'Headline1', 'Headline2', 'Headline3' },
    },
  })
end

return M

