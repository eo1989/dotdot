local api, fmt, configgy = vim.api, string.format, vim.env.XDG_CONFIG_HOME

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

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    event = 'VeryLazy',
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
          'luvit-meta/library',
          vim.env.VIMRUNTIME,
        },
      }
    end,
  },
  {
    'b0o/schemastore.nvim',
    event = 'LspAttach',
    -- ft = { 'json', 'jsonc', 'toml', 'yaml' },
  },
  {
    'DNLHC/glance.nvim',
    event = 'LspAttach',
    cmd = 'Glance',
    config = function()
      local glance = require('glance')
      -- opts = {
      glance.setup { --@diagnostic disable-line:missing-fields
        preserve_win_context = true,
        detached = function(winid) return vim.api.nvim_win_get_width(winid) < 100 end,
        preview_win_opts = { relativenumber = false },
        height = 24,
        border = { enable = false, top_char = '▁', bottom_char = '▔' },
        theme = {
          enable = true,
          mode = 'darken',
        },
        mappings = {
          list = {
            ['<C-h>'] = function() require('glance').actions.enter_win('preview') end,
          },
          preview = {
            ['<C-l>'] = function() require('glance').actions.enter_win('list') end,
          },
        },
        -- }
      }
    end,
    keys = {
      {
        'gd',
        [[:Glance definitions<CR>]],
        desc = 'Glance definitions',
      },
      {
        'gR',
        [[:Glance references<CR>]],
        desc = 'Glance references',
      },
      {
        'gM',
        [[:Glance implementations<CR>]],
        desc = 'Glance implementations',
      },
      {
        'gD',
        [[:Glance type_definitions<CR>]],
        desc = 'Glance type_definitions',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    -- lazy = false,
    -- event = { 'LspAttach', 'VeryLazy', 'FileType' },
    version = false,
    dependencies = { 'saghen/blink.cmp', 'utilyre/barbecue.nvim' },
    config = function() require('eo.lsp') end,
  },
  {
    'dgagn/diagflow.nvim',
    -- lazy = true,
    event = 'DiagnosticChanged',
    opts = {
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
    event = { 'LspAttach', 'VeryLazy' },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      {
        'SmiteshP/nvim-navic',
        opts = { highlight = true },
      },
    },
    opts = function(opts)
      local opts = {
        theme = 'auto',
        create_autocmd = true,
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
    version = 'v9.1*',
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
            end
          end)
        end,
        mode = '',
        desc = 'Format Buffer',
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
      format_on_save = {
        async = false,
        quiet = true,
        -- stop_after_first = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format', 'ruff_fix', 'ruff_organize_imports' },
        yaml = { 'prettier', 'yamlfix', 'yq', stop_after_first = true },
        json = { 'biome', 'prettier', 'jq', stop_after_first = true },
        julia = { 'runic' },
        markdown = { 'injected', 'markdownlint-cli2', 'mdformat', stop_after_first = true },
        quarto = { 'injected' },
        ['sh'] = { 'shfmt' },
        pgsql = { 'pg_format', 'sqlfluff' },
        ['sql'] = { 'sleek', 'sql_formatter', 'sqlfluff', 'sqlfmt', 'sqruff', stop_after_first = true },
        -- ['sql'] = { 'sleek', 'sqruff', 'sql_formatter', 'sqlfluff', stop_after_first = true },
        ['toml'] = { 'taplo', 'prettier', stop_after_first = true },
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
            -- lang_to_formatters = {},
          },
        },
        -- dprint = {
        --   condition = function(_, ctx)
        --     return vim.fs.find({ 'dprint.json', 'dprint.toml' }, {
        --       path = ctx.filename,
        --       upward = true,
        --     })[1]
        --   end,
        -- },
        runic = {
          command = 'julia',
          args = { '--startup-file=no', '--project=@runic', '-e', 'using Runic; exit(Runic.main(ARGS))' },
        },
        shfmt = {
          args = { '-i', '4', '-ci' },
        },
        sqruff = {
          args = { 'lsp', '-' },
        },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        python = { 'ruff' },
        markdown = { 'markdownlint_cli2' },
        sql = { 'sqlfluff', 'sqruff' }, -- sql-lint,  'sqruff lint'
        yaml = { 'yamllint' },
      }
      lint.linters = {
        ruff = {
          cmd = 'ruff',
          -- args = function() return fmt('--config=%s/nvim/pyproject.toml', configgy) end,
          args = { '--config=/Users/eo/.config/nvim/pyproject.toml' },
          condition = function(ctx)
            local root =
              require('lspconfig.util').root_pattern({ '*ruff.toml', 'pyproject.toml', 'uv.toml' }, ctx.filename)
            if root ~= vim.uv.cwd() then return false end
            return vim.fs.find({ '*ruff.toml', 'pyproject.toml', 'uv.toml' }, { path = root, upward = true })[1]
          end,
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
          args = function() return fmt('--config=%s/nvim/markdownlint.yaml', configgy) end,
        },
        markdownlint_cli2 = {
          cmd = 'markdownlint-cli2',
          args = function() return fmt('--config=%s/markdownlint-cli2/.markdownlint-cli2.jsonc', configgy) end,
        },
        yamllint = {
          env = { 'YAMLLINT_CONFIG_FILE' },
          args = function() return fmt('-c=%s/yamllint/config', configgy) end,
        },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
        group = api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          -- if vim.opt_local.modifiable:get() then require('lint').try_lint() end
          require('lint').try_lint()
        end,
      })
    end,
  },
}
