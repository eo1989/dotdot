return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    event = 'BufEnter',
    ft = { 'markdown', 'quarto' },
    dependencies = {
      { 'headlines.nvim', enabled = false },
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
      -- 'nmder/nabla.nvim',
    },
    config = function()
      require('render-markdown').setup {
        file_types = { 'markdown', 'quarto', 'Avante' },
        completions = {
          lsp = { enabled = true },
        },
        code = {
          render_modes = true, -- false | true
          sign = false, -- true | false
          style = 'full', -- 'full', 'normal'
          width = 'full', -- 'full' | 'block'
          -- language_pad = 0, -- 0 | 0.5
        },
        latex = { enabled = false },
        win_options = { conceallevel = { rendered = 2 } },
      }
    end,
  },
  {
    'jbyuki/nabla.nvim',
    -- enabled = true,
    -- ft = { 'markdown', 'latex', 'quarto', 'ipynb' },
    keys = function()
      local enabled = false
      return {
        {
          '<localleader>vn',
          function() require('nabla').popup() end,
          desc = 'Nabla popup',
          ft = { 'markdown', 'latex', 'quarto' },
        },
        {
          '<localleader>vN',
          function()
            if enabled then
              require('nabla').disable_virt()
            else
              require('nabla').enable_virt()
              local id = vim.api.nvim_create_augroup('nabla_live_popup', { clear = true })
              vim.api.nvim_create_autocmd('CursorHold', {
                callback = function() require('nabla').popup() end,
                buffer = 0,
                group = id,
              })
            end
            enabled = not enabled
          end,
          desc = 'nabla virtual',
          ft = { 'markdown', 'latex', 'quarto' },
        },
      }
    end,
  },
  {
    'HakonHarnes/img-clip.nvim',
    lazy = true,
    -- event = 'VeryLazy',
    ft = { 'markdown', 'quarto', 'Avante' },
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
  -- { 'OXY2DEV/markview.nvim', ft = 'markdown', opts = {} },
  { 'OXY2DEV/helpview.nvim', enabled = true, lazy = false, opts = {} },
  {
    'yetone/avante.nvim',
    enabled = false,
    event = 'VeryLazy',
    opts = {
      windows = {
        input = {
          prefix = '▷',
        },
        width = 40,
      },
    },
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
  },
}
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
