return function()
  require 'gitsigns'.setup {
    signs = {
      add = { hl = 'GitSignsAdd', text = '▌' },
      change = { hl = 'GitSignsChange', text = '▌' },
      delete = { hl = 'GitSignsDelete', text = '▌' },
      topdelete = { hl = 'GitSignsDelete', text = '▌' },
      changedelete = { hl = 'GitSignsChange', text = '▌' },
    },
    word_diff = false,
    numhl = false,
    preview_config = {
      border = as.style.current.border,
    },
    on_attach = function()
      local gs = package.loaded.gitsigns

      local function qf_list_modified()
        gs.setqflist 'all'
      end
      require('which-key').register {
        ['<leader>h'] = {
          name = '+gitsigns hunk',
          s = { gs.stage_hunk, 'stage' },
          u = { gs.undo_stage_hunk, 'undo stage' },
          r = { gs.reset_hunk, 'reset hunk' },
          p = { gs.preview_hunk, 'preview current hunk' },
          b = 'blame current line',
        },
        ['<localleader>g'] = {
          name = '+git',
          w = { gs.stage_buffer, 'gitsigns: stage entire buffer' },
          r = {
            name = '+reset',
            e = { gs.reset_buffer, 'gitsigns: reset entire buffer' },
          },
          b = {
            name = '+blame',
            l = { gs.blame_line, 'gitsigns: blame current line' },
            d = { gs.toggle_word_diff, 'gitsigns: toggle word diff' },
          },
        },
        ['[h'] = 'go to next git hunk',
        [']h'] = 'go to previous git hunk',
        ['<leader>lm'] = { qf_list_modified, 'gitsigns: list modified quickfix' },
      }

        -- Navigation
        as.nnoremap('[h', function()
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        as.nnoremap(']h', function()
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        vim.keymap.set({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
        vim.keymap.set({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
    end,
  }
end
