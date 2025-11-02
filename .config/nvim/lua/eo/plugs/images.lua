local api = vim.api
local map = vim.api.nvim_set_keymap or vim.keymap.set

--[[ Requirements for linux
https://github.com/3rd/image.nvim?tab=readme-ov-file#requirements
check for dependencies with `:checkhealth kickstart`
needs:
sudo apt install imagemagick
sudo apt install libmagickwand-dev
sudo apt install liblua5.1-0-dev
sudo apt install luajit
]]

---@type LazySpec
return {
  -- {
  --   'https://github.com/leafo/magick',
  --   build = 'rockspec',
  -- },
  {
    '3rd/image.nvim',
    -- ft = { 'markdown', 'quarto' },
    enabled = true, -- testing snacks image thing
    cond = function() return vim.fn.has('win32') ~= 1 end and vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
    event = 'VeryLazy',
    dependencies = {
      'leafo/magick',
    },
    opts = {
      backend = 'kitty',
      processor = 'magick_cli', -- faster performance than 'magick_cli', which is the default w/ kitty & ImageMagick, magick_rock is fucking annoying
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = true, -- default = false
          filetypes = { 'markdown', 'quarto' },
        },
        neorg = {
          enabled = false,
          -- clear_in_insert_mode = false,
          -- download_remote_images = false,
          -- only_render_image_at_cursor = false,
          filetypes = { 'norg' },
        },
        html = { enabled = true },
        css = { enabled = true },
        typst = { enabled = true, filetypes = { 'typst' } }, -- doesnt work for some reason
      },
      max_width = nil,
      max_height = nil,
      -- max_height_window_percentage = math.huge,
      max_height_window_percentage = 50,
      max_width_window_percentage = nil,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'snacks_notif', 'scrollview', 'scrollview_sign' },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = true,
      kitty_method = 'normal',
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    },
    config = function(_, opts)
      local imaged = require('image')
      local bufnr = api.nvim_get_current_buf()
      imaged.setup(opts)

      local function clear_all_images()
        -- local bufnr = api.nvim_get_current_buf()
        local images = imaged.get_images { buffer = bufnr }
        for _, img in ipairs(images) do
          img:clear()
        end
      end

      local function get_image_at_cursor(buf)
        local images = imaged.get_images { buffer = buf }
        local row = api.nvim_win_get_cursor(0)[1] - 1
        for _, img in ipairs(images) do
          if img.geometry ~= nil and img.geometry.y == row then
            local og_max_height = img.global_state.options.max_height_window_percentage
            img.global_state.options.max_height_window_percentage = nil
            return img, og_max_height
          end
        end
        return nil
      end

      local create_preview_window = function(img, og_max_height)
        local buf = api.nvim_create_buf(false, true)
        local win_width = api.nvim_get_option_value('columns', {})
        local win_height = api.nvim_get_option_value('lines', {})
        local win = api.nvim_open_win(buf, true, {
          relative = 'editor',
          style = 'minimal',
          width = win_width,
          height = win_height,
          row = 0,
          col = 0,
          zindex = 1000,
        })

        map('n', '<esc>', function()
          api.nvim_win_close(win, true)
          img.global_state.options.max_height_window_percentage = og_max_height
        end, { buffer = buf })
        return { buf = buf, win = win }
      end

      local function handle_zoom(bufnr)
        local img, og_max_height = get_image_at_cursor(bufnr)
        if img == nil then return end

        local preview = create_preview_window(img, og_max_height)
        imaged.hijack_buffer(img.path, preview.win, preview.buf)
      end

      -- map(
      --   'n',
      --   '<localleader>io',
      --   function() return handle_zoom(api.nvim_get_current_buf) end,
      --   { desc = '[i]mage [o]pen' }
      -- )

      -- map('n', '<localleader>ic', clear_all_images, { desc = 'image [c]lear' })
    end,
  },
}
