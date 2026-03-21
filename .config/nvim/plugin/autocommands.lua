if not eo then return end

local api, cmd, env, fn, fmt, v = vim.api, vim.cmd, vim.env, vim.fn, string.format, vim.v
-- local map = map or vim.keymap.set

vim.keymap.set({ 'n', 'v', 'o', 'i', 'c' }, '<Plug>(StopHL)', 'execute("nohlsearch")[-1]', { expr = true })

local function stop_hl()
  if v.hlsearch == 0 or api.nvim_get_mode().mode ~= 'n' then return end
  api.nvim_feedkeys(vim.keycode('<Plug>(StopHL)'), 'm', false)
end

local function hl_search()
  local col = api.nvim_win_get_cursor(0)[2]
  local curr_line = api.nvim_get_current_line()
  local ok, match = pcall(fn.matchstrpos, curr_line, fn.getreg('/'), 0)
  if not ok then return end
  local _, p_start, p_end = unpack(match)
  -- if the cursor is in a search result, leave highlighting on
  if col < p_start or col > p_end then stop_hl() end
end

eo.augroup('VimrcIncSearchHighlight', {
  event = { 'CursorMoved' },
  command = function() hl_search() end,
}, {
  event = { 'InsertEnter' },
  command = function() stop_hl() end,
}, {
  event = { 'OptionSet' },
  pattern = { 'hlsearch' },
  command = function()
    vim.schedule(function() cmd.redrawstatus() end)
  end,
}, {
  event = 'RecordingEnter',
  command = function() vim.o.hlsearch = false end,
}, {
  event = 'RecordingLeave',
  command = function() vim.o.hlsearch = true end,
}, {
  event = 'BufEnter',
  command = function() vim.opt.formatoptions:remove { 'c', 'r', 'o' } end,
  desc = 'Disable new line comment',
})

local smart_close_filetypes = eo.p_table {
  ['qf'] = true,
  ['log'] = true,
  ['help'] = true,
  ['query'] = true,
  ['dbui'] = true,
  ['LspInfo'] = true,
  ['Lazy'] = true,
  ['git.*'] = true,
  ['Neogit.*'] = true,
  ['neotest.*'] = true,
  ['fugitive.*'] = true,
  ['copilot.*'] = true,
  ['tsplayground'] = true,
  ['startuptime'] = true,
  ['fzf'] = true,
  ['FzfLua'] = true,
  ['fzf-lua'] = true,
  ['trouble'] = true,
}

local smart_close_buftypes = eo.p_table {
  ['nofile'] = true,
}

local function smart_close()
  if fn.winnr('$') ~= 1 then api.nvim_win_close(0, true) end
end

eo.augroup('SmartClose', {
  -- Auto open grep quickfix window
  event = { 'QuickFixCmdPost' },
  pattern = { '*grep*' },
  command = 'cwindow',
}, {
  -- Close certain filetypes by pressing q.
  event = { 'FileType' },
  command = function(args)
    local is_unmapped = fn.hasmapto('q', 'n') == 0
    local buf = vim.bo[args.buf]
    local is_eligible = is_unmapped
      or vim.wo.previewwindow
      or smart_close_filetypes[buf.ft]
      or smart_close_buftypes[buf.bt]
    if is_eligible then map('n', 'q', smart_close, { buffer = args.buf, nowait = true }) end

    -- map('n', '<Esc>', 'q', { noremap = true })

    if is_eligible then map('n', '<ESC>', smart_close, { buffer = args.buf, nowait = true }) end
  end,
}, {
  -- TODO: this is set in the ftplugin/qf.lua file ... do i leave this or leave the ftplugin/qf vim.cmd?
  -- Close quick fix window if the file containing it was closed

  --[[ QuickfixFormatting ]]
  event = { 'BufEnter', 'WinEnter' },
  command = function()
    if fn.winnr('$') < 2 and vim.bo.buftype == 'quickfix' then
      api.nvim_set_option_value({ 'cursorline' }, false, { scope = 'local' })
      api.nvim_set_option_value({ 'number' }, true, { scope = 'local' })
      api.nvim_buf_delete(0, { force = true })
    end
  end,
  pattern = { '*' },
}, {
  -- automatically close corresponding loclist when quitting a window
  event = { 'QuitPre' },
  nested = true,
  command = function()
    if vim.bo.filetype ~= 'qf' then cmd.lclose { mods = { silent = true } } end
  end,
})

eo.augroup('ExternalCommands', {
  -- Open images in an image viewer (probably Preview) or inlyne!
  event = { 'BufEnter' },
  pattern = { '*.png', '*.jpg', '*.gif', '*.webp', '*.svg' },
  command = function()
    if package.loaded['image.nvim'] ~= 1 or { package.loaded['snacks.nvim'] ~= 1 } then
      cmd(fmt('silent! "%s | :bw"', vim.g.open_command .. ' ' .. fn.expand('%')))
    end
  end,
})

-- automatically check for changed files outside vim
eo.augroup('CheckOutsideTime', {
  event = { 'WinEnter', 'BufWinEnter', 'BufWinLeave', 'BufRead', 'BufEnter', 'FocusGained' },
  command = 'silent! checktime',
})

eo.augroup('TextYankHighlight', {
  -- don't execute silently in case of errors
  event = { 'TextYankPost' },
  command = function() vim.highlight.on_yank { timeout = 100, on_visual = true, higroup = 'Visual' } end,
  desc = 'Highlight on yank',
})

eo.augroup('UpdateVim', {
  event = { 'FocusLost' },
  pattern = { '*' },
  command = 'silent! wall',
}, {
  event = { 'VimResized' },
  pattern = { '*' },
  command = 'wincmd =', -- Make windows equal size when vim resizes
})

eo.augroup('WindowBehaviours', {
  event = { 'CmdWinEnter' }, -- map q to close command window on quit
  pattern = { '*' },
  command = 'nnoremap <silent><buffer><nowait> q <C-W>c',
  -- command = 'nnoremap <silent><buffer><nowait> <ESC> <C-W>c',
}, {
  event = { 'BufWinEnter' },
  command = function(args)
    if vim.wo.diff then vim.diagnostic.enable(false, args.buf) end
  end,
}, {
  event = { 'BufWinLeave' },
  command = function(args)
    if vim.wo.diff then vim.diagnostic.enable(args.buf) end
  end,
})

local cursorline_exclude = { 'alpha', 'toggleterm' }

---@param buf number
---@return boolean
local function should_show_cursorline(buf)
  return vim.bo[buf].buftype ~= 'terminal'
    and not vim.wo.previewwindow
    and vim.wo.winhighlight == ''
    and vim.bo[buf].filetype ~= ''
    and not vim.tbl_contains(cursorline_exclude, vim.bo[buf].filetype)
end

eo.augroup('Cursorline', {
  event = { 'InsertLeave', 'WinEnter' },
  pattern = { '*' },
  command = function(args) vim.wo.cursorline = should_show_cursorline(args.buf) end,
}, {
  event = { 'InsertEnter', 'WinLeave' },
  pattern = { '*' },
  command = function() vim.wo.cursorline = false end,
})

local save_excluded = {
  'neo-tree',
  'neo-tree-popup',
  'lua.luapad',
  'gitcommit',
  'NeogitCommitMessage',
  'sniprun',
}

local function can_save()
  return eo.falsy(fn.win_gettype())
    and eo.falsy(vim.bo.buftype)
    and not eo.falsy(vim.bo.filetype)
    and vim.bo.modifiable
    and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

eo.augroup(
  'Utilities',
  {
    ---@source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
    event = { 'BufReadCmd' },
    pattern = { 'file:///*' },
    nested = true,
    command = function(args)
      cmd.bdelete { bang = true }
      cmd.edit(vim.uri_to_fname(args.file))
    end,
  },
  {
    -- always add a guard clause when creating plugin files
    event = { 'BufNewFile' },
    pattern = { vim.g.nvim_dir .. '/plugin/**.lua' },
    command = 'norm! if not eo then return end',
  },
  -- {
  --   --- disable formatting in directories in third party repositories
  --   event = { 'BufEnter' },
  --   command = function(args)
  --     local paths = vim.split(vim.o.runtimepath, ',')
  --     local match = vim.iter(paths):find(function(dir)
  --       local path = api.nvim_buf_get_name(args.buf)
  --       -- if vim.startswith(path, env.PERSONAL_PROJECTS_DIR) then return false end
  --       if vim.startswith(path, env.VIMRUNTIME) then return true end
  --       return vim.startswith(path, dir)
  --     end)
  --     vim.b[args.buf].formatting_disabled = match ~= nil
  --   end,
  -- },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function(args)
      if api.nvim_buf_line_count(args.buf) <= 1 then return end
      if can_save() then cmd('silent! write ++p') end
    end,
  },
  {
    event = { 'BufWritePost' },
    pattern = { '*' },
    nested = true,
    command = function()
      if eo.falsy(vim.bo.filetype) or fn.exists('b:ftdetect') == 1 then
        cmd([[
        unlet! b:ftdetect
        filetype detect
        call v:lua.vim.notify('Filetype set to ' . &ft, "info", {})
      ]])
      end
    end,
  },
  {
    event = { 'DirChanged', 'VimEnter' },
    command = function()
      if fn.getcwd() == env['NVIM_CONFIG'] then
        vim.keymap.set('n', 'gx', function()
          local file = fn.expand('<cfile>')
          local link = file:match('[%a%d%-%.%_]*%/[%a%d%-%.%_]*')
          if link then return vim.ui.open(string.format('https://www.github.com/%s', link)) end
          return vim.ui.open(file)
        end)
      end
    end,
  }
)

--[[ ========== Specifically for Noice :Messages buffer ========== ]]

local grp = api.nvim_create_augroup('NoiceMessageWindow', { clear = true })

local function is_noice_msg_buf(bufnr)
  -- robust-ish checks that dont require depending on noice internals
  -- 1) Many noice buffers have a recognizable name.
  local name = api.nvim_buf_get_name(bufnr)
  if string.match(name, '[Nn]oice') then return true end

  -- 2) some setups expose a filetype for message buffers
  local ft = vim.bo[bufnr].filetype
  if ft == 'noice' then return true end

  -- 3) fallback: noice message buffers are typically scratch-ish.
  -- (intentionally conservative; tighten or loosen as you like)
  if vim.bo[bufnr].buftype == 'nofile' and (ft == '' or ft == 'noice') then
    -- if you like gate further by checking if its not your other scratch buffers
    return name ~= ''
  end

  return false
end

local function tune_noice_window(winid)
  if not api.nvim_win_is_valid(winid) then return end

  local bufnr = api.nvim_win_get_buf(winid)
  if not is_noice_msg_buf(bufnr) then return end

  -- window-local options
  api.nvim_set_option_value('number', false, { win = winid })
  api.nvim_set_option_value('relativenumber', false, { win = winid })
  -- api.nvim_set_option_value('cmdheight', 0, { win = winid })

  -- optional, but probably desirable
  api.nvim_set_option_value('signcolumn', 'no', { win = winid })
  api.nvim_set_option_value('foldcolumn', '0', { win = winid })
  api.nvim_set_option_value('cursorline', false, { win = winid })
  api.nvim_set_option_value('wrap', false, { win = winid })

  -- Auto-fit height to content (visible line count), with a reasonable cap.
  -- Using line("$") counts buffer lines; for "only as big as error lines",
  -- that's typically exactly what you want in a message buffer.
  local lines = api.nvim_buf_line_count(bufnr)
  local max_h = math.floor(vim.o.lines * 0.1) -- cap at 20% of editor
  local height = math.max(1, math.min(lines, max_h))

  -- make it resilient: avoid resizing if its a floating window
  local cfg = api.nvim_win_get_config(winid)
  if cfg and cfg.relative and cfg.relative ~= '' then return end

  -- prevent fighting with your layout if noice is using splits: this sets just the current win height
  pcall(api.nvim_win_set_height, winid, height)
end

-- preferred if noice uses a stable filetype for its message buffers
api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = { 'noice' },
  callback = function(args)
    tune_noice_window(api.nvim_get_current_win())
    -- re-fit after render/events
    vim.schedule(function() tune_noice_window(api.nvim_get_current_win()) end)
  end,
})

-- fallback: catch the window when it appears
api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  group = grp,
  callback = function() tune_noice_window(api.nvim_get_current_win()) end,
})

-- keep height correct as content changes (message append/cleared)
api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'BufModifiedSet' }, {
  group = grp,
  callback = function() tune_noice_window(api.nvim_get_current_win()) end,
})

--[[ ========== Specifically for Noice :Messages buffer ========== ]]

-- Set kitty terminal padding to 0 when in nvim
--[[ https://github.com/hendrikmi/dotfiles/blob/main/nvim/lua/core/snippets.lua ]]
eo.augroup('kitty_mp', {
  event = { 'VimEnter' },
  pattern = { '*' },
  command = function() vim.cmd([[silent !kitty @ set-spacing padding=0 margin=0 3 0 3]]) end,
}, {
  event = { 'VimLeave' },
  pattern = { '*' },
  command = function() vim.cmd([[silent !kitty @ set-spacing padding=default margin=default]]) end,
})

-- eo.augroup('TerminalAutocommands', {
--   event = { 'TermClose' },
--   command = function(args)
--     --- automatically close a terminal if the job was successful
--     if eo.falsy(v.event.status) and eo.falsy(vim.bo[args.buf].ft) then cmd.bdelete { args.buf, bang = true } end
--   end,
-- })
