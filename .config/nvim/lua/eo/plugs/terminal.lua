local fn = vim.fn
local map = map or vim.keymap.set

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
  opts = {
    open_mapping = [[<c-\>]],
    shade_filetypes = {},
    shade_terminals = true,
    direction = 'horizontal',
    autochdir = true,
    persist_mode = true,
    insert_mappings = false,
    env = { TERM = 'xterm-kitty' },
    start_in_insert = true,
    winbar = { enabled = eo.ui.winbar.enable },
    highlights = {
      FloatBorder = { link = 'FloatBorder' },
      NormalFloat = { link = 'NormalFloat' },
    },
    float_opts = {
      border = eo.ui.current.border,
      winblend = 3,
    },
    -- size = bit.bor(25,  function(term)
    --   if term.direction == 'horizontal' then
    --     return 20
    --   elseif term.direction == 'vertical' then
    --     return math.floor(vim.o.columns * 0.3)
    --   end
    -- end),
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.3)
      end
    end,
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    local float_handler = function(term)
      if not eo.falsy(fn.mapcheck('kj', 't')) then
        vim.keymap.del('t', 'kj', { buffer = term.bufnr })
        vim.keymap.del('t', '<esc>', { buffer = term.bufnr })
      end
    end

    local Terminal = require('toggleterm.terminal').Terminal

    local lazygit = Terminal:new {
      cmd = 'lazygit',
      dir = 'git_dir',
      hidden = true,
      direction = 'float',
      on_open = float_handler,
    }

    -- local lazydocker = Terminal:new({
    --   cmd = 'lazydocker',
    --   dir = 'git_dir',
    --   hidden = true,
    --   direction = 'float',
    --   on_open = float_handler,
    -- })

    local btop = Terminal:new {
      cmd = 'btop',
      hidden = true,
      direction = 'float',
      on_open = float_handler,
      highlights = {
        FloatBorder = { guibg = 'Black', guifg = 'DarkGray' },
        NormalFloat = { guibg = 'Black' },
      },
    }

    -- local gh_dash = Terminal:new {
    --   cmd = 'gh dash',
    --   hidden = true,
    --   direction = 'float',
    --   on_open = float_handler,
    --   float_opts = {
    --     height = function() return math.floor(vim.o.lines * 0.6) end,
    --     width = function() return math.floor(vim.o.columns * 0.75) end,
    --   },
    -- }

    -- map('n', '<leader>lh', function() gh_dash:toggle() end, {
    --   desc = 'toggleterm: toggle github dashboard',
    -- })
    map('n', '<leader>lg', function() lazygit:toggle() end, {
      desc = 'toggleterm: toggle lazygit',
    })
    -- map('n', '<leader>ld', function() lazydocker:toggle() end, {
    --   desc = 'toggleterm: toggle lazydocker',
    -- })
    eo.command('Btop', function() btop:toggle() end)

    -- https://github.com/akinsho/toggleterm.nvim/issues/425
    local function is_whitespace(str) return str:match('^%s*$') ~= nil end

    -- func to remove leading and ending whitespace strings
    local function trim_whitespace_strings(lines)
      local start_idx, end_idx = 1, #lines

      -- find the index of the first non-whitespace string
      while start_idx <= #lines and is_whitespace(lines[start_idx]) do
        start_idx = start_idx + 1
      end

      -- find the index of the last non-whitespace string
      while end_idx >= 1 and is_whitespace(lines[end_idx]) do
        end_idx = end_idx - 1
      end

      -- create new table containing only the non-whitespace strings
      local trimmed_lines = {}
      for i = start_idx, end_idx do
        table.insert(trimmed_lines, lines[i])
      end
      return trimmed_lines
    end

    local function send_lines_to_ipython()
      local id = 1
      local current_window = vim.api.nvim_get_current_win()

      local vstart = vim.fn.getpos("'<")
      local vend = vim.fn.getpos("'>")

      local line_start = vstart[2]
      local line_end = vend[2]
      local lines = vim.fn.getline(line_start, line_end)
      local cmd = string.char(15)

      for _, line in ipairs(trim_whitespace_strings(lines)) do
        local l = line
        if l == '' then
          cmd = cmd .. string.char(15) .. string.char(14)
        else
          cmd = cmd .. l .. string.char(10)
        end
      end

      cmd = cmd .. string.char(4)
      require('toggleterm').exec(cmd, id)
      vim.api.nvim_set_current_win(current_window)
    end
    map(
      'v',
      '<localleader>r',
      [[:'<,'>lua require('toggleterm').send_lines_to_ipython()<CR>]],
      { desc = 'send to ipython' }
    )
  end,
}
