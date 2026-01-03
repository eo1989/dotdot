-- local map = vim.keymap.set
local defaults = require('defaults')
local api, highlight, border = vim.api, eo.highlight, 'rounded' or eo.ui.current.border or defaults.ui.border.chars

---@param source string
---@return boolean
local is_ai_source = function(source) return vim.tbl_contains(vim.tbl_keys(defaults.ai.sources), source:lower()) end

-- emacs behavior attempt

local function has_words_before()
  local col = api.nvim_win_get_cursor(0)[2]
  if col == 0 then return false end
  local line = api.nvim_get_current_line()
  return line:sub(col, col):match('%s') == nil
end

local t = function(str) return api.nvim_replace_termcodes(str, true, true, true) end

---PENDING https://github.com/Saghen/blink.cmp/issues/743
---Choice snippets[^1] work with blink, but leave you with a completion via
---vim's popupmenu, for which blink does not provide mappings, thus requiring
---this function
---[^1]: https://code.visualstudio.com/docs/editing/userdefinedsnippets#_choice
---@param action "next"|"prev"|"select"|"select_and_snippet_forward"
---@return boolean success (popupmenu was open)
-- local function vimPopupmenu(action)
--   if vim.fn.pumvisible() == 0 then
--     -- false -> attempt next command in blink.cmp
--     return false
--   end
--
--   --[[NOTE: This activates vims shitty ins-completion popup that interrupts blink...]]

--   -- https://neovim.io/doc/user/insert.html#_insert-completion-popup-menu
--   local key
--   if action == 'next' then key = '<C-n>' end
--   if action == 'prev' then key = '<C-p>' end
--   if action:find('select') then key = '<C-y>' end
--
--   -- `feedkey` needed to send keys from insert mode
--   local feedkey = api.nvim_replace_termcodes(key, true, false, true)
--   api.nvim_feedkeys(feedkey, 'n', false)
--
--   return true -- `true` -> dont attempt next command in blink.cmp
-- end

---@type LazySpec[]
return {
  {
    ---@module 'blink.cmp'
    'saghen/blink.cmp',
    version = '1.*', -- looks like its required if you want the correct prebuilt binaries
    -- event = { 'VeryLazy' },
    lazy = false,
    dependencies = {
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      { 'rafamadriz/friendly-snippets' },
      { 'xzbdmw/colorful-menu.nvim' },
      -- { 'fang2hou/blink-copilot', enabled = false },
      -- { 'erooke/blink-cmp-latex', ft = { 'quarto', 'markdown', 'julia', 'r', 'rmd' } },
      { 'erooke/blink-cmp-latex' },
      {
        'saghen/blink.compat',
        event = { 'InsertEnter' },
        enabled = true,
        opts = { impersonate_nvim_cmp = true, enable_events = true },
      },
      {
        'Kaiser-Yang/blink-cmp-git',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      -- { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
      -- { 'jmbuhr/cmp-pandoc-references', ft = { 'quarto', 'markdown', 'rmarkdown' } },
      { 'kristijanhusak/vim-dadbod-completion' },
      { 'jmbuhr/cmp-pandoc-references' },
      { 'kdheepak/cmp-latex-symbols' },
    },
    ---@type blink.cmp.Config
    opts = {},
    config = function(_, opts)
      local blink = require('blink.cmp')

      blink.setup {
        fuzzy = {
          implementation = 'prefer_rust',
          prebuilt_binaries = { download = true },
        },
        --[[ from:
        -- https://github.com/hat0uma/dotfiles/blob/main/.config/nvim/lua/plugins/completion/blink.lua
        --]]
        ---@type blink.cmp.KeymapConfig
        keymap = {
          -- preset = 'none',
          -- preset = 'super-tab',
          ['<Tab>'] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            'snippet_forward',
            'fallback',
          },
          ['<S-Tab>'] = {
            'snippet_backward',
            'fallback',
          },
          ['<C-j>'] = { 'select_next', 'fallback' },
          ['<C-k>'] = { 'select_prev', 'fallback' },
          -- ['<C-n>'] = {
          --   function(cmp)
          --     if cmp.snippet_active() then
          --       return cmp.accept()
          --     else
          --       return cmp.select_and_accept()
          --     end
          --   end,
          --   'snippet_forward',
          --   'fallback',
          -- },
          ['<C-Space>'] = {
            function(cmp)
              if cmp.is_visible() then
                return cmp.hide()
              else
                return cmp.show()
              end
            end,
          },
          ['<CR>'] = {
            function(cmp)
              if vim.api.nvim_get_mode().mode == 'c' then return end
              return cmp.accept()
            end,
            'fallback',
          },
          ['<C-e>'] = { 'cancel', 'fallback' },

          ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

          ['<C-f>'] = { 'snippet_forward', 'fallback' },
          ['<C-b>'] = { 'snippet_backward', 'fallback' },

          -- ['<Up>'] = { 'select_prev', 'fallback' },
          -- ['<Down>'] = { 'select_next', 'fallback' },
        },
        ---@type blink.cmp.AppearanceConfig
        appearance = {
          nerd_font_variant = 'normal',
          -- kind_icons = defaults.icons.completion_items or require('lspkind').symbol_map,
          use_nvim_cmp_as_default = true,
        },
        snippets = {
          preset = 'luasnip',
          expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
          active = function(filter)
            if filter and filter.direction then return require('luasnip').jumpable(filter.direction) end
            return require('luasnip').in_snippet()
          end,
          jump = function(direction) require('luasnip').jump(direction) end,
        },
        signature = {
          enabled = true,
          trigger = {
            enabled = true,
            show_on_insert = true,
            show_on_trigger_character = true,
          },
          window = {
            direction_priority = { 's', 'n' },
            border = border,
            treesitter_highlighting = true,
            show_documentation = true,
            -- max_width = 60,
            -- min_width = vim.go.pumwidth,
            -- max_height = vim.go.pumheight,
            winblend = 10,
          },
        },
        completion = {
          trigger = {
            show_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
            show_on_backspace_after_insert_enter = true,
            show_on_insert = true,
            prefetch_on_insert = false,
            show_in_snippet = false, -- messes with luasnip
          },
          ghost_text = { show_with_menu = false },
          ---@type blink.cmp.CompletionDocumentationConfig
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 20,
            update_delay_ms = 50,
            treesitter_highlighting = true,
            -- window = { border = border },
          },
          accept = {
            auto_brackets = {
              enabled = true, -- let autopairs do it
              semantic_token_resolution = { enabled = true },
            },
          },
          list = {
            selection = {
              preselect = function(ctx) return not require('blink.cmp').snippet_active { direction = 1 } or false end,
              -- preselect = false,
              auto_insert = function(ctx) return ctx.mode == 'cmdline' and false or true end,
            },
          },
          ---@type blink.cmp.CompletionMenuConfig
          menu = {
            enabled = true,
            auto_show = true,
            ---@type blink.cmp.WindowBorder
            border = border,
            cmdline_position = function()
              if vim.g.ui_cmdline_pos ~= nil then
                local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                return { pos[1] - 1, pos[2] }
              end
              local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
              return { vim.o.lines - height, 0 }
            end,
            min_width = vim.go.pumwidth > 0 and vim.go.pumwidth or nil, ---@diagnostic disable-line: assign-type-mismatch
            max_height = vim.go.pumheight > 0 and vim.go.pumheight or nil, ---@diagnostic disable-line: assign-type-mismatch
            ---@type blink.cmp.Draw
            draw = {
              treesitter = { 'lsp' },
              align_to = 'none', -- 'none' = disable, keep in place | 'cursor' = align to cursor | 'label'
              -- padding = { 1, 1 },
              gap = 1, -- gap between columns
              -- columns = { { 'kind_icon' }, { 'label', gap = 1 }, { 'source_name' } },
              columns = { { 'kind_icon' }, { 'label', gap = 1 } },
              components = {
                label = {
                  ---@param ctx blink.cmp.DrawItemContext
                  text = function(ctx)
                    local highlights_info = require('colorful-menu').blink_highlights(ctx)
                    if highlights_info ~= nil then
                      -- Or you want to add more item to label
                      return highlights_info.label
                    else
                      return ctx.label
                    end
                    -- return require('colorful-menu').blink_components_text(ctx)
                  end,
                  width = { fill = false },
                  ---@param ctx blink.cmp.DrawItemContext
                  highlight = function(ctx)
                    local highlights = {}

                    local highlights_info = require('colorful-menu').blink_highlights(ctx)
                    -- return require('colorful-menu').blink_components_highlight(ctx)

                    if highlights_info ~= nil then highlights = highlights_info.highlights end

                    for _, idx in ipairs(ctx.label_matched_indices) do
                      table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                    end

                    return highlights
                  end,
                },
                kind_icon = {
                  ---@param ctx blink.cmp.DrawItemContext
                  text = function(ctx)
                    if api.nvim_get_mode().mode == 'c' then return '' end

                    return defaults.icons.completion_items[ctx.item.source_name]
                      or defaults.icons.completion_items[ctx.kind]
                  end,
                  ---@param ctx blink.cmp.DrawItemContext
                  -- highlight = function(ctx)
                  --   return is_ai_source(ctx.item.source_name) and 'CmpItemKind'
                  --     -- or select(2, require('lspkind').presets.codicons(ctx.kind))
                  --     or select(2, require('lspkind').symbolic(ctx.kind))
                  -- end,
                  highlight = function(ctx) return 'CmpItemKind' .. (ctx.kind or 'Default') end,
                  -- highlight = function(ctx) return 'BlinkCmpItemKind' .. (ctx.kind or 'Default') end,
                },
                kind = {
                  ---@param ctx blink.cmp.DrawItemContext
                  highlight = function(ctx)
                    return is_ai_source(ctx.item.source_name) and 'BlinkCmpKindSnippet' or 'BlinkCmpKind' .. ctx.kind
                  end,
                  ---@param ctx blink.cmp.DrawItemContext
                  text = function(ctx) return is_ai_source(ctx.item.source_name) and ctx.item.source_name or ctx.kind end,
                },
                -- source_name = {
                --   width = { max = 60, fill = false },
                --   text = function(ctx)
                --     if ctx.item.source_id == 'lsp' then
                --       local client = vim.lsp.get_client_by_id(ctx.item.client_id)
                --       if client ~= nil then return string.format('[%s]', client.name) end
                --     end
                --     return ctx.source_name
                --   end,
                -- },
              },
            },
          },
        },
        cmdline = {
          enabled = true,
          completion = {
            ghost_text = { enabled = false },
            list = { selection = { preselect = false } },
            menu = { auto_show = true },
          },
          keymap = {
            ['<CR>'] = { 'accept', 'fallback' },
            ['<Tab>'] = { 'show_and_insert', 'select_next' },
            ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },

            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            -- ['<C-p>'] = { 'select_prev', 'fallback' },
            -- ['<C-n>'] = { 'select_next', 'fallback' },

            -- ['<C-f>'] = { 'snippet_forward', 'fallback' },
            -- ['<C-b>'] = { 'snippet_backward', 'fallback' },

            -- ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            -- ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          },
        },
        ---@type blink.cmp.SourceConfig
        sources = {
          -- default = { 'lsp', 'snippets', 'path', 'buffer', 'git', 'latex', 'references' },
          default = { 'lsp', 'snippets', 'path', 'buffer' },
          per_filetype = {
            codecompanion = { 'codecompanion' },
            sql = { inherit_defaults = true, 'dadbod' },
            lua = { inherit_defaults = true, 'lazydev' },
            snacks_input = {},
            markdown = { inherit_defaults = true, 'latex', 'references', 'symbols' },
            quarto = { inherit_defaults = true, 'latex', 'references', 'symbols' },
            julia = { inherit_defaults = true, 'latex', 'symbols' },
          },
          providers = {
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
              enabled = function() return vim.tbl_contains({ 'sql', 'plsql', 'prql', 'mysql' }, vim.bo.filetype) end,
            },
            lazydev = {
              name = 'lazydev',
              module = 'lazydev.integrations.blink',
              score_offset = 100,
            },
            git = {
              name = 'git',
              module = 'blink-cmp-git',
              opts = {},
              enabled = function()
                return vim.tbl_contains(
                  { 'octo', 'gitcommit', 'git', 'NeogitCommitMessage', 'gitrebase' },
                  vim.bo.filetype
                )
              end,
            },
            references = {
              name = 'references',
              module = 'cmp-pandoc-references.blink',
              score_offset = 2,
            },
            lsp = {
              name = 'LSP',
              module = 'blink.cmp.sources.lsp', -- this is required if you want to use the transform function below
              -- Filter text items from the LSP provider, since we have the buffer provider for that
              -- transform_items = function(_, items)
              --   return vim.tbl_filter(function(item)
              --     return {
              --       --[[ 1 = 'text', 14 = 'keyword', 15 = 'snippet' ]]
              --       item.kind ~= require('blink.cmp.types').CompletionItemKind[1]
              --         and (item.kind ~= require('blink.cmp.types').CompletionItemKind[14]),
              --     }
              --   end, items)
              -- end,
              --[[ https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugin-specs/blink-cmp.lua ]]

              enabled = function()
                if vim.bo.ft ~= 'lua' then return true end

                -- prevent useless suggestsions when typing '--' (#region shit), but keep the useful `---@param;@return` stuff
                local col = api.nvim_win_get_cursor(0)[2]
                local charsBefore = api.nvim_get_current_line():sub(col - 2, col)
                local luadocButNotComment = not charsBefore:find('^%-%-?$') and not charsBefore:find('%s%-%-?')
                return luadocButNotComment
              end,
              async = true, -- Whether we should wait for the provider to return before showing the completions
              timeout_ms = 50, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
              should_show_items = true, -- Whether or not to show the items ??
              min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
              score_offset = 10, -- Boost/penalize the score of the items
              --[[ below is from:
              -- https://github.com/hat0uma/dotfiles/blob/main/.config/nvim/lua/plugins/completion/blink.lua
              --]]
              override = {
                get_trigger_characters = function(self)
                  local trigger_characters = self:get_trigger_characters()
                  vim.list_extend(trigger_characters, { '\n', '\t', ' ' })
                  return trigger_characters
                end,
              },
            },
            path = {
              name = 'path',
              module = 'blink.cmp.sources.path',
              score_offset = 3,
              opts = {
                trailing_slash = true,
                label_trailing_slash = true,
                show_hidden_files_by_default = true,
                ignore_root_slash = false,
              },
            },
            snippets = {
              name = 'snippets',
              -- score_offset = 11,
              module = 'blink.cmp.sources.snippets',
              --- Disable the snippet provider after pressing trigger characters (i.e. ".")
              ---@param ctx blink.cmp.Context
              -- should_show_items = function(ctx) return ctx.trigger.initial_kind ~= 'trigger_character' end,
              opts = {
                use_show_condition = true,
                show_autosnippets = true,
                prefer_doc_trig = false,
              },
            },
            markdown = {
              name = 'RenderMarkdown',
              module = 'render-markdown.integ.blink',
              fallbacks = { 'lsp' },
              enabled = function() return vim.tbl_contains({ 'markdown', 'gitcommit', 'rmarkdown' }, vim.bo.filetype) end,
            },
            copilot = {
              name = 'copilot',
              module = 'blink-copilot',
              score_offset = -3,
              deduplicate = { enabled = true },
              timeout_ms = 50,
              async = true,
              max_items = 3,
              opts = {
                max_completions = 3,
                max_attempts = 4,
                debounce = 250, ---@type integer | false
              },
              transform_items = function(ctx, items)
                for _, item in ipairs(items) do
                  item.kind_icon = ' '
                end
                return items
              end,
            },
            symbols = { name = 'symbols', module = 'blink.compat.source' },
            latex = {
              name = 'latex',
              module = 'blink-cmp-latex',
              async = true,
              -- deduplicate = true,
              transform_items = function(ctx, items)
                for _, item in ipairs(items) do
                  item.kind_icon = ' '
                end
                return items
              end,
              opts = {
                insert_command = true,
                -- insert_command = function(ctx)
                --   local ft = api.nvim_get_option_value('filetype', {
                --     -- scope = 'local',
                --     buf = ctx.bufnr,
                --   })
                --   if ft == 'tex' or ft == 'quarto' or ft == 'markdown' or ft == 'julia' or ft == 'latex' then
                --     return true
                --   end
                --   return false
                -- end,
              },
            },
          },
          --[[ https://github.com/dsully/nvim/blob/abb92a6ba7735619f02170827ada776be719a0f5/lua/plugins/blink.lua#L259 ]]
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          transform_items = function(ctx, items)
            local types = require('blink.cmp.types').CompletionItemKind
            local is_word_only = string.match(ctx.line, '^%s+%w+$')
            local ft = vim.bo[ctx.bufnr].filetype

            -- sort snippets lower
            for _, item in ipairs(items) do
              if item.kind == types.Snippet then item.score_offset = (item.score_offset or 0) - 3 end
            end

            -- if ft == 'latex' or ft == 'julia' or ft == 'markdown' or ft == 'quarto' then
            --   for _, item in ipairs(items) do
            --     item.kind_icon = ' '
            --   end
            -- end

            ---@param item blink.cmp.CompletionItem
            return vim.tbl_filter(function(item)
              if item.kind == types.Text or item.kind == types.Snippet or item.deprecated then return false end

              if is_word_only and (item.kind == types.Function or item.kind == types.Variable) then return false end

              if ft == 'rust' then
                local data = item.data --[[@as RustData]]

                -- only filter out imported methods
                if data == nil or #data.imports == 0 or item.kind ~= types.Method then return true end

                for _, to_be_imported in ipairs(data.imports) do
                  for _, unwanted_prefix in ipairs { 'owo_colors' } do
                    if vim.startswith(to_be_imported.full_import_path, unwanted_prefix) then return false end
                  end
                end
              end
              return true
            end, items)
          end,
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
    opts_extend = {
      'sources.default',
      'sources.per_filetype',
      'completion.menu.draw.treesitter',
    },
  },
  {
    ---@module "copilot"
    'zbirenbaum/copilot.lua',
    enabled = false,
    event = 'InsertEnter',
    build = ':Copilot auth',
    cmd = 'Copilot',
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = false,
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
          if string.match(vim.fs.basename(api.nvim_buf_get_name(0)), '^%.env.*') then
            -- disable copilot for .env files
            return false
          end
          return true
        end,
        ['.'] = false,
      },
      server_opts_overrides = {
        settings = {
          telemetry = { telemetryLevel = 'off' },
        },
      },
      should_attach = function(_, bufname)
        if string.match(bufname, 'env') then return false end
        return true
      end,
    },
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
