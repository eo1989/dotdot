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

local git_files_cwd_aware = function(opts)
  opts = opts or {}
  local fzf = require('fzf-lua')
  -- git_root() will warn us if we're not inside a git repo
  -- so we don't have to add another warning here, if
  -- you want to avoid the error message change it to:
  -- local git_root = fzf.path.git_root(opts, true)
  local git_root = fzf.path.git_root(opts)
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
      height = 0.75,
      width = 0.85,
      row = 0.2,
      preview = {
        hidden = 'nohidden',
        layout = 'vertical',
        flip_columns = 160,
        horizontal = 'right:75%',
        vertical = 'up:75%',
      },
    },
  }, opts)
end

local function cursor_dropdown(opts)
  return dropdown(vim.tbl_deep_extend('force', {
    winopts = {
      row = 1,
      relative = 'cursor',
      height = 0.40,
      width = 0.45,
    },
  }, opts))
end

-- local function list_sessions()
--   local fzf = require('fzf-lua')
--   local ok, persisted = eo.pcall(require, 'persisted')
--   if not ok then return end
--   local sessions = persisted.list()
--   fzf.fzf_exec(
--     vim.tbl_map(function(s) return s.name end, sessions),
--     dropdown {
--       winopts = { title = format_title('Sessions', '󰆔'), height = 0.33, row = 0.5 },
--       previewer = false,
--       actions = {
--         ['default'] = function(selected)
--           local session = vim.iter(sessions):find(function(s) return s.name == selected[1] end)
--           if not session then return end
--           persisted.load { session = session.file_path }
--         end,
--         ['ctrl-d'] = {
--           function(selected)
--             local session = vim.iter(sessions):find(function(s) return s.name == selected[1] end)
--             if not session then return end
--             fn.delete(vim.fn.expand(session.file_path))
--           end,
--           fzf.actions.resume,
--         },
--       },
--     }
--   )
-- end

eo.fzf = { dropdown = dropdown, cursor_dropdown = cursor_dropdown }
------------------------------------------------------------------------------------------------------------------------
-- believe it has to be loaded early on so lspconfig can check for it?

---@type LazySpec
return {
  {
    'ibhagwan/fzf-lua',
    enabled = false,
    -- priority = 151,
    lazy = false,
    cmd = 'FzfLua',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'onsails/lspkind.nvim' },
      { 'mfussenegger/nvim-dap' },
      {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = true,
        version = false,
        config = function()
          require('treesitter-context').setup {
            enable = true,
            max_lines = 3,
          }
          -- map('n', '[c', function() require('treesitter-context').go_to_context(vim.v.count1) end, { silent = true })
        end,
      },
      { 'MeanderingProgrammer/render-markdown.nvim' },
    },
    -- stylua: ignore start
    keys = {
      { '<C-p>',          function() fzf_lua.git_files_cwd_aware() end,             desc = 'find files' },
      { '<leader>fa',     '<Cmd>FzfLua<CR>',                                        desc = 'builtins' },
      { '<leader>ff',     file_picker,                                              desc = 'find files' },
      { '<leader>fb',     function() fzf_lua.buffers() end,                         desc = 'buffers' },
      -- { '<leader>fz',     function() fzf_lua.zoxide() end,                          desc = 'zoxide' },
      { '<leader>fs',     function() fzf_lua.grep_visual() end, mode = {'v', 'x'},  desc = 'search visual selection' },
      { '<leader>fs',     function() fzf_lua.grep_cword() end, mode = 'v',          desc = 'search word under cursor'},
      { '<leader>fS',     function() fzf_lua.live_grep() end,                       desc = 'live grep' },
      { '<leader>fvh',    function() fzf_lua.highlights() end,                      desc = 'highlights' },
      { '<leader>fvk',    function() fzf_lua.keymaps() end,                         desc = 'keymaps' },
      { '<leader>fva',    function() fzf_lua.autocmds() end,                        desc = 'autocommands' },
      -- { '<leader>fd',     function() fzf_lua.diagnostics_workspace() end,           desc = 'workspace diagnostics' },  -- typos: ignore
      { '<leader>fll',    function() fzf_lua.lsp_finder() end,                      desc = 'lsp finder' },
      { '<leader>fld',    function() fzf_lua.lsp_document_symbols() end,            desc = 'document symbols' },
      { '<leader>fls',    function() fzf_lua.lsp_live_workspace_symbols() end,      desc = 'workspace symbols' },
      { '<leader>fh',     function() fzf_lua.help_tags() end,                       desc = 'help' },
      { '<leader>fgb',    function() fzf_lua.git_branches() end,                    desc = 'branches' },
      { '<leader>fgc',    function() fzf_lua.git_commits() end,                     desc = 'commits' },
      { '<leader>fgB',    function() fzf_lua.git_bcommits() end,                    desc = 'buffer commits' },
      { '<leader>fc',     function() file_picker(vim.fn.stdpath("config")) end,     desc = 'nvim config' },
    },
    -- stylua: ignore end
    -- typos: ignore
    -- { '<leader>fs',     function() fzf_lua.grep_cword({word_match = "-w" }) end,  desc = 'search word under cursor'},
    -- { '<localleader>p', fzf_lua.registers,                            desc = 'Registers' },

    config = function()
      local devicon = require('nvim-web-devicons')
      local lsp_kind = require('lspkind')
      local fzf = require('fzf-lua')
      local actions = require('fzf-lua').actions

      fzf.setup {
        prompt = prompt,
        fzf_opts = {
          ['--ansi'] = true,
          -- ['--info'] = 'default', -- hidden OR inline-right, fzf < 0.42 = 'inline'
          ['--reverse'] = true,
          ['--layout'] = 'reverse',
          ['--highlight-line'] = true, -- fzf >= 0.53
          ['--scrollbar'] = '▓',
          ['--ellipsis'] = icons.misc.ellipsis or '…',
        },
        -- fzf_colors = true,
        -- stylua: ignore start
        fzf_colors = {
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
        },
        -- stylua: ignore end
        ---@type fzf-lua.config.Previewers
        previewers = {
          ---@type fzf-lua.previewer.Bat
          bat = {
            cmd = 'bat',
            -- args = '--color=always --style=numbers,changes,grid,snips,filename',
            args = '--color=always --style=filename',
            -- theme = 'Visual Studio Dark+',
            theme = 'Catppuccin Frappe',
          },
          builtin = {
            treesitter = {
              enabled = true,
              -- context = {
              --   max_lines = 1,
              --   trim_scope = 'inner',
              -- },
            },
            toggle_behavior = 'default',
            extensions = {
              ['png'] = { 'icat', '{file}' },
              ['svg'] = { 'timg' },
              ['jpg'] = { 'icat', '{file}' },
              -- ['jpg'] = { 'ueberzug' },
            },
            -- ext_ft_override = { ['qmd'] = 'md', ['jmd'] = 'md', ['rmd'] = 'md' },
            -- ext_ft_override = { ['jmd'] = 'md', ['rmd'] = 'md' },
            render_markdown = {
              enabled = true,
              filetypes = {
                ['markdown'] = true,
                ['quarto'] = true,
              },
            },
          },
        },
        hls = {
          title = 'PickerTitle',
          border = 'PickerBorder',
          preview_border = 'PickerBorder',
        },
        winopts = {
          -- height = 0.45,
          -- width = 0.45,
          preview = {
            -- hidden = 'nohidden',
            layout = 'flex',
            flip_columns = 160,
            horizontal = 'right:55%',
            vertical = 'down:45%',
          },
          treesitter = true,
          on_create = function()
            vim.keymap.set('t', '<C-n>', '<Down>', { silent = true, remap = false })
            vim.keymap.set('t', '<C-p>', '<Up>', { silent = true, remap = false })
          end,
        },
        keymap = {
          -- stylua: ignore start
          builtin = {
            ['<Esc>']       = 'abort',
            ['<M-g']        = 'preview-page-reset',
            ['<C-/>']       = 'toggle-help',
            ['<C-e>']       = 'toggle-preview',
            ['<C-=>']       = 'toggle-fullscreen',
            ["<M-Esc>"]     = "hide",
            ["<F3>"]        = "toggle-preview-wrap",
            ["<F4>"]        = "toggle-preview",
            ["<S-Left>"]    = "preview-reset",
            -- ["ctrl-down"]    = "preview-page-down",
            -- ["ctrl-up"]      = "preview-page-up",
            ['<C-d>']      = 'preview-page-down',
            ['<C-u>']      = 'preview-page-up',
            ['<F5>']        = 'toggle-preview-ccw',
            ['<F6>']        = 'toggle-preview-cw',
            -- `ts-ctx` binds require `nvim-ts-context`
            ['<F7>']        = 'toggle-preview-ts-ctx',
            ['<F8>']        = 'preview-ts-ctx-dec',
            ['<F9>']        = 'preview-ts-ctx-inc',
          },
          fzf = {
            ['ctrl-q']      = 'select-all+accept',
            -- ["ctrl-z"]      = "abort",
            ["ctrl-f"]      = "half-page-down",
            ["ctrl-b"]      = "half-page-up",
            ["ctrl-a"]      = "beginning-of-line",
            ["ctrl-e"]      = "end-of-line",
            -- ["ctrl-j"]      = 'Down',
            -- ["ctrl-k"]      = 'Up',
            ["alt-a"]       = "toggle-all",
            ["alt-g"]       = "first",
            ["alt-G"]       = "last",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["F3"]          = "toggle-preview-wrap",
            ["F4"]          = "toggle-preview",
            -- ["ctrl-d"]      = "preview-page-down",
            -- ["ctrl-u"]      = "preview-page-up",
            ["shift-down"]  = "preview-page-down",
            ["shift-up"]    = "preview-page-up",
          },
        },
        -- stylua: ignore end
        highlights = {
          winopts = { title = ' Highlights ' },
        },

        helptags = dropdown {
          winopts = {
            title = ' 󰋖 Help ',
            -- row = 0,
            -- col = 0.50,
            preview = {
              layout = 'flex',
              vertical = 'up:85%',
              horizontal = 'right:75%',
            },
          },
        },
        oldfiles = dropdown {
          cwd_only = false,
          winopts = { title = '   History ' },
        },
        files = dropdown {
          formatter = 'path.filename_first',
          winopts = { title = '   Files ' },
          actions = {
            -- inherits from 'actions.files'
            ['enter'] = actions.file_edit,
            ['ctrl-y'] = function(selected) print(selected[1]) end,
          },
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
          async_or_timeout = 500,
          cwd_only = true,
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
          -- previewer = 'codeaction_native',
          -- preview_pager = (
          --   'delta --side-by-side --width="$FZF_PREVIEW_COLUMNS"' .. "--hunk-header-style='omit' --file-style='omit' "
          -- ),
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
        -- zoxide = dropdown {
        --   winopts = { title = ' 󱐋 Zoxide ' },
        --   cmd = 'zoxide query --list --score',
        --   formatter = 'path.dirname_first',
        --   fzf_opts = {
        --     -- stylua: ignore start
        --     ['--no-multi']  = true,
        --     ['--delimiter'] = '[\t]',
        --     ['--tabstop']   = '4',
        --     ['--tiebreak']  = 'end,index', -- prefers dirs ending with search term
        --     ['--nth']       = '2..', -- excl score from fuzzy matching
        --     -- stylua: ignore end
        --   },
        --   -- actions = { enter = actions.cd },
        -- },
      }
      -- eo.command('SessionList', list_sessions)
    end,
  },
}
