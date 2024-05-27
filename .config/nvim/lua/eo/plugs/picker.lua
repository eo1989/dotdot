local fn, env, ui, reqcall = vim.fn, vim.env, eo.ui, eo.reqcall
local icons, lsp_hls = ui.icons, ui.lsp.highlights
local prompt = icons.misc.telescope .. '  '

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
  -- local git_root = fzf_lua.path.git_root(opts, true)
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
      height = 0.70,
      width = 0.50,
      row = 1,
      -- preview = { hidden = 'hidden', layout = 'horizontal', horizontal = 'right:50%' },
      preview = { hidden = 'hidden', layout = 'vertical', vertical = 'up:60%' },
      -- preview = { hidden = false, layout = 'horizontal', vertical = 'right:60%' },
      -- preview = { hidden = 'hidden', layout = 'horizontal', horizontal = 'up:60%' },
    },
  }, opts)
end

local function cursor_dropdown(opts)
  return dropdown(vim.tbl_deep_extend('force', {
    winopts = {
      row = 1,
      relative = 'cursor',
      height = 0.33,
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

return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<c-p>', git_files_cwd_aware, desc = 'find files' },
      { '<leader>fa', '<Cmd>FzfLua<CR>', desc = 'builtins' },
      { '<leader>ff', file_picker, desc = 'find files' },
      { '<leader>fb', fzf_lua.buffers, desc = 'buffers' },
      { '<leader>fs', fzf_lua.grep_curbuf, desc = 'current buffer fuzzy find' },
      -- { '<leader>fr', fzf_lua.resume, desc = 'resume picker' },
      { '<leader>fvh', fzf_lua.highlights, desc = 'highlights' },
      { '<leader>fvk', fzf_lua.keymaps, desc = 'keymaps' },
      { '<leader>fva', fzf_lua.autocmds, desc = 'autocommands' },
      { '<leader>fle', fzf_lua.diagnostics_workspace, desc = 'workspace diagnostics' },
      { '<leader>fld', fzf_lua.lsp_document_symbols, desc = 'document symbols' },
      { '<leader>fls', fzf_lua.lsp_live_workspace_symbols, desc = 'workspace symbols' },
      { '<leader>f?', fzf_lua.help_tags, desc = 'help' },
      { '<leader>fh', fzf_lua.oldfiles, desc = 'Most (f)recently used files' },
      { '<leader>fgb', fzf_lua.git_branches, desc = 'branches' },
      { '<leader>fgc', fzf_lua.git_commits, desc = 'commits' },
      { '<leader>fgB', fzf_lua.git_bcommits, desc = 'buffer commits' },
      -- { '<leader>fs', fzf_lua.live_grep, desc = 'live grep' },
      { '<localleader>p', fzf_lua.registers, desc = 'Registers' },
      -- { '<leader>fd', function() file_picker(vim.env.DOTFILES) end, desc = 'dotfiles' },
      { '<leader>fc', function() file_picker(vim.g.nvim_dir) end, desc = 'nvim config' },
      -- { '<leader>fO', function() file_picker(env.SYNC_DIR .. '/notes/org') end, desc = 'org files' },
      { '<leader>fN', function() file_picker(env.SYNC_DIR .. '/notes/neorg') end, desc = 'norg files' },
    },
    config = function()
      local lsp_kind = require('lspkind')
      local fzf = require('fzf-lua')

      fzf.setup {
        fzf_opts = {
          -- ['--ansi'] = '',
          ['--info'] = 'default', -- hidden OR inline:⏐
          ['--reverse'] = false,
          ['--layout'] = 'default',
          ['--scrollbar'] = '▓',
          ['--ellipsis'] = icons.misc.ellipsis,
        },
        fzf_colors = {
          -- stylua: ignore start
          ['fg']        = { 'fg', 'CursorLine' },
          ['bg']        = { 'bg', 'Normal' },
          ['hl']        = { 'fg', 'Comment' },
          ['fg+']       = { 'fg', 'Normal' },
          ['bg+']       = { 'bg', 'PmenuSel' },
          ['hl+']       = { 'fg', 'Statement', 'italic' },
          ['info']      = { 'fg', 'Comment', 'italic' },
          ['prompt']    = { 'fg', 'Underlined' },
          ['pointer']   = { 'fg', 'Exception' },
          ['marker']    = { 'fg', '@character' },
          ['spinner']   = { 'fg', 'DiagnosticOk' },
          ['header']    = { 'fg', 'Comment' },
          ['gutter']    = { 'bg', 'Normal' },
          ['separator'] = { 'fg', 'Comment' },
          -- stylua: ignore end
        },
        previewers = {
          bat = {
            cmd = 'bat',
            args = '--color=always --style=numbers,changes,grid,snips,filename',
            theme = 'Dracula',
          },
          builtin = {
            toggle_behavior = 'extend',
            extensions = {
              ['png'] = { 'timg' },
              ['svg'] = { 'icat' },
              ['jpg'] = { 'icat' },
            },
          },
        },
        winopts = {
          border = ui.border.rectangle,
          preview = { layout = 'flex' },
          -- hl = { border = 'PickerBorder', preview_border = 'PickerBorder' },
          -- hl = { border = 'PickerBorder' },
        },
        keymap = {
          -- stylua: ignore start
          builtin = {
            ['<A-left>'] = 'preview-page-reset',
            -- ['<F5>']     = 'toggle-preview-ccw',
            -- ['<F6>']     = 'toggle-preview-cw',
            ['<C-/>']    = 'toggle-help',
            ['<F5>']     = 'toggle-preview',
            ['<C-=>']    = 'toggle-fullscreen',
            ['<C-d>']    = 'preview-page-down',
            ['<C-u>']    = 'preview-page-up',
            ['ESC']    = 'abort',
          },
          fzf = {
            ['ESC']    = 'abort',
            -- ['<F5>']     = 'toggle-preview',
            ['ctrl-q']   = 'select-all+accept',
          },
        },
        -- stylua: ignore end
        highlights = {
          prompt = prompt,
          winopts = { title = format_title('Highlights') },
        },
        helptags = {
          prompt = prompt,
          winopts = {
            title = format_title('Help', '󰋖'),
            preview = { layout = 'flex' },
          },
        },
        oldfiles = dropdown {
          cwd_only = true,
          winopts = { title = format_title('History', ' ') },
        },
        files = dropdown {
          winopts = {
            title = format_title('Files', ' '),
            -- preview= { layout = 'flex' },
          },
          -- fzf_opts = { formatter = "path.filename_first" },
        },
        buffers = dropdown {
          winopts = {
            title = format_title('Buffers', '󰈙 '),
            -- preview= { layout = 'flex' },
          },
          fzf_opts = { ['--delimiter'] = ' ', ['--with-nth'] = '-2..' },
        },
        keymaps = dropdown {
          winopts = { title = format_title('Keymaps', ' '), width = 0.7 },
        },
        registers = cursor_dropdown {
          winopts = { title = format_title('Registers', ' '), width = 0.6 },
        },
        grep = {
          prompt = ' ',
          winopts = {
            title = format_title('Grep', '󰈭 '),
            -- preview= { layout = 'flex' },
          },
          fzf_opts = {
            ['--keep-right'] = '',
          },
        },
        lsp = {
          cwd_only = true,
          symbols = {
            symbol_style = 1,
            symbol_icons = lsp_kind.symbols,
            symbol_hl = function(s) return lsp_hls[s] end,
          },
          code_actions = cursor_dropdown {
            winopts = {
              title = format_title('Code Actions', '󰌵', '@type'),
              -- preview= { layout = 'flex' },
            },
          },
        },
        jumps = dropdown {
          winopts = { title = format_title('Jumps', ''), preview = { hidden = 'nohidden' } },
        },
        changes = dropdown {
          prompt = '',
          winopts = { title = format_title('Changes', '⟳'), preview = { hidden = 'nohidden' } },
        },
        diagnostics = dropdown {
          winopts = {
            title = format_title('Diagnostics', ' ', 'DiagnosticError'),
            -- preview= { layout = 'flex' },
          },
        },
        git = {
          files = dropdown {
            path_shorten = false, -- this doesn't use any clever strategy unlike telescope so is somewhat useless
            cmd = 'git ls-files --others --cached --exclude-standard',
            winopts = { title = format_title('Git Files', ' ') },
          },
          branches = dropdown {
            winopts = { title = format_title('Branches', ''), height = 0.3, row = 0.4 },
          },
          status = {
            prompt = '',
            preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
            winopts = { title = format_title('Git Status', ' ') },
          },
          bcommits = {
            prompt = '',
            preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
            winopts = { title = format_title('', 'Buffer Commits') },
          },
          commits = {
            prompt = '',
            preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
            winopts = { title = format_title('', 'Commits') },
          },
          icons = {
            ['M'] = { icon = icons.git.mod, color = 'yellow' },
            ['D'] = { icon = icons.git.remove, color = 'red' },
            ['A'] = { icon = icons.git.staged, color = 'green' },
            ['R'] = { icon = icons.git.rename, color = 'yellow' },
            ['C'] = { icon = icons.git.conflict, color = 'yellow' },
            ['T'] = { icon = icons.git.mod, color = 'magenta' },
            ['?'] = { icon = icons.git.untracked, color = 'magenta' },
          },
        },
      }

      eo.command('SessionList', list_sessions)
    end,
  },
}
