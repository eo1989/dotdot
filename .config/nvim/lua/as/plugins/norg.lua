return function()
  local fn = vim.fn
  as.nnoremap('<localleader>oc', '<Cmd>Neorg module load<CR>')
  as.nnoremap('<localleader>ov', '<Cmd>Neorg workspace default<CR>')

  require('neorg').setup({
    configure_parsers = true,
    load = {
      ['core.defaults'] = {},
      -- ['core.integrations.telescope'] = {},
      -- ['core.integrations.treesitter'] = {},
      -- ['core.presenter'] = {},
      ['core.keybinds'] = {
        config = {
          default_keybinds = true,
          neorg_leader = '<localleader>',
          hook = function(keybinds)
            -- keybinds.unmap('norg', 'n', '<C-s>')
            keybinds.map_event('norg', 'n', '<C-x>', 'core.integrations.telescope.find_linkable')
            keybinds.map_event('norg', 'n', '<C-x>', 'core.looking-glass.magnify-code-block<CR>', { buffer = true })
          end,
        },
      },
      ['core.norg.completion'] = {config = {engine = 'nvim-cmp'}},
      ['core.norg.concealer'] = {
        config = {
          markup_preset = "conceal",
          icon_preset = 'diamond',
        },
      },
      ['core.norg.journal'] = {},
      ['core.norg.manoeuvre'] = {},
      ['core.tangle'] = {},
      ['core.export'] = {},
      ['core.export.markdown'] = {
        config = {
          extensions = 'all',
        }
      },
      ['core.norg.dirman'] = {
        config = {
          autodetect = true,
          workspaces = {
            notes = fn.expand('$SYNC_DIR/neorg/notes/'),
            tasks = fn.expand('$SYNC_DIR/neorg/tasks/'),
            work = fn.expand('$SYNC_DIR/neorg/work/'),
            dotfiles = fn.expand('$DOTFILES/neorg/'),
          },
        },
      },
      ['core.norg.qol.toc'] = {},
      ['core.norg.qol.todo_items'] = {},
      -- ['core.gtd.base'] = {
      --   config = {
      --     workspace = 'notes',
      --   },
      -- },
    },
  })
end
