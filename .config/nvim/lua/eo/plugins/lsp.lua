---@diagnostic disable: redefined-local
local defaults, eo_icons, default_bar_separator =
  require('defaults'), eo.ui.icons.lsp, require('defaults').icons.separators.bar
local api, fmt = vim.api, string.format
local conffigy = vim.fn.stdpath('config')

-- local pathlib = require('pathlib')
-- local conffigy = pathlib.home() .. '/.config'

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    -- cmd = 'LazyDev',
    -- event = { 'LspAttach', 'VeryLazy' },

    priorty = 1000,
    lazy = false,
    dependencies = {
      'Bilal2453/luvit-meta',
    },
    opts = {
      -- integrations = { cmp = true, lspconfig = true },
      integrations = { cmp = true, lspconfig = false },
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks', 'snacks' } },
        { path = 'blink.nvim', words = { 'blink' } },
        { path = 'lazy.nvim', words = { 'LazyConfig', 'LazySpec', 'package' } },
        { vim.env.VIMRUNTIME },
        { 'luvit-meta/library' },
        { path = 'which-key.nvim', words = { 'wk' } },
      },
    },
    -- config = function(_, opts) require('lazydev').setup(opts) end,
  },
  {
    'DNLHC/glance.nvim',
    enabled = true,
    -- event = { 'LspAttach' },
    cmd = 'Glance',
    config = function()
      local glance = require('glance')
      local actions = require('glance').actions

      -- glance.register_method {
      --   method = 'julials/client/typeHierarchy',
      -- }

      glance.setup {
        preserve_win_context = true,
        detached = function(winid) return vim.api.nvim_win_get_width(winid) < 100 end,
        preview_win_opts = {
          relativenumber = false,
          number = true,
          wrap = true,
          cursorline = true,
        },
        list = {
          width = 0.20,
        },
        folds = {
          folded = true,
          fold_closed = eo.ui.icons.misc.caret_right,
          fold_open = defaults.icons.fold.open,
          -- fold_closed = default.icons.fold.closed,
          -- fold_open = eo.ui.icons.misc., -- i dont have a arrow or chevron down arrow :(
        },
        winbar = { enable = true },
        indent_lines = {
          enable = true,
        },
        height = 18, -- 32 -> default = 18
        zindex = 45, -- 45 -> default
        border = {
          enable = false, -- adds extra space and looks ghastly
          top_char = '▁',
          bottom_char = '▔',
        },
        theme = {
          enable = true,
          -- mode = 'darken',
        },
      }
    end,
  },
  { 'b0o/schemastore.nvim', event = { 'LspAttach', 'VeryLazy' } },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufRead' },
    -- lazy = false,
    version = false,
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      require('eo.lsp')

      -- local capabilities = nil
      -- local blink = require('blink.cmp')

      -- if pcall(require, 'blink.cmp') then
      -- capabilities = require('blink.cmp').get_lsp_capabilities {

      -- capabilities = blink.get_lsp_capabilities {
      --   textDocument = {
      --     foldingRange = {
      --       dynamicRegistration = false,
      --       lineFoldingOnly = true,
      --     },
      --     completion = {
      --       completionItem = {
      --         contextSupport = true,
      --         snippetSupport = true,
      --         deprecatedSupport = true,
      --         commitCharacterSupport = true,
      --         resolveSupport = {
      --           properties = {
      --             'documentation',
      --             'detail',
      --             'additionalTextEdits',
      --           },
      --         },
      --         labelDetailsSupport = true,
      --         documentationFormat = { 'markdown', 'plaintext' },
      --       },
      --     },
      --     semanticTokens = { multilineTokenSupport = true },
      --   },
      --   workspace = {
      --     didChangeWatchedFiles = { dynamicRegistration = false },
      --     diagnostics = { refreshSupport = true },
      --   },
      --   experimental = {
      --     hoverActions = true,
      --     hoverRange = true,
      --     serverStatusNotification = true,
      --     codeActionGroup = true,
      --     ssr = true,
      --     commands = {
      --       'editor.action.triggerParameterHints',
      --     },
      --   },
      -- }

      -- vim.lsp.config('*', {
      --   capabilities = capabilities,
      -- } --[[@as vim.lsp.Config]])

      -- local configured = {
      --   'basedpyright',
      --   'bashls',
      --   'biome',
      --   'gopls',
      --   'dotls',
      --   'jsonls',
      --   'jetls',
      --   'julials',
      --   'lua_ls',
      --   'marksman',
      --   'ruff',
      --   'rumdl',
      --   'rust_analyzer',
      --   'sqls',
      --   'tombi',
      --   'ty',
      --   'postgres_lsp', -- supabase-common/postgres-language-server
      --   'yamlls',
      -- }

      -- 'markdown-oxide',
      -- 'pyrefly',
      -- 'pytest-language-server',
      -- 'pkl',
      -- 'sqlls',
      -- 'taplo',
      -- 'zuban',

      -- vim.iter(configured):each(vim.schedule_wrap(function(server_name) vim.lsp.enable(server_name) end))
    end,
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    -- event = 'VeryLazy',
    priorty = 1000,
    enabled = true,
    lazy = false,
    config = function()
      require('tiny-inline-diagnostic').setup {
        preset = 'modern',
        transparent_bg = true,
        transparent_cursorline = true,
        options = {
          use_icons_from_diagnostic = true,
          multilines = {
            enabled = true,
            always_show = true,
          },
          show_source = {
            enabled = true,
            if_many = true,
          },
          show_code = true,
          softwrap = 30,
          add_messages = {
            display_count = true,
            use_max_severity = true,
          },
        },
      }
      vim.diagnostic.config { virtual_text = false }
    end,
  },
  { 'mrjones2014/lua-gf.nvim', ft = 'lua', lazy = true },
  { 'onsails/lspkind.nvim', event = { 'VeryLazy' } }, -- forgot its needed by neotree :deadass:
  {
    ---@module 'barbecue'
    'utilyre/barbecue.nvim',
    version = false,
    event = { 'LspAttach' },
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      {
        ---@module 'nvim-navic'
        'SmiteshP/nvim-navic',
        event = { 'LspAttach' },
        opts = {
          highlight = true,
          lsp = {
            auto_attach = true,
            preference = { 'basedpyright', 'ty', 'julials', 'jetls' },
            -- preference = { 'basedpyright', 'jetls' },
          },
        },
      },
    },
    opts = function(opts, _)
      local opts = {
        theme = 'auto',
        create_autocmd = false,
        attach_navic = false,
        show_dirname = false,
        show_basename = true,
        -- show_sign = true,
      }
      vim.g.updatetime = 100
      api.nvim_create_autocmd({
        'WinResized',
        'BufWinEnter',
        'CursorHold',
        'InsertLeave',
      }, {
        group = api.nvim_create_augroup('Barbecue.updater', {}),
        callback = function() require('barbecue.ui').update() end,
      })
      require('barbecue').setup(opts, _)
    end,
  },
  {
    'stevearc/conform.nvim',
    version = false,
    event = 'BufWritePre',
    -- from stevearc/dotfiles/blob/master/.config/nvim/lua/plugins/format.lua
    -- && LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/formatting.lua
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    keys = {
      {
        '<M-f>',
        function()
          require('conform').format({ async = true }, function(err)
            if not err then
              if vim.startswith(api.nvim_get_mode().mode:lower(), 'v') then
                api.nvim_feedkeys(api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
              end
              vim.cmd.update()
            end
          end)
        end,
        mode = { 'n', 'x', 'v' },
        desc = 'Format Buffer & Save',
      },
    },
    opts = {
      default_format_opts = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      format = {
        timeout_ms = 500,
        -- async = false,
        quiet = true,
        stop_after_first = true,
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 500, lsp_format = 'fallback', quiet = true, stop_after_first = true }
      end,
      format_after_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { stop_after_first = false, 'ruff_format', 'ruff_fix', 'ruff_organize_imports' },
        json = { stop_after_first = true, 'jq', 'prettier' },
        julia = { stop_after_first = true, lsp_format = 'fallback', 'jlfmt', '_runic' },
        -- markdown = { stop_after_first = true, 'injected', 'mdsf_fmt', 'rumdl_fmt', '_dprint' },
        -- quarto = { stop_after_first = true, 'injected', 'rumdl_fmt', 'mdsf_fmt', '_dprint' },
        markdown = { 'injected' },
        quarto = { 'injected' },
        ['sh'] = { stop_after_first = true, 'beautysh', 'shfmt' }, -- bashls takes care of these already
        zsh = { 'beautysh' },
        pgsql = { stop_after_first = true, 'sql_formatter', 'pg_format', 'sqlfluff_fmt_pgsql', 'sqlfluff' },
        r = { stop_after_first = true, 'styler' },
        sql = {
          'sqlfluff_format',
          'sqruff',
          'sleek',
          'sqlfluff_fix_dbt',
          'sql_formatter',
          'sqlfluff_fix',
          'sqlfluff_fmt_pgsql',
          'sqlfmt',
          stop_after_first = true,
        },
        -- ['sql'] = { 'sleek', 'sqruff', 'sql_formatter', 'sqlfluff', stop_after_first = true },
        toml = { stop_after_first = true, 'tombi', 'prettier', 'taplo' },
        typst = { stop_after_first = true, 'typstyle', 'prettypst' },
        -- yaml = { 'yq', 'prettier', 'yamlfix', 'yamlfmt' },
        yaml = { stop_after_first = true, 'prettier', 'yq', 'yamlfix' },
        -- ['_'] = { 'trim_whitespace', 'trim_newlines', 'squeeze_blanks' },
      },
      formatters = {
        injected = {
          options = {
            ignore_errors = false, -- dont abort if one sell fails
            -- map of ts lang to formatters to use
            -- (defaults to the value from formatters_by_ft)
            -- lang_to_ext = {
            --   bash = 'sh',
            --   c_sharp = 'cs',
            --   elixir = 'exs',
            --   javascript = 'js',
            --   julia = 'jl',
            --   latex = 'tex',
            --   markdown = 'md',
            --   python = 'py',
            --   ruby = 'rb',
            --   rust = 'rs',
            --   teal = 'tl',
            --   r = 'r',
            --   typescript = 'ts',
            -- },
            -- lang_to_formatters = {},
            lang_to_formatters = {
              -- python = { 'ruff_format', 'ruff_fix', 'ruff_organize_imports' },
              -- julia = { '_jlfmt', 'runic', stop_after_first = true },
              julia = { '_jlfmt' },
              -- julia = { lsp_format = 'fallback', 'jl_fmt', 'jlfmt', '_runic', stop_after_first = true }, -- prefer | first
              -- yaml = { 'yq', 'prettier' },
              -- r = { stop_after_first = true, 'air', 'styler' },
            },
          },
        },

        -- User Error: No dialect was specified. You must configure a dialect or specify one on the command line using --dialect after the command. Available dialects:
        -- [[ansi, athena, bigquery, clickhouse, databricks, db2, doris, duckdb, exasol, flink, greenplum, hive, impala, mariadb, materialize, mysql, oracle, postgres, redshift, snowflake, soql, sparksql, sqlite, starrocks, teradata, trino, tsql, vertica]]
        --[[https://github.com/CoreyCole/dotfiles/blob/main/neovim-config/lua/plugins/init.lua]]

        sqlfluff_format = function()
          return {
            command = 'sqlfluff',
            args = { 'format', '-', '--dialect', 'sqlite' },
            stdin = true,
            -- cwd = require('conform.util').root_file {
            --   '.sqlfluff',
            --   'pep8.ini',
            --   'pyproject.toml',
            --   'setup.cfg',
            --   'tox.ini',
            -- },
            require_cwd = true,
          }
        end,
        sqlfluff_fmt_pgsql = function()
          return {
            command = 'sqlfluff',
            args = { 'format', '-', '--dialect', 'postgres' },
            stdin = true,
            cwd = require('conform.util').root_file {
              '.sqlfluff',
              'pyproject.toml',
            },
            require_cwd = true,
          }
        end,
        sqlfluff_fix = function()
          return {
            command = 'sqlfluff',
            args = { 'fix', '-' },
            exit_codes = { 0, 1 }, -- ignore exit code 1 as this occurs when there simply exist unfixable lints
            stdin = true,
            cwd = require('conform.util').root_file {
              '.sqlfluff',
              'pyproject.toml',
            },
            require_cwd = true,
          }
        end,
        sqlfluff_fix_dbt = function()
          return {
            command = 'sqlfluff',
            args = { 'fix', '$FILENAME', '--dialect', 'dbt' },
            exit_codes = { 0, 1 }, -- ignore exit code 1 as this occurs when there simply exist unfixable lints
            stdin = false,
            require_cwd = true,
          }
        end,
        stylua = { args = { '--search-parent-directories', '$FILENAME' }, stdin = false },
        -- mdsf_fmt = function()
        --   return {
        --     command = 'mdsf',
        --     condition = function(_, ctx)
        --       return vim.fs.find({ 'mdsf.json', 'mdsf.toml' }, {
        --         path = ctx.filename,
        --         upward = true,
        --       })[1]
        --     end,
        --     cwd = require('conform.util').root_file {
        --       'mdsf.json',
        --       'mdsf.toml',
        --     },
        --     require_cwd = false,
        --     args = {
        --       '--stdin',
        --       '$FILENAME',
        --     },
        --     prepend_args = {
        --       '--on-missing-language-definition',
        --       'ignore',
        --       '--on-missing-tool-binary',
        --       'ignore',
        --     },
        --     stdin = false,
        --   }
        -- end,
        shfmt = { command = 'shfmt', args = { '-i', '4', '-ci' } },
        sqruff = {
          command = 'sqruff',
          args = { 'fix', '$FILENAME' },
          stdin = false,
          require_cwd = false,
          cwd = function(_, ctx)
            local buf_path = api.nvim_buf_get_name(ctx.buf)
            if #buf_path > 0 then return vim.fs.root(buf_path, { '.sqruff' }) end
          end,
        },
        sqlformatter = function()
          require('conform.formatters.sql_formatter').args = function(ctx)
            local config_path = ctx.dirname .. '/.sql-formatter.json'
            if vim.uv.fs_stat(config_path) then return { '--config', config_path } end
            return { '--language', 'postgresql' }
          end
        end,

        --[[=[
        NOTE: looks for .JuliaFormatter.toml; to turn off formatting use `#! format:off/on`
        --]=]]

        _jlfmt = function()
          return {
            command = 'jlfmt',
            cwd = require('conform.util').root_file { '.JuliaFormatter.toml' },
            -- prepend_args = { '--prioritize-config-file' },
            args = {
              '--style',
              'sciml',
              -- '--margin',
              -- '92',
              -- '--diff',
              -- '--check',
              -- '--format-markdown',
              '--inplace',
              '--stdin-filename',
              '$FILENAME',
            },
            stdin = true,
          }
        end,
        jlfmt = function()
          return {
            command = 'jlfmt',
            cwd = require('conform.util').root_file { '.JuliaFormatter.toml' },
            -- prepend_args = { '--prioritize-config-file' },
            args = {
              '--style',
              'sciml',
              -- '--margin',
              -- '92',
              -- '--diff',
              -- '--check',
              -- '--format-markdown',
              '--inplace',
              '--stdin-filename',
              '$FILENAME',
            },
            stdin = false,
          }
        end,
        rumdl_fmt = function()
          return {
            command = 'rumdl',
            args = { 'fmt', '$FILENAME' },
            -- stdin = true,
            condition = function(_, ctx)
              return vim.fs.find({ 'rumdl.toml', '.rumdl.toml' }, {
                path = ctx.filename,
                upward = true,
              })[1]
            end,
            cwd = require('conform.util').root_file {
              '.rumdl.toml',
              'rumdl.toml',
            },
            stdin = false,
            require_cwd = false,
          }
        end,
        _dprint = function()
          return {
            command = 'dprint',
            args = { 'fmt', '--incremental', '$FILENAME' },
            condition = function(_, ctx)
              return vim.fs.find({ 'dprint.json', 'dprint.toml' }, {
                path = ctx.filename,
                upward = true,
              })[1]
            end,
            cwd = require('conform.util').root_file { 'dprint.json', 'dprint.toml' },
            require_cwd = false,
          }
        end,
        _runic = {
          command = 'runic',
          -- args = { '--startup-file=no', '--project=@runic', '-e', 'using Runic; exit(Runic.main(ARGS))' },
          args = { '--inplace', '--stdin-filename', '$FILENAME' },
          stdin = false,
        },
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)
      eo.command(
        'Format',
        function(x)
          require('conform').format {
            async = true,
            lsp_format = 'fallback',
            formatting_options = {
              name = x.fargs[1],
              range = x.range == 0 and nil or {
                ['start'] = { x.line1, 0 },
                ['end'] = { x.line2, 0 },
              },
            },
          }
        end,
        { nargs = '?', range = '%', desc = 'LSP Format' }
      )
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = 'BufReadPre',
    init = function()
      -- vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'BufReadPost', 'OptionSet' }, {
      vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'Optionset' }, {
        group = api.nvim_create_augroup('Lint', { clear = true }),
        callback = function(args)
          -- if vim.opt_local.modifiable:get() then require('lint').try_lint() end
          if not vim.g.linting then return end

          if vim.tbl_contains(defaults.ignored.buffer_types, vim.bo.buftype) then return end

          if vim.tbl_contains(defaults.ignored.file_types, vim.bo.filetype) then return end

          -- Ignore 3rd party code.
          if args.file:match('/(node_modules|__pypackages__|site_packages|cargo/registry)/') then return end

          require('lint').try_lint()
          lint.try_lint('typos')
        end,
      })
    end,
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        -- go = { 'revive' },
        -- gitcommit = { 'commitlint' },
        lua = { 'stylua' },
        -- github = { 'actionlint' },
        -- markdown = { 'mado', 'markdownlint-cli2', 'typos' },
        -- quarto = { 'mado', 'markdownlint-cli2', 'typos' },
        -- markdown = { 'rumdl_lint', 'mado_lint' },
        -- quarto = { 'rumdl_lint', 'mado_lint' },
        markdown = { 'rumdl_lint' },
        quarto = { 'rumdl_lint' },
        python = { 'ruff' },
        rst = { 'rstcheck', 'sphinx-lint' },
        sql = { 'sqruff', 'sqlfluff_lint', 'sqlfluff_lint_pgsql' },
        -- text = { 'write_good' },
        yaml = { 'yamllint' },
      }
      lint.linters = {
        rumdl_lint = {
          cmd = 'rumdl',
          -- args = { '--config', conffigy .. '/rumdl.toml', 'check' },
          args = function() return fmt('--config=%s/rumdl.toml', conffigy, 'check') end,
          ignore_exitcode = true,
          stream = 'stdout',
          stdin = true,
          parser = require('lint.parser').from_errorformat('(stdin):%l%c: %m', {
            source = 'rumdl',
            severity = vim.diagnostic.severity.WARN,
          }),
        }, --[[@as lint.Linter ]]
        mado_lint = {
          cmd = 'mado',
          -- args = { '--config', conffigy .. '/mado.toml', 'check' },
          args = function() return fmt('--config=%s/mado.toml', conffigy, 'check') end,
          ignore_exitcode = true,
          stream = 'stdout',
          stdin = true,
          parser = require('lint.parser').from_errorformat('(stdin):%l%c: %m', {
            source = 'mado',
            severity = vim.diagnostic.severity.WARN,
          }),
        }, --[[@as lint.Linter ]]
        -- ruff = {
        --   cmd = 'ruff',
        --   -- name = 'rufff',
        --   -- args = function() return fmt('--config=%s/nvim/pyproject.toml', configgy) end,
        --   -- args = { '--config=/Users/eo/.config/nvim/pyproject.toml' },
        --   -- condition = function(ctx)
        --   --   local root =
        --   --     require('lspconfig.util').root_pattern({ 'ruff.toml', 'pyproject.toml', 'uv.toml' }, ctx.filename)
        --   --   if root ~= vim.uv.cwd() then return false end
        --   --   return vim.fs.find({ 'ruff.toml', 'pyproject.toml', 'uv.toml' }, { path = root, upward = true })[1]
        --   -- end,
        -- },
        stylua = {
          append_fname = true,
          args = { '--check', '$FILENAME' },
          stdin = false,
        },
        sqlfluff_lint_pgsql = {
          cmd = 'sqlfluff',
          args = { 'lint', '--disable-progress-bar', '--nocolor', '--nofail', '--dialect=postgres' },
        },
        sqlfluff_lint = {
          cmd = 'sqlfluff',
          args = { 'lint', '--disable-progress-bar', '--nocolor', '--nofail', '--dialect=ansi' },
        },
        sqruff = {
          cmd = 'sqruff',
          args = { 'lint', '-' },
        },
        markdownlint = {
          cmd = 'markdownlint',
          -- args = function() return fmt('--config=%s/nvim/markdownlint.yaml', configgy .. '--fix', '**/*.md') end,
          args = function() return fmt('--config=%s/nvim/markdownlint.yaml', conffigy .. '--fix', '.') end,
        },
        ['markdownlint-cli2'] = {
          cmd = 'markdownlint-cli2',
          args = function()
            -- return fmt('--config=%s/markdownlint-cli2/.markdownlint-cli2.jsonc', configgy .. '--fix', '**/*.md')
            return fmt('--config=%s/markdownlint-cli2/.markdownlint-cli2.jsonc', conffigy .. '--fix', '.')
          end,
        },
        yamllint = {
          cmd = 'yamllint',
          env = { '$YAMLLINT_CONFIG_FILE' },
          args = function() return fmt('-c=%s/yamllint/yamllint.yaml', conffigy .. '--format' .. 'auto') end,
          --[[ -f/--format={parsable,standard,colored,github,auto} ]]
          -- args = function() return fmt('-c=%s/yamllint/config', configgy) end,
        },
      }
    end,
  },
}

--[[
whats your opinion of 'em?

well, you know i usually pride myself on refraining from profanity
around the ladies. But not with
]]

-- {
--   'dgagn/diagflow.nvim',
--   enabled = false,
--   -- lazy = true,
--   event = 'DiagnosticChanged',
--   version = false,
--   config = function() require('diagflow').setup(diag_opts) end,
--   -- event = 'LspAttach',
--   -- opts = {
--   --   enable = function() return vim.bo.filetype ~= 'lazy' end,
--   --   scope = 'line', -- 'cursor' | 'line'
--   --   show_sign = true,
--   --   placement = 'top',
--   --   update_event = {
--   --     'DiagnosticChanged',
--   --     'BufEnter',
--   --     'TextChanged',
--   --   },
--   --   render_event = {
--   --     'DiagnosticChanged',
--   --     'BufEnter',
--   --     'TextChanged',
--   --     'CursorMoved',
--   --     'CursorHold',
--   --   },
--   -- },
-- },

-- local diag_opts = {
--   enable = function(bufnr) return vim.bo[bufnr].filetype ~= 'lazy' end,
--   placement = 'top',
--   scope = 'line',
--   update_event = {
--     'DiagnosticChanged',
--     'TextChanged',
--     'BufEnter',
--   },
--   render_event = {
--     'DiagnosticChanged',
--     'TextChanged',
--     'CursorMoved',
--     'CursorHold',
--     'BufEnter',
--   },
--   format = function(diag)
--     local levels = {
--       [1] = 'Error',
--       [2] = 'Warn',
--       [3] = 'Info',
--       [4] = 'Trace',
--     }
--
--     local icons = eo_icons[levels[diag.severity]]
--     return fmt('%s%s%s', icon or '', icon and ' ' or '', diag.message or '')
--   end,
-- }
-- local toggle = require("snacks").toggle.new({
--   name = "ormat on save",
--   get = function()
--     return not vim.g.disable_autoformat
--   end,
--   set = function(enabled)
--     vim.g.disable_autoformat = not enabled
--   end,
-- })
-- toggle:map("<leader>uf")
