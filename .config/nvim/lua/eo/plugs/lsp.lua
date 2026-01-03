---@diagnostic disable: redefined-local
local defaults, eo_icons, default_bar_separator =
  require('defaults'), eo.ui.icons.lsp, require('defaults').icons.separators.bar
local api, fmt = vim.api, string.format
-- local conffigy = vim.fn.stdpath('config')
local pathlib = require('pathlib')
local conffigy = pathlib.home() .. '/.config'

local diag_opts = {
  enable = function() return vim.bo.filetype ~= 'lazy' end,
  placement = 'top',
  scope = 'line',
  update_event = {
    'DiagnosticChanged',
    'TextChanged',
    'BufEnter',
  },
  render_event = {
    'DiagnosticChanged',
    'TextChanged',
    'CursorMoved',
    'CursorHold',
    'BufEnter',
  },
  format = function(diag)
    local levels = {
      [1] = 'Error',
      [2] = 'Warn',
      [3] = 'Info',
      [4] = 'Trace',
    }

    local icons = eo_icons[levels[diag.severity]]
    return fmt('%s%s%s', icon or '', icon and ' ' or '', diag.message or '')
  end,
}

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

---@type LazySpec
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    -- event = { 'LspAttach', 'VeryLazy' },
    dependencies = {
      'Bilal2453/luvit-meta',
    },
    config = function()
      require('lazydev').setup {
        integrations = { lspconfig = true },
        library = {
          {
            path = '${3rd}/luv/library',
            words = { 'vim%.uv' },
          },
          {
            path = 'snacks.nvim',
            words = { 'Snacks' },
          },
          'luvit-meta/library',
          vim.env.VIMRUNTIME,
        },
      }
    end,
  },
  {
    'DNLHC/glance.nvim',
    enabled = true,
    -- event = { 'LspAttach', 'VeryLazy' },
    cmd = 'Glance',
    config = function()
      local glance = require('glance')
      local actions = require('glance').actions

      -- opts = {
      glance.setup { --@diagnostic disable-line:missing-fields
        preserve_win_context = true,
        detached = function(winid) return vim.api.nvim_win_get_width(winid) < 100 end,
        -- preview_win_opts = { relativenumber = false, statuscolumn = '' },
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
          -- fold_closed = default.icons.fold.closed,
          fold_closed = eo.ui.icons.misc.caret_right,
          fold_open = defaults.icons.fold.open,
          -- fold_open = eo.ui.icons.misc., -- i dont have a arrow or chevron down arrow :(
        },
        winbar = { enable = true },
        indent_lines = {
          enable = true,
          icon = default_bar_separator.left,
        },
        height = 32,
        zindex = 50, -- 45 -> default
        border = {
          enable = false, -- adds extra space and looks ghastly
          top_char = '▁',
          bottom_char = '▔',
        },
        theme = {
          enable = true,
          mode = 'darken',
        },
      }
    end,
  },
  { 'b0o/schemastore.nvim' },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    version = false,
    dependencies = {
      'saghen/blink.cmp',
    },
    config = function() require('eo.lsp') end,
    -- init = function() require('eo.lsp') end,
    -- config = function()
    --   -- require('lspconfig.ui.windows').default_options.border = eo.ui.current.border
    --   -- require('eo.lsp.capabilities').make_capabilities()
    --
    --   --[[
    --   select snippets taken from:
    --       https://github.com/dsully/nvim/blob/main/lua/plugins/lsp.lua
    --   --]]
    --   -- local diagnostic, lsp = vim.diagnostic, vim.lsp
    --   -- local ns, signs_handler = api.nvim_create_namespace('severe-diagnostics'), diagnostic.handlers.signs
    --
    --   -- diagnostic.handlers.signs = {
    --   --   show = function(_, bufnr, _, opts)
    --   --     local diags = diagnostic.get(bufnr)
    --   --
    --   --     local max_severity_per_line = {}
    --   --     for _, d in pairs(diags) do
    --   --       local m = max_severity_per_line[d.lnum]
    --   --       if not m or d.severity < m.severity then max_severity_per_line[d.lnum] = d end
    --   --     end
    --   --
    --   --     local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
    --   --     signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
    --   --   end,
    --   --   hide = function(_, bufnr) signs_handler.hide(ns, bufnr) end,
    --   -- }
    --
    --   -- lsp.log.set_level(lsp.log.levels.WARN)
    --   -- diagnostic.config {
    --   --   float = {
    --   --     header = '',
    --   --     focusable = false,
    --   --     severity_sort = true,
    --   --     scope = 'line',
    --   --     spacing = 2,
    --   --     source = true,
    --   --     title = { { eo.ui.icons.lsp.hint, 'DiagnosticloatTitleIcon' }, { 'Problems', 'DiagnosticFloatTitle' } },
    --   --     prefix = function(diag)
    --   --       local level = diagnostic.severity[diag.severity]
    --   --       local prefx = fmt('%s ', eo.ui.icons.lsp[level:lower()])
    --   --       return prefx, 'Diagnostic' .. level:gsub('^%l', string.upper)
    --   --     end,
    --   --   },
    --   --   severity_sort = true,
    --   --   signs = {
    --   --     severity = { min = diagnostic.severity.WARN },
    --   --     text = {
    --   --       [diagnostic.severity.WARN] = eo.ui.icons.lsp.warn,
    --   --       -- [diagnostic.severity.WARN] = defaults.icons.diagnostics.warn,
    --   --       [diagnostic.severity.ERROR] = eo.ui.icons.lsp.error,
    --   --       -- [diagnostic.severity.ERROR] = defaults.icons.diagnostics.error,
    --   --       -- [diagnostic.severity.INFO] = defaults.icons.diagnostics.info,
    --   --       [diagnostic.severity.INFO] = eo.ui.icons.lsp.info,
    --   --       [diagnostic.severity.HINT] = defaults.icons.diagnostics.hint,
    --   --     },
    --   --   },
    --   --   underline = true,
    --   --   update_in_insert = false,
    --   -- }
    --
    --   -- require('eo.lsp')
    --
    --   ---@type table<string, string[]|boolean>?
    --   -- local kind_filter = {
    --   --   default = {
    --   --     "Class",
    --   --     "Constructor",
    --   --     "Enum",
    --   --     "Field",
    --   --     "Function",
    --   --     "Interface",
    --   --     "Method",
    --   --     "Module",
    --   --     "Namespace",
    --   --     "Package",
    --   --     "Property",
    --   --     "Struct",
    --   --     "Trait",
    --   --   },
    --   --   markdown = false,
    --   --   help = false,
    --   --   lua = {
    --   --     "Class",
    --   --     "Constructor",
    --   --     "Enum",
    --   --     "Field",
    --   --     "Function",
    --   --     "Interface",
    --   --     "Method",
    --   --     "Module",
    --   --     "Namespace",
    --   --     -- "Package", -- luals uses it for control flow structures
    --   --     "Property",
    --   --     "Struct",
    --   --     "Trait",
    --   --   },
    --   -- }
    --
    --   -- local register_capability = lsp.handlers["client/registerCapability"]
    --
    --   ---@param res lsp.RegistrationParams
    --   ---@param ctx lsp.HandlerContext
    --   -- lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    --   --   local client_id = ctx.client_id
    --   --   local client = lsp.get_client_by_id(client_id)
    --   --
    --   --   if client ~= nil then
    --   --     for buffer in pairs(client.attached_buffers) do
    --   --       api.nvim_create_autocmd({"User"}, {
    --   --         pattern
    --   --       })
    --   --     end
    --   --   end
    --   -- end
    -- end,
  },
  {
    'dgagn/diagflow.nvim',
    enabled = true,
    -- lazy = true,
    event = 'DiagnosticChanged',
    version = false,
    config = function() require('diagflow').setup(diag_opts) end,
    -- event = 'LspAttach',
    -- opts = {
    --   enable = function() return vim.bo.filetype ~= 'lazy' end,
    --   scope = 'line', -- 'cursor' | 'line'
    --   show_sign = true,
    --   placement = 'top',
    --   update_event = {
    --     'DiagnosticChanged',
    --     'BufEnter',
    --     'TextChanged',
    --   },
    --   render_event = {
    --     'DiagnosticChanged',
    --     'BufEnter',
    --     'TextChanged',
    --     'CursorMoved',
    --     'CursorHold',
    --   },
    -- },
  },
  { 'mrjones2014/lua-gf.nvim', ft = 'lua', lazy = true },
  { 'onsails/lspkind.nvim', lazy = true },
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
        event = { 'VeryLazy' },
        opts = {
          highlight = true,
          lsp = {
            auto_attach = true,
          },
          preference = { 'basedpyright', 'ty' },
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
    -- version = 'v9.1*',
    version = false,
    event = { 'BufWritePre', 'VeryLazy' },
    cmd = 'ConformInfo',
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
                vim.api.nvim_feedkeys(api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
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
        yaml = { stop_after_first = true, 'yamlfix', 'yq', 'prettier' },
        json = { stop_after_first = true, 'biome_check', 'biome', 'jq', 'prettier' },
        -- jsonc = { 'biome_check', 'biome', 'jq', 'prettier', stop_after_first = true },
        -- julia = { 'runic', lsp_format = 'fallback', stop_after_first = true },
        julia = { stop_after_first = true, lsp_format = 'prefer', 'jl_fmt', 'jlfmt' },
        -- ['markdown'] = { stop_after_first = true, 'injected', 'rumdl_fmt', 'mdsf_fmt', 'markdownlint-cli2' },
        markdown = { stop_after_first = true, 'injected', 'rumdl_fmt', 'mdsf_fmt' },
        -- ['markdown.mdx'] = { stop_after_first = true, 'injected', 'rumdl_fmt', 'mdsf_fmt', 'markdownlint-cli2' },
        -- ['markdown.mdx'] = { stop_after_first = true, 'injected', 'rumdl_fmt', 'mdsf_fmt' },
        -- quarto = { 'injected', 'mdsf' },
        quarto = { stop_after_first = true, 'injected', 'rumdl_fmt' },
        ['sh'] = { stop_after_first = true, 'shfmt', 'beautysh' }, -- bashls takes care of these already
        zsh = { 'beautysh' },
        pgsql = { stop_after_first = true, 'pg_format', 'sqlfluff' },
        r = { 'air' },
        sql = {
          'sqlfluff_format',
          'sqlfluff_fmt_pgsql',
          'sqlfluff_fix',
          'sqruff',
          'sqlfluff_fix_dbt',
          'sleek',
          'sql_formatter',
          'sqlfmt',
          stop_after_first = true,
        },
        -- ['sql'] = { 'sleek', 'sqruff', 'sql_formatter', 'sqlfluff', stop_after_first = true },
        toml = { stop_after_first = true, 'tombi', 'taplo', 'prettier' },
        typst = { stop_after_first = true, 'prettypst', 'typstyle' },
        ['_'] = { 'trim_whitespace', 'trim_newlines', 'squeeze_blanks' },
      },
      formatters = {
        injected = {
          options = {
            ignore_errors = false,
            -- map of ts lang to formatters to use
            -- (defaults to the value from formatters_by_ft)
            -- lang_to_formatters = {
            --   -- python = { 'ruff_format', 'ruff_organize', 'ruff_fix' },
            --   -- julia = { 'jlfmt', lsp_format = 'fallback', 'mdsf', 'runic', stop_after_first = true },
            --   julia = { lsp_format = 'first', 'jlfmt', 'runic', stop_after_first = true }, -- prefer | first
            --   yaml = { 'prettier', 'yq' },
            -- },
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
              'setup.cfg',
              'pep8.ini',
              'tox.ini',
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
              'setup.cfg',
              'pep8.ini',
              'tox.ini',
            },
            require_cwd = true,
          }
        end,
        sqlfluff_fix_dbt = function()
          return {
            command = 'sqlfluff',
            args = { 'fix', '$FILENAME' },
            exit_codes = { 0, 1 }, -- ignore exit code 1 as this occurs when there simply exist unfixable lints
            stdin = false,
            require_cwd = true,
          }
        end,
        stylua = {
          args = { '--search-parent-directories', '$FILENAME' },
          stdin = false,
        },
        mdsf_fmt = function()
          return {
            command = 'mdsf',
            condition = function(_, ctx)
              return vim.fs.find({ 'mdsf.json' }, {
                path = ctx.filename,
                upward = true,
              })[1]
            end,
            cwd = require('conform.util').root_file {
              'mdsf.json',
            },
            args = {
              '--stdin',
              '$FILENAME',
            },
            prepend_args = {
              '--on-missing-language-definition',
              'ignore',
              '--on-missing-tool-binary',
              'ignore',
            },
            stdin = false,
          }
        end,
        shfmt = {
          command = 'shfmt',
          args = { '-i', '4', '-ci' },
        },
        sqruff = {
          command = 'sqruff',
          args = { 'fix', '$FILENAME' },
          stdin = false,
        },
        jl_fmt = function()
          return {
            --[[ 
              NOTE: looks for .JuliaFormatter.toml; to turn off formatting use `#! format:off/on`
            --]]
            --
            command = 'jlfmt',
            cwd = require('conform.util').root_file {
              '.JuliaFormatter.toml',
            },
            args = {
              '--inplace',
              '--stdin-filename' .. '$FILENAME',
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
        dprint = {
          command = 'dprint',
          args = { 'fmt', '--incremental', '$FILENAME' },
          -- condition = function(_, ctx)
          --   return vim.fs.find({ 'dprint.json', 'dprint.toml' }, {
          --     path = ctx.filename,
          --     upward = true,
          --   })[1]
          -- end,
          -- cwd = require('conform.util').root_file { 'dprint.json' },
        },
        runic = {
          command = 'julia',
          args = { '--startup-file=no', '--project=@runic', '-e', 'using Runic; exit(Runic.main(ARGS))' },
        },
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)
      eo.command('Format', function() require('conform').format { async = true, lsp_format = 'fallback' } end)
    end,
  },
  {
    'mfussenegger/nvim-lint',
    -- event = { 'BufReadPre', 'BufNewFile' },
    -- event = { 'VeryLazy' },
    event = { 'BufReadPre', 'VeryLazy' },
    init = function()
      -- vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'BufReadPost', 'OptionSet' }, {
      vim.api.nvim_create_autocmd('TextChanged', {
        -- group = api.nvim_create_augroup('lint', { clear = true }),
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
        markdown = { 'rumdl_lint', 'mado' },
        quarto = { 'rumdl_lint', 'mado' },
        python = { 'ruff' },
        rst = { 'rstcheck', 'sphinx-lint' },
        sql = { 'sqlfluff_lint_pgsql', 'sqlfluff_lint', 'sqruff' },
        -- text = { 'write_good' },
        yaml = { 'yamllint' },
      }
      lint.linters = {
        rumdl_lint = {
          cmd = 'rumdl',
          args = { '--config', conffigy .. '/rumdl.toml', 'check', '.' },
          -- args = function() return fmt('--config=%s/rumdl.toml', configgy) end,
          -- ignore_exitcode = true,
          -- stream = 'stdout',
          -- stdin = true,
          -- parser = require('lint.parser').from_errorformat('(stdin):%l%c: %m', {
          --   source = 'rumdl',
          --   severity = vim.diagnostic.severity.WARN,
          -- }),
        }, --[[@as lint.Linter ]]
        mado = {
          cmd = 'mado',
          args = { '--config', conffigy .. '/mado.toml', 'check' },
          -- args = function() return fmt('--config=%s/mado.toml', configgy) end,
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
          args = function() return fmt('--config=%s/nvim/markdownlint.yaml', configgy .. '--fix', '.') end,
        },
        ['markdownlint-cli2'] = {
          cmd = 'markdownlint-cli2',
          args = function()
            -- return fmt('--config=%s/markdownlint-cli2/.markdownlint-cli2.jsonc', configgy .. '--fix', '**/*.md')
            return fmt('--config=%s/markdownlint-cli2/.markdownlint-cli2.jsonc', configgy .. '--fix', '.')
          end,
        },
        yamllint = {
          cmd = 'yamllint',
          env = { '$YAMLLINT_CONFIG_FILE' },
          args = function() return fmt('-c=%s/yamllint/yamllint.yaml', configgy .. '--format' .. 'auto') end,
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
