---@diagnostic disable: redefined-local
local defaults, default_bar_separator = require('defaults'), require('defaults').icons.separators.bar
local api, fmt = vim.api, string.format
local conffigy = vim.env.XDG_CONFIG_HOME

-- {
--   'williamboman/mason.nvim',
--   build = ':MasonUpdate',
--   opts = { ui = { border = 'rounded', height = 0.7 } },
-- },
-- {
--   'williamboman/mason-lspconfig.nvim',
--   lazy = true,
--   dependencies = {
--     { 'williamboman/mason.nvim' },
--   },
--   opts = {
--     automatic_installation = true,
--     -- handlers = {
--     --   function(name)
--     --     local configs = require('eo.servers')(name)
--     --     if configs then
--     --       require('lspconfig')[name].setup(configs)
--     --       -- else
--     --       --   vim.lsp.enable('*', { config })
--     --     end
--     --     for server, config in pairs(configs) do
--     --       vim.lsp.config(server, config)
--     --       vim.lsp.enable(server)
--     --     end
--     --   end,
--     -- },
--   },
-- },

-- local toggle = require("snacks").toggle.new({
--   name = "Format on save",
--   get = function()
--     return not vim.g.disable_autoformat
--   end,
--   set = function(enabled)
--     vim.g.disable_autoformat = not enabled
--   end,
-- })

-- toggle:map("<leader>uf")

-- eo.command(name, rhs, opts?)

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
    -- event = { 'LspAttach', 'VeryLazy' },
    cmd = 'Glance',
    config = function()
      local glance = require('glance')
      local actions = require('glance').actions

      -- opts = {
      glance.setup { --@diagnostic disable-line:missing-fields
        -- preserve_win_context = true,
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
        border = {
          enable = false,
          top_char = '▁',
          bottom_char = '▔',
        },
        theme = {
          enable = true,
          mode = 'darken',
        },
      }
    end,
    --[[ these are already set in plugin/attach.lua ]]
    -- keys = {
    --   {
    --     'gd',
    --     [[:Glance definitions<CR>]],
    --     desc = 'Glance definitions',
    --     silent = true,
    --   },
    --   {
    --     'gR',
    --     [[:Glance references<CR>]],
    --     desc = 'Glance references',
    --     silent = true,
    --   },
    --   {
    --     'gM',
    --     [[:Glance implementations<CR>]],
    --     desc = 'Glance implementations',
    --     silent = true,
    --   },
    --   {
    --     'gD',
    --     [[:Glance type_definitions<CR>]],
    --     desc = 'Glance type_definitions',
    --     silent = true,
    --   },
    -- },
  },
  {
    'neovim/nvim-lspconfig',
    enabled = true,
    -- lazy = false,
    event = { 'BufRead' },
    version = false,
    dependencies = {
      'saghen/blink.cmp',
      {
        'b0o/schemastore.nvim',
        event = 'LspAttach',
        -- ft = { 'json', 'jsonc', 'toml', 'yaml' },
      },
      {
        'microsoft/python-type-stubs',
        -- ft = 'python',
        -- lazy = false,
        -- priority = 999,
      },
    },
    config = function() require('eo.lsp') end,
  },
  {
    'dgagn/diagflow.nvim',
    enabled = false,
    -- lazy = true,
    -- event = 'DiagnosticChanged',
    version = false,
    event = 'LspAttach',
    opts = {
      enable = function() return vim.bo.filetype ~= 'lazy' end,
      scope = 'line', -- 'cursor' | 'line'
      show_sign = true,
      placement = 'top',
      update_event = {
        'DiagnosticChanged',
        'BufEnter',
        'TextChanged',
      },
      render_event = {
        'DiagnosticChanged',
        'BufEnter',
        'TextChanged',
        'CursorMoved',
        'CursorHold',
      },
    },
  },
  { 'mrjones2014/lua-gf.nvim', ft = 'lua', lazy = true },
  { 'onsails/lspkind.nvim', lazy = true },
  {
    'utilyre/barbecue.nvim',
    version = false,
    event = { 'LspAttach', 'VeryLazy' },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      {
        'SmiteshP/nvim-navic',
        event = 'LspAttach',
        opts = {
          highlight = true,
          lsp = { auto_attach = true },
        },
      },
    },
    opts = function(opts)
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
    event = { 'BufWritePre' },
    cmd = 'ConformInfo',
    -- from stevearc/dotfiles/blob/master/.config/nvim/lua/plugins/format.lua
    -- && LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/formatting.lua
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    keys = {
      {
        '<M-f>',
        function()
          require('conform').format({ async = false }, function(err)
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
        timeout_ms = 10000,
        lsp_format = 'fallback',
      },
      format = {
        timeout_ms = 200,
        -- async = false,
        quiet = true,
        -- stop_after_first = true,
      },
      -- format_on_save = {
      --   async = false,
      --   quiet = true,
      --   -- stop_after_first = true,
      -- },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      -- format_after_save = {
      --   async = true,
      --   quiet = true,
      -- },
      format_after_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- python = { 'ruff_format', 'ruff_fix', 'ruff_organize_imports', lsp_format = false },
        python = { 'ruff_format', 'ruff_fix', 'ruff_organize_imports', lsp_format = 'never', stop_after_first = false }, -- itll use the lsp
        yaml = { stop_after_first = true, 'prettier', 'yamlfix', 'yq' },
        json = { stop_after_first = true, 'biome_check', 'biome', 'prettier', 'jq' },
        jsonc = { stop_after_first = true, 'biome_check', 'biome', 'prettier', 'jq' },
        -- julia = { 'runic', lsp_format = 'fallback', stop_after_first = true },
        julia = { lsp_format = true }, -- go back to JuliaFormatter (in julials), runic is meh.
        markdown = { stop_after_first = true, 'injected', 'mdsf', 'markdownlint-cli2' },
        quarto = { 'injected' },
        -- ['sh'] = { 'shfmt' }, -- bashls takes care of these already
        ['zsh'] = { 'beautysh' },
        pgsql = { stop_after_first = true, 'pg_format', 'sqlfluff' },
        ['r'] = { 'air' },
        ['sql'] = {
          'sqlfluff_format',
          'sqlfluff_fix_dbt',
          'sqlfluff_fix',
          'sqruff',
          'sleek',
          'sql_formatter',
          'sqlfmt',
          stop_after_first = true,
        },
        -- ['sql'] = { 'sleek', 'sqruff', 'sql_formatter', 'sqlfluff', stop_after_first = true },
        ['toml'] = { stop_after_first = true, 'tombi', 'taplo', 'prettier' },
        ['_'] = { 'trim_whitespace', 'trim_newlines', 'squeeze_blanks' },
        ['*'] = { 'typos' },
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
              elixir = 'exs',
              javascript = 'js',
              julia = 'jl',
              latex = 'tex',
              markdown = 'md',
              python = 'py',
              r = 'r',
              ruby = 'rb',
              rust = 'rs',
              teal = 'tl',
              typescript = 'ts',
              sql = 'sql',
            },
            -- map of ts lang to formatters to use
            -- (defaults to the value from formatters_by_ft)
            lang_to_formatters = {
              python = { 'ruff_fix', 'ruff_format', 'ruff_organize' },
              yaml = { 'prettier', 'yq' },
            },
          },
        },
        --[[https://github.com/CoreyCole/dotfiles/blob/main/neovim-config/lua/plugins/init.lua]]
        sqlfluff_format = function()
          return {
            command = 'sqlfluff',
            args = { 'format', '-' },
            stdin = true,
            cwd = require('conform.util').root_file {
              '.sqlfluff',
              'pep8.ini',
              'pyproject.toml',
              'setup.cfg',
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
              'pep8.ini',
              'pyproject.toml',
              'setup.cfg',
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
        stylua = {
          args = { '--search-parent-directories', '$FILENAME' },
          -- args = { '--lsp', '-s', '$FILENAME', '-' },
          stdin = false,
        },
        mdsf = {
          command = 'mdsf',
          args = {
            '--on-missing-language-definition=ignore',
            '--on-missing-tool-binary=ignore',
            '--stdin' .. '$FILENAME',
          },
        },
        -- dprint = {
        --   command = 'dprint',
        --   args = { 'fmt', '--incremental' },
        --   condition = function(_, ctx)
        --     return vim.fs.find({ 'dprint.json', 'dprint.toml' }, {
        --       path = ctx.filename,
        --       upward = true,
        --     })[1]
        --   end,
        -- },
        -- runic = {
        --   command = 'julia',
        --   args = { '--startup-file=no', '--project=@runic', '-e', 'using Runic; exit(Runic.main(ARGS))' },
        -- },
        shfmt = {
          args = { '-i', '4', '-ci' },
        },
        sqruff = {
          args = { 'lsp', '-' },
        },
      },
    },
    -- config = function(_, opts)
    --   require('conform').setup(opts)
    --   eo.command('Format', function() require('conform').format() end, {})
    -- end,
  },
  {
    'mfussenegger/nvim-lint',
    -- event = { 'BufReadPre', 'BufNewFile' },
    -- event = { 'VeryLazy' },
    event = { 'BufReadPre' },
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
          -- lint.try_lint('typos')
        end,
      })
    end,
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        -- go = { 'revive' },
        gitcommit = { 'commitlint' },
        lua = { 'stylua' },
        github = { 'actionlint' },
        markdown = { 'mado', 'markdownlint_cli2' },
        python = { 'ruff' },
        rst = { 'rstcheck', 'sphinx-lint' },
        sql = { 'sqlfluff', 'sqruff', 'sql-lint' }, -- sql-lint,  'sqruff lint'
        text = { 'write_good' },
        yaml = { 'yamllint' },
      }
      lint.linters = {
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
          -- cmd = 'stylua',
          append_fname = true,
          args = { '--check', '$FILENAME' },
          -- args = { '--check' },
          stdin = false,
        },
        sqlfluff = {
          cmd = 'sqlfluff',
          args = { 'lint', '--disable-progress-bar', '--nocolor', '--nofail', '--dialect=ansi' }, -- '--dialect=postgres'
        },
        sqruff = {
          cmd = 'sqruff',
          args = { 'lint', '-' },
        },
        markdownlint = {
          cmd = 'markdownlint',
          args = function() return fmt('--config=%s/nvim/markdownlint.yaml', configgy .. '--fix', '**/*.md') end,
        },
        markdownlint_cli2 = {
          cmd = 'markdownlint-cli2',
          args = function()
            return fmt('--config=%s/markdownlint-cli2/.markdownlint-cli2.jsonc', configgy .. '--fix', '**/*.md')
          end,
        },
        yamllint = {
          env = { 'YAMLLINT_CONFIG_FILE' },
          -- args = function() return fmt('-c=%s/yamllint/config', configgy) end,
          args = function() return fmt('-c=%s/yamllint/yamllint.yaml', configgy) end,
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
