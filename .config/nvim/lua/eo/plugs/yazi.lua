---@type LazySpec
return {
  'mikavilpas/yazi.nvim',
  ---@type YaziConfig | {}
  version = '*',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true },
  },
  keys = {
    {
      '<leader>-',
      '<cmd>Yazi<CR>',
      mode = { 'n', 'v' },
      desc = 'Open yazi at current file',
    },
    {
      '<leader>cw',
      '<cmd>Yazi cwd<CR>',
      -- mode = { "n", "v" },
      desc = "Open the file manager in nvim's working dir",
    },
    {
      '<C-up>',
      '<cmd>Yazi toggle<CR>',
      -- mode = { "n", "v" },
      desc = 'Resume last yazi session',
    },
  },
  opts = {
    open_for_directories = true,
    keymaps = {
      show_help = '<F1>',
    },
  },
  -- since this is open_for_directories = true,
  -- this will be required to speed up loading?
  init = function()
    -- mark netrw as loaded so it isnt loaded at all
    vim.g.loaded_netrwPlugin = 1
  end,
}
