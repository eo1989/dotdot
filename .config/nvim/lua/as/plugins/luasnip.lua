return function()
  local extras = require("luasnip.extras")
  local fmt = require("luasnip.extras.fmt").fmt
  local api = vim.api

  local ls = require('luasnip')
  local ls_types = require('luasnip.util.types')
  -- local util = require('luasnip.util.util')

  -- require('luasnip.loaders.from_vscode').lazy_load({
  --   paths = {
  --     "~/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  --   },
  -- })

  require('luasnip.config').setup({
    history = false,
    -- region_check_events = 'CursorMoved', --,CursorMovedI,CursorHold,CursorHoldI',
    -- delete_check_events = 'TextChangedI', --,InsertLeave',
    updateevents = 'TextChanged,TextChangedI', --TextChangedI',
    enable_autosnippets = true,
    store_selection_keys = '<Tab>',
    filetype_extend = { 'markdown', { 'python', 'julia' } },
    -- ft_func = require('luasnip.extras.filetype_functions').from_cursor,
    -- ft_func = require('luasnip.extras.filetype_functions').from_pos_or_filetype,
    ext_opts = {
      [ls_types.choiceNode] = {
        active = {
          -- hl_mode = 'combine',
          virt_text = { { ' 𝞴', 'NonTest' } }, -- '●' ' ' 'Operator'
        },
      },
      [ls_types.insertNode] = {
        active = {
          -- hl_mode = 'combine',
          virt_text = { { ' ↵', 'Operator' } },
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
    -- local table = {
    -- parser_nested_assembler = function(_, snippet)
    --   local select = function(snip, no_move)
    --     snip.parent:enter_node(snip.indx)
    --     -- upon deletion, extmarks of inner nodes should shift to end of placeholder-text.
    --     for _, node in ipairs(snip.nodes) do
    --       node:set_mark_rgrav(true, true)
    --     end
    --     -- select all text inside the snippet
    --     if not no_move then
    --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    --       local pos_begin, pos_end = snip.mark:pos_begin_end()
    --       util.normal_move_on(pos_begin)
    --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('v', true, false, true), 'n', true)
    --       util.normal_move_before(pos_end)
    --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('o<C-G>', true, false, true), 'n', true)
    --     end
    --   end
    --
    --   function snippet:jump_into(dir, no_move)
    --     if self.active then
    --       -- inside snippet, but not selected.
    --       if dir == 1 then
    --         self:input_leave()
    --         return self.next:jump_into(dir, no_move)
    --       else
    --         select(self, no_move)
    --         return self
    --       end
    --     else
    --       -- jumping in from outside snippet.
    --       self:input_enter()
    --       if dir == 1 then
    --         select(self, no_move)
    --         return self
    --       else
    --         return self.inner_last:jump_into(dir, no_move)
    --       end
    --     end
    --   end
    --
    --   function snippet:jump_from(dir, no_move)
    --     if dir == 1 then
    --       return self.inner_first:jump_into(dir, no_move)
    --     else
    --       self:input_leave()
    --       return self.prev:jump_into(dir, no_move)
    --     end
    --   end
    --
    --   return snippet
    -- end,
    -- }
  })

  as.command('LuaSnipEdit', function() require('luasnip.loaders.from_lua').edit_snippet_files() end)
  -- as.imap('<Esc>', [[<esc>:LuaSnipUnlinkCurrent<CR>]], { silent = true })
  -- as.smap('<Esc>', [[<esc>:LuaSnipUnlinkCurrent<CR>]], { silent = true })


  -- require('as.plugins.snips.choice_popup')
  -- require('as.plugins.snips.dynamic_node_external_update')

  -- vim.keymap.set({"i" }, "<C-u>", function()
  --   if ls.choice_active() then ls.change_choice(1) end
  -- end, {})
  -- vim.keymap.del("i", "<c-u>")
  -- vim.keymap.set("i", "<c-u>", function() extras.select_choice() end, { unique = true })
  vim.keymap.set({"i", "s"}, "<A-e>", function() extras.select_choice() end)

  -- local map = vim.keymap.set
  vim.keymap.set({"i", "s"}, "<C-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    -- elseif extras.select_choice() then
    --   extras.select_choice(1)
    end
  end)
  vim.keymap.set({"i", "s"}, "<C-h>", function()
    if ls.choice_active() then
      ls.change_choice(-1)
    -- elseif extras.select_choice() then
    --   extras.select_choice(1)
    end
  end)
  -- vim.keymap.set({'s', 'i'}, '<c-u>', require('luasnip.extras.select_choice'))
  -- vim.keymap.set( {'s', 'i'}, "<C-j>", function()
  --   if ls.expand_or_jumpable() then ls.expand_or_jump() end
  -- end)
  -- vim.keymap.set( {'s', 'i'}, '<C-k>', function()
  --     if ls.jumpable() then ls.jump(-1) end
  -- end)


  -- local function reload_luasnip_config()
  --   require('luasnip').cleanup()
  --   for k in pairs(package.loaded) do
  --     if k:match('.*plugins.snips.*') then
  --       package.loaded[k] = nil
  --       require(k)
  --     end
  --   end
  -- end
  -- vim.keymap.set('n', '<space>rs', reload_luasnip_config, { desc = 'Reload snippets' })

  -- require('as.plugins.snips.python')
  -- require('as.plugins.snips.lua')
  -- require('as.plugins.snips.tex_math')
  -- require('as.plugins.snips.julia').config()
  -- require('luasnip.loaders.from_lua').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load()
  -- require('luasnip.loaders.from_vscode').lazy_load({ paths = './snippets/textmate' })
end
