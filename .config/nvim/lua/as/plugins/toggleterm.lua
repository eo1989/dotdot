return function()
  local fn = vim.fn
  local exp = vim.fn.expand

  require('toggleterm').setup({
    open_mapping = [[<c-\>]],
    shade_filetypes = { 'none' },
    direction = 'horizontal',
    autochdir = true,
    persist_mode = true,
    insert_mappings = false,
    start_in_insert = true,
    -- winbar = { enabled = as.ui.winbar.enable },
    winbar = { enabled = false },
    highlights = {
      FloatBorder = { link = 'FloatBorder' },
      NormalFloat = { link = 'NormalFloat' },
    },
    float_opts = {
      border = as.style.current.border,
      winblend = 3,
    },
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
  })

  local float_handler = function(term)
    if not as.empty(fn.mapcheck('kj', 't')) then
      vim.keymap.del('t', 'kj', { buffer = term.bufnr })
      vim.keymap.del('t', '<esc>', { buffer = term.bufnr })
    end
  end

  local Terminal = require('toggleterm.terminal').Terminal

  local lazygit = Terminal:new({
    cmd = 'lazygit',
    dir = 'git_dir',
    hidden = true,
    direction = 'float',
    on_open = float_handler,
  })

  as.nnoremap('<leader>lg', function()
    lazygit:toggle()
  end, 'toggleterm: toggle lazygit')

  local btop = Terminal:new({
    cmd = 'btop',
    hidden = true,
    direction = 'float',
    on_open = float_handler,
    highlights = {
      FloatBorder = { guibg = 'Black', guifg = 'DarkGray' },
      NormalFloat = { guibg = 'Black' },
    },
  })

  as.command('Btop', function()
    btop:toggle()
  end)

  local ipython = Terminal:new({
    cmd = 'ptipython',
    direction = 'horizontal',
    hidden = false
  })

  as.command('IPython', function()
    ipython:toggle()
  end)

  -- as.command('Ipython', function()
  --   return _toggle_ipython()
  -- end)
end


  -- local gh_dash = Terminal:new({
  --   cmd = 'gh dash',
  --   hidden = true,
  --   direction = 'float',
  --   on_open = float_handler,
  --   float_opts = {
  --     height = function()
  --       return math.floor(vim.o.lines * 0.8)
  --     end,
  --     width = function()
  --       return math.floor(vim.o.columns * 0.95)
  --     end,
  --   },
  -- })

  -- as.nnoremap('<localleader>rP', function()
  --   py:toggle()
  -- end, 'toggleterm: run python file')

  -- as.nnoremap('<leader>ld', function()
  --   gh_dash:toggle()
  -- end, 'toggleterm: toggle github dashboard')
