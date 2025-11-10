local api, cmd, fn, fmt = vim.api, vim.cmd, vim.fn, string.format
local separators = require('defaults').icons.separators
local border, highlight, icons = eo.ui.current.border, eo.highlight, eo.ui.icons

---@module "lazy"
---@type LazySpec
return {
  {
    'nvim-lua/plenary.nvim',
    priority = 1001,
    version = false,
    lazy = false,
  },
  { 'kkharji/sqlite.lua', event = 'VeryLazy' },
  { 'nvim-tree/nvim-web-devicons', lazy = false, priority = 1001 },
  { 'psliwka/vim-smoothie', lazy = false, enabled = false },
  --[[ TODO: check Oliver-Leete for his julia autopairs configurations ]]
  {
    ---@module "nvim-autopairs"
    'windwp/nvim-autopairs',
    version = false,
    enabled = true,
    event = { 'InsertEnter' },
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      -- local cmp = require('cmp')
      local autopairs = require('nvim-autopairs')
      local blink = require('blink-cmp')
      -- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      -- local handlers = require('nvim-autopairs.completion.handlers')
      -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })

      --[[fast_wrap options below]]
      -- pattern = string.gsub([[ [%'%"%)%>%]%)%}%,%;] ]], '%s+', ''),
      -- end_key = 'l',
      -- check_comma = true,

      autopairs.setup {
        close_triple_quotes = true,
        disable_filetype = { 'neo-tree-popup', 'FzfLua' },
        enable_check_bracket_line = true,
        check_ts = true,
        map_cr = true,
        map_c_w = true,
        -- fast_wrap = {},
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '<', '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%%,]]=],
          before_key = 'h',
          after_key = 'l',
          cursor_pos_before = true,
          avoid_move_to_end = true,
          offset = -2,
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          manual_position = true,
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
  { 'fladson/vim-kitty' },
  { 'neoclide/jsonc.vim' },
  -- { 'fei6409/log-highlight.nvim', ft = 'log', event = 'BufRead *.log', opts = {} },
  -- { 'fei6409/log-highlight.nvim', event = 'BufRead *.log', opts = {} },
  { 'fei6409/log-highlight.nvim', ft = { 'checkhealth', 'log' }, opts = {} },
  {
    'mrjones2014/smart-splits.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      ignore_filetypes = { 'nofile', 'quickfix', 'qf', 'prompt' },
      ignore_buftypes = { 'nofile' },
    },
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
  { 'tpope/vim-repeat', event = 'VeryLazy', config = function() end },
  { 'tpope/vim-scriptease', lazy = true, opts = {} },
  { 'milisims/nvim-luaref', lazy = true, opts = {} },
  {
    url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
    enabled = false,
    -- ft = 'qf',
    dependencies = {
      'nvim-treesitter',
      'nvim-web-devicons',
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
    'stevearc/quicker.nvim',
    -- event = 'FileType qf',
    -- ft = { 'qf' },
    ---@module "quicker"
    ---@type quicker.SetupOptions
    config = function()
      -- https://github.com/matthewgrossman/dotfiles/blob/master/config/nvim/init.lua
      require('quicker').setup {
        borders = { vert = separators.bar2.vertical_center_thin },
      }
      map('n', '<localleader>q', function() require('quicker').toggle() end, { desc = 'Toggle quickfix' })
      map(
        'n',
        '>',
        function() require('quicker').expand { before = 2, after = 2, add_to_existing = true } end,
        { desc = 'Expand context' }
      )
      map('n', '<', function() require('quicker').collapse() end, { desc = 'Collapse context' })
    end,
    keys = {
      -- https://github.com/bassamsdata/nvim/blob/main/lua/plugins/qf.lua
      {
        '<leader>xd',
        function()
          local quicker = require('quicker')
          if quicker.is_open() then
            quicker.close()
          else
            vim.diagnostic.setloclist()
          end
        end,
        desc = 'Toggle diagnostics',
      },
    },
  },
  {
    'kevinhwang91/nvim-bqf',
    enabled = true,
    branch = 'main',
    -- ft = 'qf',
    -- event = 'FileType qf',
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
  {
    ---@module "neogen"
    'danymat/neogen',
    cmd = { 'Neogen' },
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      snippet_engine = 'luasnip',
      languages = {
        lua = {
          template = { annotation_convention = 'emmylua' },
        },
        python = {
          template = { annotation_convention = 'numpydoc' },
          -- template = { annotation_convention = "reST" },
          -- template = { annotation_convention = "google_docstrings" },
        },
        julia = { template = { annotation_convention = 'julia' } },
        go = { template = { annotation_convention = 'godoc' } },
      },
    },
    keys = {
      { '<localleader>aa', function() require('neogen').generate() end, desc = 'Annotate thing' },
      { '<localleader>af', function() require('neogen').generate { type = 'func' } end, desc = 'Annotate function' },
      { '<localleader>ac', function() require('neogen').generate { type = 'class' } end, desc = 'Annotate class' },
      { '<localleader>at', function() require('neogen').generate { type = 'type' } end, desc = 'Annotate type' },
    },
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
}
