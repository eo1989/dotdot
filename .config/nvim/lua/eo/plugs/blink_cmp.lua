local api, highlight, border = vim.api, eo.highlight, eo.ui.current.border

---VSCode-like smart indent

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

return {
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    build = ':Copilot auth',
    cmd = 'Copilot',
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        -- debounce = 250,
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
        -- ['*'] = false,
        julia = true,
        python = true,
        quarto = true,
        markdown = true,
        norg = false,
        gitcommit = false,
        -- ['dap-repl'] = false,
        ['FzfLua'] = false,
        -- DressingInput = false,
        -- TelescopePrompt = false,
        ['neo-tree-popup'] = false,
        -- NeogitCommitMessage = false,
      },
    },
  },
  {
    'saghen/blink.cmp',
    -- event = { 'InsertEnter', 'CmdlineEnter' },
    lazy = false,
    version = '1.*', -- looks like its required if you want the correct prebuilt binaries
    dependencies = {
      -- { 'onsails/lspkind.nvim' },
      -- { 'L3MON4D3/LuaSnip' },
      -- {
      --   'rafamadriz/friendly-snippets',
      --   -- event = { 'InsertEnter' },
      --   config = function()
      --     require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath('config') .. '/luasnippets' } }
      --   end,
      -- },
      { 'xzbdmw/colorful-menu.nvim' },
      { 'fang2hou/blink-copilot' },
      { 'erooke/blink-cmp-latex' },
      {
        'Kaiser-Yang/blink-cmp-git',
        ft = { 'octo', 'gitcommit', 'git' },
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    -- init = function()
    --   highlight.plugin('blink', {
    --     { BlinkCmpMenuBorder = { link = 'PickBorder' } },
    --     { BlinkCmpMenuBorder = { link = 'PickBorder' } },
    --     { BlinkCmpMenuBorder = { link = 'Normal' } },
    --   })
    -- end,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    -- opts = {
    config = function()
      local blink = require('blink-cmp')
      -- local luasnip = require('luasnip')
      -- local devicons = require('nvim-web-devicons')
      -- local lspkind = require('lspkind')
      -- local neotab = require('neotab')
      blink.setup {
        fuzzy = {
          implementation = 'rust',
          prebuilt_binaries = { download = true },
        },
        -- keymap = {
        --   preset = 'super-tab', -- "default" | "super-tab" (similar to vscode) | "enter" (supertab w/ enter to accept)
        --   -- ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        --   ['<Up>'] = { 'select_prev', 'fallback' },
        --   ['<Down>'] = { 'select_next', 'fallback' },
        --
        --   ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        --   ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        --   ['<Tab>'] = {
        --     function(cmp)
        --       if cmp.snippet_active() then
        --         cmp.accept()
        --         -- elseif cmp.is_active(1) then
        --         --   return cmp.select_and_accept()
        --         -- elseif luasnip.jumpable(1) then
        --         --   luasnip.jump(1)
        --       else
        --         return cmp.select_and_accept()
        --         -- neotab.tabout_luasnip()
        --       end
        --     end,
        --     'snippet_forward',
        --     'fallback',
        --   },
        --   ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        -- },
        appearance = {
          nerd_font_variant = 'normal',
          use_nvim_cmp_as_default = true,
        },
        -- snippets = {
        --   preset = 'luasnip',
        --   expand = function(snippet) luasnip.lsp_expand(snippet) end,
        --   active = function(filter)
        --     if filter and filter.direction then return luasnip.jumpable(filter.direction) end
        --     return luasnip.in_snippet()
        --   end,
        --   jump = function(direction) luasnip.jump(direction) end,
        -- },
        signature = {
          enabled = false,
          trigger = {
            show_on_insert = true,
            show_on_insert_on_trigger_character = true,
            -- show_on_accept = true,
            -- show_on_accept_on_trigger_character = true,
          },
          window = {
            border = 'none',
            max_width = 80,
            max_height = 6,
            direction_priority = { 's', 'n' },
            show_documentation = true, -- show larger documentation regular signature help
            winhighlight = 'Normal:ColorColumn',
          },
        },
        completion = {
          trigger = {
            show_on_trigger_character = true,
            show_on_insert = true,
            show_on_backspace_in_keyword = true,
            show_on_insert_on_trigger_character = true,
            show_in_snippet = false,
          },
          ghost_text = { show_with_menu = false },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 50,
            update_delay_ms = 50,
            treesitter_highlighting = true,
            window = { border = 'rounded' },
          },
          accept = {
            auto_brackets = {
              enabled = true,
              semantic_token_resolution = { enabled = true },
            },
          },
          -- list = {
          --   selection = {
          --     preselect = false or function(ctx) return not blink.snippet_active { direction = 1 } end,
          --     -- preselect = function(ctx) return not require('blink.cmp').snippet_active { direction = 1 } end,
          --     auto_insert = function(ctx) return ctx.mode == 'cmdline' and false or true end,
          --     -- auto_insert = false,
          --   },
          --   -- cycle = { from_top = false },
          -- },
          menu = {
            border = 'rounded',
            -- border = border,
            auto_show = true,
            draw = {
              treesitter = { 'lsp', 'copilot' },
              align_to = 'label', -- 'none' = disable | 'cursor' = align to cursor | 'label'
              padding = 0, -- { left, right }
              gap = 1, -- gap between columns
              columns = {
                { 'kind_icon' },
                { 'label', gap = 1 },
              },
              components = {
                label = {
                  text = function(ctx) return require('colorful-menu').blink_components_text(ctx) end,
                  highlight = function(ctx) return require('colorful-menu').blink_components_highlight(ctx) end,
                },
              },
            },
          },
        },
        cmdline = {
          enabled = true,
          completion = {
            -- list = {
            --   selection = {
            --     preselect = false,
            --     auto_insert = true,
            --   },
            -- },
            menu = { auto_show = true },
            ghost_text = { enabled = false },
          },
        },
        sources = {
          -- default = { 'lazydev', 'lsp', 'path', 'snippets', 'git', 'buffer', 'copilot' },
          -- default = { 'lazydev', 'lsp', 'path', 'snippets', 'git', 'copilot', 'markdown', 'latex_symbols' },
          default = { 'lsp', 'path', 'snippets', 'copilot', 'buffer' },
          per_filetype = {
            sql = { inherit_defaults = true, 'dadbod' },
            lua = { inherit_defaults = true, 'lazydev' },
            markdown = { inherit_defaults = true, 'markdown', 'latex' },
            quarto = { inherit_defaults = true, 'markdown', 'latex' },
            julia = { inherit_defaults = true, 'latex' },
            python = { inherit_defaults = true, 'latex' },
          },
          providers = {
            --[[https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugin-specs/blink-cmp.lua]]
            buffer = {
              max_items = 4,
              min_keyword_length = 4,
              -- with '-7', typing `then` in lua prioritizes the `then .. end` snippet, effectively
              -- acting as `nvim-endwise`.
              score_offset = -7,
            },
            dadbod = {
              module = 'vim_dadbod_completion.blink',
              score_offset = 90,
              enabled = function() return vim.tbl_contains({ 'sql', 'plsql', 'prql', 'mysql' }, vim.o.filetype) end,
            },
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              fallbacks = { 'lsp' },
              score_offset = 103,
            },
            git = {
              name = 'Git',
              module = 'blink-cmp-git',
              opts = {},
              enabled = function() return vim.tbl_contains({ 'octo', 'gitcommit', 'git' }, vim.bo.filetype) end,
            },
            lsp = {
              name = 'LSP',
              module = 'blink.cmp.sources.lsp',
              fallbacks = {}, -- dont use 'buffer' as fallback
              -- Filter text items from the LSP provider, since we have the buffer provider for that
              transform_items = function(_, items)
                -- for _, item in ipairs(items) do
                --   if item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
                --     item.score_offset = item.score_offset - 3
                --   end
                -- end
                return vim.tbl_filter(function(item)
                  return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
                  -- and item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
                end, items)
              end,
              --- NOTE: All of these options may be functions to get dynamic behavior
              --- See the type definitions for more information
              enabled = true, -- Whether or not to enable the provider
              async = false, -- Whether we should wait for the provider to return before showing the completions
              timeout_ms = 500, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
              -- transform_items = nil, -- Function to transform the items before they're returned
              should_show_items = true, -- Whether or not to show the items
              max_items = 30, -- Maximum number of items to display in the menu
              min_keyword_length = 1, -- Minimum number of characters in the keyword to trigger the provider
              -- If this provider returns 0 items, it will fallback to these providers.
              -- If multiple providers fallback to the same provider, all of the providers must return 0 items for it to fallback
              score_offset = 111, -- Boost/penalize the score of the items
              override = nil, -- Override the source's functions
            },
            path = {
              name = 'path',
              module = 'blink.cmp.sources.path',
              score_offset = -2,
              opts = {
                trailing_slash = true,
                label_trailing_slash = true,
                get_cwd = function(context) return vim.fn.expand(('#%d:p:h'):format(context.bufnr)) end,
                -- get_cwd = { vim.uv.cwd() },
                show_hidden_files_by_default = true,
              },
            },
            -- snippets = {
            --   name = 'snippets',
            --   module = 'blink.cmp.sources.snippets',
            --   opts = {
            --     -- Whether to use show_condition for filtering snippets
            --     use_show_condition = true,
            --     -- Whether to show autosnippets in the completion list
            --     show_autosnippets = false,
            --   },
            --   min_keyword_length = 1,
            --   score_offset = 97,
            -- },
            markdown = {
              name = 'RenderMarkdown',
              module = 'render-markdown.integ.blink',
              fallbacks = { 'lsp' },
              -- enabled = function() return vim.tbl_contains({ 'markdown', 'quarto' }, vim.o.filetype) end,
            },
            copilot = {
              name = 'Copilot',
              module = 'blink-copilot',
              score_offset = 69,
              deduplicate = { enabled = true },
              async = true,
              max_items = 2,
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
                  item.kind_icon = ''
                  item.kind_name = 'Copilot'
                end
                return items
              end,
            },
            latex = {
              name = 'Latex',
              module = 'blink-cmp-latex',
              -- score_offset = '+1',
              async = true,
              -- opts = {
              --   -- insert_command = true,
              --   insert_command = function(ctx)
              --     local ft = api.nvim_get_option_value('filetype', {
              --       scope = 'local',
              --       buf = ctx.bufnr,
              --     })
              --     -- NOTE: lol wtf is this
              --     if
              --       ft == 'markdown'
              --       or ft == 'quarto'
              --       or ft == 'latex'
              --       or ft == 'plantex'
              --       or ft == 'julia'
              --       or ft == 'python'
              --     then
              --       return true
              --     end
              --     return false
              --   end,
              -- },
            },
          },
        },
      }
      -- config = function(_, opts) require('blink-cmp').setup { opts } end,
      opts_extend = { 'sources.default' }
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          require('copilot.suggestion').dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function() vim.b.copilot_suggestion_hidden = false end,
      })
    end,
  },
}
