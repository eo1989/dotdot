return {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  -- cmd = { 'TypstPreview', 'TypstPreviewToggle', 'TypstPreviewUpdate' },
  keys = {
    {
      '<localleader>cp',
      '<cmd>TypstPreviewToggle<CR>',
      desc = 'Toggle Typst Preview',
      ft = 'typst',
    },
  },
  opts = {
    dependencies_bin = {
      tinymist = 'tinymist',
    },
  },
}
