return {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  cmd = { 'TypstPreview', 'TypstPreviewToggle', 'TypstPreviewUpdate' },
  keys = {
    {
      '<leader>cp',
      ft = 'typst',
      '<cmd>TypstPreviewToggle<CR>',
      desc = 'Toggle Typst Preview',
    },
  },
  opts = {
    dependencies_bin = {
      tinymist = 'tinymist',
    },
  },
}
