local api, fn = vim.api, vim.fn
local opts = { noremap = true, silent = true }

---@type LazySpec
return {
  {
    'kawre/neotab.nvim',
    cond = not vim.g.vscode or not vim.b.bigfile,
    event = 'InsertEnter',
    opts = {},
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    -- lazy = false,
    event = 'InsertEnter', -- let blink handle this bit
    build = { 'make install_jsregexp' },
    dependencies = {
      'kawre/neotab.nvim',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local ls = require('luasnip')
      local types = require('luasnip.util.types')
      local extras = require('luasnip.extras')
      local fmt = require('luasnip.extras.fmt').fmt
      local node = require('luasnip.util.util')
      local node_util = require('luasnip.nodes.util')
      local ft_functions = require('luasnip.extras.filetype_functions')
      local util = require('luasnip.util.util')

      ---@type LuaSnip
      ls.config.setup {
        keep_roots = true,
        link_roots = true,
        link_children = true,
        exit_roots = false,
        loaders_store_source = true,
        enable_autosnippets = true,
        store_selection_keys = '<Tab>',
        -- update_events = 'InsertLeave',
        -- update_events = 'TextChanged,TextChangedI,InsertLeave',
        update_events = 'TextChanged,InsertLeave',
        region_check_events = { 'CursorMoved', 'CursorHold', 'InsertEnter' },
        -- region_check_events = { 'CursorMoved', 'InsertEnter' },
        delete_check_events = 'InsertLeave',
        ft_func = ft_functions.from_pos_or_filetype,
        snip_env = {
          fmt = fmt,
          m = extras.match,
          t = ls.text_node,
          f = ls.function_node,
          c = ls.choice_node,
          d = ls.dynamic_node,
          i = ls.insert_node,
          l = extras.lambda,
          s = ls.snippet,
          snippet = ls.snippet,
          sn = ls.snippet_node,
          isn = ls.indent_snippet_node,
          r = ls.restore_node,
          events = require('luasnip.util.events'),
          ai = require('luasnip.nodes.absolute_indexer'),
          rep = extras.rep,
          p = extras.partial,
          n = extras.nonempty,
          dl = extras.dynamic_lambda,
          fmta = require('luasnip.extras.fmt').fmta,
          conds = require('luasnip.extras.conditions'),
          postfix = require('luasnip.extras.postfix').postfix,
          ms = ls.multi_snippet,
          k = require('luasnip.nodes.key_indexer').key_indexer,
          -- s = function(...)
          --   local snip = ls.s(...)
          --   table.insert(getfenv(2).ls_file_snippets, snip)
          -- end,
          utils = require('util.snippets'),
        },
        -- specifically from akinsho, and L3MON4D3.
        ext_opts = {
          --[[ unvisited from https://github.com/rockyzhang24/dotfiles/blob/master/.config/nvim/plugin/luasnip.lua ]]
          --[[ passive/ 'hl_group' from https://github.com/leiserfg/dots/blob/master/.config/nvim/lua/my/plugins/LuaSnip.lua ]]
          [types.insertNode] = {
            active = { virt_text = { { 'λ', 'Type' } }, hl_mode = 'combine' },
            -- passive = { hl_group = 'Substitute' },
            unvisited = {
              -- virt_text = { { '|', 'Conceal' } },
              virt_text_pos = 'inline',
            },
          },
          [types.choiceNode] = {
            active = { virt_text = { { '●', 'Operator' } }, hl_mode = 'combine' },
            -- active = { virt_text = { { 'choiceNode', 'IncSearch' } } }, -- or 'LspInlayHint' maybe?
            unvisited = { virt_text = { { '󰇷', 'DiagnosticVirtualTextError' } } },
          },
          [types.exitNode] = {
            -- passive = { hl_group = 'Substitute' },
            unvisited = {
              virt_text = { { '|', 'Type' } },
              virt_text_pos = 'inline',
            },
          },
        },
        parser_nested_assembler = function(_, snippetNode)
          local select = function(snip, no_move, dry_run)
            if dry_run then return end
            snip:focus()
            -- make sure the inner nodes will all shift to one side when the
            -- entire text is replaced.
            snip:subtree_set_rgrav(true)
            -- fix own extmark-gravities, subtree_set_rgrav affects them as well.
            snip.mark:set_rgravs(false, true)

            -- SELECT all text inside the snippet.
            if not no_move then
              require('luasnip.util.feedkeys').feedkeys_insert('<Esc>')
              node_util.select_node(snip)
            end
          end

          local original_extmarks_valid = snippetNode.extmarks_valid
          function snippetNode:extmarks_valid()
            -- the contents of this snippetNode are supposed to be deleted, and
            -- we don't want the snippet to be considered invalid because of
            -- that -> always return true.
            return true
          end

          function snippetNode:init_dry_run_active(dry_run)
            if dry_run and dry_run.active[self] == nil then dry_run.active[self] = self.active end
          end

          function snippetNode:is_active(dry_run)
            return (not dry_run and self.active) or (dry_run and dry_run.active[self])
          end

          function snippetNode:jump_into(dir, no_move, dry_run)
            self:init_dry_run_active(dry_run)
            if self:is_active(dry_run) then
              -- inside snippet, but not selected.
              if dir == 1 then
                self:input_leave(no_move, dry_run)
                return self.next:jump_into(dir, no_move, dry_run)
              else
                select(self, no_move, dry_run)
                return self
              end
            else
              -- jumping in from outside snippet.
              self:input_enter(no_move, dry_run)
              if dir == 1 then
                select(self, no_move, dry_run)
                return self
              else
                return self.inner_last:jump_into(dir, no_move, dry_run)
              end
            end
          end

          -- this is called only if the snippet is currently selected.
          function snippetNode:jump_from(dir, no_move, dry_run)
            if dir == 1 then
              if original_extmarks_valid(snippetNode) then
                return self.inner_first:jump_into(dir, no_move, dry_run)
              else
                return self.next:jump_into(dir, no_move, dry_run)
              end
            else
              self:input_leave(no_move, dry_run)
              return self.prev:jump_into(dir, no_move, dry_run)
            end
          end

          return snippetNode
        end,
      }

      eo.command('LuaSnipEdit', function() require('luasnip.loaders').edit_snippet_files() end, {})

      map({ 's', 'i' }, '<c-l>', function()
        if ls.choice_active() then ls.change_choice(1) end
      end)

      map({ 's', 'i' }, '<c-j>', function()
        if not ls.expand_or_jumpable() then return '<Tab>' end
        ls.expand_or_jump()
      end, { expr = true })

      map({ 's', 'i' }, '<c-b>', function()
        if not ls.jumpable(-1) then return '<S-Tab>' end
        ls.jump(-1)
      end, { expr = true })

      require('luasnip.loaders.from_lua').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load {
        paths = vim.fn.stdpath('config') .. '/snips',
        fs_event_providers = { 'autocmd', 'libuv' },
      }
      -- require('luasnip.loaders.from_vscode').lazy_load {
      --   paths = './snippets/textmate',
      -- }
      require('luasnip.loaders.from_lua').load {
        paths = fn.stdpath('config') .. '/luasnippets/',
        fs_event_providers = { 'autocmd', 'libuv' },
      }

      local luasnip_aug = api.nvim_create_augroup('ClearLuasnipSession', { clear = true })
      api.nvim_create_autocmd('CursorHold', {
        desc = 'Deactivate snippet after leaving insert/select mode',
        pattern = '*',
        group = luasnip_aug,
        callback = function()
          vim.cmd.LuaSnipUnlinkCurrent { mods = { emsg_silent = true } }
          vim.snippet.stop()
        end,
      })

      ls.filetype_extend('NeogitCommitMessage', { 'gitcommit' })
      ls.filetype_extend('typescriptreact', { 'javascript', 'typescript' })
      ls.filetype_extend('python', { 'ipynb' })
    end,
  },
}
