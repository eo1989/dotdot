local defaults = require('defaults').icons
local block = defaults.separators.bar2.vertical_block
local rect = eo.ui.border.rectangle
-- local hls = eo.highlight

-- local icons = eo.ui.icons
local _toggle_state = true

local chars = { top_char = '▁', bottom_char = '▔' }

---@type LazySpec
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = true,
    event = 'BufEnter',
    ft = { 'markdown', 'quarto', 'Avante', 'noice', 'rmd' },
    dependencies = {
      -- { 'headlines.nvim', enabled = false },
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'ray-x/yamlmatter.nvim' },
    },
    config = function()
      require('render-markdown').setup {
        file_types = { 'markdown', 'quarto', 'Avante', 'rmd', 'noice' },
        completions = { lsp = { enabled = false } }, -- starts to mess with shit
        code = {
          enabled = true,
          sign = false, -- true | false
          style = 'full', -- 'full', 'normal'
          width = 'full', -- 'full' | 'block'
          language_pad = 2, -- 0 | 0.5
          above = chars['top_char'],
          below = chars['bottom_char'],
          left_margin = 0,
          left_pad = 0, -- 0 | 1
          right_pad = 2,
          min_width = 40,
          border = 'thin',
          inline_pad = 1,
        },
        latex = { enabled = false }, -- either nabla or snacks
        win_options = { conceallevel = { rendered = 2 } },
      }
    end,
  },
  {
    'HakonHarnes/img-clip.nvim',
    lazy = true,
    -- event = 'VeryLazy',
    ft = { 'markdown', 'Avante' },
    keys = {
      {
        '<localleader>vi',
        ':PasteImage<CR>',
        ft = { 'markdown', 'quarto', 'Avante' },
        desc = '[i]nsert [i]mage from clipboard',
      },
    },
    opts = {
      default = {
        dir_path = function() return vim.fn.expand('%:t:r') end,
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = { insert_mode = true },
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = '![$CURSOR]($FILE_PATH)',
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = '![$CURSOR]($FILE_PATH)',
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
  },
  { 'OXY2DEV/helpview.nvim', enabled = true, lazy = false, ft = { 'help', 'vimdoc', 'text' }, opts = {} },
}
-- {
--   'jbyuki/nabla.nvim',
--   enabled = false,
--   -- ft = { 'markdown', 'latex', 'quarto', 'ipynb' },
--   keys = function()
--     local enabled = false
--     return {
--       {
--         '<localleader>vn',
--         function() require('nabla').popup() end,
--         desc = 'Nabla popup',
--         ft = { 'markdown', 'latex', 'quarto' },
--       },
--       {
--         '<localleader>vN',
--         function()
--           if enabled then
--             require('nabla').disable_virt()
--           else
--             require('nabla').enable_virt()
--             local id = vim.api.nvim_create_augroup('nabla_live_popup', { clear = true })
--             vim.api.nvim_create_autocmd('CursorHold', {
--               callback = function() require('nabla').popup() end,
--               buffer = 0,
--               group = id,
--             })
--           end
--           enabled = not enabled
--         end,
--         desc = 'nabla virtual',
--         ft = { 'markdown', 'latex', 'quarto' },
--       },
--     }
--   end,
-- },
-- {
--   'OXY2DEV/markview.nvim',
--   enabled = false,
--   event = 'BufRead',
--   dependencies = {
--     'saghen/blink.cmp',
--     'nvim-treesitter/nvim-treesitter',
--     'nvim-tree/nvim-web-devicons',
--   },
--   ft = { 'markdown' },
--   opts = {},
-- },
-- {
--   'yetone/avante.nvim',
--   enabled = false,
--   event = 'VeryLazy',
--   opts = {
--     windows = {
--       input = {
--         prefix = '▷',
--       },
--       width = 40,
--     },
--   },
--   build = 'make',
--   dependencies = {
--     'nvim-treesitter/nvim-treesitter',
--     'stevearc/dressing.nvim',
--     'nvim-lua/plenary.nvim',
--     'MunifTanjim/nui.nvim',
--     'nvim-tree/nvim-web-devicons',
--   },
-- },
-- {
--   'iamcco/markdown-preview.nvim',
--   enabled = false,
--   build = function() vim.fn['mkdp#util#install']() end,
--   ft = { 'markdown' },
--   config = function()
--     vim.g.mkdp_auto_start = 0
--     vim.g.mkdp_auto_close = 1
--   end,
-- },
