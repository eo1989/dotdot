---@type LazySpec
return {
  {
    'monaqa/dial.nvim',
    -- stylua: ignore start
    keys = {
      { '<C-a>',   '<Plug>(dial-increment)',   mode = 'n' },
      { '<C-x>',   '<Plug>(dial-decrement)',   mode = 'n' },
      { 'g<C-a>',  '<Plug>(dial-g-increment)', mode = 'n' },
      { 'g<C-x>',  '<Plug>(dial-g-decrement)', mode = 'n' },
      { '<C-a>',   '<Plug>(dial-increment)',   mode = 'v' },
      { '<C-x>',   '<Plug>(dial-decrement)',   mode = 'v' },
      { 'g<C-a>',  '<Plug>(dial-g-increment)', mode = 'x' },
      { 'g<C-x>',  '<Plug>(dial-g-decrement)', mode = 'x' },
    },
    -- stylua: ignore end
    config = function()
      local augend = require('dial.augend')
      local config = require('dial.config')

      local casing = augend.case.new {
        types = { 'camelCase', 'snake_case', 'PascalCase', 'SCREAMING_SNAKE_CASE' },
        cyclic = true,
      }

      config.augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.date.alias['%m/%d/%Y'],
          augend.date.new {
            pattern = '%m/%d',
            default_kind = 'day',
            only_valid = true,
            word = true,
            clamp = true,
            end_sensitive = true,
          },
          augend.constant.new { elements = { 'True', 'False' }, word = false, cyclic = true },
        },
      }

      -- local operators = augend.constant.new {
      --   elements = { '&&', '||' },
      --   word = false,
      --   cyclic = true,
      -- }

      -- config.augends:on_filetype {
      --   julia = {
      --     operators,
      --     augend.integer.alias.decimal,
      --     augend.integer.alias.hex,
      --     augend.constant.alias.bool,
      --   },
      --   python = {
      --     augend.constant.new {
      --       elements = { 'and', 'or' },
      --       word = true, -- if false, 'sand' is incremented into 'sor', 'doctor' into 'doctand', etc
      --       cyclic = true, -- 'or' increments into 'and'
      --     },
      --     augend.constant.new { elements = { 'True', 'False' }, word = false, preserve_case = true, cyclic = true },
      --     augend.integer.alias.decimal,
      --     augend.integer.alias.hex,
      --     augend.constant.alias.bool,
      --   },
      --   markdown = {
      --     augend.integer.alias.decimal,
      --     augend.misc.alias.markdown_header,
      --   },
      --   yaml = {
      --     augend.integer.alias.decimal,
      --     augend.semver.alias.semver,
      --   },
      --   toml = {
      --     augend.integer.alias.decimal,
      --     augend.semver.alias.semver,
      --   },
      -- }
    end,
  },
  {
    'jghauser/fold-cycle.nvim',
    opts = {},
    keys = {
      -- stylua: ignore start
      { '<BS>',   function() require('fold-cycle').open() end,      desc = 'fold: toggle',    mode = 'n', silent = true },
      { 'zC',     function() require('fold-cycle').close_all() end, desc = 'fold: close all', mode = 'n', silent = true },
      -- stylua: ignore end
    },
  },
  {
    'kylechui/nvim-surround',
    lazy = false,
    version = '*',
    keys = { { 's', mode = 'v' }, '<C-g>s', '<C-g>S', 'ys', 'yss', 'yS', 'cs', 'ds' },
    opts = { move_cursor = true, keymaps = { visual = 's' } },
  },
  {
    'glts/vim-textobj-comment',
    dependencies = { { 'kana/vim-textobj-user', dependencies = { 'kana/vim-operator-user' } } },
    init = function() vim.g.textobj_comment_no_default_key_mappings = 1 end,
    keys = {
      { 'ax', '<Plug>(textobj-comment-a)', mode = { 'x', 'o' } },
      { 'ix', '<Plug>(textobj-comment-i)', mode = { 'x', 'o' } },
    },
  },
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    config = function() require('mini.ai').setup { mappings = { around_last = '', inside_last = '' } } end,
  },
  {
    'tpope/vim-abolish',
    event = 'CmdlineEnter',
    keys = {
      {
        '<localleader>[',
        ':S/<C-R><C-W>//<LEFT>',
        mode = 'n',
        silent = false,
        desc = 'abolish: replace word under the cursor (line)',
      },
      {
        '<localleader>]',
        ':%S/<C-r><C-w>//c<left><left>',
        mode = 'n',
        silent = false,
        desc = 'abolish: replace word under the cursor (file)',
      },
      {
        '<localleader>[',
        [["zy:'<'>S/<C-r><C-o>"//c<left><left>]],
        mode = 'x',
        silent = false,
        desc = 'abolish: replace word under the cursor (visual)',
      },
    },
  },
}
-- {
--   'chrisgrieser/nvim-various-textobjs',
--   enabled = false,
--   -- ft = { 'markdown', 'quarto' },
--   config = function()
--     require('various_textobjs').setup {
--       lookForwardLines = 8, -- default 5
--     }
--     map(
--       { 'o', 'x' },
--       'is',
--       ":lua require('various-textobjs').sub_word(true)<CR>",
--       { silent = true, desc = 'inner subword' }
--     )
--     map(
--       { 'o', 'x' },
--       'as',
--       ":lua require('various-textobjs').sub_word(false)<CR>",
--       { silent = true, desc = 'around subword' }
--     )
--   end,
-- },
