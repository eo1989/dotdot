-- local map = vim.keymap.set
local api, highlight, border = vim.api, eo.highlight, eo.ui.current.border
local defaults = require('defaults')
-- local session = require('')
-- local trigger_text = ';'

-- emacs behavior attempt

local function has_words_before()
  local col = api.nvim_win_get_cursor(0)[2]
  if col == 0 then return false end
  local line = api.nvim_get_current_line()
  return line:sub(col, col):match('%s') == nil
end

---@type LazySpec
return {
  {
    ---@module "copilot"
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    build = ':Copilot auth',
    cmd = 'Copilot',
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = '<M-l>',
          next = '<M-]>',
          prev = '<M-[>',
          -- dismiss = '<C-]>',
        },
      },
      filetypes = {
        ['*'] = true,
        julia = true,
        r = true,
        help = true,
        lua = true,
        python = true,
        quarto = false,
        markdown = false,
        norg = false,
        gitcommit = false,
        ['FzfLua'] = false,
        -- ['dap-repl'] = false,
        -- DressingInput = false,
        -- TelescopePrompt = false,
        ['neo-tree-popup'] = false,
        NeogitCommitMessage = false,
        sh = function()
          if string.match(vim.fs.basename(api.nvim_buf_get_name(0)), "^%.env.*") then
            -- disable copilot for .env files
            return false
          end
          return true
        end,
        ['.'] = false,
      },
      server_opts_overrides = {
        settings = {
          telemetry = { telemetryLevel = 'off' }
        },
      },
      should_attach = function(_, bufname)
        if string.match(bufname, "env") then
          return false
        end
        return true
      end
    },
  },
  -- {
  --   'copilotlsp-nvim/copilot-lsp',
  --   dependencies = { 'fang2hou/blink-copilot' },
  --   init = function()
  --     vim.g.copilot_nes_debounce = 250
  --     vim.lsp.enable('copilot_ls')
  --   end,
  --   opts = {},
  -- },
  {
    ---@module 'blink.cmp'
    'saghen/blink.cmp',
    -- event = { 'VimEnter' },
    lazy = false, -- lazy loading handled internally!
    version = '1.*', -- looks like its required if you want the correct prebuilt binaries
    dependencies = {
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      { 'xzbdmw/colorful-menu.nvim' },
      -- { 'copilotlsp-nvim/copilot-lsp' },
      { 'fang2hou/blink-copilot' },
      { 'erooke/blink-cmp-latex', ft = { 'quarto', 'markdown', 'julia', 'r', 'rmd', 'julia' } },
      { 'saghen/blink.compat', enabled = true },
      {
        'Kaiser-Yang/blink-cmp-git',
        ft = { 'octo', 'gitcommit', 'git' },
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {},
    config = function(_, opts)
      local blink = require('blink-cmp')
      -- local luasnip = require('luasnip')

      blink.setup {
        fuzzy = {
          implementation = 'prefer_rust_with_warning',
          prebuilt_binaries = { download = true },
        },
        keymap = {
          preset = 'super-tab', -- "default" | "super-tab" (similar to vscode) | "enter" (supertab w/ enter to accept)
          -- preset = 'none', -- "default" | "super-tab" (similar to vscode) | "enter" (supertab w/ enter to accept)
          ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },

          ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          --[[ from https://github.com/Saghen/blink.cmp/issues/743 ]]
          -- ['<Tab>'] = {
          --   function(cmp)
          --     if cmp.snippet_active() then
          --       return cmp.accept()
          --     else
          --       return cmp.select_and_accept()
          --     end
          --   end,
          --   function()
          --     if vim.fn.pumvisible() == 1 then
          --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-y>', true, false, true), 'n', false)
          --       return true
          --     else
          --       return false
          --     end
          --   end,
          --   'snippet_forward',
          --   'fallback',
          -- },
          -- ['<Tab>'] = {
          --   function(cmp)
          --     if cmp.snippet_active() then
          --       return cmp.accept()
          --     else
          --       return cmp.select_and_accept()
          --     end
          --     -- if has_words_before() then
          --     --   return cmp.insert_next()
          --     --   -- elseif cmp.is_active(1) then
          --     --   --   return cmp.select_and_accept()
          --     -- elseif luasnip.expand_or_jumpable(1) then
          --     --   return luasnip.expand_or_jump(1)
          --     --   -- elseif luasnip.jumpable(1) then
          --     --   --   luasnip.jump(1)
          --     -- else
          --     --   return cmp.select_and_accept()
          --     --   -- neotab.tabout_luasnip()
          --     -- end
          --   end,
          --   'snippet_forward',
          --   'fallback',
          -- },
          -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
          -- ['<M-Tab>'] = {
          --   function(cmp)
          --     if vim.b[api.nvim_get_current_buf()].nes_state then
          --       cmp.hide()
          --       return require('copilot-lsp.nes').apply_pending_nes()
          --     end
          --   end,
          --   'fallback',
          -- },
          -- ['<Tab>'] = {
          --   function(cmp)
          --     if vim.b[vim.api.nvim_get_current_buf()].nes_state then
          --       cmp.hide()
          --       return (
          --         require('copilot-lsp.nes').apply_pending_nes()
          --         and require('copilot-lsp.nes').walk_cursor_end_edit()
          --       )
          --     end
          --     if cmp.snippet_active() then
          --       return cmp.accept()
          --     else
          --       return cmp.select_and_accept()
          --     end
          --   end,
          --   'snippet_forward',
          --   'fallback',
          -- },
        },
        appearance = {
          nerd_font_variant = 'normal',
          use_nvim_cmp_as_default = true,
        },
        snippets = {
          preset = 'luasnip',
          expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
          --[[ https://github.com/L3MON4D3/Dotfiles/blob/main/nvim/lua/plugins/blink.lua ]]
          -- expand = function(snippet)
          --   local override_snip = require('session').lsp_override_snips[snip]
          --   if override_snip then
          --     require('luasnip').snip_expand(override_snip)
          --   else
          --     require('luasnip').lsp_expand(snippet)
          --   end
          -- end,
          active = function(filter)
            if filter and filter.direction then return require('luasnip').jumpable(filter.direction) end
            return require('luasnip').in_snippet()
          end,
          jump = function(direction) require('luasnip').jump(direction) end,
        },
        signature = {
          enabled = false,
          trigger = {
            enabled = true,
            show_on_insert = true,
            show_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
          },
          window = {
            direction_priority = { 'n', 's' },
            -- border = 'solid',
            border = 'none',
            treesitter_highlighting = true,
            show_documentation = false,
            -- max_width = 60,
            -- min_width = vim.o.pumwidth,
            -- max_height = vim.o.pumheight,
            winblend = 10,
          },
        },
        completion = {
          trigger = {
            prefetch_on_insert = true,
            show_on_trigger_character = true,
            show_on_accept_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
            show_on_backspace = false,
            show_on_backspace_in_keyword = false,
            show_on_backspace_after_accept = false,
            show_on_backspace_after_insert_enter = true,
            show_on_keyword = true,
            show_on_insert = true,
            show_in_snippet = false, -- messes with luasnip
          },
          ghost_text = { show_with_menu = false },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 20,
            update_delay_ms = 50,
            treesitter_highlighting = true,
            window = {
              border = 'rounded',
              -- min_width = 40,
              -- max_width = 120,
              -- max_height = 60,
            },
          },
          accept = {
            auto_brackets = {
              enabled = true, -- let autopairs do it
              semantic_token_resolution = { enabled = true },
            },
          },
          list = {
            selection = {
              -- preselect = false or function(ctx) return not blink.snippet_active { direction = 1 } end,
              preselect = function(ctx) return not require('blink.cmp').snippet_active { direction = 1 } end,
              auto_insert = function(ctx) return ctx.mode == 'cmdline' and false or true end,
              -- auto_insert = false,
            },
            -- cycle = { from_top = true, from_bottom = true },
          },
          menu = {
            enabled = true,
            -- min_width = 20,
            -- max_height = 30,
            -- border = 'rounded',
            border = border,
            auto_show = true,
            cmdline_position = function()
              if vim.g.ui_cmdline_pos ~= nil then
                local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                return { pos[1] - 1, pos[2] }
              end
              local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
              return { vim.o.lines - height, 0 }
            end,
            draw = {
              treesitter = { 'lsp', 'copilot' },
              align_to = 'none', -- 'none' = disable | 'cursor' = align to cursor | 'label'
              -- padding = 1, -- { left, right }
              padding = { 1, 1 },
              gap = 1, -- gap between columns
              columns = {
                { 'kind_icon' },
                { 'label', gap = 1 },
              },
              components = {
                label = {
                  -- width = { fill = true, max = 80 },
                  text = function(ctx)
                    local highlights_info = require('colorful-menu').blink_highlights(ctx)
                    if highlights_info ~= nil then
                      -- Or you want to add more item to label
                      return highlights_info.label
                    else
                      return ctx.label
                    end
                  end,
                  -- text = require('colorful-menu').blink_components_text,
                  highlight = function(ctx)
                    local highlights = {}
                    local highlights_info = require('colorful-menu').blink_highlights(ctx)
                    if highlights_info ~= nil then highlights = highlights_info.highlights end
                    for _, idx in ipairs(ctx.label_matched_indices) do
                      table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                    end
                    -- Do something else
                    return highlights
                  end,
                  -- highlight = require('colorful-menu').blink_components_highlight,
                },
                kind_icon = {
                  text = function(ctx)
                    local icon = defaults.icons.completion_items[ctx.kind] or ''
                    -- local icon = defaults.icons.completion_items or ""
                    -- return icon .." " .. (ctx.kind or "")
                    return icon or ''
                  end,
                  -- treesitter_highlighting = true,
                  highlight = function(ctx) return 'CmpItemKind' .. (ctx.kind or 'Default') end,
                },
              },
            },
          },
        },
        cmdline = {
          enabled = true,
          completion = {
            ghost_text = { enabled = false },
            menu = { auto_show = true },
          },
        },
        sources = {
          default = { 'lsp', 'snippets', 'path', 'copilot', 'buffer', 'otter' },
          -- default = function(ctx)
          --   local node = vim.treesitter.get_node()
          --   if vim.bo.filetype == 'lua' then
          --     return { 'lsp', 'path', 'lazydev' }
          --   elseif node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
          --     return {'buffer'}
          --   end
          -- end,
          per_filetype = {
            sql = { inherit_defaults = true, 'dadbod' },
            lua = { inherit_defaults = true, 'lazydev' },
            markdown = { inherit_defaults = true, 'markdown', 'latex' },
            quarto = { inherit_defaults = true, 'markdown', 'latex' },
            julia = { inherit_defaults = true, 'latex' },
            -- python = { inherit_defaults = true, 'latex' },
          },
          providers = {
            otter = {
              name = 'otter',
              module = 'blink.compat.source',
              -- cmp_name = 'otter',
              enabled = true,
              opts = {},
            },
            --[[https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugin-specs/blink-cmp.lua]]
            buffer = {
              max_items = 4,
              min_keyword_length = 2,
              -- with '-7', typing `then` in lua prioritizes the `then .. end` snippet, effectively
              -- acting as `nvim-endwise`.
              score_offset = -7,
            },
            dadbod = {
              name = 'dadbod',
              module = 'vim_dadbod_completion.blink',
              -- score_offset = 90,
              enabled = function() return vim.tbl_contains({ 'sql', 'plsql', 'prql', 'mysql' }, vim.o.filetype) end,
            },
            lazydev = {
              name = 'lazydev',
              module = 'lazydev.integrations.blink',
              fallbacks = { 'lsp' },
              -- score_offset = 103,
            },
            git = {
              name = 'git',
              module = 'blink-cmp-git',
              opts = {},
              enabled = function()
                return vim.tbl_contains(
                  { 'octo', 'gitcommit', 'git', 'markdown', 'NeogitCommitMessage', 'gitrebase' },
                  vim.bo.filetype
                )
              end,
            },
            lsp = {
              name = 'LSP',
              module = 'blink.cmp.sources.lsp',
              -- fallbacks = {}, -- dont use 'buffer' as fallback
              -- Filter text items from the LSP provider, since we have the buffer provider for that
              transform_items = function(_, items)
                return vim.tbl_filter(function(item)
                  return {
                    item.kind ~= require('blink.cmp.types').CompletionItemKind.Text,
                    -- or { item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword },
                  }
                end, items)
              end,
              --- NOTE: All of these options may be functions to get dynamic behavior
              --- See the type definitions for more information
              enabled = true, -- Whether or not to enable the provider
              async = true, -- Whether we should wait for the provider to return before showing the completions
              timeout_ms = 50, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
              should_show_items = true, -- Whether or not to show the items ??
              max_items = 20, -- Maximum number of items to display in the menu
              min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
              -- If this provider returns 0 items, it will fallback to these providers.
              -- If multiple providers fallback to the same provider, all of the providers must return 0 items for it to fallback
              -- score_offset = 11, -- Boost/penalize the score of the items
              -- override = nil, -- Override the source's functions
            },
            path = {
              name = 'path',
              module = 'blink.cmp.sources.path',
              -- score_offset = 3,
              opts = {
                trailing_slash = true,
                label_trailing_slash = true,
                show_hidden_files_by_default = true,
                -- Treat `/path` as starting from the current working directory (cwd) instead of the root of your filesystem
                ignore_root_slash = false,
              },
            },
            snippets = {
              name = 'snippets',
              score_offset = 5,
              module = 'blink.cmp.sources.snippets',
              opts = {
                -- Whether to use show_condition for filtering snippets
                use_show_condition = true,
                -- Whether to show autosnippets in the completion list
                show_autosnippets = true,
                -- Whether to prefer docTrig placeholders over trig when expanding regTrig snippets
                prefer_doc_trig = false,
              },
            },
            markdown = {
              name = 'RenderMarkdown',
              module = 'render-markdown.integ.blink',
              fallbacks = { 'lsp' },
              enabled = function()
                return vim.tbl_contains({ 'markdown', 'quarto', 'gitcommit', 'rmd' }, vim.o.filetype)
              end,
            },
            copilot = {
              name = 'Copilot',
              module = 'blink-copilot',
              score_offset = -9,
              deduplicate = { enabled = true },
              timeout_ms = 50,
              async = true,
              max_items = 3,
              opts = {
                max_completions = 3,
                max_attempts = 4,
                debounce = 250, ---@type integer | false
                -- auto_refresh = {
                --   backward = true,
                --   forward = true,
                -- },
              },
              transform_items = function(ctx, items)
                for _, item in ipairs(items) do
                  item.kind_icon = ' '
                  -- item.kind_name = 'Copilot'
                end
                return items
              end,
            },
            latex = {
              name = 'Latex',
              module = 'blink-cmp-latex',
              async = true,
              transform_items = function(ctx, items)
                for _, item in ipairs(items) do
                  item.kind_icon = ' '
                end
                return items
              end,
              opts = {
                insert_command = true,
              },
            },
          },
        },
      }
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          local ok_copilot, copilot = pcall(require, 'copilot')
          if ok_copilot then
            require('copilot.suggestion').dismiss()
            vim.b.copilot_suggestion_hidden = true
            return
          end

          --[[ add matchup_matchparen here]]
          vim.b['matchup_matchparen_enabled'] = false
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          local ok_copilot, copilot = pcall(require, 'copilot')
          if ok_copilot then
            vim.b.copilot_suggestion_hidden = false
            return
          end
          --[[ add matchup_matchparen here]]
          vim.b['matchup_matchparen_enabled'] = true
        end,
      })
    end,
    opts_extend = { 'sources.default' },
  },
}

---[[VSCode-like smart indent]]

---@param cmp blink.cmp.API
---@return boolean | nil
-- local function smart_indent(cmp)
--   if cmp.snippet_active() then return cmp.accept() end
--
--   if cmp.is_visible() then return cmp.select_and_accept() end
--
--   if vim.b[vim.api.nvim_get_current_buf()].nes_state then
--     cmp.hide()
--     return require('copilot-lsp.nes').apply_pending_nes()
--   end
--
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   local ok, indent = pcall(require('nvim-treesitter.indent').get_indent, row)
--   if not ok then indent = 0 end
--
--   local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
--   if col < indent and line:sub(1, col):gsub('^%s+', '') == '' then
--     -- smart indent line vscode - indent to the correct level when
--     -- pressing tab at the beginning of a line.
--
--     vim.schedule(function()
--       vim.api.nvim_buf_set_lines(0, row - 1, row, true, {
--         string.rep(' ', indent or 0) .. line:sub(col),
--       })
--
--       vim.api.nvim_win_set_cursor(0, { row, math.max(0, indent) })
--     end)
--     return true
--     -- elseif col >= indent then
--     -- vim.schedule(require('tabout').taboutMulti)
--     -- return true
--   end
-- end

-- IntelliJ-like smart backspace
---@param cmp blink.cmp.API
---@return boolean | nil
-- local function smart_backspace(cmp)
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--
--   if row == 1 and col == 0 then return end
--
--   if cmp.is_visible() then cmp.hide() end
--
--   local ts = require('nvim-treesitter.indent')
--   local ok, indent = pcall(ts.get_indent, row)
--   if not ok then indent = 0 end
--
--   local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
--   if vim.fn.strcharpart(line, indent - 1, col - indent + 1):gsub('%s+', '') ~= '' then return end
--
--   if indent > 0 and col > indent then
--     local new_line = vim.fn.strcharpart(line, 0, indent) .. vim.fn.strcharpart(line, col)
--     vim.schedule(function()
--       vim.api.nvim_buf_set_lines(0, row - 1, row, true, {
--         new_line,
--       })
--       vim.api.nvim_win_set_cursor(0, { row, math.min(indent or 0, vim.fn.strcharlen(new_line)) })
--     end)
--     return true
--   elseif row > 1 and (indent > 0 and col + 1 > indent) then
--     local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, true)[1]
--     if vim.trim(prev_line) == '' then
--       local prev_indent = ts.get_indent(row - 1) or 0
--       local new_line = vim.fn.strcharpart(line, 0, prev_indent) .. vim.fn.strcharpart(line, col)
--       vim.schedule(function()
--         vim.api.nvim_buf_set_lines(0, row - 2, row, true, {
--           new_line,
--         })
--
--         vim.api.nvim_win_set_cursor(0, {
--           row - 1,
--           math.max(0, math.min(prev_indent, vim.fn.strcharlen(new_line))),
--         })
--       end)
--       return true
--     else
--       local len = vim.fn.strcharlen(prev_line)
--       local new_line = prev_line .. vim.fn.strcharpart(line, col)
--       vim.schedule(function()
--         vim.api.nvim_buf_set_lines(0, row - 2, row, true, {
--           new_line,
--         })
--         vim.api.nvim_win_set_cursor(0, { row - 1, math.max(0, len) })
--       end)
--       return true
--     end
--   end
-- end
