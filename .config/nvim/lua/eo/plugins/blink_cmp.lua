local map = map or vim.keymap.set
local defaults = require('defaults')
local api, highlight = vim.api, eo.highlight
local border = eo.ui.current.border or 'rounded'

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

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    local ok_copilot, copilot = pcall(require, 'copilot')
    if ok_copilot then
      require('copilot.suggestion').dismiss()
      vim.b.copilot_suggestion_hidden = true
    end
    vim.b['matchup_matchparen_enabled'] = false
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuClose',
  callback = function()
    local ok_copilot, copilot = pcall(require, 'copilot')
    if ok_copilot then vim.b.copilot_suggestion_hidden = false end
    vim.b['matchup_matchparen_enabled'] = true
  end,
})

---@type LazySpec
return {
  {
    ---@module 'blink-cmp'
    'saghen/blink.cmp',
    version = '1.*', -- looks like its required if you want the correct prebuilt binaries
    -- lazy = false,
    event = { 'InsertEnter', 'CmdlineEnter', 'VeryLazy' },
    dependencies = {
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      { 'rafamadriz/friendly-snippets' },
      { 'xzbdmw/colorful-menu.nvim' },
      { 'fang2hou/blink-copilot', enabled = true },
      {
        'saghen/blink.compat',
        version = '2.*',
        -- lazy = true,
        event = 'VeryLazy',
        opts = { impersonate_nvim_cmp = true, enable_events = true },
      },
      {
        'Kaiser-Yang/blink-cmp-git',
        lazy = true,
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      { 'kristijanhusak/vim-dadbod-completion' },
      -- { 'jmbuhr/cmp-pandoc-references' },
      { 'erooke/blink-cmp-latex' },
      { 'kdheepak/cmp-latex-symbols' },
    },
    ---@type blink.cmp.Config
    opts = {
      fuzzy = {
        implementation = 'prefer_rust',
        prebuilt_binaries = { download = true },
      },
      --[[ from:
         ~~https://github.com/hat0uma/dotfiles/blob/main/.config/nvim/lua/plugins/completion/blink.lua~~

         https://github.com/b0o/dotfiles/blob/main/config/nvim/lua/user/plugins/completion.lua
        --]]
      ---@type blink.cmp.KeymapConfig
      keymap = {
        preset = 'super-tab',
        -- ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        -- https://github.com/julienvincent/config.nvim/blob/6644fb3ed32ce8956b7652b74397e38298402c3c/lua/julienvincent/plugins/completion.lua#L38
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
          -- 'select_prev',
          'snippet_backward',
          'fallback',
        },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<D-i>'] = { function(cmp) cmp.show { providers = { 'copilot' } } end },
        ['<C-p>'] = { 'select_prev', 'show', 'fallback' },
        ['<C-n>'] = { 'show_and_insert', 'select_next', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      },
      ---@type blink.cmp.AppearanceConfig
      appearance = {
        nerd_font_variant = 'normal',
        -- use_nvim_cmp_as_default = true,
        kind_icons = defaults.icons.completion_items,
      },
      snippets = {
        preset = 'luasnip',
      },
      signature = {
        enabled = true,
        -- trigger = {
        --   enabled = true,
        --   show_on_insert = true,
        --   show_on_trigger_character = true,
        -- },
        window = {
          direction_priority = { 's', 'n' },
          border = border or 'rounded',
          treesitter_highlighting = true,
          -- show_documentation = true,
          winblend = 10,
        },
      },
      completion = {
        trigger = {
          -- show_on_trigger_character = true,
          -- show_on_insert_on_trigger_character = true,
          -- show_on_backspace_after_insert_enter = true,
          -- show_on_insert = true,
          -- prefetch_on_insert = false,
          show_in_snippet = false, -- messes with luasnip
          show_on_blocked_trigger_characters = { ' ', '\n', '\t', '$' },
        },
        ghost_text = {
          enabled = false,
          show_with_menu = false,
          show_without_selection = false,
          show_without_menu = false,
        },
        ---@type blink.cmp.CompletionDocumentationConfig
        documentation = {
          auto_show = true,
          treesitter_highlighting = true,
        },
        accept = {
          dot_repeat = false,
          auto_brackets = {
            enabled = true,
            semantic_token_resolution = { enabled = true },
          },
        },
        list = {
          selection = {
            preselect = function(ctx) return not require('blink.cmp').snippet_active { direction = 1 } or false end,
            -- preselect = false,
            -- auto_insert = function(ctx) return ctx.mode == 'cmdline' and false or true end,
            auto_insert = false,
          },
          cycle = { from_top = true, from_bottom = true },
        },
        ---@type blink.cmp.CompletionMenuConfig
        menu = {
          -- enabled = true,
          -- auto_show = true,
          ---@type blink.cmp.WindowBorder
          border = border,
          -- cmdline_position = function()
          --   if vim.g.ui_cmdline_pos ~= nil then
          --     local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
          --     return { pos[1] - 1, pos[2] }
          --   end
          --   local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          --   return { vim.o.lines - height, 0 }
          -- end,
          -- min_width = vim.go.pumwidth > 0 and vim.go.pumwidth or nil, ---@diagnostic disable-line: assign-type-mismatch
          -- max_height = vim.go.pumheight > 0 and vim.go.pumheight or nil, ---@diagnostic disable-line: assign-type-mismatch
          -- min_width = 40,
          -- max_height = 40,
          direction_priority = { 'n', 's' },
          -- direction_priority = function()
          --   local ctx = require('blink.cmp').get_context()
          --   local item = require('blink.cmp').get_selected_item()
          --   if ctx == nil or item == nil then return { 's', 'n' } end
          --   local item_next = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
          --   local is_multi_line = item_next:find('\n') ~= nil
          --
          --   -- after showing the menu upwards, maintain that direction
          --   -- until we re-open the menu, so store the context id in a global var
          --   if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
          --     vim.g.blink_cmp_upwards_ctx_id = ctx.id
          --     return { 'n', 's' }
          --   end
          --   return { 's', 'n' }
          -- end,
          ---@type blink.cmp.Draw
          draw = {
            treesitter = { 'lsp' },
            -- align_to = 'none', -- 'none' = disable, keep in place | 'cursor' = align to cursor | 'label'
            align_to = 'none', -- 'none' = disable, keep in place | 'cursor' = align to cursor | 'label'
            -- gap = 1, -- gap between columns
            columns = { { 'kind_icon' }, { 'label', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  local highlights_info = require('colorful-menu').blink_highlights(ctx)
                  if highlights_info ~= nil then
                    -- Or you want to add more item to label
                    return highlights_info.label
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require('colorful-menu').blink_highlights(ctx)
                  if highlights_info ~= nil then highlights = highlights_info.highlights end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                  end
                  return highlights
                end,
              },
            },
          },
        },
      },
      cmdline = { enabled = true },
      sources = {
        -- default = { 'lsp', 'snippets', 'path', 'buffer', 'latex' },
        default = { 'lsp', 'snippets', 'path', 'lazydev', 'git' },
        per_filetype = {
          codecompanion = { 'codecompanion' },
          sql = { inherit_defaults = true, 'dadbod' },
          -- lua = { inherit_defaults = true, 'lazydev' },
          snacks_input = { inherit_defaults = false },
          ['dap-repl'] = { 'omni' },
          julia = { inherit_defaults = true, 'latex_symbols' },
          markdown = { inherit_defaults = true, 'latex' },
          quarto = { inherit_defaults = true, 'latex' },
        },
        providers = {
          --[[https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugin-specs/blink-cmp.lua]]
          -- buffer = {
          --   -- with '-7', typing `then` in lua prioritizes the `then .. end` snippet, effectively
          --   -- acting as `nvim-endwise`.
          --   score_offset = -7,
          -- },
          dadbod = {
            name = 'dadbod',
            module = 'vim_dadbod_completion.blink',
            enabled = function() return vim.tbl_contains({ 'sql', 'plsql', 'prql', 'mysql' }, vim.bo.filetype) end,
          },
          lazydev = {
            name = 'lazydev',
            module = 'lazydev.integrations.blink',
            fallbacks = { 'lsp' },
            -- score_offset = 100,
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
          lsp = {
            name = 'lsp',
            module = 'blink.cmp.sources.lsp', -- this is required if you want to use the transform function below
            fallbacks = {},
            transform_items = function(ctx, items)
              local types = require('blink.cmp.types').CompletionItemKind --[[@as vim.lsp.protocol.CompletionItemKind]]
              local is_word_only = string.match(ctx.line, '^%s+%w+$')
              -- local ft = vim.bo[ctx.bufnr].filetype

              for _, item in ipairs(items) do
                if item.kind == types.Snippet then item.score_offset = (item.score_offset or 0) - 3 end
              end

              ---@param item blink.cmp.CompletionItem
              return vim.tbl_filter(function(item)
                if item.kind == types.Text or item.kind == types.Snippet or item.deprecated == true then
                  return false
                end

                if is_word_only and (item.kind == types.Function or item.kind == types.Variable) then return false end

                return item.kind ~= types.Keyword
              end, items)
            end,

            --[[ https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugin-specs/blink-cmp.lua ]]

            enabled = function()
              if vim.bo.ft ~= 'lua' then return true end

              -- prevent useless suggestsions when typing '--' (#region shit), but keep the useful `---@param;@return` stuff
              local col = api.nvim_win_get_cursor(0)[2]
              local charsBefore = api.nvim_get_current_line():sub(col - 2, col)
              local luadocButNotComment = not charsBefore:find('^%-%-?$') and not charsBefore:find('%s%-%-?')
              return luadocButNotComment
            end,
            -- async = false, -- Whether we should wait for the provider to return before showing the completions
            -- timeout_ms = 50, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
            -- should_show_items = true, -- Whether or not to show the items ??
            -- min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
            -- min_keyword_length = function(ctx) return ctx.trigger.initial_kind == 'manual' and 0 or 1 end,
            score_offset = 3, -- Boost/penalize the score of the items
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
            -- score_offset = 2,
            module = 'blink.cmp.sources.snippets',
            --- Disable the snippet provider after pressing trigger characters (i.e. ".")
            ---@param ctx blink.cmp.Context
            should_show_items = function(ctx) return ctx.trigger.initial_kind ~= 'trigger_character' end,
            opts = {
              use_show_condition = true,
              show_autosnippets = true,
              prefer_doc_trig = true,
              use_label_description = true,
            },
          },
          markdown = {
            name = 'RenderMarkdown',
            module = 'render-markdown.integ.blink',
            -- fallbacks = { 'lsp' },
            enabled = function()
              return vim.tbl_contains({ 'markdown', 'gitcommit', 'rmarkdown', 'quarto' }, vim.bo.filetype)
            end,
          },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = -3,
            deduplicate = { enabled = true },
            timeout_ms = 50,
            -- async = false,
            max_items = 3,
            opts = {
              max_completions = 3,
              max_attempts = 4,
              debounce = 250, ---@type integer | false
            },
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_icon = ''
              end
              return items
            end,
          },
          -- symbols = {
          --   name = 'symbols',
          --   module = 'blink.compat.source',
          --   enabled = function() return vim.tbl_contains({ 'julia', 'markdown', 'quarto' }, vim.bo.filetype) end,
          -- },

          -- references = {
          --   name = 'pandoc_references',
          --   module = 'cmp-pandoc-references.blink',
          --   score_offset = 2,
          --   enabled = function() return vim.tbl_contains({ 'markdown', 'quarto' }, vim.bo.filetype) end,
          -- },
          latex_symbols = {
            name = 'latex_symbols',
            module = 'blink.compat.source',
            enabled = function() return vim.tbl_contains({ 'julia' }, vim.bo.filetype) end,
            -- enabled = function(ctx)
            --   local ft = api.nvim_get_option_value('filetype', {
            --     scope = 'local',
            --     buf = ctx.bufnr,
            --   })
            --   if ft == 'julia' then
            --     return true
            --   elseif ft == 'tex' or ft == 'markdown' or ft == 'quarto' then
            --     return false
            --   end
            -- end,
            opts = {
              -- 0 => mixed, show cmd & insert symbol
              -- 1 => julia, show & insert the symbol
              -- 2 => latex, show & insert the cmd
              strategy = 1,
            },
          },
          latex = {
            name = 'latex',
            module = 'blink-cmp-latex',
            -- async = true,
            -- deduplicate = true,
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_icon = ' '
              end
              return items
            end,
            enabled = function() return vim.tbl_contains({ 'markdown', 'quarto', 'tex', 'latex' }, vim.bo.filetype) end,
            opts = {
              -- insert_command = true,
              insert_command = function(ctx)
                local ft = api.nvim_get_option_value('filetype', {
                  scope = 'local',
                  buf = ctx.bufnr,
                })
                if ft == 'tex' or ft == 'quarto' or ft == 'markdown' then
                  return true
                  -- elseif ft == 'julia' then
                  --   -- julia can use the actual unicode inside as code. so \sigma should be 𝜎
                  --   return false
                end
                -- return false
              end,
            },
          },
        },
      },
    },
    opts_extend = {
      'sources.default',
      'sources.per_filetype',
      'completion.menu.draw.treesitter',
    },
  },
  {
    'zbirenbaum/copilot.lua',
    enabled = true,
    version = false,
    event = 'InsertEnter',
    build = ':Copilot auth',
    -- cmd = 'Copilot',
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
        ['*'] = false,
        julia = true,
        r = true,
        help = false,
        lua = false,
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
        ['snacks-input'] = false,
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
      -- should_attach = function(_, bufname)
      --   if string.match(bufname, 'env') then return false end
      --   return true
      -- end,
    },
  },
  {
    'saghen/blink.indent',
    event = { 'VeryLazy' },
    opts = function()
      Snacks.toggle({
        name = 'Indent',
        get = function() return not require('blink.indent').is_enabled() end,
        set = function() require('blink.indent').enable(not require('blink.indent').is_enabled()) end,
      }):map('<localleader>uI')
      ---@type blink.indent.Config
      return {
        blocked = {
          buftype = defaults.ignored.buffer_types,
          filetypes = defaults.ignored.file_types,
        },
        static = {
          enabled = true,
        },
        scope = {
          enabled = true,
          -- char = '│',
          priority = 1024,
          -- highlights = { '' },
          underline = {
            enabled = false,
          },
        },
      }
    end,
  },
  {
    'saghen/blink.pairs',
    version = '*', -- required apparently
    lazy = false,
    dependencies = 'saghen/blink.download',
    -- build = 'cargo build --release',
    ---@module 'blink.pairs'
    ---@type blink.pairs.Config
    opts = {
      mappings = {
        enabled = true,
        cmdline = true,
        disabled_filetypes = {},
        pairs = {},
      },
      highlights = {
        enabled = true,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        cmdline = true,
        groups = {
          'BlinkPairsOrange',
          'BlinkPairsPurple',
          'BlinkPairsBlue',
        },
        unmatched_group = 'BlinkPairsUnmatched',
        matchparen = {
          enabled = true,
          cmdline = false,
          include_surrounding = true, -- default = true
          group = 'BlinkPairsMatchParen',
          priority = 250,
        },
      },
    },
  },
}
