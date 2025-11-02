---@module "lazy"
---@type LazySpec
return {
  {
    --[[ this juliadoc thing is annoying. Need to extract the block movement stuff and remove this plugin completely.]]
    'goerz/julia-vim',
    enabled = false,
    -- ft = 'julia',
    branch = 'tweaks',
    config = function()
      -- vim.g.latex_to_unicode_file_types = { 'julia', 'python', 'markdown', 'pandoc', 'human' }
      vim.g.latex_to_unicode_tab = 'off' --|> blink-cmp-latex
      vim.g.latex_to_unicode_auto = 0
      vim.g.latex_to_unicode_keymap = 0
    end,
  },
  {
    'kdheepak/nvim-dap-julia',
    ft = { 'julia' },
    opts = {},
  },
  {
    'stevearc/overseer.nvim',
    ---@module "overseer"
    ---@module "eo.plugs.overseer"
    ---@type OverseerUserConfig
    opts = {
      extra_templates = {
        julia = {
          name = 'julia',
          generator = function(_, cb)
            cb {
              {
                name = 'Run File',
                builder = function()
                  ---@type overseer.TaskDefinition
                  return {
                    name = 'Running ' .. vim.fn.expand('%:t:r'),
                    cmd = { 'julia', '--project@.', vim.fn.expand('%:p') },
                  }
                end,
                condition = { filetype = 'julia' },
              },
            }
          end,
        },
      },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    optional = true,
    opts = {
      ft_repls = {
        julia = {
          cmd = { 'julia', '--project=@.' },
        },
      },
    },
  },
}
