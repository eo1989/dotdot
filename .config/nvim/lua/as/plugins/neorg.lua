return function()
  local fn = vim.fn
  as.nnoremap('<localleader>oc', '<Cmd>Neorg gtd capture<CR>')
  as.nnoremap('<localleader>ov', '<Cmd>Neorg gtd views<CR>')

  require('neorg').setup({
    configure_parsers = true,
    load = {
      ['core.defaults'] = {},
      ['core.integrations.telescope'] = {},
      ['core.keybinds'] = {
        config = {
          default_keybinds = true,
          neorg_leader = '<localleader>',
          hook = function(keybinds)
            keybinds.unmap('norg', 'n', '<C-s>')
            keybinds.map_event('norg', 'n', '<C-x>', 'core.integrations.telescope.find_linkable')
            keybinds.map_event('norg', 'n', '<C-x>', 'core.looking-glass.magnify-code-block<CR>', { buffer = true })
          end,
        },
      },
      ['core.norg.completion'] = {
        config = {
          engine = 'nvim-cmp',
        },
      },
      ['core.norg.concealer'] = {
        config = {
          icon_preset = 'diamond',
        },
      },
      ['core.norg.journal'] = {},
      ['core.export'] = {},
      ['core.export.markdown'] = {
        config = {
          extensions = 'all',
        }
      },
      ['core.norg.dirman'] = {
        config = {
          workspaces = {
            notes = fn.expand('$SYNC_DIR/neorg/notes/'),
            tasks = fn.expand('$SYNC_DIR/neorg/tasks/'),
            work = fn.expand('$SYNC_DIR/neorg/work/'),
            dotfiles = fn.expand('$DOTFILES/neorg/'),
          },
        },
      },
      ['core.gtd.base'] = {
        config = {
          workspace = 'notes',
        },
      },
    },
  })
end
