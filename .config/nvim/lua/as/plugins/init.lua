local fn, fmt = vim.fn, string.format
---Require a plugin config
---@param name string
---@return any
local function conf(name) return require(fmt('as.plugins.%s', name)) end

-----------------------------------------------------------------------------//
-- Bootstrap Lazy {{{3
-----------------------------------------------------------------------------//
local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
----------------------------------------------------------------------------- }}}1
-- cfilter plugin allows filtering down an existing quickfix list
vim.cmd.packadd({ 'cfilter', bang = true })

require('lazy').setup(
  {
		-----------------------------------------------------------------------------//
		-- Core {{{3
		-----------------------------------------------------------------------------//
		-- THE LIBRARY
		{ 'nvim-lua/plenary.nvim' },
    -- { "zbirenbaum/copilot-cmp", dependencies = { "zbirenbaum/copilot.lua" }, config = true },
    {
      'zbirenbaum/copilot.lua',
      -- event = { 'InsertEnter' },
      dependencies = { 'neovim/nvim-lspconfig' },
      -- init = function() vim.g.copilot_no_tab_map = true end,
      config = function()
        require('copilot').setup({
          panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
              jump_prev = "[[",
              jump_next = "]]",
              accept = "<CR>",
              refresh = "gr",
              open = "<M-CR>"  -- left alt! change kitty for right alt
            },
          },
          suggestion = {
            enabled = true,
            auto_trigger = false,
            debounce = 75,
            keymap = {
              accept = "<M-l>",
              accept_word = false,
              accept_line = false,
              next = "<M-]>",
              prev = "<M-[>",
              dismiss = "<C-]>",
            },
          }
        })
      end
    },
		{
  		'nvim-telescope/telescope.nvim',
  		config = conf('telescope').config,
      dependencies = {
        {
          "nvim-telescope/telescope-file-browser.nvim",
          config = function() require('telescope').load_extension('file_browser') end,
        },
        {
          "debugloop/telescope-undo.nvim",
          config = function() require('telescope').load_extension('undo') end,
        },
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
          config = function() require('telescope').load_extension('fzf') end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          dependencies = { 'kkharji/sqlite.lua' },
          config = function() require('telescope').load_extension('smart_history') end,
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          dependencies = { 'kkharji/sqlite.lua' },
          config = function() require('telescope').load_extension('frecency') end,
        },
        {
          'benfowler/telescope-luasnip.nvim',
          config = function() require('telescope').load_extension('luasnip') end,
        },
        {
          'zane-/howdoi.nvim',
          config = function() require('telescope').load_extension('howdoi') end,
        },
        {
          'nvim-telescope/telescope-live-grep-args.nvim',
          config = function() require('telescope').load_extension('live_grep_args') end,
        },
      },
    },
		{ 'kyazdani42/nvim-web-devicons' },
		{ 'folke/which-key.nvim', config = conf('whichkey') },
		{ 'anuvyklack/hydra.nvim', config = conf('hydraa') },
		{
      'goolord/alpha-nvim',
      enabled = false,
      config = conf('alpha')
    },
		{ 'lukas-reineke/indent-blankline.nvim', config = conf('indentline') },
		{
      'nvim-neo-tree/neo-tree.nvim',
      version = 'v2.x',
      config = conf('neo-tree'),
      keys = { '<C-n>', '<Cmd>Neotree toggle reveal<CR>', desc = 'Neotree' },
      cmd = { 'Neotree toggle reveal' },
      dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'kyazdani42/nvim-web-devicons',
        { 'mrbjarksen/neo-tree-diagnostics.nvim' },
        { 's1n7ax/nvim-window-picker', config = conf('window-picker') },
      },
    },
		-- }}}
		-----------------------------------------------------------------------------//
		-- LSP,Completion & Debugger {{{
		-----------------------------------------------------------------------------//
		{
      {
        'williamboman/mason.nvim',
        event = 'BufReadPre',
        dependencies = {
          'neovim/nvim-lspconfig',
          'williamboman/mason-lspconfig.nvim',
        },
        config = function()
          local get_config = require('as.servers')
          require('mason').setup({ ui = { border = as.style.current.border } })
          require('mason-lspconfig').setup({ automatic_installation = true })
          require('mason-lspconfig').setup_handlers({
            function(name)
              local config = get_config(name)
              if config then require('lspconfig')[name].setup(config) end
            end,
          })
        end,
      },
      {
        'jayp0521/mason-null-ls.nvim',
        dependencies = {
          'williamboman/mason.nvim',
          'jose-elias-alvarez/null-ls.nvim',
        },
        config = function()
          require('mason-null-ls').setup({
            automatic_installation = true,
          })
        end,
      },
    },
		{
      'neovim/nvim-lspconfig',
      event = 'BufRead',
      config = function()
        require('as.highlights').plugin('lspconfig', {
          { LspInfoBorder = { link = 'FloatBorder' } },
        })
        require('lspconfig.ui.windows').default_options.border = as.style.current.border
        -- require('lspconfig').pyright.setup(require('as.servers')('pyright'))
        require('lspconfig').pylsp.setup(require('as.servers')('pylsp'))
      end,
    },
    {
      'lewis6991/hover.nvim',
       config = function()
        require("hover").setup {
            init = function()
                -- Require providers
                require("hover.providers.lsp")
                -- require('hover.providers.gh')
                -- require('hover.providers.gh_user')
                -- require('hover.providers.jira')
                require('hover.providers.man')
                require('hover.providers.dictionary')
            end,
            preview_opts = {
                border = nil
            },
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = true,
            title = true
        }

        -- Setup keymaps
        vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
        vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
      end,
    },
		{
			'DNLHC/glance.nvim',
      enabled = false,
      lazy = true,
			config = true,
		},
		{
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup({
          text = {
            spinner = 'circle_halves',
          },
          align = {
            bottom = false,
            right = true,
          },
          fmt = {
            stack_upwards = false,
          },
        })
        as.augroup('CloseFidget', {
          {
            event = { 'VimLeavePre', 'LspDetach' },
            command = 'silent! FidgetClose',
          },
        })
      end,
    },
		{
      'kosayoda/nvim-lightbulb',
      config = function()
        require('as.highlights').plugin('Lightbulb', {
          { LightBulbFloatWin = { foreground = { from = 'Type' } } },
          { LightBulbVirtualText = { foreground = { from = 'Type' } } },
        })
        local icon = as.style.icons.misc.lightbulb
        require('nvim-lightbulb').setup({
          ignore = { 'null-ls' },
          autocmd = { enabled = true },
          sign = { enabled = false },
          virtual_text = { enabled = true, text = icon, hl_mode = 'blend' },
          float = { text = icon, enabled = false, win_opts = { border = 'none' } }, -- 
        })
      end,
    },
		{
      'jose-elias-alvarez/null-ls.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = conf('null-ls'),
    },
		{
      'lvimuser/lsp-inlayhints.nvim',
      config = function()
        require('lsp-inlayhints').setup({
          enabled_at_startup = true,
          inlay_hints = {
            only_current_line = true,
            highlight = 'Comment',
            labels_separator = ' | ',
            parameter_hints = {
              prefix = '',
            },
            type_hints = {
              prefix = '.. ',
              remove_colon_start = true,
            },
          },
          label_formatter = function(labels, kind, opts, client_name)
            if kind == 2 and not opts.parameter_hints.show then
              return ""
            elseif not opts.type_hints.show then
              return ""
            end
            return table.concat(labels or {}, ", ")
          end,
          virt_text_formatter = function(label, hint, opts, client_name)
            if client_name == 'sumneko_lua' then
              hint.paddingLeft = false
              hint.paddingRight = false
            end
            local virt_text = {}
            virt_text[#virt_text + 1] = hint.paddingLeft and { " ", "Normal" } or nil
            virt_text[#virt_text + 1] = { label, opts.highlight }
            virt_text[#virt_text + 1] = hint.paddingRight and { " ", "Normal" } or nil
            return virt_text
          end,
        })
      end,
    },
		{
      'ray-x/lsp_signature.nvim',
      enabled = true,
      config = function()
        require('lsp_signature').setup({
          bind = true,
          fix_pos = false,
          auto_close_after = 15, -- close after 15 seconds
          hint_enable = false,
          handler_opts = { border = as.style.current.border },
          toggle_key = "<M-,>",
          select_signature_key = '<M-n>',
        })
      end,
    },
		{
      'hrsh7th/nvim-cmp',
      event = { 'InsertEnter' },
      config = conf('cmp'),
      dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-buffer' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'onsails/lspkind.nvim' },
        { 'jc-doyle/cmp-pandoc-references' },
        { 'tamago324/cmp-zsh' },
        { 'kdheepak/cmp-latex-symbols' },
        { 'tzachar/cmp-tabnine', build = './install.sh'},
        -- {
        --   'petertriho/cmp-git',
        --   config = function()
        --     require('cmp_git').setup({ filetypes = { 'gitcommit', 'NeogitCommitMessage' } })
        --   end,
        -- },
      },
    },
		-- Use <Tab> to escape from pairs such as ""|''|() etc.
		{
      'abecodes/tabout.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'hrsh7th/nvim-cmp' },
      config = function()
        require('tabout').setup({
          ignore_beginning = false,
          completion = false,
          tabouts = {
            { open = "'", close = "'" },
            { open = '"', close = '"' },
            { open = "`", close = "`" },
            { open = "(", close = ")" },
            { open = "[", close = "]" },
            { open = "{", close = "}" },
            { open = "<", close = ">" },
          },
        })
      end,
    },
		-- }}}
		-----------------------------------------------------------------------------//
		-- Testing and Debugging {{{
		-----------------------------------------------------------------------------//
		{
       'nvim-neotest/neotest',
       lazy = true,
       init = conf('neotest').setup,
       config = conf('neotest').config,
       dependencies = {
         { 'nvim-neotest/neotest-plenary', module = 'neotest-plenary' },
         { 'nvim-neotest/neotest-python' , module = 'neotest-python' },
       },
     },
		{
      'mfussenegger/nvim-dap',
      init = conf('dap').setup,
      config = conf('dap').config,
      lazy = true,
      dependencies = {
        {
          'rcarriga/nvim-dap-ui',
          config = conf('dapui'),
        },
        {
          'theHamsta/nvim-dap-virtual-text',
          config = function() require('nvim-dap-virtual-text').setup({ all_frames = true }) end,
        },
        {
         'mfussenegger/nvim-dap-python',
          ft = 'python',
          -- config = function() require('dap-python').setupzr
        },
      },
    },
		--}}}
		-----------------------------------------------------------------------------//
		-- UI {{{
		-----------------------------------------------------------------------------//
		{
      'lukas-reineke/virt-column.nvim',
      config = function()
        require('as.highlights').plugin('virt_column', {
          { VirtColumn = { bg = 'None', fg = { from = 'Comment', alter = 10 } } },
        })
        require('virt-column').setup({ char = '▕' })
      end,
    },
		{
      'stevearc/dressing.nvim',
      event = { 'VimEnter' },
      -- dependencies =  { 'nvim-telescope/telescope.nvim' },
      config = conf('dressing')
    },
		{
     'SmiteshP/nvim-navic',
      dependencies = { 'neovim/nvim-lspconfig' },
      config = conf('navic')
    },
		{
      'kevinhwang91/nvim-ufo',
      enabled = true,
      dependencies = { 'kevinhwang91/promise-async' },
      config = conf('ufoo'),
    },
		-- }}}
		---------------------------------------------------------------------------
		-- Utilities {{{
		---------------------------------------------------------------------------
		{ 'ii14/emmylua-nvim' },
		{
      'chaoren/vim-wordmotion',
      config = function()
        -- vim.g.wordmotion_prefix = '<leader>'
        vim.g.wordmotion_spaces = { '-', '_', '\\/', '\\.' }
      end,
    },
		{
      'kylechui/nvim-surround',
			event = 'BufReadPre',
      config = function()
        require('nvim-surround').setup({
          move_cursor = true,
          keymaps = { visual = 's' },
        })
      end,
    },
		{
      'L3MON4D3/LuaSnip',
      event = { 'InsertEnter' },
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = conf('luasnip'),
    },
		{
      'monaqa/dial.nvim',
      config = conf('dial'),
      keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
      },
    },
    },
		{
      'jghauser/fold-cycle.nvim',
			-- event = 'VeryLazy',
      keys = {
        {
          '<BS>',
          function()
            require('fold-cycle').open()
          end,
          desc = 'Toggle fold',
        }
      },
      config = true,
    },
		{
      'mfussenegger/nvim-treehopper',
      config = function()
        as.augroup('TreehopperMaps', {
          {
            event = 'FileType',
            command = function(args)
              -- FIXME: this issue should be handled inside the plugin rather than manually

              local langs = require('nvim-treesitter.parsers').available_parsers()
              if vim.tbl_contains(langs, vim.bo[args.buf].filetype) then
                as.omap('u', ":<C-U>lua require('tsht').nodes()<CR>", { buffer = args.buf })
                as.vnoremap('u', ":lua require('tsht').nodes()<CR>", { buffer = args.buf })
              end
            end,
          },
        })

      end,
    },
		{
      'windwp/nvim-autopairs',
      dependencies = { 'hrsh7th/nvim-cmp' },
      config = function()
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
        require('nvim-autopairs').setup({
          close_triple_quotes = true,
          check_ts = true,
          fast_wrap = { map = '<C-e>' },
        })
      end,
    },
		{
      'danymat/neogen',
      keys = {
        {
          '<localleader>nc',
          function()
            require('neogen').generate()
          end,
          desc = 'Neogen comment',
        },
      },
      config = function() require('neogen').setup({ snippet_engine = 'luasnip' }) end,
    },
		{ 'rcarriga/nvim-notify', config = conf('notify'), event = 'BufReadPre' },
		{
      'mbbill/undotree',
      lazy = true,
      cmd = 'UndotreeToggle',
      -- init = function() as.nnoremap('<leader>u', '<cmd>UndotreeToggle<CR>', 'undotree: toggle') end,
      config = function()
        vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>')
        vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
      end,
    },
		{
      'moll/vim-bbye',
			event = 'VeryLazy',
      config = function() as.nnoremap('<leader>qq', '<Cmd>Bwipeout<CR>', 'bbye: quit') end,
    },

		-----------------------------------------------------------------------------//
		-- Quickfix
		-----------------------------------------------------------------------------//
		{
      url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
      config = function()
        require('as.highlights').plugin('pqf', {
          theme = {
            ['*'] = { { qfPosition = { link = 'Todo' } } },
            ['horizon'] = { { qfPosition = { link = 'String' } } },
          },
        })
        require('pqf').setup()
      end,
    },
		{
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        require('as.highlights').plugin('bqf', {
          { BqfPreviewBorder = { fg = { from = 'Comment' } } },
        })
      end,
    },
		-- }}}
		--------------------------------------------------------------------------------
		-- Knowledge and task management {{{
		--------------------------------------------------------------------------------
		{
      'nvim-neorg/neorg',
      dependencies = {
        'nvim-neorg/neorg-telescope',
        'nvim-treesitter/nvim-treesitter',
        'nvim-lua/plenary.nvim',
      },
      config = conf('norg'),
      -- ft = 'norg',
    },
		{ 'nvim-orgmode/orgmode', config = conf('orgmode') },
		{
      'lukas-reineke/headlines.nvim',
      ft = { 'org', 'norg', 'text', 'markdown', 'yaml', 'quarto' },
      -- init = conf('headlines').setup,
      config = conf('headlines').config,
    },
		-- }}}
		--------------------------------------------------------------------------------
		-- Profiling & Startup {{{
		--------------------------------------------------------------------------------
		{
      'dstein64/vim-startuptime',
      enabled = false,
      cmd = { 'StartupTime' },
      config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { '+let g:auto_session_enabled = 0' }
      end,
    },
		-- }}}
		--------------------------------------------------------------------------------
		-- TPOPE {{{
		--------------------------------------------------------------------------------
		{
      'kristijanhusak/vim-dadbod-ui',
      enabled = true,
      dependencies = 'tpope/vim-dadbod',
      cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection' },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        as.nnoremap('<leader>db', '<cmd>DBUIToggle<CR>', 'dadbod: toggle')
      end,
    },
		{ 'tpope/vim-repeat' },
		{
      'tpope/vim-abolish',
      config = function()
        as.nnoremap('<localleader>[', ':S/<C-R><C-W>//<LEFT>', { silent = false })
        as.nnoremap('<localleader>]', ':%S/<C-r><C-w>//c<left><left>', { silent = false })
        as.xnoremap('<localleader>[', [["zy:'<'>S/<C-r><C-o>"//c<left><left>]], { silent = false })
      end,
    },
		-- sets searchable path for filetypes like go so 'gf' works
		{ 'tpope/vim-apathy' },
		-- }}}
		-----------------------------------------------------------------------------//
		-- Filetype Plugins {{{
		-----------------------------------------------------------------------------//
		---@eo {{{
		{
      'JuliaEditorSupport/julia-vim',
      config = function()
        vim.g['latex_to_unicode_auto'] = 0
        vim.g['latex_to_unicode_tab'] = 0
        vim.g['latex_to_unicode_file_types'] = { "julia", "python", "rust", "nim", "markdown", "quarto", "org", "norg" }
        vim.g['julia_indent_align_brackets'] = true
        vim.g['julia_indent_align_funcargs'] = true
        vim.g['julia_indent_align_import'] = true
      end
    },
		{
      'hinell/move.nvim',
      event = 'BufRead',
      config = function()
        local opts = { silent = true }
        vim.keymap.set('n', '<A-j>', ':MoveLine 1<CR>', opts)
        vim.keymap.set('n', '<A-k>', ':MoveLine -1<CR>', opts)
        vim.keymap.set('n', '<A-h>', ':MoveHChar -1<CR>', opts)
        vim.keymap.set('n', '<A-l>', ':MoveHChar 1<CR>', opts)
        vim.keymap.set('x', '<A-j>', ':MoveBlock 1<CR>', opts)
        vim.keymap.set('x', '<A-k>', ':MoveBlock -1<CR>', opts)
        vim.keymap.set('v', '<A-h>', ':MoveHBlock -1<CR>', opts)
        vim.keymap.set('v', '<A-l>', ':MoveHBlock 1<CR>', opts)
      end
    },
		{
      'heavenshell/vim-pydocstring',
      -- TODO: must decide which is better between this and neogen
      enabled = false,
      ft = 'python',
      -- cmd = { "Pydocstring", "PydocstringFormat" },
      build = 'make install'
    },
		{
      'vimjas/vim-python-pep8-indent',
      ft = 'python',
    },
		{
      'microsoft/python-type-stubs',
      ft = 'python',
      -- event = 'BufRead'
    },
		{
      "RishabhRD/popfix",
      -- enabled = false,
      -- lazy = true,
      dependencies = "RishabhRD/nvim-cheat.sh",
      cmd = { 'Cheat', 'CheatList', 'CheatWithoutComments', 'CheatListWithoutComments' },
      init = function()
        as.nnoremap(
        '<localleader>c',
        function() require('nvim-cheat')
          :new_cheat(false, vim.bo.filetype .. ' ')
        end)
      end,
    },
		{
      'dccsillag/magma-nvim',
      -- event = 'VeryLazy',
      -- make sure to install pynvim jupyter_client ueberzug Pillow cairosvg pnglatex plotly
      build = { ':UpdateRemotePlugins' },
      config = function()
        vim.g['magma_image_provider'] = 'kitty'
        -- vim.g['magma_image_provider'] = 'ueberzug'
        vim.g['magma_automatically_open_output'] = false
        vim.g['magma_cell_highlight_group'] = "TSVariable"
        vim.g['magma_save_path'] = vim.fn.stdpath("data") .. "/magma"
      end,
    },
		{
      'is0n/jaq-nvim',
      config = function()
        require('jaq-nvim').setup{
          cmds = {
            internal = {
              lua = "luafile %",
              vim = "source %"
            },
            external = {
              markdown = "glow %",
              python   = "python3 %",
              go       = "go run %",
              sh       = "sh %"
            }
          },
          behavior = {
            default     = "quickfix",
            startinsert = false,
            wincmd      = false,
            autosave    = false
          },
          ui = {
            float = {
              border    = "none",
              winhl     = "Normal",
              borderhl  = "FloatBorder",
              winblend  = 0,
              height    = 0.8,
              width     = 0.8,
              x         = 0.5,
              y         = 0.5
            },
            terminal = {
              position = "bot",
              size     = 15,
              line_no  = false
            },
            quickfix = {
              position = "bot",
              size     = 12
            }
          }
        }
      end
    },
		{
      'michaelb/sniprun',
      -- pin = true,
      build = './install.sh 1',
      init = conf('snipran'),
      config = function()
        -- vim.keymap.set({'v', 'x', 'o'}, '<localleader>r', '<Plug>(SnipRun)', { nowait = true })
        -- vim.keymap.set('n', '<localleader>,', '<Plug>(SnipRunOperator)', { nowait = true })
        -- vim.keymap.set('n', '<localleader>,', '<Plug>(SnipRun)', { nowait = true })
        vim.keymap.set('n', '<F5>', ":let b:caret=winsaveview() <CR> | :%SnipRun <CR>| :call winrestview(b:caret) <CR>", {})
        vim.keymap.set('n', '<F6>', [[:SnipReset<CR>]])
        -- TODO: Probably need to use a functino here to make SnipInfo accept string input.
        vim.keymap.set('n', '<F7>', [[:SnipInfo ]])
      end,
      keys = {
        { "<localleader>,", "<Plug>(SnipRun)", desc = "SnipRun", nowait = true },
        { "<localleader>,", "<Plug>(SnipRunOperator)", nowait = true },
        { "<localleader>r", "<Plug>(SnipRun)", mode = { "v", "x", "o" } },
      },
    },
		{
      'GCBallesteros/jupytext.vim',
      init = function()
        vim.g['jupytext_fmt'] = 'py' -- for now until qtconsole works
      end
    },
		{ 'GCBallesteros/vim-textobj-hydrogen', dependencies = { 'kana/vim-textobj-user' } },
		{
      'norcalli/nvim-colorizer.lua',
      cmd = { 'ColorizerToggle' },
      config = function()
        -- require('colorizer').init({ 'lua', 'vim', 'kitty', 'conf' }, {
        require('colorizer').setup({'*'}, {
          RGB = true,
          mode = 'foreground',
        })
      end,
    },
		{ 'nanotee/nvim-lua-guide' },
		{
      'stevearc/overseer.nvim',
      enabled = false,
			lazy = true,
      config = conf('ovs')
    },
		{
      'olexsmir/gopher.nvim',
      enabled = false,
      dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    },
		{ 'nanotee/sqls.nvim' },
		{ 'AckslD/swenv.nvim' },
		{
      'AckslD/nvim-FeMaCo.lua',
      cmd = 'FeMaco',
      -- module = { "femaco.edit" },
      -- ft = { 'markdown', 'norg', 'org' },
      config = function()
        require('femaco').setup({
          post_open_float = function(winnr)
            vim.api.nvim_win_set_option(winnr, 'winblend', 10)
          end,
        })
      end
    },
		{
      "quarto-dev/quarto-nvim",
      ft = { 'quarto' },
      dependencies = {
        'neovim/nvim-lspconfig',
        'jmbuhr/otter.nvim'
      },
      config = function()
        require('quarto').setup{
          debug = false,
          closePreviewOnExit = true,
          lspFeatures = {
            enabled = true, --def = false
            languages = { 'r', 'python', 'julia' },
            diagnostics = {
              enabled = false, -- def = true
              triggers = { 'BufWrite' },
            },
            completion = {
              enabled = true, -- def = false
            },
          },
          keymap = {
            hover = 'K',
            definition = 'gd'
          },
        }
      end
    },
		{
      'iamcco/markdown-preview.nvim',
      cmd = { "MarkdownPreview" },
      build = function() vim.fn['mkdp#util#install']() end,
      ft = { 'markdown', 'quarto', 'vimwiki' },
      config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end,
      dependencies = {
        "zhaozg/vim-diagram",
        "aklt/plantuml-syntax",
      }
    },
		{ 'mtdl9/vim-log-highlighting' },
		{ 'fladson/vim-kitty' },
		{ 'psliwka/vim-smoothie' },
		-- }}}
		--------------------------------------------------------------------------------
		-- Syntax {{{1
		--------------------------------------------------------------------------------
		{
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
      config = conf('treesitter'),
      dependencies = {
        {
          'nvim-treesitter/playground',
          cmd = { 'TSHighlightCapturesUnderCursor', 'TSPlayground' },
          config = function()
            vim.keymap.set('n', '<S-M-x>', '<Cmd>TSHighlightCapturesUnderCursor<CR>')
          end,
        },
        { 'mrjones2014/nvim-ts-rainbow' },
        { 'nvim-treesitter/nvim-treesitter-textobjects' },
        { 'rrethy/nvim-treesitter-endwise' },
        {
          'andymass/vim-matchup',
          event = 'BufReadPost',
          config = function()
            vim.g['matchup_matchparen_deferred'] = 5
            vim.g['matchup_matchparen_offscreen'] = {
              method = 'popup',
              fullwidth = 1,
              highlight = 'OffscreenMatchPopup',
            }
            vim.g['matchup_motion_cursor_end'] = 1
            vim.g['matchup_surround_enabled'] = 1
            -- vim.g['matchup_matchparen_nomode'] = 'i'
            vim.g['matchup_matchparen_deferred_show_delay'] = 100
            vim.g['matchup_matchparen_deferred_hide_delay'] = 100
          end,
        },
        {
          'mizlan/iswap.nvim',
          cmd = { 'ISwap', 'ISwapWith', 'ISwapNode' },
          -- keys = {
          --   { vim.keymap.set('n', '<localleader>iw', "<cmd>ISwapWith<CR>", { noremap = true }) },
          --   { vim.keymap.set('n', '<localleader>ia', "<Cmd>ISwap<CR>",     { noremap = true }) },
          --   { vim.keymap.set('n', '<localleader>in', "<Cmd>ISwapNode<CR>", { noremap = true }) }
          -- },
          config = function()
            vim.keymap.set('n', '<leader>iw', "<cmd>ISwapWith<CR>", {noremap = true})
            vim.keymap.set('n', '<leader>ia', "<Cmd>ISwap<CR>", {noremap = true})
            vim.keymap.set('n', '<leader>in', "<Cmd>ISwapNode<CR>", { noremap = true })
            -- as.nnoremap('<leader>iw', '<Cmd>ISwapWith<CR>', 'ISwap: swap with')
            -- as.nnoremap('<leader>ia', '<Cmd>ISwap<CR>', 'ISwap: swap any')
          end,
        },
        { 'm-demare/hlargs.nvim', config = true },
      },
    },
    {
      'aarondiel/spread.nvim',
      lazy = true,
      keys = {
        {
          'gS',
          function()
            require('spread').out()
          end,
          desc = 'spread: expand',
        },
        {
          'gJ',
          function()
            require('spread').combine()
          end,
          desc = 'spread: combine',
        },
      },
    },
		{
      'ruifm/gitlinker.nvim',
      lazy = true,
      dependencies = { 'nvim-lua/plenary.nvim' },
      init = conf('gytlinker').setup,
      config = conf('gytlinker').config,
    },
		{
			'lewis6991/gitsigns.nvim',
			event = 'VeryLazy',
			config = conf('gytsigns')
		},
		{
      'TimUntersberger/neogit',
      lazy = true,
      cmd = 'Neogit',
      keys = { '<localleader>gs', '<localleader>gl', '<localleader>gp' },
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = conf('neogit'),
    },
		{
      'sindrets/diffview.nvim',
      lazy = true,
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
      init = conf('dyffview').setup,
      config = conf('dyffview').config,
    },
		---}}}
		--------------------------------------------------------------------------------
		-- Text Objects {{{1
		--------------------------------------------------------------------------------

		{ 'numToStr/Comment.nvim', config = true },
    { 'wellle/targets.vim' },
		{
      'kana/vim-textobj-user',
      dependencies = {
        'kana/vim-operator-user',
        {
          'glts/vim-textobj-comment',
          event = 'CursorHold',
          config = function()
            vim.g.textobj_comment_no_default_key_mappings = 1
            vim.keymap.set({'x', 'o'}, 'ax', '<Plug>(textobj-comment-a)')
            vim.keymap.set({'x', 'o'}, 'ix', '<Plug>(textobj-comment-i)')
          end,
        },
      },
    },
		-- }}}
		--------------------------------------------------------------------------------
		-- Search Tools {{{1
		--------------------------------------------------------------------------------
		{
      'ggandor/leap.nvim',
      lazy = true,
      keys = { 's' },
      -- does it require this dependency?
      dependencies = { 'tpope/vim-repeat' },
      config = function()
        require('as.highlights').plugin('leap', {
          theme = {
            ['*'] = {
              { LeapBackdrop = { fg = '#707070' } },
              { LeapLabelPrimary = { bg = 'NONE', fg = '#ccff88', italic = true } },
              { LeapLabelSecondary = { bg = 'NONE', fg = '#99ccff' } },
              { LeapLabelSelected = { bg = 'NONE', fg = 'Magenta' } },
            },
          }
        })
        require('leap').setup({
          equivalence_classes = { ' \t\r\n', '([{', ')]}', '`"\'' },
        })
        as.nnoremap('s', function()
          require('leap').leap({
            target_windows = vim.tbl_filter(
              function(win) return as.empty(vim.fn.win_gettype(win)) end,
              vim.api.nvim_tabpage_list_wins(0)
            ),
          })
        end)
      end,
    },
		{
      'ggandor/flit.nvim',
      lazy = true,
      keys = { 'f' },
      dependencies = { 'ggandor/leap.nvim' },
      config = function()
        require('flit').setup({
          labeled_modes = 'nvo',
          multiline = false,
        })
      end,
    },
		-- }}}
		--------------------------------------------------------------------------------
		-- Themes  {{{1
		--------------------------------------------------------------------------------
		{ 'LunarVim/horizon.nvim' },
		{
       'theHamsta/nvim-semantic-tokens',
        config = function()
          require('as.plugins.semantictokens').setup()
        end
     },
		'Lunarvim/onedarker.nvim',
		'Lunarvim/darkplus.nvim',
		'folke/tokyonight.nvim',
		{
      'Mofiqul/vscode.nvim',
      lazy = false,
      priority = 1000,
      config = function ()
        vim.g.vscode_style = 'dark'
        vim.g.vscode_transparent = false
        vim.g.vscode_italic_comment = 1
        vim.g.vscode_disable_nvimtree_bg = false
        vim.cmd([[colorscheme vscode]])
      end
    },
		{
      'NTBBloodbath/doom-one.nvim',
      config = function()
        vim.g.doom_one_italic_comments = true
        vim.g.doom_one_enable_treesitter = true
        vim.g.doom_one_diagnostics_text_color = true
        vim.g.doom_one_pumblend_enable = true
        vim.g.doom_one_pumblend_transparency = 3
        vim.g.doom_one_plugin_neorg = true
        vim.g.doom_one_plugin_barbar = true
        vim.g.doom_one_plugin_telescope = true
        vim.g.doom_one_plugin_neogit = true
        vim.g.doom_one_plugin_nvim_tree = true
        vim.g.doom_one_plugin_dashboard = true
        vim.g.doom_one_plugin_startify = true
        vim.g.doom_one_plugin_whichkey = true
        vim.g.doom_one_plugin_indent_blankline = true
        vim.g.doom_one_plugin_vim_illuminate = true
        vim.g.doom_one_plugin_lspsaga = true
      end
    },
    { "ellisonleao/gruvbox.nvim" },
    {
      "folke/tokyonight.nvim",
      enabled = false,
      lazy = true,
      -- priority = 1000,
      config = function()
        local tokyonight = require("tokyonight")
        tokyonight.setup({
          style = "moon",
          sidebars = {
            "qf",
            "vista_kind",
            "terminal",
            "spectre_panel",
            "startuptime",
            "Outline",
          },
        })
        -- tokyonight.load()
      end,
    },
		-- }}}
		{ 'rafcamlet/nvim-luapad', cmd = 'Luapad' },
		{
      'akinsho/org-bullets.nvim',
      ft = { 'org' },
      config = true,
    },
		{
      'akinsho/toggleterm.nvim',
      config = conf('toggleterm'),
    },
		{
      'akinsho/bufferline.nvim',
      config = conf('bufferline'),
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },
		{
      'akinsho/git-conflict.nvim',
      enabled = false,
      config = function() require('git-conflict').setup({ disable_diagnostics = true }) end,
    },
	},
  {
    defaults = {},
    ui = {
      border = as.style.current.border,
    },
    install = {
      colorscheme = { 'vscode' },
    },
  }
)

    -----------------------------------------------------
    -- use({
    --   'kristijanhusak/vim-dadbod-completion',
    --   -- after = { "nvim-cmp" },
    --   wants = { "kristijanhusak/vim-dadbod-ui" },
    --   disable = false,
    --   ft = { 'sql', 'mysql', 'plsql' },
    --   config = function()
    --     require('cmp').init.buffer({
    --       sources = {{ name = 'vim-dadbod-completion' }}
    --     })
    --   end
    -- })
    -- use({
    --   'luk400/vim-jukit',
    --   disable = true,
    --   ft = { 'python', 'julia', 'markdown' },
    --   init = function ()
    --     vim.g['jukit_terminal'] = 'kitty'
    --     vim.g['jukit_mappings'] = 0
    --   end
    -- })
    -- use({
    --   'jakewvincent/mkdnflow.nvim',
    --   disable = true,
    --   opt = true,
    --   ft = { 'markdown' },
    --   config = function()
    --     require('mkdnflow').init({})
    --   end,
    -- })

-- vim:ft=lua fdls=3 ts=2 sts=2 sw=2 nospell;
