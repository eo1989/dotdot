local api = vim.api
-- lua_opts = function()
--   local ls = require('luasnip')
--   local types = require('luasnip.util.types')
--   local extras = require('luasnip.extras')
--   local fmt = require('luasnip.extras.fmt').fmt
--   local node = require('luasnip.util.util')
--   local node_util = require('luasnip.nodes.util')
--   ls.config.set_config {
--     keep_roots = true,
--     link_roots = true,
--     link_children = true,
--     loaders_store_source = true,
--     enable_autosnippets = false,
--     store_selection_keys = '<Tab>',
--     update_events = 'InsertLeave',
--     -- update_events = 'TextChanged,TextChangedI,InsertLeave',
--     -- update_events = 'TextChanged,InsertLeave',
--     region_check_events = { 'CursorMoved', 'CursorHold', 'InsertEnter' },
--     -- region_check_events = { 'CursorMoved', 'InsertEnter' },
--     delete_check_events = 'InsertEnter',
--     -- region_check_events = 'CursorMoved', -- prevent <tab> from jumping back to a snippet after its left
--     -- delete_check_events = { 'TextChanged', 'InsertEnter' },
--     ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
--     load_ft_func = require('luasnip.extras.filetype_functions').extend_load_ft {
--       quarto = { 'markdown', 'julia', 'python' },
--     },
--     -- ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
--     -- specifically from akinsho.
--     ext_opts = {
--       [types.choiceNode] = {
--         active = {
--           hl_mode = 'combine',
--           virt_text = { { '●', 'Operator' } },
--         },
--       },
--       [types.insertNode] = {
--         active = {
--           hl_mode = 'combine',
--           virt_text = { { 'λ', 'Type' } },
--         },
--       },
--     },
--     snip_env = {
--       fmt = fmt,
--       m = extras.match,
--       t = ls.text_node,
--       f = ls.function_node,
--       c = ls.choice_node,
--       d = ls.dynamic_node,
--       i = ls.insert_node,
--       l = extras.lambda,
--       snippet = ls.snippet,
--     },
--     parser_nested_assembler = function(_, snippetNode)
--       local select = function(snip, no_move, dry_run)
--         if dry_run then return end
--         snip:focus()
--         --[[ make sure the inner nodes will all shift to one side when the entire text is
--             --replaced ]]
--         snip:subtree_set_rgrav(true)
--         --[[ fix own extmark-gravities, subtree_set_rgrav affects them all.]]
--         snip.mark:set_rgravs(false, true)
--
--         -- SELECT all text inside the snippet.
--         if not no_move then
--           require('luasnip.util.feedkeys').feedkeys_insert('<Esc>')
--           node_util.select_node(snip)
--         end
--       end
--
--       local original_extmarks_valid = snippetNode.extmarks_valid
--       function snippetNode:extmarks_valid()
--         --[[ the contents of this snippetNode are supposed to be deleted, and
--             --   we dont want the snippet to be considered invalid bc of that -> always return true
--             --]]
--         return true
--       end
--
--       function snippetNode:init_dry_run_active(dry_run)
--         if dry_run and dry_run.active[self] == nil then dry_run.active[self] = self.active end
--       end
--
--       function snippetNode:is_active(dry_run) return (not dry_run and self.active) or (dry_run and dry_run.active[self]) end
--
--       function snippetNode:jump_into(dir, no_move, dry_run)
--         self:init_dry_run_active(dry_run)
--         if self:is_active(dry_run) then
--           if dir == 1 then
--             self:input_leave(no_move, dry_run)
--             return self.next:jump_into(dir, no_move, dry_run)
--           else
--             select(self, no_move, dry_run)
--             return self
--           end
--         else
--           -- jumping in from outside snippet.
--           self:input_enter(no_move, dry_run)
--           if dir == 1 then
--             select(self, no_move, dry_run)
--             return self
--           else
--             return self.inner_last:jump_into(dir, no_move, dry_run)
--           end
--         end
--       end
--
--       -- this is called only if the snippet is currently selected.
--       function snippetNode:jump_from(dir, no_move, dry_run)
--         if dir == 1 then
--           if original_extmarks_valid(snippetNode) then
--             return self.inner_first:jump_into(dir, no_move, dry_run)
--           else
--             return self.next:jump_into(dir, no_move, dry_run)
--           end
--         else
--           self:input_leave(no_move, dry_run)
--           return self.prev:jump_into(dir, no_move, dry_run)
--         end
--       end
--       return snippetNode
--     end,
--   }
--
--   eo.command('LuaSnipEdit', function() require('luasnip.loaders').edit_snippet_files() end, {})
--
--   require('luasnip.loaders.from_lua').lazy_load()
--   require('luasnip.loaders.from_vscode').lazy_load {
--     lazy_paths = vim.fn.stdpath('config') .. '/snips',
--     fs_event_providers = { 'autocmd', 'libuv' },
--   }
--   require('luasnip.loaders.from_vscode').lazy_load {
--     lazy_paths = vim.fn.stdpath('config') .. '/snips/',
--     fs_event_providers = { 'autocmd', 'libuv' },
--   }
--   -- luasnip is lazy loaded so it will error upon launch
--   require('luasnip.loaders.from_lua').lazy_load {
--     lazy_paths = vim.fn.stdpath('config') .. '/luasnippets',
--     fs_event_providers = { 'autocmd', 'libuv' },
--   }
--   require('luasnip.loaders.from_lua').lazy_load {
--     lazy_paths = vim.fn.stdpath('config') .. '/luasnippets/',
--     fs_event_providers = { 'autocmd', 'libuv' },
--   }
--   -- ls.filetype_extend('quarto', { 'markdown' })
--   -- ls.filetype_extend('quarto', { 'julia' })
--
--   local opts = { noremap = true, silent = true }
--   map({ 'i', 's' }, '<C-g>', function()
--     if ls.in_snippet() then -- added to check if your actually in a snippet
--       if ls.choice_active() then
--         return ls.change_choice(1)
--       else
--         return _G.dynamic_node_external_update(1) -- feel free to update to any index i
--       end
--     end
--   end, opts)
--
--   map({ 'i', 's' }, '<C-f>', function()
--     if ls.in_snippet() then -- added to check if your actually in a snippet
--       if ls.choice_active() then
--         return ls.change_choice(-1)
--       else
--         return _G.dynamic_node_external_update() -- feel free to update to any index i
--       end
--     end
--   end, opts)
--
--   map({ 's', 'i' }, '<C-l>', function()
--     if ls.choice_active() then ls.change_choice(1) end
--   end)
-- end

-- return {
--   {
--     'kawre/neotab.nvim',
--     event = { 'InsertEnter' },
--     opts = {},
--   },
--   {
--     'L3MON4D3/LuaSnip',
--     -- enabled = true,
--     version = { 'v2.*' },
--     event = { 'InsertEnter', 'VeryLazy' },
--     build = 'make install_jsregexp',
--     dependencies = { 'rafamadriz/friendly-snippets', 'kawre/neotab.nvim' },
--     -- config = function()
--     --   local ls = require('luasnip')
--     --   local types = require('luasnip.util.types')
--     --   local extras = require('luasnip.extras')
--     --   local fmt = require('luasnip.extras.fmt').fmt
--     --   local node = require('luasnip.util.util')
--     --   local node_util = require('luasnip.nodes.util')
--     --   ls.config.set_config {
--     --     keep_roots = true,
--     --     link_roots = true,
--     --     link_children = true,
--     --     loaders_store_source = true,
--     --     enable_autosnippets = false,
--     --     store_selection_keys = '<Tab>',
--     --     update_events = 'InsertLeave',
--     --     -- update_events = 'TextChanged,TextChangedI,InsertLeave',
--     --     -- update_events = 'TextChanged,InsertLeave',
--     --     region_check_events = { 'CursorMoved', 'CursorHold', 'InsertEnter' },
--     --     -- region_check_events = { 'CursorMoved', 'InsertEnter' },
--     --     delete_check_events = 'InsertEnter',
--     --     -- region_check_events = 'CursorMoved', -- prevent <tab> from jumping back to a snippet after its left
--     --     -- delete_check_events = { 'TextChanged', 'InsertEnter' },
--     --     ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
--     --     load_ft_func = require('luasnip.extras.filetype_functions').extend_load_ft {
--     --       quarto = { 'markdown', 'julia', 'python' },
--     --     },
--     --     -- ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
--     --     -- specifically from akinsho.
--     --     ext_opts = {
--     --       [types.choiceNode] = {
--     --         active = {
--     --           hl_mode = 'combine',
--     --           virt_text = { { '●', 'Operator' } },
--     --         },
--     --       },
--     --       [types.insertNode] = {
--     --         active = {
--     --           hl_mode = 'combine',
--     --           virt_text = { { 'λ', 'Type' } },
--     --         },
--     --       },
--     --     },
--     --     snip_env = {
--     --       fmt = fmt,
--     --       m = extras.match,
--     --       t = ls.text_node,
--     --       f = ls.function_node,
--     --       c = ls.choice_node,
--     --       d = ls.dynamic_node,
--     --       i = ls.insert_node,
--     --       l = extras.lambda,
--     --       snippet = ls.snippet,
--     --     },
--     --     parser_nested_assembler = function(_, snippetNode)
--     --       local select = function(snip, no_move, dry_run)
--     --         if dry_run then return end
--     --         snip:focus()
--     --         --[[ make sure the inner nodes will all shift to one side when the entire text is
--     --         --replaced ]]
--     --         snip:subtree_set_rgrav(true)
--     --         --[[ fix own extmark-gravities, subtree_set_rgrav affects them all.]]
--     --         snip.mark:set_rgravs(false, true)
--     --
--     --         -- SELECT all text inside the snippet.
--     --         if not no_move then
--     --           require('luasnip.util.feedkeys').feedkeys_insert('<Esc>')
--     --           node_util.select_node(snip)
--     --         end
--     --       end
--     --
--     --       local original_extmarks_valid = snippetNode.extmarks_valid
--     --       function snippetNode:extmarks_valid()
--     --         --[[ the contents of this snippetNode are supposed to be deleted, and
--     --         --   we dont want the snippet to be considered invalid bc of that -> always return true
--     --         --]]
--     --         return true
--     --       end
--     --
--     --       function snippetNode:init_dry_run_active(dry_run)
--     --         if dry_run and dry_run.active[self] == nil then dry_run.active[self] = self.active end
--     --       end
--     --
--     --       function snippetNode:is_active(dry_run)
--     --         return (not dry_run and self.active) or (dry_run and dry_run.active[self])
--     --       end
--     --
--     --       function snippetNode:jump_into(dir, no_move, dry_run)
--     --         self:init_dry_run_active(dry_run)
--     --         if self:is_active(dry_run) then
--     --           if dir == 1 then
--     --             self:input_leave(no_move, dry_run)
--     --             return self.next:jump_into(dir, no_move, dry_run)
--     --           else
--     --             select(self, no_move, dry_run)
--     --             return self
--     --           end
--     --         else
--     --           -- jumping in from outside snippet.
--     --           self:input_enter(no_move, dry_run)
--     --           if dir == 1 then
--     --             select(self, no_move, dry_run)
--     --             return self
--     --           else
--     --             return self.inner_last:jump_into(dir, no_move, dry_run)
--     --           end
--     --         end
--     --       end
--     --
--     --       -- this is called only if the snippet is currently selected.
--     --       function snippetNode:jump_from(dir, no_move, dry_run)
--     --         if dir == 1 then
--     --           if original_extmarks_valid(snippetNode) then
--     --             return self.inner_first:jump_into(dir, no_move, dry_run)
--     --           else
--     --             return self.next:jump_into(dir, no_move, dry_run)
--     --           end
--     --         else
--     --           self:input_leave(no_move, dry_run)
--     --           return self.prev:jump_into(dir, no_move, dry_run)
--     --         end
--     --       end
--     --       return snippetNode
--     --     end,
--     --   }
--     --
--     --   eo.command('LuaSnipEdit', function() require('luasnip.loaders').edit_snippet_files() end, {})
--     --
--     --   require('luasnip.loaders.from_lua').lazy_load()
--     --   require('luasnip.loaders.from_vscode').lazy_load {
--     --     lazy_paths = vim.fn.stdpath('config') .. '/snips',
--     --     fs_event_providers = { 'autocmd', 'libuv' },
--     --   }
--     --   require('luasnip.loaders.from_vscode').lazy_load {
--     --     lazy_paths = vim.fn.stdpath('config') .. '/snips/',
--     --     fs_event_providers = { 'autocmd', 'libuv' },
--     --   }
--     --   -- luasnip is lazy loaded so it will error upon launch
--     --   require('luasnip.loaders.from_lua').lazy_load {
--     --     lazy_paths = vim.fn.stdpath('config') .. '/luasnippets',
--     --     fs_event_providers = { 'autocmd', 'libuv' },
--     --   }
--     --   require('luasnip.loaders.from_lua').lazy_load {
--     --     lazy_paths = vim.fn.stdpath('config') .. '/luasnippets/',
--     --     fs_event_providers = { 'autocmd', 'libuv' },
--     --   }
--     --   -- ls.filetype_extend('quarto', { 'markdown' })
--     --   -- ls.filetype_extend('quarto', { 'julia' })
--     --
--     --   local opts = { noremap = true, silent = true }
--     --   map({ 'i', 's' }, '<C-g>', function()
--     --     if ls.in_snippet() then -- added to check if your actually in a snippet
--     --       if ls.choice_active() then
--     --         return ls.change_choice(1)
--     --       else
--     --         return _G.dynamic_node_external_update(1) -- feel free to update to any index i
--     --       end
--     --     end
--     --   end, opts)
--     --
--     --   map({ 'i', 's' }, '<C-f>', function()
--     --     if ls.in_snippet() then -- added to check if your actually in a snippet
--     --       if ls.choice_active() then
--     --         return ls.change_choice(-1)
--     --       else
--     --         return _G.dynamic_node_external_update() -- feel free to update to any index i
--     --       end
--     --     end
--     --   end, opts)
--     --
--     --   map({ 's', 'i' }, '<C-l>', function()
--     --     if ls.choice_active() then ls.change_choice(1) end
--     --   end)
--     --
--     --   -- map({ 's', 'i' }, '<C-j>', function()
--     --   --   -- if not ls.expand_or_jumpable() then return '<Tab>' end
--     --   --   if not ls.expand_or_locally_jumpable() then return '<Tab>' end
--     --   --   ls.expand_or_locally_jumpable()
--     --   -- end, { expr = true, remap = true })
--     --
--     --   -- map({ 's', 'i' }, '<C-h>', function()
--     --   --   if not ls.jumpable(-1) then return '<S-Tab>' end
--     --   --   ls.jump(-1)
--     --   -- end, { expr = true, remap = true })
--     -- end,
--     opts = lua_opts,
--   },
-- }

return {
  { 'kawre/neotab.nvim', lazy = true, opts = {} },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    event = 'InsertEnter *',
    build = { 'make install_jsregexp' },
    dependencies = { 'neotab.nvim' },
    opts = {
      module = {},
    },
    config = function()
      local ls = require('luasnip')
      local types = require('luasnip.util.types')
      local extras = require('luasnip.extras')
      local fmt = require('luasnip.extras.fmt').fmt
      local node = require('luasnip.util.util')
      local node_util = require('luasnip.nodes.util')

      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load {
        lazy_paths = vim.fn.stdpath('config') .. '/snips',
        fs_event_providers = { 'autocmd', 'libuv' },
      }
      require('luasnip.loaders.from_vscode').lazy_load {
        lazy_paths = vim.fn.stdpath('config') .. '/snips/',
        fs_event_providers = { 'autocmd', 'libuv' },
      }
      -- luasnip is lazy loaded so it will error upon launch
      require('luasnip.loaders.from_lua').lazy_load {
        lazy_paths = vim.fn.stdpath('config') .. '/luasnippets',
        fs_event_providers = { 'autocmd', 'libuv' },
      }
      require('luasnip.loaders.from_lua').lazy_load {
        lazy_paths = vim.fn.stdpath('config') .. '/luasnippets/',
        fs_event_providers = { 'autocmd', 'libuv' },
      }

      require('luasnip.loaders.from_lua').lazy_load()

      map({ 's', 'i' }, '<C-k>', function() pcall(ls.change_choice, -1) end)
      map({ 's', 'i' }, '<C-j>', function() pcall(ls.change_choice, 1) end)

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

      map({ 's', 'i' }, '<C-h>', function()
        if ls.get_active_snip() then
          ls.jump(-1)
        elseif vim.snippet.active() then
          vim.snippet.jump(-1)
        else
          local cur = api.nvim_win_get_cursor(0)
          pcall(api.nvim_win_set_cursor, 0, { cur[1], cur[2] - 1 })
        end
      end)

      map({ 's', 'i' }, '<C-l>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        elseif ls.get_active_snip() then
          ls.jump(1)
        elseif vim.snippet.active() then
          vim.snippet.jump(1)
        else
          local cur = api.nvim_win_get_cursor(0)
          pcall(api.nvim_win_set_cursor, 0, { cur[1], cur[2] + 1 })
        end
      end)

      map({ 'i', 's' }, '<Tab>', function()
        if lsp.expand_or_jumpable() then
          ls.expand_or_jump()
        elseif ls.get_active_snip() then
          ls.jump(1)
        elseif vim.snippet.active() then
          vim.snippet.jump(1)
        else
          vim.snippet.jump(1)
          api.nvim_feedkeys(api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', true)
        end
      end)

      local util = require('luasnip.util.util')

      ls.config.setup {
        keep_roots = true,
        link_roots = true,
        link_children = true,
        loaders_store_source = true,
        enable_autosnippets = true,
        store_selection_keys = '<Tab>',
        -- update_events = 'InsertLeave',
        update_events = 'TextChanged,TextChangedI',
        -- update_events = 'TextChanged,InsertLeave',
        region_check_events = { 'CursorMoved', 'CursorHold', 'InsertEnter' },
        -- region_check_events = { 'CursorMoved', 'InsertEnter' },
        delete_check_events = 'InsertEnter',
        -- region_check_events = 'CursorMoved', -- prevent <tab> from jumping back to a snippet after its left
        -- delete_check_events = { 'TextChanged', 'InsertEnter' },
        ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
        load_ft_func = require('luasnip.extras.filetype_functions').extend_load_ft {
          quarto = { 'markdown', 'julia', 'python' },
        },
        -- ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
        -- specifically from akinsho.
        ext_opts = {
          [types.choiceNode] = {
            active = {
              hl_mode = 'combine',
              virt_text = { { '●', 'Operator' } },
            },
          },
          [types.insertNode] = {
            active = {
              hl_mode = 'combine',
              virt_text = { { 'λ', 'Type' } },
            },
          },
        },
        snip_env = {
          fmt = fmt,
          m = extras.match,
          t = ls.text_node,
          f = ls.function_node,
          c = ls.choice_node,
          d = ls.dynamic_node,
          i = ls.insert_node,
          l = extras.lambda,
          snippet = ls.snippet,
        },
        parser_nested_assembler = function(_, snippet)
          local select = function(snip, no_move)
            snip.parent:enter_node(snip.idnx)
            -- upon deletion, extmarks of inner nodes should shift to end of placeholder-text.
            for _, node in ipairs(snip.nodes) do
              node:set_mark_rgrav(true, true)
            end
            -- Select all text inisdie the snippet
            if not no_move then
              api.nvim_feedkeys(api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
              local pos_begin, pos_end = snip.mark:pos_begin_end()
              util.normal_move_on(pos_begin)
              api.nvim_feedkeys(api.nvim_replace_termcodes('v', true, false, true), 'n', true)
              util.normal_move_before(pos_end)
              api.nvim_feedkeys(api.nvim_replace_termcodes('o<C-G>', true, false, true), 'n', true)
            end
          end
          function snippet:jump_into(dir, no_move)
            if self.active then
              -- inside snippet, but not selected
              if dir == 1 then
                self:input_leave(no_move)
                return self.next:jump_into(dir, no_move)
              else
                select(self, no_move)
                return self
              end
            else
              -- jumping in from outside snippet.
              self:input_enter()
              if dir == 1 then
                select(self, no_move)
                return self
              else
                return self.inner_last:jump_into(dir, no_move)
              end
            end
          end
          -- this is called only if the snippet is currently selected
          function snippet:jump_from(dir, no_move)
            if dir == 1 then
              return self.inner_first:jump_into(dir, no_move)
            else
              self:input_leave()
              return self.prev:jump_into(dir, no_move)
            end
          end
          return snippet
        end,
      }
      local function cmd(_, _, ...)
        local proc = vim.system({ ... }):wait()
        return vim.trim(proc.stdout)
      end
      ls.add_snippets('all', {
        ls.snippet('ts', ls.function_node(cmd, {}, { user_args = { 'date', '+%H:%M' } })),
        ls.snippet('date', ls.function_node(cmd, {}, { user_args = { 'date', '+%Y-%m-%d' } })),
      })

      local function load_snippets(reload)
        for k in pairs(opts.modules) do
          local mod = 'snippets.' .. k
          if reload then package.loaded[mod] = nil end
          local ok, err = pcall(require, mod)
          if not ok then
            vim.notify(string.format("Error loading snippet module '%s': %s", k, err), vim.log.levels.ERROR)
          end
        end
      end
      local function reload()
        require('luasnip.loaders.from_vscode').load()
        load_snippets(true)
      end

      load_snippets(false)
      api.nvim_create_user_command('LuaSnipReload', reload, { bar = true })
      api.nvim_create_autocmd('BufWritePost', {
        desc = 'Reload snippets on write',
        pattern = { '*' },
        callback = function(args)
          local bufname = api.nvim_buf_get_name(args.buf)
          if
            bufname:match('/snippets/.+%.lua$')
            or bufname:match('/snippets/.+%.json$')
            or bufname:match('package.json$')
          then
            vim.notifty('Reloading snippets', vim.log.levels.INFO)
            reload()
          end
        end,
      })

      eo.command('LuaSnipEdit', function() require('luasnip.loaders').edit_snippet_files() end, {})

      -- ls.filetype_extend('quarto', { 'markdown' })
      -- ls.filetype_extend('quarto', { 'julia' })

      local upts = { noremap = true, silent = true }
      map({ 'i', 's' }, '<C-h>', function()
        if ls.in_snippet() then -- added to check if your actually in a snippet
          if ls.choice_active() then
            return ls.change_choice(1)
          else
            return _G.dynamic_node_external_update(1) -- feel free to update to any index i
          end
        end
      end, upts)

      map({ 'i', 's' }, '<C-g>', function()
        if ls.in_snippet() then -- added to check if your actually in a snippet
          if ls.choice_active() then
            return ls.change_choice(-1)
          else
            return _G.dynamic_node_external_update() -- feel free to update to any index i
          end
        end
      end, upts)

      -- map({ 's', 'i' }, '<C-j>', function()
      --   -- if not ls.expand_or_jumpable() then return '<Tab>' end
      --   if not ls.expand_or_locally_jumpable() then return '<Tab>' end
      --   ls.expand_or_locally_jumpable()
      -- end, { expr = true, remap = true })

      -- map({ 's', 'i' }, '<C-h>', function()
      --   if not ls.jumpable(-1) then return '<S-Tab>' end
      --   ls.jump(-1)
      -- end, { expr = true, remap = true })
    end,
  },
}
-- parser_nested_assembler = function(_, snippetNode)
--   local select = function(snip, no_move, dry_run)
--     if dry_run then return end
--     snip:focus()
--     --[[ make sure the inner nodes will all shift to one side when the entire text is
--         --replaced ]]
--     snip:subtree_set_rgrav(true)
--     --[[ fix own extmark-gravities, subtree_set_rgrav affects them all.]]
--     snip.mark:set_rgravs(false, true)
--
--     -- SELECT all text inside the snippet.
--     if not no_move then
--       require('luasnip.util.feedkeys').feedkeys_insert('<Esc>')
--       node_util.select_node(snip)
--     end
--   end
--
--   local original_extmarks_valid = snippetNode.extmarks_valid
--   function snippetNode:extmarks_valid()
--     --[[ the contents of this snippetNode are supposed to be deleted, and
--         --   we dont want the snippet to be considered invalid bc of that -> always return true
--         --]]
--     return true
--   end
--
--   function snippetNode:init_dry_run_active(dry_run)
--     if dry_run and dry_run.active[self] == nil then dry_run.active[self] = self.active end
--   end
--
--   function snippetNode:is_active(dry_run)
--     return (not dry_run and self.active) or (dry_run and dry_run.active[self])
--   end
--
--   function snippetNode:jump_into(dir, no_move, dry_run)
--     self:init_dry_run_active(dry_run)
--     if self:is_active(dry_run) then
--       if dir == 1 then
--         self:input_leave(no_move, dry_run)
--         return self.next:jump_into(dir, no_move, dry_run)
--       else
--         select(self, no_move, dry_run)
--         return self
--       end
--     else
--       -- jumping in from outside snippet.
--       self:input_enter(no_move, dry_run)
--       if dir == 1 then
--         select(self, no_move, dry_run)
--         return self
--       else
--         return self.inner_last:jump_into(dir, no_move, dry_run)
--       end
--     end
--   end
--
--   -- this is called only if the snippet is currently selected.
--   function snippetNode:jump_from(dir, no_move, dry_run)
--     if dir == 1 then
--       if original_extmarks_valid(snippetNode) then
--         return self.inner_first:jump_into(dir, no_move, dry_run)
--       else
--         return self.next:jump_into(dir, no_move, dry_run)
--       end
--     else
--       self:input_leave(no_move, dry_run)
--       return self.prev:jump_into(dir, no_move, dry_run)
--     end
--   end
--   return snippetNode
-- end,
