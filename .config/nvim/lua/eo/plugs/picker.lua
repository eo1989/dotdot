local border = eo.ui.current.border
local fn, ui, reqcall = vim.fn, eo.ui, eo.reqcall
local icons, lsp_hls = ui.icons, ui.lsp.highlights
local prompt = icons.misc.telescope or { ' ' .. '  ' } -- '' .. ' ' }

local fzf_lua = reqcall('fzf-lua') ---@module 'fzf-lua'
------------------------------------------------------------------------------------------------------------------------
-- FZF-LUA HELPERS
------------------------------------------------------------------------------------------------------------------------
local function format_title(str, icon, icon_hl)
  return {
    { ' ' },
    { (icon and icon .. ' ' or ''), icon_hl or 'DevIconDefault' },
    { str, 'Bold' },
    { ' ' },
  }
end

local file_picker = function(cwd) fzf_lua.files { cwd = cwd } end

local function git_files_cwd_aware(opts)
  opts = opts or {}
  local fzf = require('fzf-lua')
  -- git_root() will warn us if we're not inside a git repo
  -- so we don't have to add another warning here, if
  -- you want to avoid the error message change it to:
  local git_root = fzf.path.git_root(opts, true)
  -- local git_root = fzf_lua.path.git_root(opts, true)
  -- local git_root = fzf.path.git_root(opts)
  if not git_root then return fzf.files(opts) end
  local relative = fzf.path.relative(vim.uv.cwd(), git_root)
  opts.fzf_opts = { ['--query'] = git_root ~= relative and relative or nil }
  return fzf.git_files(opts)
end

local function dropdown(opts)
  opts = opts or { winopts = {} }
  local title = vim.tbl_get(opts, 'winopts', 'title') ---@type string?
  if title and type(title) == 'string' then opts.winopts.title = format_title(title) end
  return vim.tbl_deep_extend('force', {
    prompt = prompt,
    fzf_opts = { ['--layout'] = 'reverse' },
    winopts = {
      title_pos = opts.winopts.title and 'center' or nil,
      height = 0.7,
      width = 0.8,
      row = 0.1,
      -- preview = { hidden = 'hidden', layout = 'horizontal', horizontal = 'right:50%' },
      -- preview = { hidden = 'nohidden', layout = 'vertical', vertical = 'up:50%' },
      -- preview = { hidden = false, layout = 'horizontal', vertical = 'right:60%' },
      preview = { hidden = 'nohidden', layout = 'horizontal', horizontal = 'up:65%' },
    },
  }, opts)
end

local function cursor_dropdown(opts)
  return dropdown(vim.tbl_deep_extend('force', {
    winopts = {
      row = 1,
      relative = 'cursor',
      height = 0.35,
      width = 0.45,
    },
  }, opts))
end

local function list_sessions()
  local fzf = require('fzf-lua')
  local ok, persisted = eo.pcall(require, 'persisted')
  if not ok then return end
  local sessions = persisted.list()
  fzf.fzf_exec(
    vim.tbl_map(function(s) return s.name end, sessions),
    dropdown {
      winopts = { title = format_title('Sessions', '󰆔'), height = 0.33, row = 0.5 },
      previewer = false,
      actions = {
        ['default'] = function(selected)
          local session = vim.iter(sessions):find(function(s) return s.name == selected[1] end)
          if not session then return end
          persisted.load { session = session.file_path }
        end,
        ['ctrl-d'] = {
          function(selected)
            local session = vim.iter(sessions):find(function(s) return s.name == selected[1] end)
            if not session then return end
            fn.delete(vim.fn.expand(session.file_path))
          end,
          fzf.actions.resume,
        },
      },
    }
  )
end

eo.fzf = { dropdown = dropdown, cursor_dropdown = cursor_dropdown }
------------------------------------------------------------------------------------------------------------------------
-- believe it has to be loaded early on so lspconfig can check for it?

return {
  {
    'ibhagwan/fzf-lua',
    priority = 101,
    lazy = false,
    cmd = 'FzfLua',
    dependencies = {
      'nvim-web-devicons',
      'lspkind.nvim',
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter-context',
      'MeanderingProgrammer/render-markdown.nvim',
    },
    -- stylua: ignore start
    keys = {
      { '<C-p>',          fzf_lua.git_files,                            desc = 'find files' },
      { '<leader>fa',     '<Cmd>FzfLua<CR>',                            desc = 'builtins' },
      { '<leader>ff',     file_picker,                                  desc = 'find files' },
      { '<leader>fb',     fzf_lua.buffers,                              desc = 'buffers' },
      { '<leader>fs',     fzf_lua.grep_curbuf,                          desc = 'current buffer fuzzy find' },
      { '<leader>fvh',    fzf_lua.highlights,                           desc = 'highlights' },
      { '<leader>fvk',    fzf_lua.keymaps,                              desc = 'keymaps' },
      { '<leader>fva',    fzf_lua.autocmds,                             desc = 'autocommands' },
      { '<leader>file',   fzf_lua.diagnostics_workspace,                desc = 'workspace diagnostics' },
      { '<leader>fld',    fzf_lua.lsp_document_symbols,                 desc = 'document symbols' },
      { '<leader>fls',    fzf_lua.lsp_live_workspace_symbols,           desc = 'workspace symbols' },
      { '<leader>fh',     fzf_lua.help_tags,                            desc = 'help' },
      { '<leader>fgb',    fzf_lua.git_branches,                         desc = 'branches' },
      { '<leader>fgc',    fzf_lua.git_commits,                          desc = 'commits' },
      { '<leader>fgB',    fzf_lua.git_bcommits,                         desc = 'buffer commits' },
      { '<leader>fS',     fzf_lua.live_grep,                            desc = 'live grep' },
      { '<leader>fc',     function() file_picker(vim.g.nvim_dir) end,   desc = 'nvim config' },
    },
    -- { '<localleader>p', fzf_lua.registers,                            desc = 'Registers' },
    -- stylua: ignore end
    config = function()
      local devicon = require('nvim-web-devicons')
      local lsp_kind = require('lspkind')
      local fzf = require('fzf-lua')

      fzf.setup {
        prompt = prompt,
        fzf_opts = {
          ['--ansi'] = true,
          -- ['--info'] = 'default', -- hidden OR inline-right, fzf < 0.42 = 'inline'
          ['--reverse'] = true,
          ['--layout'] = 'default',
          ['--highlight-line'] = true, -- fzf >= 0.53
          ['--scrollbar'] = '▓',
          ['--ellipsis'] = icons.misc.ellipsis or '…',
        },
        -- fzf_colors = true,
        fzf_colors = {
          -- stylua: ignore start
          ['fg']        = { 'fg', 'CursorLine' },
          ['hl']        = { 'fg', 'Comment' },
          ['fg+']       = { 'fg', 'Normal' },
          ['hl+']       = { 'fg', 'Statement', 'italic' },
          ['info']      = { 'fg', 'Comment', 'italic' },
          ['prompt']    = { 'fg', 'Underlined' },
          ['pointer']   = { 'fg', 'Exception' },
          ['marker']    = { 'fg', '@character' },
          ['spinner']   = { 'fg', 'DiagnosticOk' },
          ['header']    = { 'fg', 'Comment' },
          ['separator'] = { 'fg', 'Comment' },
          ['bg']        = { 'bg', 'Normal' },
          ['bg+']       = { 'bg', 'PmenuSel' },
          ['gutter']    = { 'bg', 'Normal' },
          -- stylua: ignore end
        },
        previewers = {
          bat = {
            cmd = 'bat',
            -- args = '--color=always --style=numbers,changes,grid,snips,filename',
            args = '--color=always --style=numbers,snips',
            theme = 'Dracula',
          },
          builtin = {
            treesitter = {
              enabled = true,
              context = {
                max_lines = 0,
                -- trim_scope = 'inner',
              },
            },
            toggle_behavior = 'extend',
            extensions = {
              ['png'] = { 'chafa', '{file}' },
              ['svg'] = { 'chafa', '{file}' },
              ['jpg'] = { 'chafa', '{file}' },
            },
            render_markdown = {
              enabled = true,
              filetypes = {
                ['markdown'] = true,
                ['quarto'] = true,
              },
            },
          },
          codeaction = { diff_opts = { ctxlen = 3 } },
          codeaction_native = {
            diff_opts = { ctxlen = 3 },
            pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
          },
        },
        hls = {
          title = 'PickerTitle',
          border = 'PickerBorder',
          preview_border = 'PickerBorder',
        },

        -- winopts = {
        --   row = 1,
        --   relative = 'cursor',
        --   height = 0.33,
        --   width = 0.25,
        -- },
        winopts = {
          -- row = 1,
          -- relative = 'cursor',
          -- height = 0.33,
          -- width = 0.25,
          -- preview = { layout = 'horizontal' },
          -- treesitter = false,
          border = ui.current.border,
          on_create = function()
            vim.keymap.set('t', '<C-j>', '<Down>', { silent = true, buffer = true })
            vim.keymap.set('t', '<C-k>', '<Up>', { silent = true, buffer = true })
          end,
        },
        keymap = {
          -- stylua: ignore start
          builtin = {
            ['<M-g']     = 'preview-page-reset',
            ['<C-/>']    = 'toggle-help',
            ['<C-e>']    = 'toggle-preview',
            ['<C-=>']    = 'toggle-fullscreen',
            ['<C-d>']    = 'preview-page-down',
            ['<C-u>']    = 'preview-page-up',
            ['<ESC>']    = 'hide',
            ['<F5>']     = 'toggle-preview-ccw',
            ['<F6>']     = 'toggle-preview-cw',
            -- `ts-ctx` binds require `nvim-ts-context`
            ['<F7>']     = 'toggle-preview-ts-ctx',
            ['<F8>']     = 'preview-ts-ctx-dec',
            ['<F9>']     = 'preview-ts-ctx-inc',
          },
          fzf = {
            ['ctrl-q']   = 'select-all+accept',
            -- fzf '--bind=' options
            -- true,        -- uncomment to inherit all the below in your custom config
            ["ctrl-z"]      = "abort",
            ["ctrl-u"]      = "unix-line-discard",
            ["ctrl-f"]      = "half-page-down",
            ["ctrl-b"]      = "half-page-up",
            ["ctrl-a"]      = "beginning-of-line",
            ["ctrl-e"]      = "end-of-line",
            ["alt-a"]       = "toggle-all",
            ["alt-g"]       = "first",
            ["alt-G"]       = "last",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"]          = "toggle-preview-wrap",
            ["f4"]          = "toggle-preview",
            -- ["shift-down"]  = "preview-page-down",
            -- ["shift-up"]    = "preview-page-up",
          },
        },
        -- stylua: ignore end
        highlights = {
          winopts = { title = ' Highlights ' },
        },
        helptags = {
          winopts = {
            title = ' 󰋖 Help ',
          },
        },
        oldfiles = dropdown {
          cwd_only = true,
          winopts = { title = '   History ' },
        },
        files = dropdown {
          formatter = 'path.filename_first',
          winopts = { title = '   Files ' },
          -- actions = {
          --   -- inherits from 'actions.files'
          --   ['enter'] = actions.file_edit,
          --   ['ctrl-y'] = function(selected) print(selected[1]) end,
          -- },
        },
        buffers = dropdown {
          fzf_opts = { ['--delimiter'] = ' ', ['--with-nth'] = '-1..' },
          winopts = { title = ' 󰈙 Buffers ' },
        },
        keymaps = dropdown {
          winopts = { title = '   Keymaps ', width = 0.7 },
        },
        registers = cursor_dropdown {
          winopts = { title = '   Registers ', width = 0.6 },
        },
        grep = {
          prompt = '  ',
          winopts = {
            title = ' 󰈭 Grep ',
          },
          -- RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH
          rg_opts = '--column --hidden --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
          fzf_opts = {
            ['--keep-right'] = '',
          },
        },
        lsp = {
          cwd_only = true, -- ??
          symbols = {
            symbol_style = 1,
            symbol_icons = lsp_kind.symbol_map,
            -- symbol_icons = devicon.get_icons,
            symbol_hl = function(s) return lsp_hls[s] end,
          },
          code_actions = dropdown {
            winopts = {
              title = ' 󰌵 Code Actions ',
              '@type',
            },
          },
        },
        jumps = dropdown {
          winopts = { title = '   Jumps ', preview = { hidden = 'nohidden' } },
        },
        changes = dropdown {
          prompt = '',
          winopts = { title = ' ⟳ Changes ', preview = { hidden = 'nohidden' } },
        },
        diagnostics = dropdown {
          winopts = {
            title = '   Diagnostics ',
            'DiagnosticError',
          },
        },
        git = {
          files = dropdown {
            path_shorten = false, -- this doesn't use any clever strategy unlike telescope so is somewhat useless
            cmd = 'git ls-files --others --cached --exclude-standard',
            winopts = { title = '   Git Files ' },
          },
          branches = dropdown {
            winopts = { title = '  Branches ', height = 0.3, row = 0.4 },
          },
          status = {
            prompt = '',
            preview_pager = 'delta --width="$FZF_PREVIEW_COLUMNS"',
            winopts = { title = '   Git Status ' },
          },
          bcommits = {
            prompt = '',
            preview_pager = 'delta --width="$FZF_PREVIEW_COLUMNS"',
            winopts = { title = '  Buffer Commits ' },
          },
          commits = {
            prompt = '',
            preview_pager = 'delta --width="$FZF_PREVIEW_COLUMNS"',
            winopts = { title = '  Commits ' },
          },
          icons = {
            -- stylua: ignore start
            ['M'] = { icon = icons.git.mod,       color = 'yellow'  },
            ['D'] = { icon = icons.git.remove,    color = 'red'     },
            ['A'] = { icon = icons.git.staged,    color = 'green'   },
            ['R'] = { icon = icons.git.rename,    color = 'yellow'  },
            ['C'] = { icon = icons.git.conflict,  color = 'yellow'  },
            ['T'] = { icon = icons.git.mod,       color = 'magenta' },
            ['?'] = { icon = icons.git.untracked, color = 'magenta' },
            -- stylua: ignore end
          },
        },
        zoxide = dropdown {
          winopts = { title = ' 󱐋 Zoxide ' },
          cmd = 'zoxide query --list --score',
          formatter = 'path.dirname_first',
          fzf_opts = {
            -- stylua: ignore start
            ['--no-multi']  = true,
            ['--delimiter'] = '[\t]',
            ['--tabstop']   = '4',
            ['--tiebreak']  = 'end,index', -- prefers dirs ending with search term
            ['--nth']       = '2..', -- excl score from fuzzy matching
            -- stylua: ignore end
          },
          -- actions = { enter = actions.cd },
        },
      }
      eo.command('SessionList', list_sessions)
    end,
  },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    -- lazy = true,
    init = function()
      ---@diagnostic disable-next-line:duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line:duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
    opts = {
      -- input = { relative = 'win' }, -- 'cursor', 'win', 'editor'
      input = { enabled = false },
      select = {
        backend = { 'nui', 'fzf_lua', 'fzf', 'builtin' },
        trim_prompt = true,
        builtin = {
          border = border,
          min_height = 20,
          win_options = { winblend = 10 },
          mappings = { n = { ['q'] = 'Close', ['<ESC>'] = 'Close' } },
        },
        get_config = function(opts)
          opts.prompt = opts.prompt and opts.prompt:gsub(':', '')
          if opts.kind == 'codeaction' then
            -- return {
            --   backend = 'fzf_lua',
            --   fzf_lua = eo.fzf.cursor_dropdown {
            --     winopts = { title = opts.prompt },
            --   },
            -- }
            return {
              backend = 'nui',
              -- fzf_lua = eo.fzf.cursor_dropdown {
              --   winopts = { title = opts.prompt },
              -- },
              nui = {
                position = '95%',
                border = { style = border },
                min_height = 20,
                min_width = vim.o.columns - 2,
              },
            }
          end
          -- if opts.kind == 'orgmode' then
          --   return {
          --     backend = 'nui',
          --     nui = {
          --       position = '97%',
          --       border = { style = rect },
          --       min_width = vim.o.columns - 2,
          --     },
          --   }
          -- end
          return {
            backend = 'fzf_lua',
            fzf_lua = eo.fzf.dropdown {
              winopts = {
                title = opts.prompt,
                height = 0.45,
                row = 0.45,
                -- height = 0.50,
                -- row = 0.50,
              },
            },
          }
        end,
        nui = {
          min_height = 20,
          win_options = {
            winhighlight = table.concat({
              'Normal:Italic',
              'FloatBorder:PickerBorder',
              'FloatTitle:Title',
              'CursorLine:Visual',
            }, ','),
          },
        },
      },
    },
  },
}
