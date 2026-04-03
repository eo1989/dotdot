local api, fn = vim.api, vim.fn
local map = vim.keymap.set or _G.map
local opts = { noremap = true, silent = true }

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

return {
  {
    ---@module 'luasnip'
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = { 'make install_jsregexp' },
    event = { 'InsertEnter', 'VeryLazy' },
    dependencies = {
      {
        'kawre/neotab.nvim',
        cond = not vim.g.vscode,
        opts = {},
      },
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      local ls = require('luasnip')
      local types = require('luasnip.util.types')
      local node_util = require('luasnip.nodes.util')

      map({ 'i', 's' }, '<C-e>', function()
        if ls.choice_active() then ls.change_choice(1) end
      end)

      -- map({ 'i', 's' }, '<C-f>', function()
      --   if not ls.expand_or_jumpable() then return '<Tab>' end
      --   ls.expand_or_jump()
      -- end, { expr = true })

      -- map({ 'i', 's' }, '<C-b>', function()
      --   if not ls.jumpable(-1) then return '<S-Tab>' end
      --   ls.jump(-1)
      -- end, { expr = true })

      -- map({ 'i', 's' }, '<C-,>', require('luasnip.extras.select_choice'), { silent = true })

      -- local select_next = false
      -- map({ 'i' }, '<C-;>', function()
      --   local ok, _ = pcall(ls.activate_node, {
      --     strict = true,
      --     select = select_next,
      --   })
      --   if not ok then
      --     print('No code.')
      --     return
      --   end
      --
      --   if select_next then return end
      --
      --   local curbuf = vim.api.nvim_get_current_buf()
      --   local hl_duration_ms = 100
      --
      --   local node = ls.session.current_nodes[curbuf]
      --   local from, to = node:get_buf_position { raw = true }
      --
      --   -- hl snippet for 100ms
      --   local id = vim.api.nvim_buf_set_extmark(curbuf, ls.session.ns_id, from[1], from[2], {
      --     -- one line below, at col 0 => entire last lnie is highlighted
      --     end_row = to[1],
      --     end_col = to[2],
      --     hl_group = 'Visual',
      --   })
      --
      --   vim.defer_fn(function() vim.api.nvim_buf_del_extmark(curbuf, ls.session.ns_id, id) end, hl_duration_ms)
      --
      --   -- select if there is another press within the next second
      --   select_next = true
      --   vim.uv.new_timer():start(1000, 0, function() select_next = false end)
      -- end)

      ls.config.set_config {
        keep_roots = true,
        link_roots = true,
        link_children = true,
        exit_roots = false,
        loaders_store_source = true,
        update_events = { 'InsertLeave' },
        enable_autosnippets = true,
        region_check_events = { 'CursorMoved', 'InsertLeave' },
        -- delete_check_events = 'InsertEnter, TextChanged, CursorMovedI',
        delete_check_events = 'InsertEnter, TextChanged',
        -- store_selection_keys = '<Tab>',
        cut_selection_keys = '<Tab>',
        -- ft_func = require('luasnip.extras.filetype_functions').from_pos_or_filetype,
        -- ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
        snip_env = {
          -- __snip_env_behavior = 'extend', -- 'extend' | 'set'
          ai = require('luasnip.nodes.absolute_indexer'),
          -- f = ls.function_node,
          c = ls.choice_node,
          conds = require('luasnip.extras.conditions'),
          d = ls.dynamic_node,
          dl = require('luasnip.extras').dynamic_lambda,
          events = require('luasnip.util.events'),
          f = function(func, argnodes, ...)
            return ls.f(
              function(args, imm_parent, user_args) return func(args, imm_parent.snippet, user_args) end,
              argnodes,
              ...
            )
          end,
          fmta = require('luasnip.extras.fmt').fmta,
          fmt = require('luasnip.extras.fmt').fmt,
          i = ls.insert_node,
          l = require('luasnip.extras').lambda,
          -- ls = ls,
          -- k = require('luasnip.nodes.key_indexer'),
          k = require('luasnip.nodes.key_indexer').new_key,
          isn = ls.indent_snippet_node,
          n = require('luasnip.extras').nonempty,
          m = require('luasnip.extras').match,
          ms = ls.multi_snippet,
          opt = (function()
            if pcall(require, 'luasnip.nodes.optional_arg') then
              return require('luasnip.nodes.optional_arg').new_opt
            else
              return nil
            end
          end)(),
          p = require('luasnip.extras').partial,
          postfix = require('luasnip.extras.postfix').postfix,
          ts_postfix = require('luasnip.extras.treesitter_postfix').treesitter_postfix,
          r = ls.restore_node,
          rep = require('luasnip.extras').rep,
          s = ls.snippet,
          snippet = ls.snippet,
          sn = ls.sn,
          t = ls.text_node,
          types = require('luasnip.util.types'),
          util = require('luasnip.util.util'),
          ms_add = function(...)
            local m_s = ls.multi_snippet(...)
            table.insert(getfenv(2).ls_file_snippets, m_s)
          end,
          s_add = function(...)
            local snip = ls.s(...)
            snip.metadata = debug.getinfo(2)
            table.insert(getfenv(2).ls_file_snippets, snip)
          end,
          px_add = function(...)
            local postfix = require('luasnip.extras.treesitter_postfix').treesitter_postfix
            local snip = postfix(...)
            table.insert(getfenv(2).ls_file_snippets, snip)
          end,
          ins_generate = function(nodes)
            return setmetatable(nodes or {}, {
              __index = function(table, key)
                local idx = tonumber(key)
                if idx then
                  local val = ls.i(idx)
                  rawset(table, key, val)
                  return val
                end
              end,
            })
          end,
          parse_add = function(...)
            local p = ls.extend_decorator.apply(ls.parser.parse_snippet, {}, { dedent = true, trim_empty = true })
            local snip = p(...)
            table.insert(getfenv(2).ls_file_snippets, snip)
          end,
          parse_add_auto = function(...)
            local p = ls.extend_decorator.apply(ls.parser.parse_snippet, {}, { dedent = true, trim_empty = true })
            local snip = p(...)
            table.insert(getfenv(2).ls_file_autosnippets, snip)
          end,
          parse = ls.extend_decorator.apply(ls.parser.parse_snippet, {}, { dedent = true, trim_empty = true }),
          -- s = function(...)
          --   local snip = ls.s(...)
          --   table.insert(getfenv(2).ls_file_snippets, snip)
          -- end,
          -- utils = require('util.snippets'),
        },
        -- specifically from akinsho, and L3MON4D3.
        ext_opts = {
          --[[ unvisited from https://github.com/rockyzhang24/dotfiles/blob/master/.config/nvim/plugin/luasnip.lua ]]
          --[[ passive/ 'hl_group' from https://github.com/leiserfg/dots/blob/master/.config/nvim/lua/my/plugins/LuaSnip.lua ]]
          [types.insertNode] = {
            active = {
              virt_text = { { 'λ', 'Type' } },
              hl_mode = 'combine',
              priority = 1,
              -- hl_group = "CatppuccinBlue",
            },
            unvisited = {
              virt_text_pos = 'inline',
            },
          },
          [types.choiceNode] = {
            active = { virt_text = { { '●', 'Operator' } }, hl_mode = 'combine' },
            -- active = { virt_text = { { 'choiceNode', 'IncSearch' } } }, -- or 'LspInlayHint' maybe?
            unvisited = { virt_text = { { '󰇷', 'DiagnosticVirtualTextError' } } },
          },
        },
        ext_base_prio = 200,
        ext_prio_increase = 2,
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

      -- ls.filetype_extend('NeogitCommitMessage', { 'gitcommit' })
      -- ls.filetype_extend('typescriptreact', { 'javascript', 'typescript' })
      -- ls.filetype_extend('quarto', { 'markdown' })

      require('luasnip.loaders.from_lua').lazy_load {
        paths = './luasnippets',
        fs_event_providers = { 'autocmd', 'lubuv' },
      }
      require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/luasnippets' }

      require('luasnip.loaders.from_snipmate').load { paths = './snippets' }
      -- require('luasnip.loaders.from_vscode').load()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load { paths = './snippets' }

      -- require('eo.plugins.luasnip.external_update_dynamic_node')
      -- require('eo.plugins.luasnip.repeat_integration')
    end,
  },
}
