--==================================================================================================
-- VidocqH/data-viewer.nvim           https://github.com/VidocqH/data-viewer.nvim
-- theKnightsOfRohan/csvlens.nvim     https://github.com/theKnightsOfRohan/csvlens.nvim
-- emmanueltouzery/decisive.nvim      https://github.com/emmanueltouzery/decisive.nvim
-- Willem-J-an/visidata.nvim          https://github.com/Willem-J-an/visidata.nvim
--==================================================================================================
-- ok97465/ipybridge.nvim             https://github.com/ok97465/ipybridge.nvim

---@type LazySpec
return {
  'nelnn/bear.nvim',
  dependencies = { 'mfussenegger/nvim-dap' },
  ft = { 'python' },
  event = { 'BufRead *.py' },
}
