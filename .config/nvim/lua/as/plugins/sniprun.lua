local M = {}

function M.setup()
  require("sniprun").setup({
  -- selected_interpreters = {'Python3_jupyter'},
  repl_enable = {'Python3_fifo'}, -- maybe change this to py3fifo
  -- interpreter_options = {
  --   GFM_original= {
  --     default_filetype = 'python3_jupyter'
  --   }
  -- },
  live_mode_toggle = 'off', -- live dangerously
  display = {
    "NvimNotify",
    "VirtualTextOk",
    "VirtualTextErr",
  },
  borders = 'shadow',
  -- show_no_output = {"NvimNotify", "VirtualTextOk"},
  -- display_options = {
  --   terminal_width = 35,
  --   notification_timeout = 20,
  -- },
  -- snipruncolors = {
  --   SniprunVirtualTextOk = { fg = "Yellow", bg = "#3E4556" }, -- ctermbg = "7", ctermfg = "4" },
  --   SniprunVirtualTextErr = { fg = "#E06C75", bg = "#3E4556" }, -- ctermbg = "7", ctermfg = "1" },
  --   SniprunFloatingWinOk = { fg = "#51AFEF" }, --, ctermfg = "4*", ctermbg = "7" },
  --   SniprunFloatingWinErr = { fg = "#E06C75" }, -- ctermfg = "1*", ctermbg = "7" },
  -- },
  })
end

return M
