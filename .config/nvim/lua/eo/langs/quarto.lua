---@module "lazy"
---@type LazySpec
return {
  {
    'quarto-dev/quarto-nvim',
    -- event = { 'BufNewFile', 'BufReadPre' },
    ft = { 'quarto', 'markdown' },
    cmd = {
      'QuartoPreview',
      'QuartoClosePreview',
      'QuartoHelp',
      'QuartoActivate',
      'QuartoDiagnostics',
      'QuartoSend',
      'QuartoSendAbove',
      'QuartoSendBelow',
      'QuartoSendAll',
      'QuartoSendLine',
    },
    keys = {
      -- {
      --   '<leader>rc',
      --   function()
      --     local runner = require('quarto.runner')
      --     return runner.run_cell
      --   end,
      --   -- [[:QuartoSend<CR>]],
      --   ft = 'quarto',
      --   desc = 'run cell',
      -- },
      {
        '<leader>rc',
        function() return require('quarto.runner').run_cell() end,
        -- [[:QuartoSend<CR>]],
        ft = 'quarto',
        desc = 'run cell',
      },
      {
        '<leader>rr',
        function() return require('quarto.runner').run_range() end,
        ft = 'quarto',
        desc = 'run visual range',
        mode = { 'x', 'v' },
      },
      {
        '<localleader>qq',
        function() require('quarto').quartoPreview() end,
        ft = 'quarto',
        desc = 'Open quarto preview',
      },
      {
        '<localleader>qc',
        function() require('quarto').quartoClosePreview() end,
        ft = 'quarto',
        desc = 'Close quarto preview',
      },
      {
        '<localleader>qw',
        function() require('quarto').quartoPreviewNoWatch() end,
        ft = 'quarto',
        desc = 'Open quarto preview (no watch)',
      },
      {
        '<localleader>qu',
        function() require('quarto').quartoUpdatePreview() end,
        ft = 'quarto',
        desc = 'Update quarto preview',
      },
    },
    dependencies = {
      'jmbuhr/otter.nvim',
      'vim-pandoc/vim-pandoc-syntax',
      'akinsho/toggleterm.nvim',
      'saghen/blink.compat',
    },
    opts = {
      closePreviewOnExit = true,
      lspFeatures = {
        enabled = true,
        chunks = 'all', -- 'all', 'curly'
        languages = { 'python', 'julia', 'bash', 'lua', 'r' },
        diagnostics = {
          enabled = true,
          triggers = { 'BufWritePost' },
        },
        completion = { enabled = true },
      },
      keymap = {
        hover = 'K',
        definition = 'gd',
        rename = '<leader>rn',
        references = 'gr',
        format = '<M-f>',
      },
      codeRunner = {
        enabled = true,
        default_method = 'slime', -- "molten", "slime", "iron" or <function>
        -- filetype to runner, ie. `{ python = "molten" }`.
        -- ft_runners = {
        --   -- { julia = function() require('smuggler') end },
        --   { python = 'iron' },
        --   { julia = 'iron' },
        -- },
        -- Takes precedence over `default_method`
        never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
      },
    },
    config = function(_, opts)
      vim.g['pandoc#syntax#conceal#use'] = true
      vim.g['pandoc#syntax#codeblock#embeds#use'] = true
      vim.g['pandoc#syntax#conceal#blacklist'] = { 'codeblock_delim', 'codeblock_start' }
      vim.g['tex_conceal'] = 'gm'
      require('quarto').setup(opts)
    end,
  },
  {
    'jmbuhr/otter.nvim',
    -- ft = { 'markdown', 'quarto' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'neovim/nvim-lspconfig', 'saghen/blink.compat' },
    event = { 'BufRead' },
    opts = {
      -- NOTE: these settings are from dsully: https://github.com/dsully/nvim/blob/main/lua/plugins/otter.lua
      -- except for the flake.nix file
      lsp = {
        -- `:h events` that cause the diagnostics to update. Set to:
        -- { "BufWritePost", "InsertLeave", "TextChanged" } for less performant
        -- but more instant diagnostic updates
        diagnostic_update_events = { 'BufWritePost' },
        -- function to find the root dir where the otter-ls is started
        root_dir = function(_, bufnr)
          return vim.fs.root(bufnr or 0, {
            '.git',
            -- 'flake.nix',
            'package.json',
            'pyproject.toml',
            '_quarto.yml',
            'package.json',
          }) or vim.fn.getcwd(0)
        end,
      },
      buffers = {
        -- if set to true, the filetype of the otterbuffers will be set.
        -- otherwise only the autocommand of lspconfig that attaches
        -- the language server will be executed without setting the filetype
        --- this setting is deprecated and will default to true in the future
        -- set_filetype = false,
        -- write <path>.otter.<embedded language extension> files
        -- to disk on save of main buffer.
        -- useful for some linters that require actual files.
        -- otter files are deleted on quit or main buffer close
        write_to_disk = true,
        -- a table of preambles for each language. The key is the language and the value is a table of strings that will be written to the otter buffer starting on the first line.
        preambles = {},
        -- a table of postambles for each language. The key is the language and the value is a table of strings that will be written to the end of the otter buffer.
        postambles = {},
        -- A table of patterns to ignore for each language. The key is the language and the value is a lua match pattern to ignore.
        -- lua patterns: https://www.lua.org/pil/20.2.html
        ignore_pattern = {
          -- ipython cell magic (lines starting with %) and shell commands (lines starting with !)
          python = '^(%s*[%%!].*)',
        },
      },
      -- list of characters that should be stripped from the beginning and end of the code chunks
      strip_wrapping_quote_characters = { "'", '"', '`' },
      -- remove whitespace from the beginning of the code chunks when writing to the ottter buffers
      -- and calculate it back in when handling lsp requests
      handle_leading_whitespace = true,
      -- mapping of filetypes to extensions for those not already included in otter.tools.extensions
      -- e.g. ["bash"] = "sh"
      extensions = {},
      -- add event listeners for LSP events for debugging
      debug = false,
      verbose = { -- set to false to disable all verbose messages
        no_code_found = false, -- warn if otter.activate is called, but no injected code was found
      },
    },
  },
  -- {
  --   'stevearc/overseer.nvim',
  --   ---@module "eo.plugs.overseer"
  --   ---@type OverseerUserConfig
  --   opts = {
  --     extra_templates = {
  --       quarto = {
  --         name = quarto,
  --         generator = function(_, cb)
  --           ---@class Params
  --           ---@field render_on_save boolean
  --           ---@field open_output boolean
  --
  --           local TAG = require('overseer.constants').TAG
  --           local quarto_params = {
  --             render_on_save = {
  --               type = 'boolean',
  --               name = 'Watch for file changes',
  --               desc = 'Rerender the notebook every time the file changes',
  --               default = true,
  --             },
  --             open_output = {
  --               type = 'boolean',
  --               name = 'Show on startup',
  --               desc = 'Open the task view when it starts',
  --               default = true,
  --             },
  --           }
  --
  --           ---Check for `render-on-save: false` in _quarto.yml or the current qmd file
  --           ---@param user_preference boolean If the user would actually like to render on save
  --           ---@param root_dir string The root directory of the project
  --           ---@return boolean -- The user's choice, unless the file or project disables it
  --           local render_on_save_enabled = function(user_preference, root_dir)
  --             if user_preference then
  --               local lines
  --               if root_dir then
  --                 local quarto_config = root_dir .. '/_quarto.yml'
  --                 lines = vim.fn.readfile(quarto_config)
  --               else
  --                 -- assumption: the yaml header isnt longer than a generous 500 lines
  --                 lines = vim.api.nvim_buf_get_lines(0, 0, 500, false)
  --               end
  --               local query = 'render%-on%-save: false'
  --               for _, line in ipairs(lines) do
  --                 if line:find(query) then return false end
  --               end
  --             end
  --             return user_preference
  --           end
  --
  --           ---Build a quarto file preview task
  --           ---@param params Params The overseer task parameters
  --           ---@param mode
  --           ---| "file" Render the current file only
  --           ---| "project" Render the entire project
  --           ---@return overseer.TaskDefinition
  --           local quarto_preview = function(params, mode)
  --             -- Find root dirs / chk if its a project
  --             local buffer_path = vim.fn.expand('%:p')
  --             local root_dir = require('quarto.util').root_pattern('_quarto.yml')(buffer_path)
  --             local args = {}
  --             local name
  --             local components = { 'default', 'unique_replace' }
  --
  --             if mode == 'file' then
  --               name = 'Render ' .. vim.fn.expand('%:t:r')
  --               vim.list_extend(args, { buffer_path })
  --             else
  --               name = 'Render project'
  --             end
  --
  --             local render_on_save = render_on_save_enabled(params.render_on_save, root_dir)
  --             if not render_on_save then
  --               name = name .. ' (no watch)'
  --               vim.list_extend(args, { '--no-watch-inputs' })
  --             end
  --
  --             if params.open_output then vim.list_extend(components, { 'open_output' }) end
  --
  --             ---@type overseer.TaskDefinition
  --             return {
  --               name = name,
  --               cmd = { 'quarto', 'preview' },
  --               args = args,
  --               components = components,
  --             }
  --           end
  --
  --           ---@type fun(search: overseer.SearchParams): boolean, nil|string
  --           local is_quarto_file = function(_)
  --             local file_extension = vim.fn.expand('%:e')
  --             if not file_extension then return false, 'Not in a file. exiting.' end
  --             local quarto_extensions = { 'qmd', 'Rmd', 'ipynb', 'md' }
  --             if not vim.list_contains(quarto_extensions, file_extension) then
  --               return false, 'Not a quarto file, ends in ' .. file_extension .. ' exiting.'
  --             end
  --             return true
  --           end
  --
  --           ---@type fun(search: overseer.SearchParams): boolean, nil|string
  --           local is_quarto_project = function(_)
  --             local root_dir = require('quarto.util').root_pattern('_quarto.yml')(vim.fn.expand('%:p'))
  --             return root_dir ~= nil
  --           end
  --
  --           cb {
  --             {
  --               name = 'Preview file',
  --               ---@type overseer.TemplateBuildOpts
  --               builder = function(params) return quarto_preview(params, 'file') end,
  --               params = quarto_params,
  --               condition = {
  --                 callback = is_quarto_file,
  --               },
  --               tags = { TAG.BUILD },
  --             },
  --             {
  --               name = 'Preview project',
  --               builder = function(params) return quarto_preview(params, 'project') end,
  --               params = quarto_params,
  --               condition = {
  --                 callback = is_quarto_project,
  --               },
  --             },
  --           }
  --         end,
  --       },
  --     },
  --   },
  -- },
}
