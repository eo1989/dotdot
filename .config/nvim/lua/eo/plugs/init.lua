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
  { 'kkharji/sqlite.lua', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = false },
  { 'psliwka/vim-smoothie', lazy = false, enabled = true },
  {
    'wurli/contextindent.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- ft = { 'markdown', 'quarto', 'ipynb' },
    opts = { pattern = '*' },
  },
  {
    'nmac427/guess-indent.nvim',
    event = 'BufRead',
    cond = not vim.g.vscode,
    config = function() require('guess-indent').setup {} end,
  },
  --[[ TODO: check Oliver-Leete for his julia autopairs configurations ]]
  {
    ---@module "nvim-autopairs"
    'windwp/nvim-autopairs',
    version = false,
    enabled = true,
    event = { 'InsertEnter' },
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      local autopairs = require('nvim-autopairs')

      autopairs.setup {
        close_triple_quotes = true,
        disable_filetype = { 'neo-tree-popup', 'FzfLua', 'Snacks' },
        enable_check_bracket_line = true,
        check_ts = true,
        map_cr = true,
        map_c_w = true,
        fast_wrap = {
          map = '<M-e>',
        },
      }
    end,
  },
  {
    ---@module 'flatten'
    'willothy/flatten.nvim',
    lazy = false,
    priority = 1001,
    ---@type Flatten.Config
    opts = {
      -- nest_if_no_args = true,
      -- allow_cmd_passthrough =
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
  { 'tyru/open-browser.vim', lazy = true },
  { 'aklt/plantuml-syntax', ft = { 'plantuml' } },
  {
    'weirongxu/plantuml-previewer.vim',
    -- lazy = true,
    ft = { 'plantuml' },
    dependencies = {
      'open-browser.vim',
      'plantuml-syntax',
    },
  },
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
  -- {
  --   url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
  --   enabled = false,
  --   -- ft = 'qf',
  --   dependencies = {
  --     'nvim-treesitter',
  --     'nvim-web-devicons',
  --   },
  --   config = function()
  --     highlight.plugin('pqf', {
  --       theme = {
  --         ['*'] = { { qfPosition = { link = 'Todo' } } }, -- try 'String' next
  --         -- ['*'] = { { qfPosition = { link = 'Todo' } } },
  --       },
  --     })
  --     require('pqf').setup()
  --   end,
  -- },
  -- {
  --   'stevearc/quicker.nvim',
  --   -- event = 'FileType qf',
  --   -- ft = { 'qf' },
  --   ---@module "quicker"
  --   ---@type quicker.SetupOptions
  --   config = function()
  --     -- https://github.com/matthewgrossman/dotfiles/blob/master/config/nvim/init.lua
  --     require('quicker').setup {
  --       borders = { vert = separators.bar2.vertical_center_thin },
  --     }
  --     map('n', '<localleader>q', function() require('quicker').toggle() end, { desc = 'Toggle quickfix' })
  --     map(
  --       'n',
  --       '>',
  --       function() require('quicker').expand { before = 2, after = 2, add_to_existing = true } end,
  --       { desc = 'Expand context' }
  --     )
  --     map('n', '<', function() require('quicker').collapse() end, { desc = 'Collapse context' })
  --   end,
  --   keys = {
  --     -- https://github.com/bassamsdata/nvim/blob/main/lua/plugins/qf.lua
  --     {
  --       '<leader>xd',
  --       function()
  --         local quicker = require('quicker')
  --         if quicker.is_open() then
  --           quicker.close()
  --         else
  --           vim.diagnostic.setloclist()
  --         end
  --       end,
  --       desc = 'Toggle diagnostics',
  --     },
  --   },
  -- },
  {
    'kevinhwang91/nvim-bqf',
    enabled = true,
    branch = 'main',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      auto_enable = true,
      preview = {
        win_height = 14,
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
