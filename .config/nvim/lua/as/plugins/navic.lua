return function()
  vim.g.navic_silence = true
  -- local highlights = require('as.highlights')
  local s = as.style
  local misc = s.icons.misc
  -- if require('nvim-web-devicons').has_loaded() then
  --   local devicons = require('nvim-web-devicons').get_icons()
  -- else
  --   return nil
  -- end



  local devicons = require('nvim-web-devicons').get_icons()
  -- require('as.highlights').plugin('navic', {
  --   { NavicText = { bold = true } },
  --   { NavicSeparator = { link = 'Directory' } },
  -- })
  -- local icons = as.map(function(icon, key)
  --   highlights.set(('NavicIcons%s'):format(key), { link = s.lsp.highlights[key] })
  --   return icon .. ' '
  -- end, s.current.lsp_icons)

  require('nvim-navic').setup({
    icons = devicons,
    -- icons = true,
    highlight = true,
    depth = 6,
    depth_limit_indicator = misc.ellipsis,
    separator = (' %s '):format(misc.caret_right),
  })
end
