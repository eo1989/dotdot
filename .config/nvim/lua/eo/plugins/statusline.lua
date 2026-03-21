local api, bo, fn = vim.api, vim.bo, vim.fn
local eo_separators = eo.ui.icons.separators

local formatter_status = function()
  local ok, conform = pcall(require, 'conform')
  if not ok then return '' end

  local formatters = conform.list_formatters_to_run(0)[0][0]
  local formuttuhs = conform.get_formatter_info(0)
  -- if #formatters == 0 then return '' end
  if #formuttuhs == 0 then return '' end

  local formatter_names = {}
  -- if bo['ft'] == 'python' and formatters[string.format('ruff', 0)]() then end

  for _, formatter in ipairs(formatters) do
    -- if formatter.name == 'ruff' and bo['ft'] == 'python' then
    if formatter.name == 'ruff_format' or formatter.name == 'ruff_fix' then -- its obviously going to be python
      -- prefer ruff if available
      -- formatter_names = { 'ruff' }
      table.insert(formatter_names, 'ruff')
    else
      return
      -- return table.insert(formatter_names, formatter.name)
      -- break
    end
    table.insert(formatter_names, formatter.name)
  end

  return '󰉿 ' .. table.concat(formatter_names, ',')
end

local function linter_status()
  local ok, lint = pcall(require, 'lint')
  if not ok then return '' end

  -- local linters = lint.linters_by_ft[bo.ft]
  local lintrs = lint.get_running(0) -- grab current buffer?
  -- if #linters == 0 then return '' end
  if #lintrs == 0 then return '' end

  local linter_names = {}

  for _, linter in ipairs(lintrs) do
    if linter.name == 'ruff' then
      table.insert(linter_names, 'ruff')
    else
      return
    end
    table.insert(linter_names, linter.name)
  end

  return '󰁨 ' .. table.concat(lintrs, ',')
end

local safe_formatter_status = function()
  local ok, result = pcall(formatter_status)
  return ok and result or ''
end

local safe_linter_status = function()
  local ok, result = pcall(linter_status)
  return ok and result or ''
end

-- _G.formatter_status = safe_formatter_status
-- _G.linter_status = safe_linter_status

---@type LazySpec
return {
  {
    'nvim-lualine/lualine.nvim',
    version = false,
    event = 'VeryLazy',
    -- lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'meuter/lualine-so-fancy.nvim',
    },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto', -- auto, tokyonight
        -- component_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        -- component_separators = {
        --   left = eo_separators.right_half_empty_circle,
        --   right = eo_separators.left_half_empty_circle,
        -- },
        section_separators = { left = '', right = '' },
        -- section_separators = {
        --   left = eo_separators.right_half_circle,
        --   right = eo_separators.left_half_circle,
        -- },
        refresh = { statusline = 100, winbar = 100 },
        winbar = { 'help' },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            'fancy_mode',
            width = 1,
            separator = { left = '' },
            -- separator = { left = eo_separators.left_half_circle },
            padding = { left = 0, right = 1 },
          },
        },
        lualine_b = {
          -- { 'filename', shorting_target = 25 },
          {
            'fancy_cwd',
            -- separator = { left = '', right = '' },
            separator = { right = '' },
            -- separator = { right = eo_separators.right_half_circle },
            -- colors = { fg = '#293248', bg = '#' },
            colors = { fg = '#293248', bg = '#414362' },
            padding = { left = 1, right = 1 },
          },
          {
            'fancy_branch',
            separator = { left = '', right = '' },
            -- separator = { left = '', right = '' },
            -- separator = { left = '', right = '' },
            -- separator = { left = eo_separators.left_half_circle, right = eo_separators.right_half_circle },
            padding = { left = 1, right = 0 },
          },
          {
            'fancy_diff',
            -- separator = { left = '', right = '' },
            -- separator = { right = '' },
            separator = { left = '', right = '' },
            -- separator = { left = eo_separators.left_half_circle, right = eo_separators.right_half_circle },
            -- symbols = { added = '+', modified = '~', removed = '-' },
            colored = true,
            padding = { left = 1, right = 0 },
          },
        },
        lualine_c = {
          '%=',
          {
            'fancy_lsp_servers',
            separator = { left = '', right = '' },
            -- separator = { left = eo_separators.left_half_circle, right = eo_separators.right_half_circle },
            -- separator = { left = '' },
            color = { fg = 'darkgrey', bg = '#414362', gui = 'italic' },
            padding = { left = 0, right = 1 },
          },
          {
            safe_formatter_status,
            separator = { left = '⏐', right = '' },
            -- separator = { left = eo_separators.left_half_circle, right = eo_separators.right_half_circle },
            -- separator = { right = '' },
            color = { fg = 'darkgrey', bg = '#414362', gui = 'italic' },
            padding = { left = 0, right = 0 },
          },
          {
            safe_linter_status,
            -- separator = { left = '', right = '' },
            -- separator = { left = eo_separators.left_half_circle, right = eo_separators.right_half_circle },
            separator = { right = '' },
            color = { fg = 'darkgrey', bg = '#414362', gui = 'italic' },
            padding = { left = 0, right = 0 },
          },
          '%=',
        },
        lualine_x = {
          {
            'fancy_diagnostics',
            symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
            colored = true,
            separator = { left = '', right = '' },
            -- separator = { left = eo_separators.left_half_circle, right = eo_separators.right_half_circle },
          },
          {
            'venv-selector',
            cond = function() return vim.bo['filetype'] == 'python' end,
          },
          -- {
          --   "swenv",
          --   cond = function()
          --     return vim.bo['filetype'] == 'python'
          --   end,
          -- },
          {
            'fancy_filetype',
            ts_icon = ' ',
            padding = { left = 0, right = 0 },
            -- separator = { left = '', right = '' },
            separator = { left = '' },
            -- color = { bg = '#363959' },
            -- color = { bg = '#303250' },
            -- separator = { right = eo_separators.right_half_circle },
          },
          {
            'fancy_location',
            -- separator = { left = '', right = '' },
            -- separator = { left = '', right = '' },
            separator = { left = '' },
            -- color = { bg = '#414362' },
            -- separator = { left = '' },
          },
          {
            'fancy_searchcount',
            separator = { left = '' },
          },
        },
        lualine_z = {
          {
            function() return ' ' .. os.date('%R') end,
            separator = { left = '', right = '' },
            -- separator = { left = eo_separators.left_half_circle, right = eo_separators.right_half_circle },
            padding = { left = 0, right = 0 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'progress', 'fancy_location', 'fancy_searchcount' },
        lualine_z = {},
      },
      extensions = {
        'avante',
        'fzf',
        'toggleterm',
        'quickfix',
        'overseer',
        'neo-tree',
        'oil',
        'lazy',
        'man',
        'fugitive',
        'trouble',
        'mason',
        'symbols-outline',
        'nvim-dap-ui',
      },
    },
  },
}
