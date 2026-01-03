local L = vim.lsp.log_levels
local api, augroup, highlight, ui = vim.api, eo.augroup, eo.highlight, eo.ui
local border = eo.ui.current.border

---@type LazySpec
return {
  {
    ---@module 'blink.indent'
    'saghen/blink.indent',
    ---@type blink.indent.Config
    enabled = false, --[[ currently errors way too often.. but its fast af! ]]
    opts = {
      -- scope = {
      --   underline = { enabled = true },
      -- },
    },
  },
  {
    'lukas-reineke/virt-column.nvim',
    enabled = true,
    -- event = { 'BufNewFile', 'BufReadPost' },
    event = { 'VimEnter', 'VeryLazy' },
    opts = { char = '▕' },
    init = function()
      augroup('VirtCol', {
        -- event = { 'VimEnter', 'BufEnter', 'WinEnter', 'UIEnter' },
        event = { 'VimEnter', 'BufEnter', 'WinEnter' },
        command = function(args)
          ui.decorations.set_colorcolumn(
            args.buf,
            function(virtcolumn) require('virt-column').setup_buffer { virtcolumn = virtcolumn } end
          )
        end,
      })
    end,
  },
}

-- {
--   'lukas-reineke/indent-blankline.nvim',
--   enabled = false,
--   version = '*',
--   dependencies = { 'nvim-treesitter/nvim-treesitter', 'HiPhish/rainbow-delimiters.nvim' },
--   -- event = { 'BufNewFile', 'BufReadPost' },
--   event = 'UIEnter',
--   main = 'ibl',
--   opts = {
--     exclude = {
--       -- stylua: ignore start
--       filetypes = {
--         'dbout', 'neo-tree', 'neo-tree-popup', 'log', 'gitcommit',
--         'txt', 'help', 'NvimTree', 'git', 'undotree', 'checkhealth',
--         'quarto', 'markdown', 'norg', 'org', 'orgagenda','lspinfo',
--       },
--       buftypes = {
--         'terminal', 'nofile', 'quickfix', 'prompt', 'Lazy',
--         'Mason', 'fzf', 'FzfLua', 'overseer', 'fzf-lua',
--       },
--       -- stylua: ignore end
--     },
--     debounce = 500,
--     indent = {
--       smart_indent_cap = true,
--       char = '│', -- ▏┆ ┊ 
--     },
--     scope = {
--       enabled = true,
--       show_start = true,
--       show_exact_scope = true, -- default 'false'
--       show_end = false,
--       char = '▎', -- 🮇
--       include = {
--         node_type = {
--           lua = { 'return_statement', 'table_constructor' },
--         },
--       },
--       highlight = {
--         'RainbowDelimiterRed',
--         'RainbowDelimiterYellow',
--         'RainbowDelimiterBlue',
--         'RainbowDelimiterOrange',
--         'RainbowDelimiterGreen',
--         'RainbowDelimiterViolet',
--         'RainbowDelimiterCyan',
--       },
--     },
--   },
--   config = function(_, opts)
--     require('ibl').setup(opts)
--     local hooks = require('ibl.hooks')
--     hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
--     hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
--     hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
--   end,
-- },
