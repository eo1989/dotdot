return function()
  local null_ls = require('null-ls')
  null_ls.setup({
    debounce = 150,
    sources = {
      -- null_ls.builtins.diagnostics.ruff,
      -- null_ls.builtins.formatting.black, -- .with({ extra_args = { '--fast', '-' } }),
      null_ls.builtins.formatting.black, -- defaults are just fine
      null_ls.builtins.diagnostics.flake8.with({
        -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        extra_args = { '--config', vim.fn.expand('~/.flake8') },
        runtime_condition = function()
          return vim.fn.executable('flake8')
        end
        -- condition = function() return vim.fn.executable('flake8') end,
      }),

      null_ls.builtins.formatting.cbfmt:with({
        -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        condition = function() return as.executable('cbfmt') end,
        extra_args = {
          -- '--stdin-filepath',
          -- '$FILNAME',
          -- '--best-effort',
          '--config',
          string.format('%s/.config/cbfmt.toml', vim.env.HOME),
        },
      }),

      ----- markdown -----
      null_ls.builtins.formatting.prettier.with({
        -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        filetypes = { 'html', 'json', 'yaml', 'markdown', 'toml' },
        condition = function() return as.executable('prettier') end,
      }),

      null_ls.builtins.hover.dictionary.with({
        filetypes = { 'org', 'norg', 'text', 'markdown', 'quarto' }
      }),

      ---- shell ----
      null_ls.builtins.diagnostics.zsh.with({
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE
      }),
      -- null_ls.builtins.code_actions.shellcheck,
      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.formatting.beautysh.with({
        extra_args = { '--indent-size', '4' },
      }),

      null_ls.builtins.formatting.shellharden,

      -- null_ls.builtins.formatting.shfmt.with({
      --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      --   filetypes = { "zsh", "sh", "bash" },
      --   extra_args = { "-i", "4", "-ci" },
      --   condition = function() return as.executable("shfmt") end
      -- }),

      null_ls.builtins.hover.printenv.with({
        filetypes = { 'zsh', 'sh', 'bash', 'dosbatch', "ps1" }
      }),

      ---- env files ----
      null_ls.builtins.diagnostics.dotenv_linter,

      ---- lua -----
      null_ls.builtins.formatting.stylua.with({
        extra_args = { '--config-path', vim.fn.expand('~/.config/stylua/stylua.toml') },
        condition = function()
          return vim.fn.executable('stylua')
        end
      }),
      ---- sql -----
      null_ls.builtins.diagnostics.sqlfluff.with({
        extra_args = { '--dialect', 'postgres' }, -- mysql, postgres, sql?
      }),
      null_ls.builtins.formatting.sql_formatter,
      null_ls.builtins.formatting.sqlformat,
    },
  })
end
