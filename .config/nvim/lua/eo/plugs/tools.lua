local api, fs, fmt, uv = vim.api, vim.fs, string.format, vim.uv
local config = vim.env.HOME .. '/.config'
-- local config = function() return uv.os_homedir() .. '/.config' end
-- print(config)
return {
  {
    'stevearc/conform.nvim',
    event = { 'LspAttach', 'BufWritePre' },
    -- event = 'VeryLazy',
    -- cmd = { 'ConformInfo' },
    -- from stevearc/dotfiles/blob/master/.config/nvim/lua/plugins/format.lua
    -- && LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/formatting.lua
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    keys = {
      {
        '=',
        function()
          require('conform').format({ async = true, lsp_fallback = true }, function(err)
            if not err then
              if vim.startswith(api.nvim_get_mode().mode:lower(), 'v') then
                api.nvim_feedkeys(api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
              end
            end
          end)
        end,
        mode = '',
        desc = 'Format Buffer',
      },
    },
    opts = {
      format = {
        timeout_ms = 500,
        async = true,
        quiet = false, -- for now
      },
      log_level = vim.log.levels.ERROR,
      format_after_save = { lsp_fallback = true },
      format_on_save = { timeout_ms = 500, lsp_fallback = false },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = function(bufnr)
          if require('conform').get_formatter_info('ruff_format', bufnr).available then
            return { 'ruff_format' }
          else
            return { 'black' }
          end
        end,
        yaml = { { 'yamlfmt', 'prettier', 'yq' }, 'prettierd' },
        json = { { 'jq', 'dprint', 'prettier' }, 'prettierd' },
        markdown = { { 'injected', 'cbfmt', 'mdformat' }, 'markdownlint', 'prettierd' },
        norg = { 'injected' },
        -- sh = { { 'beautysh', 'shfmt' } },
        sh = function(bufnr)
          if require('conform').get_formatter_info('beautysh', bufnr).available then
            return { 'beautysh' }
          else
            return { 'shfmt' }
          end
        end,
        pgsql = { { 'pg_format', 'sqlfluff' } },
        sql = { { 'sql_formatter', 'sqlfmt', 'sqlfluff' } },
        toml = { { 'dprint', 'taplo' },  'prettierd' },
        ['_'] = { 'trim_newlines', 'trim_whitespace' },
        -- ['*'] = { 'trim_whitespace' },
      },
      formatters = {
        injected = {
          options = {
            ignore_errors = false,
            -- map of ts lang to file extension
            -- temp file name with this extension will be generated during formatting
            -- because some formatters care about the filename
            lang_to_ext = {
              bash = 'sh',
              c_sharp = 'cs',
              julia = 'jl',
              latex = 'tex',
              markdown = 'md',
              -- python = 'py',
              ruby = 'rb',
              rust = 'rs',
              teal = 'tl',
              r = 'r',
            },
            -- map of ts lang to formatters to use
            -- (defaults to the value from formatters_by_ft)
            lang_to_formatters = {
              python = 
            },
          },
        },
        stylua = {
          -- name = 'stylua',
          cmd = 'stylua',
          -- args = { '-s', '-' },
          args = { '--config-path', config .. '/nvim/stylua.toml', '-' },
          -- args = { '--config-path', config .. '/stylua/stylua.toml' },
          -- condition = function(ctx)
          --   return fs.find({ 'stylua.toml' }, {
          --     upward = true,
          --     path = ctx.filename,
          --     stop = uv.os_homedir(),
          --   })[1]
          -- end,
        },
        dprint = {
          cmd = 'dprint',
          condition = function(ctx)
            return fs.find({ 'dprint.json', 'dprint.toml' }, {
              upward = true,
              path = ctx.filename,
              stop = uv.os_homedir(),
            })[1]
          end,
        },
        shfmt = {
          prepend_args = { '-i', '4', '-ci' },
        },
        black = {
          prepend_args = { '-t', 'py312' },
          args = { '--fast', '--ipynb' },
        },
      },
    },
    config = function(_, opts)
      -- if vim.g.started_by_firenvim then
      --   opts.format_on_save = false
      --   opts.format_after_save = false
      -- end
      require('conform').setup(opts)
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    -- event = 'BufWritePost',
    init = function()
      -- api.nvim_create_autocmd({ 'TextChanged', 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
      api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
        callback = function(args)
          if args.file:match('/(node_modules|__pypackages__|site_packages)/') then return end
          if not vim.g.large_file then require('lint').try_lint() end
        end,
        group = api.nvim_create_augroup('nvim-lint', { clear = true }),
      })
    end,
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        python = { 'ruff', 'flake8' }, --'pylint' 'flake8' 'mypy' 'ruff'
        -- markdown = { 'markdownlint_cli2' },
        markdown = { 'markdownlint' },
        sql = { 'sqlfluff' },
        yaml = { 'yamllint' },
        ['*'] = { 'typos' },
      }
      lint.linters = {
        zsh = {
          cmd = 'zsh',
          args = { '-n' },
        },
        sqlfluff = {
          cmd = 'sqlfluff',
          pre_args = { '--dialect', 'ansi' },
          args = { 'lint' },
        },
        markdownlint = {
          cmd = 'markdownlint',
          args = function()
            -- local config = vim.env.HOME .. '/.config'
            -- return fmt('--config=%s/markdownlint/.markdownlint.jsonc', config)
            -- return fmt('--config=%s/markdownlint/.markdownlint.yaml', config)
            return fmt('--config=%s/nvim/markdownlint.yaml', config)
          end,
        },
        markdownlint_cli2 = {
          cmd = 'markdownlint-cli2',
          args = function()
            -- local config = vim.env.HOME .. '/.config'
            return fmt('--config=%s/markdownlint-cli2/.markdownlint-cli2.jsonc', config)
          end,
        },
        yamllint = {
          name = 'yamllint',
          cmd = 'yamllint',
          env = { 'YAMLLINT_CONFIG_FILE' },
          args = function() return fmt('-c=%s/yamllint/config', config) end,
        },
        -- selene = {
        --   cmd = 'selene',
        --   args = {
        --     '-q',
        --     function()
        --       return fmt('--config=%s/nvim/selene.toml', config)
        --       -- return vim.fs.find({ 'selene.toml', '.selene.toml' }, { path = ctx.filename, upward = true })[1]
        --     end,
        --   },
        -- },
        -- ruff = {
        --   cmd = 'ruff check',
        --   args = {
        --     function(ctx) return fs.find({ 'ruff.toml', 'pyproject.toml' }, { path = ctx.filename, upward = true })[1] end,
        --   },
        -- },
        -- pflake8 = {
        --   name = 'pflake8',
        --   cmd = 'pflake8',
        --   args = {
        --     function()
        --       return fmt('--config=%s/flake8', config)
        --       -- return vim.fs.find({ 'flake8', '.flake8' }, { path = ctx.filename, upward = true })[1]
        --     end,
        --   },
        -- },
      }
    end,
  },
}
