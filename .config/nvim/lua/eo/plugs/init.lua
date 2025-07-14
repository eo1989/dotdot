local api, cmd, fn, fmt = vim.api, vim.cmd, vim.fn, string.format
local border, highlight, icons = eo.ui.current.border, eo.highlight, eo.ui.icons

return {
  {
    'nvim-lua/plenary.nvim',
    version = false,
    lazy = false,
  },
  { 'kkharji/sqlite.lua', event = 'VeryLazy' },
  { 'nvim-tree/nvim-web-devicons', lazy = false, priority = 999 },
  { 'psliwka/vim-smoothie', lazy = false },
  {
    -- TODO: check Oliver-Leete for his julia autopairs configurations
    'windwp/nvim-autopairs',
    enabled = true,
    event = { 'InsertEnter' },
    -- dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      -- local cmp = require('cmp')
      local autopairs = require('nvim-autopairs')
      -- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      -- local handlers = require('nvim-autopairs.completion.handlers')
      -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })
      autopairs.setup {
        close_triple_quotes = true,
        disable_filetype = { 'neo-tree-popup', 'FzfLua' },
        enable_check_bracket_line = true,
        check_ts = true,
        map_cr = true,
        map_c_w = true,
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '<', '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,%;] ]], '%s+', ''),
          end_key = 'l',
          offset = -2,
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey = 'Comment',
        },
      }
    end,
  },
  {
    'willothy/flatten.nvim',
    lazy = false,
    priority = 1001,
    opts = {
      window = { open = 'alternate' },
      hooks = {
        block_end = function() require('toggleterm').toggle() end,
        post_open = function(_, winnr, _, is_blocking)
          if is_blocking then
            require('toggleterm').toggle()
          else
            vim.api.nvim_set_current_win(winnr)
          end
        end,
      },
    },
  },
  { 'fladson/vim-kitty', lazy = false },
  { 'neoclide/jsonc.vim', ft = { 'jsonc', 'json' }, opts = {} },
  { 'fei6409/log-highlight.nvim', ft = 'log', event = 'BufRead *.log', opts = {} },
  {
    'mrjones2014/smart-splits.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
    build = './kitty/install-kittens.bash',
    keys = {
      -- stylua: ignore start
      -- TODO: Change these as <A-h/l> are already mapped to resize left/right
      { '<A-h>',   function() require('smart-splits').resize_left()       end, mode = 'n' },
      { '<A-l>',   function() require('smart-splits').resize_right()      end, mode = 'n' },
      { '<C-A-j>', function() require('smart-splits').resize_down()       end, mode = 'n' },
      { '<C-A-k>', function() require('smart-splits').resize_up()         end, mode = 'n' },
      { '<C-h>',   function() require('smart-splits').move_cursor_left()  end, mode = 'n' },
      { '<C-l>',   function() require('smart-splits').move_cursor_right() end, mode = 'n' },
      -- stylua: ignore end
      {
        '<C-j>',
        function() require('smart-splits').move_cursor_down() end,
        mode = 'n',
      },
      {
        '<C-k>',
        function() require('smart-splits').move_cursor_up() end,
        mode = 'n',
      },
    },
  },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'tpope/vim-scriptease', event = 'VeryLazy' },
  { 'milisims/nvim-luaref', lazy = true, opts = {} },
  {
    url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
    enabled = true,
    event = 'FileType qf',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      highlight.plugin('pqf', {
        theme = {
          ['*'] = { { qfPosition = { link = 'Todo' } } }, -- try 'String' next
          -- ['*'] = { { qfPosition = { link = 'Todo' } } },
        },
      })
      require('pqf').setup()
    end,
  },
  {
    'kevinhwang91/nvim-bqf',
    enabled = true,
    -- ft = 'qf',
    event = 'FileType qf',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      auto_enable = true,
      preview = {
        win_height = 12,
        win_vheight = 16,
        delay_syntax = 3,
        border_chars = { '┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█' },
      },
      func_map = {
        vsplit = '',
        ptogglemode = 'z,',
        stoggleup = '',
      },
      filter = {
        fzf = {
          action_for = { ['ctrl-s'] = 'split' },
          extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', ' ' }, -- 󰄾 >
        },
      },
    },
    config = function(_, opts)
      highlight.plugin('bqf', {
        { BqfPreviewBorder = { fg = { from = 'Comment' } } },
      })
      require('bqf').setup(opts)
      -- api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
      --   buffer = 0,
      --   callback = function(args)
      --     if vim.bo[args.buf].filetype == 'qf' then vim.treesitter.start() end
      --   end,
      -- })
    end,
  },
  {
    'mbbill/undotree',
    enabled = true,
    cmd = 'UndotreeToggle',
    keys = { { '<localleader>U', '<Cmd>UndotreeToggle<CR>', desc = 'undotree: toggle' } },
    config = function()
      vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  -- {
  --   'rafcamlet/nvim-luapad',
  --   enabled = true,
  --   cmd = 'Luapad',
  -- },
  {
    'norcalli/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    config = function()
      require('colorizer').setup({ '*' }, {
        RGB = true,
        mode = 'foreground',
      })
    end,
  },
  -- {
  --   'pteroctopus/faster.nvim',
  --   lazy = false,
  --   opts = {},
  -- },
  {
    'danymat/neogen',
    cmd = { 'Neogen' },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {},
  },
  {
    'chrishrb/gx.nvim',
    enabled = true,
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    cmd = { 'Browse' },
    init = function() vim.g.netrw_nogx = 1 end,
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      handler_options = {
        -- you can select between google, bing, duckduckgo, and ecosia
        search_engine = 'google',
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
