local M = {}

M.config = function()
  local luadev = require("lua-dev").setup({
    library = {
      vimruntime = true, -- runtime path
      types = true, -- full signature, docs & completion of vim.{api, treesitter, lsp, etc}
      plugins = true -- installed opt or start plugins in packpath
      -- you can specify the list of plugins to make available as a workspace library.
      -- plugins = {"nvim-treesitter", "plenary.nvim", "telescope.nvim", "nlua.nvim", "nvim-luaref", "nvim-luadev", "luv-vimdocs"}
    },
    lspconfig = lvim.lang.lua.lsp.setup
  })
  lvim.lang.lua.lsp.setup = luadev
end

return M
