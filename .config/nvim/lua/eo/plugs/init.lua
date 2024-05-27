local api, cmd, fn, fmt = vim.api, vim.cmd, vim.fn, string.format
local border, highlight, icons = eo.ui.current.border, eo.highlight, eo.ui.icons

return {
  { 'nvim-lua/plenary.nvim', priority = 1004, lazy = false },
  { 'MunifTanjim/nui.nvim', lazy = false },
  -- 'grapp-dev/nui-components.nvim',
  {
    'nvim-tree/nvim-web-devicons',
    priority = 1004,
    lazy = false,
    dependencies = { 'DaikyXendo/nvim-material-icon' },
    config = function()
      require('nvim-web-devicons').setup {
        override = require('nvim-material-icon').get_icons(),
      }
    end,
  },
  { 'psliwka/vim-smoothie', lazy = false },
  {
    -- TODO: check Oliver-Leete for his julia autopairs configurations
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      local autopairs = require('nvim-autopairs')
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      autopairs.setup {
        require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } }),
        close_triple_quotes = true,
        disable_filetype = { 'neo-tree-popup' },
        check_ts = true,
        fast_wrap = { map = '<c-e>' },
      }
    end,
  },
  -- {
  --   'glacambre/firenvim',
  --   lazy = true,
  --   build = function() vim.fn['firenvim#install'](0) end,
  -- },
  {
    'famiu/bufdelete.nvim',
    lazy = false,
    keys = { { '<leader>qq', '<Cmd>Bdelete<CR>', desc = 'buffer delete' } },
  },
  {
    'willothy/flatten.nvim',
    lazy = false,
    priority = 1002,
    config = {
      window = { open = 'alternate' },
      callbacks = {
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
  { 'fladson/vim-kitty', ft = 'kitty' },
  { 'neoclide/jsonc.vim', ft = { 'jsonc', 'json5', 'hjson' } },
  -- { 'tpope/vim-git', event = 'VeryLazy' },
  { 'mtdl9/vim-log-highlighting', ft = 'log' },
  {
    'mrjones2014/smart-splits.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
    build = './kitty/install-kittens.bash',
    keys = {
      -- TODO: Change these as <A-h/l> are already mapped to resize left/right
      { '<A-h>', function() require('smart-splits').resize_left() end },
      { '<A-l>', function() require('smart-splits').resize_right() end },
      { '<C-A-j>', function() require('smart-splits').resize_down() end },
      { '<C-A-k>', function() require('smart-splits').resize_up() end },
      { '<C-h>', function() require('smart-splits').move_cursor_left() end },
      { '<C-j>', function() require('smart-splits').move_cursor_down() end },
      { '<C-k>', function() require('smart-splits').move_cursor_up() end },
      { '<C-l>', function() require('smart-splits').move_cursor_right() end },
    },
  },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'tpope/vim-scriptease', event = 'VeryLazy' },
  -- { 'milisims/nvim-luaref', lazy = true },
  {
    url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
    event = 'VeryLazy',
    config = function()
      highlight.plugin('pqf', {
        theme = {
          ['*'] = { { qfPosition = { link = 'String' } } }, -- ToDo
          ['horizon'] = { { qfPosition = { link = 'String' } } },
        },
      })
      require('pqf').setup()
    end,
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function() highlight.plugin('bqf', { { BqfPreviewBorder = { fg = { from = 'Comment' } } } }) end,
  },
  -- {
  --   'olexsmir/gopher.nvim',
  --   ft = 'go',
  --   dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  -- },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = { { '<leader>u', '<Cmd>UndotreeToggle<CR>', desc = 'undotree: toggle' } },
    config = function()
      vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  { 'treesit' },
  { 'lsp' },
  { 'ui' },
  { 'tools' },
  { 'completion' },
  { 'colorschemes' },
  { 'statusline' },
  { 'components' },
  { 'editing' },
  { 'notes' },
  { 'tests' },
  { 'images' },
  { 'git' },
  { 'navigate' },
  { 'picker' },
  { 'db' },
  { 'whichkey' },
  { 'snippets' },
  { 'terminal' },
  { 'pythonsyall' },
  { 'overseer' },
  -- {
  --   'folke/todo-comments.nvim',
  --   enabled = false,
  --   lazy = true,
  --   -- event = 'VeryLazy',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     require('todo-comments').setup()
  --     eo.command('TodoDots', ('TodoQuickFix cwd=%s keywords=TODO,FIXME'):format(vim.g.nvim_dir))
  --   end,
  -- },
  { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion', ft = 'help' },
  { 'rafcamlet/nvim-luapad', cmd = 'Luapad' },
}
