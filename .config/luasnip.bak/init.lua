local api = vim.api
local extras = require('luasnip.extras')
-- local ft_functions = require('luasnip.extras.filetype_functions')
local node_util = require('luasnip.nodes.util')
-- local fmt = require('luasnip.extras.fmt').fmt
local node = require('luasnip.util.util')
local types = require('luasnip.util.types')

local ls = require('luasnip')

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
    -- event = 'InsertEnter', -- let blink handle this bit
    build = { 'make install_jsregexp' },
    dependencies = {
      'kawre/neotab.nvim',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      -- local ls = require('luasnip')
      ls.config.setup {
        keep_roots = true,
        link_roots = true,
        link_children = true,
        exit_roots = false,
        loaders_store_source = true,
        enable_autosnippets = true,
        store_selection_keys = '<Tab>',
        update_events = 'InsertLeave',
        -- update_events = 'TextChanged,TextChangedI,InsertLeave',
        -- update_events = 'TextChanged,InsertLeave',
        -- region_check_events = { 'CursorMoved', 'CursorHold', 'InsertLeave' },
        region_check_events = { 'CursorHold', 'InsertLeave' },
        -- region_check_events = 'CursorMoved', -- prevent <tab> from jumping back to a snippet after its left
        delete_check_events = 'TextChanged, InsertEnter, CursorMovedI',
        -- ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
        -- ft_func = ft_functions.from_filetype,
        ft_func = require('luasnip.extras.filetype_functions').from_pos_or_filetype,
        -- load_ft_func = require('luasnip.extras.filetype_functions').extend_load_ft {
        load_ft_func = require('luasnip.extras.filetype_functions').extend_load_ft {
          markdown = { 'julia', 'python' },
          quarto = { 'julia', 'python' },
          python = { 'ipynb' },
        },
        snip_env = {
          __snip_env_behavior = 'set',
          ms = ls.multi_snippet,
          ms_add = function(...)
            local m_s = ls.multi_snippet(...)
            table.insert(getfenv(2).ls_file_snippets, m_s)
          end,
          s_add = function(...)
            local snip = ls.s(...)
            snip.metadata = debug.getinfo(2)
            table.insert(getfenv(2).ls_file_snippets, snip)
          end,
          s_add_auto = function(...)
            local snip = ls.s(...)
            table.insert(getfenv(2).ls_file_autosnippets, snip)
          end,
          -- ts_px_add = function(...)
          --   local ts_postfix = require('luasnip.extras.treesitter_postfix').treesitter_postfix
          --   local snip = ts_postfix(...)
          --   table.insert(getfenv(2).ls_file_snippets, snip)
          -- end,
          px_add = function(...)
            local postfix = require('luasnip.extras.postfix').postfix
            local snip = postfix(...)
            table.insert(getfenv(2).ls_file_snippets, snip)
          end,
          s = ls.s,
          sn = ls.sn,
          -- t = ls.text_node,
          t = ls.t,
          -- i = ls.insert_node,
          i = ls.i,
          -- f = ls.function_node,
          f = function(func, argnodes, ...)
            return ls.f(
              function(args, imm_parent, user_args) return func(args, imm_parent.snippet, user_args) end,
              argnodes,
              ...
            )
          end,
          --- override to enable restore_cursor.
          -- c = ls.choice_node,
          c = function(pos, nodes, opts)
            opts = opts or {}
            opts.restore_cursor = true
            return ls.c(pos, nodes, opts)
          end,
          -- d = ls.dynamic_node,
          d = function(pos, func, argnodes, ...)
            return ls.d(
              pos,
              function(args, imm_parent, old_state, ...) return func(args, imm_parent.snippet, old_state, ...) end,
              argnodes,
              ...
            )
          end,
          isn = require('luasnip.nodes.snippet').ISN,
          -- l = extras.lambda,
          l = require('luasnip.extras').lambda,
          dl = require('luasnip.extras').dynamic_lambda,
          rep = require('luasnip.extras').rep,
          r = ls.restore_node,
          p = require('luasnip.extras').partial,
          types = require('luasnip.util.types'),
          events = require('luasnip.util.events'),
          util = require('luasnip.util.util'),
          -- fmt = fmt,
          fmt = require('luasnip.extras.fmt').fmt,
          fmta = require('luasnip.extras.fmt').fmta,
          ls = ls,
          ins_generate = function(nodes)
            return setmetatable(nodes or {}, {
              __index = function(table, key)
                local index = tonumber(key)
                if index then
                  local val = ls.i(index)
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
          n = require('luasnip.extras').nonempty,
          -- m = extras.match,
          m = require('luasnip.extras').match,
          ai = require('luasnip.nodes.absolute_indexer'),
          postfix = require('luasnip.extras.postfix').postfix,
          -- ts_postfix = require('luasnip.extra.treesitter_postfix').treesitter_postfix,
          conds = require('luasnip.extras.expand_conditions'),
          k = require('luasnip.nodes.key_indexer').new_key,
          opt = (function()
            if pcall(require, 'luasnip.nodes.optional_arg') then
              return require('luasnip.nodes.optional_arg').new_opt
            else
              return nil
            end
          end)(),
          snippet = ls.snippet,
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
              -- virt_text = { { '|', 'Conceal' } },
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
      require('luasnip.util.log').set_loglevel('debug')

      ls.filetype_extend('latex', { 'tex' })
      ls.filetype_extend('glsl', { 'c' })
      ls.filetype_extend('cpp', { 'c' })
      ls.filetype_extend('sh', { 'bash' })
      ls.filetype_extend('cuda', { 'cpp', 'c' })

      local aug = api.nvim_create_augroup('ClearLuasnipSession', { clear = true })
      api.nvim_create_autocmd('CursorHold', {
        desc = 'Deactivate snippet after leaving insert/select mode',
        pattern = '*',
        group = aug,
        callback = function()
          vim.cmd.LuaSnipUnlinkCurrent { mods = { emsg_silent = true } }
          vim.snippet.stop()
        end,
      })

      eo.command('LuaSnipEdit', function() require('luasnip.loaders').edit_snippet_files() end, {})
      eo.command('LuaSnipEditF', function() require('plugs.luasnip.ft_edit') end, {})

      local sl_ok, sl = pcall(require, 'luasnip.extras.snip_location')
      if sl_ok then eo.command('LuaSnipEditS', sl.jump_to_active_snippet, {}) end

      -- map({ 'i', 's' }, '<C-k>', ls.expand, { silent = true })
      -- map({ 'i', 's' }, '<C-l>', function() ls.jump(1) end, { silent = true })
      -- map({ 'i', 's' }, '<C-j>', function() ls.jump(-1) end, { silent = true })

      map({ 'i', 's' }, '<C-l>', function()
        if ls.choice_active() then ls.change_choice(1) end
      end, { silent = true })

      map({ 'i', 's' }, '<C-e>', require('luasnip.extras.select_choice'), { silent = true })

      local select_next = false
      map('i', '<M-;>', function()
        local ok, _ = pcall(ls.activate_node, {
          strict = true,
          select = select_next,
        })
        if not ok then
          print('No node.')
          return
        end

        if select_next then return end

        local curbuf = vim.api.nvim_get_current_buf()
        local hl_duration_ms = 100

        local node = ls.session.current_nodes[curbuf]
        local from, to = node:get_buf_position { raw = true }

        -- highlight snippet for 1000ms
        local id = vim.api.nvim_buf_set_extmark(curbuf, ls.session.ms_id, from[1], from[2], {
          -- one line below, at col 0 => entire last line is highlighted
          end_row = to[1],
          end_col = to[2],
          hl_group = 'Visual',
        })
        vim.defer_fn(function() vim.api.nvim_buf_del_extmark(curbuf, ls.session.ns_id, id) end, hl_duration_ms)

        -- select if there is another press within the next second
        select_next = true
        vim.uv.new_timer():start(1000, 0, function() select_next = false end)
      end)

      require('luasnip.loaders.from_lua').lazy_load { paths = './luasnippets' }
      require('luasnip.loaders.from_lua').load { lazy_paths = './luasnippets' }

      require('luasnip.loaders.from_lua').lazy_load {
        paths = './luasnippets',
        fs_event_providers = { 'autocmd', 'libuv' },
      }
      require('luasnip.loaders.from_lua').load {
        lazy_paths = './luasnippets/',
        fs_event_providers = { 'autocmd', 'libuv' },
      }

      require('eo.plugs.luasnip.external_update_dynamic_node')
    end,
  },
}

-- return {
--   require('eo.plugs.snippets'),
-- }
