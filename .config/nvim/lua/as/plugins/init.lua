---@diagnostic disable: redefined-local
local utils = require('as.utils.plugins')

local with_local, conf = utils.with_local, utils.conf
-- local use_local = utils.use_local
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fmt('%s/packer/packer_compiled.lua', fn.stdpath('cache'))
-----------------------------------------------------------------------------//
-- Bootstrap Packer {{{3
-----------------------------------------------------------------------------//
utils.bootstrap_packer()
----------------------------------------------------------------------------- }}}1
-- cfilter plugin allows filtering down an existing quickfix list
vim.cmd.packadd({ 'cfilter', bang = true })

as.require('impatient')

local packer = require('packer')
--- NOTE "use" functions cannot call *upvalues* i.e. the functions
--- passed to setup or config etc. cannot reference aliased functions
--- or local variables
packer.startup({
  function(use)
    -- FIXME: this no longer loads the local plugin since the compiled file now
    -- loads packer.nvim so the local alias(local-packer) does not work
    use({ 'wbthomason/packer.nvim', opt = true })
    -----------------------------------------------------------------------------//
    -- Core {{{3
    -----------------------------------------------------------------------------//
    -- THE LIBRARY
    use('nvim-lua/plenary.nvim')

    use( {
      'simrat39/symbols-outline.nvim',
      opt = true,
      config = function() require('symbols-outline').setup() end,
      cmd = { 'SymbolsOutline' }
    } )

    use({
      'theHamsta/nvim-semantic-tokens',
      config = function()
        require('as.plugins.semantictokens').setup()
      end
    })


    use({ 'rafcamlet/nvim-luapad', cmd = { 'Luapad', 'LuaRun' } })

    use({
      'ahmedkhalf/project.nvim',
      opt = true,
      config = function()
        require('project_nvim').setup({
          detection_methods = { 'pattern', 'lsp' },
          ignore_lsp = { 'null-ls' },
          patterns = { '.git' },
        })
      end,
    })

    use({
      'nvim-telescope/telescope.nvim',
      branch = 'master', -- '0.1.x',
      module_pattern = 'telescope.*',
      config = conf('telescope').config,
      event = 'CursorHold',
      requires = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          after = 'telescope.nvim',
          config = function() require('telescope').load_extension('fzf') end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          requires = { { 'kkharji/sqlite.lua', module = 'sqlite' } },
          after = 'telescope.nvim',
          config = function() require('telescope').load_extension('smart_history') end,
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          after = 'telescope.nvim',
          requires = { { 'kkharji/sqlite.lua', module = 'sqlite' } },
          config = function() require('telescope').load_extension('frecency') end,
        },
      {
          'benfowler/telescope-luasnip.nvim',
          after = 'telescope.nvim',
          config = function() require('telescope').load_extension('luasnip') end,
        },
        {
          'Zane-/howdoi.nvim',
          after = 'telescope.nvim',
          config = function() require('telescope').load_extension('howdoi') end,
        },
        {
          'nvim-telescope/telescope-live-grep-args.nvim',
          after = 'telescope.nvim',
          config = function() require('telescope').load_extension('live_grep_args') end,
        },
      },
    })

    use('kyazdani42/nvim-web-devicons')

    use({ 'folke/which-key.nvim', config = conf('whichkey') })

    use({ 'anuvyklack/hydra.nvim', config = conf('hydraa') })

    use({
      'rmagatti/auto-session',
      disable = false,
      config = function()
        local fn = vim.fn
        local fmt = string.format
        local data = fn.stdpath('data')
        require('auto-session').setup({
          log_level = 'error',
          auto_session_root_dir = fmt('%s/session/auto/', data),
          -- Do not enable auto restoration in my projects directory, I'd like to choose projects myself
          auto_restore_enabled = not vim.startswith(fn.getcwd(), vim.env.PROJECTS_DIR),
          auto_session_suppress_dirs = {
            vim.env.HOME,
            vim.env.PROJECTS_DIR,
            fmt('%s/Desktop', vim.env.HOME),
            fmt('%s/site/pack/packer/opt/*', data),
            fmt('%s/site/pack/packer/start/*', data),
          },
          auto_session_use_git_branch = false, -- This cause inconsistent results
        })
      end,
    })


    use({ 'goolord/alpha-nvim', config = conf('alpha') })

    use({ 'lukas-reineke/indent-blankline.nvim', config = conf('indentline') })


    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = conf('neo-tree'),
      keys = { '<C-N>' },
      cmd = { 'NeoTree' },
      requires = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'kyazdani42/nvim-web-devicons',
        { 'mrbjarksen/neo-tree-diagnostics.nvim', module = 'neo-tree.sources.diagnostics' },
        { 's1n7ax/nvim-window-picker', tag = 'v1.*', config = conf('window-picker') },
      },
    })
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{1
    -----------------------------------------------------------------------------//
    use({
      {
        'williamboman/mason.nvim',
        event = 'BufRead',
        requires = {
          'nvim-lspconfig',
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
        requires = {
          'williamboman/mason.nvim',
          'jose-elias-alvarez/null-ls.nvim',
        },
        after = 'mason.nvim',
        config = function()
          require('mason-null-ls').setup({
            automatic_installation = true,
          })
        end,
      },
    })

    -- TODO:
    use({
      'neovim/nvim-lspconfig',
        -- after = {'cmp-nvim-lsp'},
        module_pattern = 'lspconfig.*',
        config = function()
          require('as.highlights').plugin('lspconfig', { { LspInfoBorder = { link = 'FloatBorder' } } })
          require('lspconfig.ui.windows').default_options.border = as.style.current.border
          require('lspconfig').pyright.setup(require('as.servers')('pyright'))
          -- require('lspconfig').pylance.setup(require('as.servers')('pylance_'))
          -- require('lspconfig').pylance.setup(require('as.servers')('pylance'))
      end,
    })


    use({
      'smjonas/inc-rename.nvim',
      disable = false,
      config = function()
        require('inc_rename').setup({ hl_group = 'Visual' })
        as.nnoremap('<leader>ri', function()
          return ':IncRename ' .. vim.fn.expand('<cword>')
        end, {
          expr = true,
          silent = false,
          desc = 'lsp: incremental rename',
        })
      end,
    })

    use({
      'andrewferrier/textobj-diagnostic.nvim',
      disable = true,
      config = function() require('textobj-diagnostic').setup() end,
    })

    use({
      'zbirenbaum/neodim',
      disable = false,
      config = function()
        require('neodim').setup({
          blend_color = require('as.highlights').get('Normal', 'bg'),
          alpha = 0.45,
          hide = {
            underline = false,
          },
        })
      end,
    })

    use({
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
          window = {
            relative = 'editor', -- default => 'win'
            blend = vim.api.nvim_get_option('pumblend'), -- default => 100
          },
        })
        as.augroup('CloseFidget', {
          {
            event = { 'VimLeavePre', 'LspDetach' },
            command = 'silent! FidgetClose',
          },
        })
      end,
    })

    use({
      'kosayoda/nvim-lightbulb',
      disable = false,
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
    })

    use({
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = conf('null-ls'),
    })

    use({
      'lvimuser/lsp-inlayhints.nvim',
      -- disable = true,
      -- event = 'BufRead',
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
    })

    use({
      'ray-x/lsp_signature.nvim',
      -- event = 'InsertEnter',
      config = function()
        require('lsp_signature').setup({
          bind = true,
          fix_pos = false,
          auto_close_after = 20, -- close after 15 seconds
          hint_enable = false,
          handler_opts = { border = as.style.current.border },
          toggle_key = "<M-'>",
          select_signature_key = "<M-n>",
        })
      end,
    })

    -- use({'onsails/lspkind.nvim'})

    use({
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      -- event = 'InsertEnter',
      config = conf('cmp'),
      requires = {
        { 'hrsh7th/cmp-nvim-lsp', module = 'cmp-nvim-lsp' }, -- after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'rcarriga/cmp-dap', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        -- { 'dmitmel/cmp-cmdline-history', after = 'nvim-cmp' },
        { 'onsails/lspkind.nvim', },
        { 'jc-doyle/cmp-pandoc-references', after = 'nvim-cmp' },
        { 'tamago324/cmp-zsh', after = 'nvim-cmp' }, -- ft = 'zsh',
        { 'max397574/cmp-greek', after = 'nvim-cmp' },
        -- { 'lukas-reineke/cmp-rg', tag = '*', after = 'nvim-cmp' },
        {
          'petertriho/cmp-git',
          -- disable = false,
          after = 'nvim-cmp',
          config = function()
            require('cmp_git').setup({ filetypes = { 'gitcommit', 'NeogitCommitMessage' } })
          end,
        },
      },
    })

    use({ 'tzachar/cmp-tabnine', run = './install.sh', after = 'nvim-cmp'}) --, disable = true
    -- use({ 'kdheepak/cmp-latex-symbols', after = 'nvim-cmp', ft = { 'latex', 'julia' } })

    use({ 'kdheepak/cmp-latex-symbols', after = 'nvim-cmp' })

    -- Use <Tab> to escape from pairs such as ""|''|() etc.
    use({
      'abecodes/tabout.nvim',
      wants = { 'nvim-treesitter' },
      after = { 'nvim-cmp' },
      config = function()
        require('tabout').setup({
          -- tabkey = "",
          -- backwards_tabkey = "",
          ignore_beginning = false,
          completion = false
        })
      end
    })

    -- }}}
    -----------------------------------------------------------------------------//
    -- Testing and Debugging {{{1
    -----------------------------------------------------------------------------//
    use({
      'nvim-neotest/neotest',
      tag = '*',
      setup = conf('neotest').setup,
      config = conf('neotest').config,
      module = 'neotest',
      requires = {
        { 'nvim-neotest/neotest-plenary', module = 'neotest-plenary' },
        { 'nvim-neotest/neotest-python', module = 'neotest-python' },
      },
    })

    use({
      'mfussenegger/nvim-dap',
      module = 'dap',
      tag = '*',
      setup = conf('dap').setup,
      config = conf('dap').config,
      requires = {
        {
          'rcarriga/nvim-dap-ui',
          after = 'nvim-dap',
          config = conf('dapui'),
        },
        {
          'theHamsta/nvim-dap-virtual-text',
          after = 'nvim-dap',
          config = function()
            require('nvim-dap-virtual-text').setup({ all_frames = true })
          end,
        },
      },
    })

    use({
      'mfussenegger/nvim-dap-python',
      ft = 'python',
      after = 'nvim-dap',
      event = {
        'BufRead',
        'BufNew',
      }
      -- config = function()
      --   local dap = require("dap")
      --   dap.adapters.python = {
      --     type = 'executable',
      --     command =
      --   }
      -- end
    })

    --}}}

    ---@eo {{{
    use({
      'JuliaEditorSupport/julia-vim',
      config = function()
        vim.g['latex_to_unicode_auto'] = false
        vim.g['julia_indent_align_brackets'] = true
        vim.g['julia_indent_align_funcargs'] = true
        vim.g['julia_indent_align_import'] = true
      end
    })


     use({
      "nvim-lualine/lualine.nvim",
      disable = true,
      -- after = "nvim-treesitter",
      -- config = function()
      --   require("lualine").setup()
      -- end,
      config = conf('lualine'),
      wants = "nvim-web-devicons",
    })


    use({
      'fedepujol/move.nvim',
      -- event = 'BufRead',
      config = function()
        local opts = { silent = true }
        as.nnoremap('<A-j>', '<cmd>MoveLine(1)<CR>', opts)
        as.nnoremap('<A-k>', '<cmd>MoveLine(-1)<CR>', opts)
        as.nnoremap('<A-h>', '<cmd>MoveHChar(-1)<CR>', opts)
        as.nnoremap('<A-l>', '<cmd>MoveHChar(1)<CR>', opts)

        as.xnoremap('<A-j>', [[:MoveBlock(1)<CR>]], opts)
        as.xnoremap('<A-k>', [[:MoveBlock(-1)<CR>]], opts)
        as.xnoremap('<A-l>', [[:MoveHBlock(-1)<CR>]], opts)
        as.xnoremap('<A-h>', [[:MoveHBlock(1)<CR>]], opts)
      end
    })

    use({
      'heavenshell/vim-pydocstring',
      ft = 'python',
      cmd = { "Pydocstring", "PydocstringFormat" },
      run = 'make install'
    })

    use({
      'vimjas/vim-python-pep8-indent',
      ft = 'python',
      event = { 'BufRead', 'InsertEnter', 'TextChangedI' }
    })

    use({
      'microsoft/python-type-stubs',
      ft = 'python',
      event = 'BufRead'
    })

    use({
      "RishabhRD/popfix",
      requires = "RishabhRD/nvim-cheat.sh",
      cmd = { 'Cheat', 'CheatList', 'CheatWithoutComments', 'CheatListWithoutComments' },
      setup = function()
        as.nnoremap(
          '<localleader>c',
          function() require('nvim-cheat')
            :new_cheat(false, vim.bo.filetype .. ' ')
          end)
      end,
    })

    use({
      'andymass/vim-matchup',
      ft = { 'lua', 'python', 'go', 'markdown', 'bash', 'zsh' },
      event = 'VimEnter',
      config = function()
        vim.g['matchup_matchparen_offscreen'] = { method = 'popup' }
        vim.g['matchup_matchparen_deferred'] = 1
        vim.g['matchup_motion_cursor_end'] = 1
        vim.g['matchup_surround_enabled'] = 1
        vim.g['matchup_matchparen_nomode'] = 'i'
        vim.g['matchup_matchparen_deferred_show_delay'] = 100
        vim.g['matchup_matchparen_deferred_hide_delay'] = 100
      end,
    })


    use({
      'dccsillag/magma-nvim',
      -- opt = true,
      -- make sure to install pynvim jupyter_client ueberzug Pillow cairosvg pnglatex plotly
      run = ':UpdateRemotePlugins',
      config = function()
        vim.g['magma_image_provider'] = 'kitty'
        vim.g['magma_automatically_open_output'] = true
        vim.g['magma_cell_highlight_group'] = "CursorLine"
        vim.g['magma_save_path'] = vim.fn.stdpath("data") .. "/magma"
      end,
    })

    use({
      "0x100101/onedark.nvim",
      config = function()
        require("onedark").setup({
          style = 'cool', -- 'dark' <- default
          transparent = true, -- false <- default
          cmp_itemkind_reverse = true, -- false <- default
          toggle_style_key = nil, -- '<leader>ts' <- default
          code_style = {
            comments = 'italic',
            keywords = 'bold',
            functions = 'italic,bold',
            strings = 'italic',
            variables = 'bold',
          },
          diagnostics = {
            darker = true,
            undercurl = true, -- instead of underline
            background = true, -- use background for virt text
          },
          colors = {}, -- overrides
          higlights = {}, -- overrides
        })
      end
    })

    use({ 'is0n/jaq-nvim' })

    use({
      'michaelb/sniprun',
      run = 'bash ./install.sh 1',
      -- module = { "sniprun", "sniprun.api" },
      -- setup = conf('snyprun').setup,
      -- config = conf('sniprun').config,
      setup = function()
        require('as.plugins.sniprun').setup()
      end,
      config = function()
        require('as.plugins.sniprun').config()
      end,
    })

    use({
      "epwalsh/obsidian.nvim",
      disable = true,
      opt = true,
      ft = 'markdown',
      config = function()
        require('obsidian').setup({
        dir = "~/Notes/",
        completion = {
          nvim_cmp = true, -- if using nvim-cmp, else false
        }
      })
      end
    })

    use({
      "quarto-dev/quarto-nvim",
      disable = false,
      opt = true,
      ft = { 'markdown', 'qmd' },
      config = function()
        require('quarto').setup({
          closePreviewOnExit = true,
          diagnostics = {
            enabled = false,
            languages = { 'r', 'python', 'julia' }
          }
        })
      end
    })

    use({
      'luk400/vim-jukit',
      disable = true,
      ft = { 'python', 'julia', 'markdown' },
      setup = function ()
        vim.g['jukit_terminal'] = 'kitty'
        vim.g['jukit_mappings'] = 0
      end
    })


    use({ 'bfredl/nvim-lanterna', disable = true, opt = true })

    use({ 'GCBallesteros/jupytext.vim',  config = function() vim.g['jupytext_fmt'] = 'py' end }) --ft = { 'ipynb', 'python', 'markdown' }, ft = { 'ipynb' }, event = 'BufRead'
    use({ 'GCBallesteros/vim-textobj-hydrogen', ft = { 'python', 'julia', 'markdown' } })

    -- }}}
    -----------------------------------------------------------------------------//
    -- UI {{{1
    -----------------------------------------------------------------------------//


    use({
      'norcalli/nvim-colorizer.lua',
      cmd = { 'ColorizerToggle' },
      config = function()
        -- require('colorizer').setup({ 'lua', 'vim', 'kitty', 'conf' }, {
        require('colorizer').setup({'*'}, {
          RGB = true,
          mode = 'foreground',
        })
      end,
    })

    use({
      'lukas-reineke/virt-column.nvim',
      disable = true,
      -- event = 'BufEnter', --UIEnter
      config = function()
        require('as.highlights').plugin('virt_column', {
          { VirtColumn = { bg = 'None', fg = { from = 'Comment', alter = 10 } } },
        })
        require('virt-column').setup({ char = '▕' })
      end,
    })

    -- NOTE: Defer loading till telescope is loaded this as it implicitly loads telescope so needs to be delayed

    use({ 'stevearc/dressing.nvim', after = 'telescope.nvim', config = conf('dressing') })
    use({ 'stevearc/overseer.nvim', config = conf('ovs'), disable = false, event = 'BufRead' })
    -- find stevearcs dotfiles and copy his job:start block to take advantage of overseer like he has.

    use({ 'SmiteshP/nvim-navic', requires = 'neovim/nvim-lspconfig', config = conf('navic') }) --, requires = 'neovim/nvim-lspconfig'


    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{1
    --------------------------------------------------------------------------------
    use({ 'ii14/emmylua-nvim' })
    use({ 'nanotee/nvim-lua-guide', event = 'BufRead' })

    use({
      'chaoren/vim-wordmotion',
      disable = false,
      setup = function()
        vim.g.wordmotion_prefix = '<leader>'
        vim.g.wordmotion_spaces = { '-', '_', '\\/', '\\.' }
      end,
    })

    use({
      'kylechui/nvim-surround',
      tag = '*',
      config = function()
        -- require('nvim-surround').setup({})
        require('nvim-surround').setup({
          move_cursor = true,
          keymaps = { visual = 's' },
        })
      end
    })

    -- FIXME: https://github.com/L3MON4D3/LuaSnip/issues/129
    -- causes formatting bugs on save when update events are TextChanged{I}
    -- use_rocks({ 'jsregexp' })
    use({
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      module = 'luasnip',
      tag = "*",
      requires = { 'rafamadriz/friendly-snippets', 'honza/vim-snippets' },
      config = conf('luasnip'),
      --rocks = { 'jsregexp' },
    })

    use({ 'monaqa/dial.nvim', config = conf('dial') }) -- event = 'BufRead',

    use({
      'jghauser/fold-cycle.nvim',
      config = function()
        require('fold-cycle').setup()
        as.nnoremap('<BS>', function()
          require('fold-cycle').open()
        end)
      end,
    })

    use({
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
    })

    use({
      'windwp/nvim-autopairs',
      -- event = 'InsertCharPre',
      after = 'nvim-cmp',
      requires = 'nvim-cmp',
      config = function()
        local cmp = require('cmp')
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({}))
        require('nvim-autopairs').setup({
          map_c_w = true,
          close_triple_quotes = true,
          check_ts = true,
          ts_config = {
            lua = { 'string' },
          },
          fast_wrap = {
            chars = { '{', '[', '(', '"', "'", "`" },
            map = '<C-e>',
          },
        })
        -- require('nvim-autopairs').add_rules(require('nvim-autopairs.rules.endwise-lua'))
      end,
    })

    use({
      'danymat/neogen',
      requires = 'nvim-treesitter/nvim-treesitter',
      module = 'neogen',
      setup = function()
        as.nnoremap('<localleader>nc', require('neogen').generate, 'comment: generate')
      end,
      config = function()
        require('neogen').setup({
          enabled = true,
          languages = {
            lua = {
              template = {
                annotation_convention = 'emmylua',
              },
            },
            python = {
              template = {
                annotation_convention = 'google_docstrings', --numpydoc
              },
            },
          },
          snippet_engine = 'luasnip',
        })
      end,
    })

    use({
      'mizlan/iswap.nvim',
      cmd = { 'ISwap', 'ISwapWith' },
      config = function()
        require('iswap').setup()
      end,
      setup = function()
        as.nnoremap('<localleader>iw', '<Cmd>ISwapWith<CR>', 'ISwap: swap with')
        as.nnoremap('<localleader>ia', '<Cmd>ISwap<CR>', 'ISwap: swap any')
      end,
    })

    use({ 'rcarriga/nvim-notify', tag = '*', config = conf('notiphy') })

    use({
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      setup = function()
        as.nnoremap('<localleader>U', '<cmd>UndotreeToggle<CR>', 'undotree: toggle')
      end,
      config = function()
        vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
      end,
    })

    use({
      'moll/vim-bbye',
      event = 'BufRead',
      config = function()
        as.nnoremap('<leader>qq', '<Cmd>Bwipeout<CR>', 'bbye: quit')
      end,
    })

    -----------------------------------------------------------------------------//
    -- Quickfix
    -----------------------------------------------------------------------------//
    use({
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      event = 'BufReadPre',
      config = function()
        require('as.highlights').plugin('pqf', {
          theme = {
            ['doom-one'] = { { qfPosition = { link = 'Todo' } } },
            ['*'] = { { qfPosition = { link = 'String' } } },
          },
        })
        require('pqf').setup()
      end,
    })

    use({
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        require('as.highlights').plugin('bqf', {
          { BqfPreviewBorder = { fg = { from = 'String' } } },
        })
      end,
    })
    -- }}}
    --------------------------------------------------------------------------------
    -- Knowledge and task management {{{1
    --------------------------------------------------------------------------------

    use({
      "nvim-neorg/neorg",
      tag = '*',
      -- cmd = { "Neorg" },
      ft = 'norg',
      -- after = { "nvim-treesitter", "telescope.nvim" },
      -- wants = { "nvim-treesitter", "nvim-lspconfig", "nvim-cmp" },
      requires = { "nvim-neorg/neorg-telescope", "nvim-lua/plenary.nvim" },
      config = conf('neorg'),
    })

    -- use({ 'nvim-orgmode/orgmode', config = conf('orggmode'), ft = 'org' })
    use({ 'nvim-orgmode/orgmode', config = conf('orggmode') })

    use({
      'lukas-reineke/headlines.nvim',
      ft = { 'org', 'norg', 'markdown', 'yaml' },
      setup = conf('headlines').setup,
      config = conf('headlines').setup,
    })

    -- }}}
    --------------------------------------------------------------------------------
    -- Profiling & Startup {{{1
    --------------------------------------------------------------------------------
    -- TODO: this plugin will be redundant once https://github.com/neovim/neovim/pull/15436 is merged
    use({ 'lewis6991/impatient.nvim' })
    use({
      'dstein64/vim-startuptime',
      disable = false,
      tag = '*',
      cmd = 'StartupTime',
      config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { '+let g:auto_session_enabled = 0' }
      end,
    })
    -- }}}
    --------------------------------------------------------------------------------
    -- TPOPE {{{1
    --------------------------------------------------------------------------------
    use({
      'kristijanhusak/vim-dadbod-ui',
      disable = false,
      ft = { 'sql', 'mysql', 'plsql' },
      requires = 'tpope/vim-dadbod',
      cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection' },
      setup = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        as.nnoremap('<leader>db', '<cmd>DBUIToggle<CR>', 'dadbod: toggle')
      end,
    })

    use({
      'kristijanhusak/vim-dadbod-completion',
      -- after = { "nvim-cmp" },
      wants = { "kristijanhusak/vim-dadbod-ui" },
      disable = false,
      ft = { 'sql', 'mysql', 'plsql' },
      config = function()
        require('cmp').setup.buffer({
          sources = {{ name = 'vim-dadbod-completion' }}
        })
      end
    })

    use({
      'tpope/vim-abolish',
      event = 'BufRead',
      config = function()
        as.nnoremap('<localleader>[', ':S/<C-R><C-W>//<LEFT>', { silent = false })
        as.nnoremap('<localleader>]', ':%S/<C-r><C-w>//c<left><left>', { silent = false })
        as.xnoremap('<localleader>[', [["zy:'<'>S/<C-r><C-o>"//c<left><left>]], { silent = false })
      end,
    })

    use({ 'tpope/vim-repeat', event = 'BufRead' })

    use({ 'tpope/vim-scriptease', cmd = { 'Messages', 'Verbose', 'Time', 'Scriptnames' } })

    -- sets searchable path for filetypes like go so 'gf' works
    use({ 'tpope/vim-apathy' })

    -- }}}
    -----------------------------------------------------------------------------//
    -- Filetype Plugins {{{1
    -----------------------------------------------------------------------------//

    use({
      'olexsmir/gopher.nvim',
      disable = false,
      ft = 'go',
      requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter' },
    })

    use({
      'nanotee/sqls.nvim',
      disable = false,
      ft = { 'sql', 'plsql', 'mysql' },
      module = { 'sqls' },
      cmd = {
        "SqlsExecuteQuery",
        "SqlsExecuteQueryVertical",
        "SqlsShowDatabases",
        "SqlsShowSchemas",
        "SqlsShowConnections",
        "SqlsSwitchDatabase",
        "SqlsSwitchConnection",
      }
    })

    use({
      "dinhhuy258/vim-database",
      disable = true,
      run = ":UpdateRemotePlugins",
      cmd = { "VDToggleDatabase", "VDToggleQuery", "VimDatabaseListTablesFzf" },
    })

    use({ 'AckslD/swenv.nvim' })

    use({
      'AckslD/nvim-FeMaCo.lua',
      disable = false,
      cmd = 'FeMaco',
      module = { "femaco.edit" },
      -- ft = { 'markdown', 'norg', 'org' },
      config = function()
        require('femaco').setup({
          post_open_float = function(winnr)
            vim.api.nvim_win_set_option(winnr, 'winblend', 10)
          end,
        })
      end,
    })


    use({
      'iamcco/markdown-preview.nvim',
      opt = true,
      cmd = { "MarkdownPreview" },
      run = function()
        vim.fn['mkdp#util#install']()
      end,
      ft = { 'markdown' },
      config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end,
      requires = {
        "zhaozg/vim-diagram",
        "aklt/plantuml-syntax",
        -- quarto.nvim??
      }
    })

    use({ 'mtdl9/vim-log-highlighting' }) --, ft = { 'log', 'text' }

    use({ 'fladson/vim-kitty' })

    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{1
    --------------------------------------------------------------------------------

    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      -- run = function ()
      --   if vim.fn.exists(':TSUpdate') == 2 then
      --     vim.cmd(':TSUpdate')
      --   end
      -- end,
      config = conf('treesitter'),
      requires = {
        {
          'nvim-treesitter/playground',
          cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
          setup = function()
            as.nnoremap('<S-M-x>', '<Cmd>TSHighlightCapturesUnderCursor<CR>', 'treesitter: cursor highlight')
          end,
        },
      },
    })

    use({ 'p00f/nvim-ts-rainbow' })
    use({ 'nvim-treesitter/nvim-treesitter-textobjects' })
    use({ 'rrethy/nvim-treesitter-endwise', wants = "nvim-treesitter" }) -- event = "InsertEnter" })

    use({
      'm-demare/hlargs.nvim',
      -- event = 'BufRead',
      after = { 'nvim-treesitter' },
      config = function()
        require('as.highlights').plugin('hlargs', {
          theme = {
            -- ['*'] = { { Hlargs = { italic = true, foreground = '#A5D6FF' } } },
            ['*'] = { Hlargs = { italic = true } },
            -- ['horizon'] = { { Hlargs = { italic = true, foreground = { from = 'Normal' } } } },
            ['horizon'] = { Hlargs = { italic = true } },
          },
        })
        require('hlargs').setup({
          color = "#ef9062",
          use_colorpalette = false,
          -- highlight = { "TSParameter" },
          colorpalette = {
            { fg = "#ef9062" },
            { fg = "#3AC6BE" },
            { fg = "#18D27F" },
            { fg = "#EB75D6" },
            { fg = "#E5D180" },
            { fg = "#8997F5" },
            { fg = "#D49DA5" },
            { fg = "#7FEC35" },
            { fg = "#F6B223" },
            { fg = "#F67C1B" },
            { fg = "#DE9A4E" },
            { fg = "#BBEA87" },
            { fg = "#EEF06D" },
            { fg = "#8FB272" },
          },
          excluded_filetypes = {
            -- "lua",
            "rust",
            "typescript",
            "typescriptreact",
            "javascript",
            "javascriptreact"
          },
          excluded_argnames = {
            declarations = { 'use_rocks' },
            usages = {
              go = { '_' },
              -- lua = { 'self', 'use_rocks' },
              -- python = { 'self', 'cls' },
            },
          },
        })
      end,
    })

    use({ 'psliwka/vim-smoothie', event = 'BufRead'  })

    -- use({ 'psliwka/vim-dirtytalk', run = ':DirtytalkUpdate' })
    -- use('melvio/medical-spell-files')

    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{1
    --------------------------------------------------------------------------------

    use({
      'ruifm/gitlinker.nvim',
      module = 'gitlinker',
      requires = 'plenary.nvim',
      setup = conf('gytlinker').setup,
      config = conf('gytlinker').config,
    })

    use({
      'lewis6991/gitsigns.nvim',
      event = 'BufRead',
      config = conf('gytsigns')
    })

    use({
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = {
        '<localleader>gs',
        '<localleader>gl',
        '<localleader>gp'
      },
      requires = 'plenary.nvim',
      config = conf('neogit'),
    })

    use({
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
      module = 'diffview',
      setup = conf('dyffview').setup,
      config = conf('dyffview').config,
    })

    use({
      'aarondiel/spread.nvim',
      after = 'nvim-treesitter',
      module = 'spread',
      setup = function()
        as.nnoremap('gS', function()
          require('spread').out()
        end, 'spread: expand')
        as.nnoremap('gJ', function()
          require('spread').combine()
        end, 'spread: combine')
      end,
    })

    use({
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    })

    use({ 'wellle/targets.vim' })

    use({
      'kana/vim-textobj-user',
      requires = {
        'kana/vim-operator-user',
        {
          'glts/vim-textobj-comment',
          event = 'CursorHold',
          config = function()
            vim.g.textobj_comment_no_default_key_mappings = 1
            as.xmap('ax', '<Plug>(textobj-comment-a)')
            as.omap('ax', '<Plug>(textobj-comment-a)')
            as.xmap('ix', '<Plug>(textobj-comment-i)')
            as.omap('ix', '<Plug>(textobj-comment-i)')
          end,
        },
      },
    })


    -- }}}
    --------------------------------------------------------------------------------
    -- Search Tools {{{1
    --------------------------------------------------------------------------------

    use({
      'phaazon/hop.nvim',
      -- event = 'BufRead',
      tag = 'v2.*', -- branch = 'fix-multi-window-floats',
      keys = { { 'n', 'S' }, { 'n', 'f' }, { 'n', 'F' } },
      config = conf('hop'),
    })

    -- }}}
    --------------------------------------------------------------------------------
    -- Themes  {{{1
    --------------------------------------------------------------------------------
    use({ 'LunarVim/horizon.nvim' })
    use({ 'Lunarvim/onedarker.nvim' })
    use({ 'Lunarvim/darkplus.nvim' })
    use({ 'folke/tokyonight.nvim' })
    use({
      'Mofiqul/vscode.nvim',
      config = function ()
        vim.g.vscode_style = 'dark'
        vim.g.vscode_transparent = false
        vim.g.vscode_italic_comment = 1
        vim.g.vscode_disable_nvimtree_bg = false
      end
    })

    use({
      'NTBBloodbath/doom-one.nvim',
			-- module = 'doom-one',
      config = function()
        -- vim.g.doom_one_terminal_colors = true
        -- vim.g.doom_one_cursor_coloring = true
        -- vim.g.doom_one_transparent_background = true
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
    })
    -- }}}
    --------------------------------------------------------------------------------------------------
    -- Akinsho's  {{{1
    -----------------------------------------------------------------------------//

    use({
      'akinsho/org-bullets.nvim',
      ft = 'org',
      config = function()
        require('org-bullets').setup()
      end,
    })

    use({
      'akinsho/toggleterm.nvim',
      branch = 'main',
      config = conf('toggleterm'),
    })

    use({
      'akinsho/bufferline.nvim',
      disable = false,
      config = conf('bufferline'),
      requires = 'nvim-web-devicons',
    })

    use({
      'akinsho/git-conflict.nvim',
      opt = true,
      event = 'BufRead',
      config = function()
        require('git-conflict').setup({
          disable_diagnostics = true,
        })
      end,
    })
    --}}}
    --------------------------------------------------------------------------------------------------
    -- {{{ dead to me, the unloved

    -- use({
    --   'jakewvincent/mkdnflow.nvim',
    --   disable = true,
    --   opt = true,
    --   ft = { 'markdown' },
    --   config = function()
    --     require('mkdnflow').setup({})
    --   end,
    -- })
    -- use({
    --   'uga-rosa/ccc.nvim',
    --   disable = true,
    --   opt = true,
    --   event = 'BufRead',
    --   config = function()
    --     require('ccc').setup({
    --       win_opts = { border = as.style.current.border },
    --       highlighter = {
    --         auto_enable = false,
    --       },
    --     })
    --   end,
    -- })
    -- use({ 'vim-scripts/ReplaceWithRegister', disable = true, opt = true })
    -- use({
    --   'folke/todo-comments.nvim',
    --   after = 'nvim-treesitter',
    --   requires = 'nvim-treesitter/nvim-treesitter',
    --   config = function()
    --     require("todo-comments").setup()
    --     as.command('TodoDots', ('TodoQuickFix cwd=%s keywords=TODO,FIXME,NOTE'):format(vim.g.vim_dir))
    --   end,
    -- })
    -- use({
    --   "ziontee113/color-picker.nvim",
    --   disable = true,
    --   opt = true,
    --   cmd = { "PickColor", "PickColorInsert" },
    --   config = function()
    --     require "color-picker"
    --   end,
    -- })
    -- use({
    --   "max397574/colortils.nvim",
    --   disable = true,
    --   opt = true,
    --   cmd = "Colortils",
    --   config = function()
    --     require("colortils").setup()
    --   end
    -- })
    -- use({
    --   'kevinhwang91/nvim-ufo',
    --   -- disable = true,
    --   requires = 'kevinhwang91/promise-async',
    --   config = conf('ufoo'),
    -- })
    -- use({
    --   'linty-org/readline.nvim',
    --   disable = true,
    --   event = { 'CmdlineEnter' },
    --   config = function()
    --     local readline = require('readline')
    --     local map = vim.keymap.set
    --     map('!', '<M-f>',  readline.forward_word)
    --     map('!', '<M-b>',  readline.backward_word)
    --     map('!', '<C-a>',  readline.beginning_of_line)
    --     map('!', '<C-e>',  readline.end_of_line)
    --     map('!', '<M-d>',  readline.kill_word)
    --     map('!', '<M-BS>', readline.backward_kill_word)
    --     map('!', '<C-w>',  readline.unix_word_rubout)
    --     -- map('!', '<C-k>', readline.kill_line)
    --     -- map('!', '<C-u>', readline.backward_kill_line)
    --   end,
    -- })
    -- use({
    --   "0x100101/lab.nvim",
    --   run = 'cd js && npm ci',
    --   requires = { 'nvim-lua/plenary.nvim' },
    --   config = function()
    --     require("lab").setup({
    --       code_runner = { enabled = true }, -- default
    --       quick_data = { enabled = false }, -- true <- defualt
    --     })
    --   end
    -- })
    -- use({
    --   "matbme/JABS.nvim",
    --   cmd = "JABSOpen",
    --   config = function()
    --     require("jabs").setup()
    --   end,
    --   disable = false,
    -- })
    -- use({ "RRethy/vim-illuminate"})
    -- use({ 'untitled-ai/jupyter_ascending.vim' })
    -- use({
    --   'bfredl/nvim-ipy',
    --   opt = true,
    --   ft = { 'python', 'julia' }, -- 'markdown', 'norg', 'org' },
    --   config = function()
    --     vim.g['nvim_ipy_perform_mappings'] = 0
    --   end,
    -- })
    -- use({ 'hkupty/iron.nvim', opt = true, disable = true })
    -- use {"ahmedkhalf/jupyter-nvim",
    --   disable = true,
    --   run = ":UpdateRemotePlugins",
    --   config = function()
    --     require("jupyter-nvim").setup()
    --   end
    -- }
    -- use {
    --   "knubie/vim-kitty-navigator",
    --   run = 'cp ./*.py ~/.config/kitty/',
    --   cond = function() return not vim.env.TMUX end
    -- }
    -- }}}

  end,
  log = { level = 'info' },
  config = {
    max_jobs = 12,
    compile_path = PACKER_COMPILED_PATH,
    preview_updates = true,
    display = {
      prompt_border = as.style.current.border,
      open_cmd = 'silent topleft 65vnew',
    },
    git = {
      clone_timeout = 90,
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
})

as.command('PackerCompiledEdit', function()
  vim.cmd.edit(PACKER_COMPILED_PATH)
end)

as.command('PackerCompiledDelete', function()
  vim.fn.delete(PACKER_COMPILED_PATH)
  packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
end)

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  vim.cmd.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

as.nnoremap('<leader>ps', '<Cmd>PackerSync<CR>', 'packer: sync')
as.nnoremap('<leader>pc', '<Cmd>PackerClean<CR>', 'packer: clean')
as.nnoremap('<leader>pC', '<Cmd>PackerCompile<CR>', 'packer: compile')

local function reload()
  as.invalidate('as.plugins', true)
  packer.compile()
end

as.augroup('PackerSetupInit', {
  {
    event = 'BufWritePost',
    pattern = { '*/as/plugins/*.lua' },
    desc = 'Packer setup and reload',
    command = reload,
  },
  {
    event = 'User',
    pattern = { 'VimrcReloaded' },
    desc = 'Packer setup and reload',
    command = reload,
  },
  {
    event = 'User',
    pattern = 'PackerCompileDone',
    command = function()
      packer_notify('Compilation finished', 'info')
    end,
  },
})

-- vim:ft=lua fdm=marker ts=2 sts=2 sw=2 nospell
