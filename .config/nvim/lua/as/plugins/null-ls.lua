return function()
  local null_ls = require('null-ls')
  null_ls.setup({
    debounce = 150,
    sources = {
      null_ls.builtins.formatting.black, -- .with({ extra_args = { '--fast', '-' } }),
      -- null_ls.builtins.formatting.black.with({ extra_args = { '--fast', '-' } }),
        -- extra_args = function(_)
        --   return {
        --     '--target-version',
        --     'py39',
        --     '--fast',
        --     '--quiet',
        --     '-'
        --   }
        -- end,
      null_ls.builtins.diagnostics.flake8.with({
        extra_args = { '--config', vim.fs.normalize('~/.flake8') },
        runtime_condition = function()
          return vim.fn.executable('pipx run flake8')
        end
        -- condition = function() return vim.fn.executable('flake8') end,
      }),

      null_ls.builtins.formatting.cbfmt:with({
        condition = function() return as.executable('cbfmt') end,
      }),

      ----- markdown -----
      null_ls.builtins.formatting.prettier.with({
        filetypes = { 'html', 'json', 'yaml', 'markdown', 'toml' },
        condition = function() return as.executable('prettier') end,
      }),

      ---- shell ----
      null_ls.builtins.diagnostics.zsh,
      -- null_ls.builtins.code_actions.shellcheck,
      null_ls.builtins.formatting.shfmt.with({
        filetypes = { "zsh", "sh", "bash" },
        extra_args = { "-s", "-i", "4" },
        condition = function() return as.executable("shfmt") end
      }),

      ---- lua -----
      null_ls.builtins.formatting.stylua.with({
        -- extra_args = { '--config-path', vim.fs.normalize('~/.config/stylua/stylua.toml') },
        -- condition = function() return vim.fn.executable('stylua') end,
        condition = function()
          return as.executable('stylua')
            and not vim.tbl_isempty(vim.fs.find({ '.stylua.toml', 'stylua.toml'}, {
              path = vim.fn.expand('%:p'),
              upward = true,
            }))
        end,
      }),
    },
  })
end
