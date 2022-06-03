local utils = require 'as.utils.plugins'

local conf = utils.conf
-- local use_local = utils.use_local
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath('cache') .. '/packer/packer_compiled.lua'

---Some plugins are not safe to be reloaded because their setup functions
 ---and are not idempotent. This wraps the setup calls of such plugins
 ---@param func fun()
function as.block_reload(func)
  if vim.g.packer_compiled_loaded then
    return
  end
  func()
end
-----------------------------------------------------------------------------//
-- Bootstrap Packer {{{3
-----------------------------------------------------------------------------//
utils.bootstrap_packer()
----------------------------------------------------------------------------- }}}1
-- cfilter plugin allows filter down an existing quickfix list
vim.cmd 'packadd! cfilter'

---@see: https://github.com/lewis6991/impatient.nvim/issues/35
as.safe_require 'impatient'

local packer = require 'packer'
--- NOTE "use" functions cannot call *upvalues* i.e. the functions
--- passed to setup or config etc. cannot reference aliased functions
--- or local variables
-- packer.luarocks.
packer.startup({
  -- function(use, use_rocks)
  function(use)
    -- FIXME: this no longer loads the local plugin since the compiled file now
    -- loads packer.nvim so the local alias(local-packer) does not work
    use ({ 'wbthomason/packer.nvim', local_path = 'contributing', opt = true })
    -----------------------------------------------------------------------------//
    -- Core {{{3
    -----------------------------------------------------------------------------//
    -- use_rocks 'penlight' --@eo trying to use local installed penlight
    -- use_rocks '/Users/eo/.luarocks/share/lua/5.1/pl' --penlight
    use ({
      'lewis6991/satellite.nvim',
      disable = true,
      config= function()
        require("satellite").setup({
          handlers = {
            gitsigns = {
              enable = false,
            },
            marks = {
              enable = false,
            },
          },
          excluded_filetypes = {
            'packer', 'neo-tree', 'norg', 'neo-tree-popup', 'dapui_scopes', 'dapui_stacks', 'python',
            'lua', 'julia'
          },
        })
      end,
    })

    use({ 'antoinemadec/FixCursorHold.nvim' } )

    use({
      'chentoast/marks.nvim',
      disable = true,
      config = conf('marks'),
    })


    use({
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      keys = { '<c-p>', '<localleader>fo', '<leader>ff', '<leader>fs' },
      module_pattern = 'telescope.*',
      config = conf('telescope'),
      requires = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('fzf')
          end,
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          after = 'telescope.nvim',
          requires = 'tami5/sqlite.lua',
        },
        {
          'camgraff/telescope-tmux.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('tmux')
          end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('smart_history')
          end,
        },
      },
    })

    -- use {
    --   "mrjones2014/dash.nvim",
    --   disable = true,
    --   command = "Dash",
    --   module = "dash",
    --   run = "make install",
    --   after = "telescope.nvim",
    -- }

    -- use({
    --   'ilAYAli/scMRU.nvim',
    --   cmd = { 'Mfu', 'Mru' },
    --   setup = function()
    --     as.nnoremap('<leader>fm', '<Cmd>Mfu<CR>', 'most freq used')
    --   end,
    -- })

    use({ 'kyazdani42/nvim-web-devicons' })

    use({ 'folke/which-key.nvim', config = conf 'whichkey' })

    use({
      'folke/trouble.nvim',
      keys = { '<leader>ld' },
      cmd = { 'TroubleToggle' },
      requires = 'nvim-web-devicons',
      setup = conf('trouble').setup,
      config = conf('trouble').config,
    })

    -- use {
    --   'rmagatti/auto-session',
    --   disable = true,
    --   config = function()
    --     require('auto-session').setup {
    --       log_level = 'error',
    --       auto_session_root_dir = ('%s/session/auto/'):format(vim.fn.stdpath 'data'),
    --     }
    --   end,
    -- }


    use({
      'knubie/vim-kitty-navigator',
      disable = true,
      run = 'cp ./*.py ~/.config/kitty/',
      cond = function()
        return vim.env.TMUX == nil
      end,
    })

    use({
      'nvim-lua/plenary.nvim',
      config = function()
        as.augroup('PlenaryTests', {
          {
            event = 'BufEnter',
            -- pattern = { '*/personal/*/tests/*_spec.lua' },
            pattern = { '*/*/tests/*_spec.lua' },
            command = function()
              require('which-key').register({
                t = {
                  name = '+plenary',
                  f = { '<Plug>PlenaryTestFile', 'test file' },
                  d = {
                    "<cmd>PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}<CR>",
                    'test directory',
                  },
                },
              }, {
                prefix = '<localleader>',
                buffer = 0,
              })
            end,
          },
        })
      end,
    })

    use({ 'lukas-reineke/indent-blankline.nvim', config = conf 'indentline' })

    -- use { 'kyazdani42/nvim-tree.lua', config = conf 'nvim-tree', requires = 'nvim-web-devicons', disable = true }
    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = conf('neo-tree'),
      keys = { '<C-n>' },
      cmd = { 'NeoTree' },
      requires = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'kyazdani42/nvim-web-devicons',
        {
          's1n7ax/nvim-window-picker',
          tag = "1.*",
          config = conf('window-picker')
        }
      },
    })
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{1
    -----------------------------------------------------------------------------//
    -- use { 'neovim/nvim-lspconfig', config = conf 'lspconfig' }
    use({
      'williamboman/nvim-lsp-installer',
      requires = { { 'neovim/nvim-lspconfig', config = conf('lspconfig') } },
      config = function()
        as.augroup('LspInstallerConfig', {
          {
            event = 'Filetype',
            pattern = 'lsp-installer',
            command = function()
              vim.api.nvim_win_set_config(0, { border = as.style.current.border })
            end,
          },
        })
      end,
    })

    use({
      'lukas-reineke/lsp-format.nvim',
      config = function()
        require('lsp-format').setup({
          go = { exclude = { 'gopls' } },
        })
        as.nnoremap('<leader>lf', '<cmd>FormatToggle<CR>', 'lsp format: toggle')
      end,
    })

    use({
      'narutoxy/dim.lua',
      requires = { 'nvim-treesitter/nvim-treesitter', 'neovim/nvim-lspconfig' },
      config = function()
        require('dim').setup({
          disable_lsp_decorations = true,
        })
      end,
    })

    use({
      'kosayoda/nvim-lightbulb',
      disable = true,
      config = function()
        local lightbulb = require('nvim-lightbulb')
        lightbulb.setup({
          ignore = { 'null-ls' },
          sign = { enabled = false },
          float = { enabled = true, win_opts = { border = 'NONE' } },
          autocmd = {
            enabled = true,
          },
        })
      end,
    })
    --    use 'b0o/schemastore.nvim'
    use({
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = conf('null-ls'),
    })

    use({
      'ray-x/lsp_signature.nvim',
      config = function()
        require('lsp_signature').setup({
          bind = true,
          fix_pos = false,
          auto_close_after = 10, -- close after 15 seconds
          hint_enable = false,
          handler_opts = { border = as.style.current.border },
        })
      end
    })

    ---{{{@EO setup
    --- NOTE: Need to set these as ftplugins!
    use({ "untitled-ai/jupyter_ascending.vim", disable = true })

    use({ "pechorin/any-jump.vim" })

    use({
      'Vimjas/vim-python-pep8-indent',
      ft = { 'python' },
    })

    use({ 'GCBallesteros/vim-textobj-hydrogen', disable = true })

    use({'kana/vim-textobj-line'})

    use({
      'GCBallesteros/jupytext.vim',
      opt = true,
      setup = function()
        vim.g['jupytext_fmt'] = {'md'}
      end,
    })

    use({ 'tversteeg/registers.nvim', disable = true })

    use({
      'andymass/vim-matchup',
      config = function()
        vim.g['matchup_matchparen_offscreen'] = { method = 'popup' }
        vim.g['matchup_matchparen_deferred'] = 1
        vim.g['matchup_matchparen_hi_surround_always'] = 1
        vim.g['matchup_surround_enabled'] = 1
      end,
    })

    use({
      'dccsillag/magma-nvim',
      -- ft = { 'python', 'julia' },
      run = ':UpdateRemotePlugins',
    })

    ---@Trialing eo
    use({
      "m-demare/hlargs.nvim",
      requires = { 'nvim-treesitter/nvim-treesitter'},
      ft = { 'python', 'lua', 'go', 'rust','vim', 'typescript'},
      config = function()
        require('hlargs').setup()
      end
    })

    use {
      "bfredl/nvim-ipy",
      ft = { "python", "julia", "markdown" },
      disable = true,
      config = function()
        vim.g.nvim_ipy_perform_mappings = 1
      end,
    }

    use({
      'michaelb/sniprun',
      run = 'bash ./install.sh',
      config = function()
        -- require("as.plugins.sniprun").setup()
        require("sniprun").setup()
      end,
    })

    use({
      'klafyvel/vim-slime-cells',
      disable = true,
      requires = { 'jpalardy/vim-slime', opt = true },
      ft = { 'julia', 'python' },
      config = function()
        vim.g.slime_target = 'kitty'
        vim.g.slime_cell_delimiter = '^\\s*##'
        -- vim.g.slime_default_config = {socket}
        -- vim.g.slime_bracketed_paste = 1
        -- vim.g.slime_no_mappings = 0
      end,
    })

    use({
      'jghauser/kitty-runner.nvim',
      opt = true,
      disable = true,
      config = function()
        require('kitty-runner').setup({
          use_keymaps = false,
        })
      end,
    })

    ---}}}
    use({
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      -- branch ='dev',
      event = { 'InsertEnter', 'CmdlineEnter' },
      config = conf('cmp'),
      requires = {
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        { 'f3fora/cmp-spell', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        { 'tzachar/cmp-tabnine', run = './install.sh', after = 'nvim-cmp' },
        { 'kdheepak/cmp-latex-symbols', after = 'nvim-cmp' },
        { 'uga-rosa/cmp-dictionary', after = 'nvim-cmp' },
        { 'dmitmel/cmp-cmdline-history', after = 'nvim-cmp' },
      },
    })

    use({
      'AckslD/nvim-neoclip.lua',
      config = function()
        require('neoclip').setup({
          enable_persistent_history = true,
          keys = {
            telescope = {
              i = { select = '<c-p>', paste = '<CR>', paste_behind = '<c-k>' },
              n = { select = 'p', paste = '<CR>', paste_behind = 'P' },
            },
          },
        })
        local function clip()
          require('telescope').extensions.neoclip.default(require('telescope.themes').get_dropdown())
        end

        require('which-key').register({
          ['<localleader>p'] = { clip, 'neoclip: open yank history' },
        })
      end,
    })

    -- FIXME: https://github.com/L3MON4D3/LuaSnip/issues/129
    -- causes formatting bugs on save when updateevents are TextChanged{I}
    use({
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      module = 'luasnip',
      requires = 'rafamadriz/friendly-snippets',
      config = conf('luasnip'),
    })
    -- }}}
    -----------------------------------------------------------------------------//
    -- Testing and Debugging {{{1
    -----------------------------------------------------------------------------//
    use({
      'vim-test/vim-test',
      opt = true,
      cmd = { 'TestFile', 'TestNearest', 'TestSuite' },
      setup = conf('vim-test').setup,
      config = conf('vim-test').conf,
    })

    use({
      'rcarriga/vim-ultest',
      wants = { 'vim-test' },
      requires = { 'vim-test' },
      event = 'CursorHold *_spec.*,*_test.*',
      setup = conf('ultest').setup,
      config = conf('ultest').config,
    })

    -- use({
    --   'mfussenegger/nvim-dap',
    --   setup = conf('dap').setup,
    --   config = conf('dap').config,
    --   requires = {
    --     {
    --       'rcarriga/nvim-dap-ui',
    --       after = 'nvim-dap',
    --       config = conf 'dapui',
    --     },
    --     {
    --       'theHamsta/nvim-dap-virtual-text',
    --       config = function()
    --         require('nvim-dap-virtual-text').setup()
    --       end,
    --     },
    --   },
    -- })

    -- use { 'jbyuki/one-small-step-for-vimkind', requires = 'nvim-dap' }
    use({'folke/lua-dev.nvim'})

    --}}}
    -----------------------------------------------------------------------------//
    -- UI
    -----------------------------------------------------------------------------//
    use({
      'b0o/incline.nvim',
      config = conf('incline')
    })

    use({
      'stevearc/dressing.nvim',
      -- NOTE: Defer loading till telescope is loaded.
      -- This implicitly loads telescope so needs to be delayed
      after = 'telescope.nvim',
      config = conf('dressing')

    })

    --------------------------------------------------------------------------------
    -- Utilities {{{1
    --------------------------------------------------------------------------------
    use({'nanotee/luv-vimdocs'})
    use({'milisims/nvim-luaref'})

    use({
      'simrat39/symbols-outline.nvim',
      cmd = 'SymbolsOutline',
      setup = function()
        as.nnoremap('<leader>lS',
          '<cmd>SymbolsOutline<CR>', 'toggle: symbols outline')
        vim.g.symbols_outline = {
          border = as.style.current.border,
          auto_preview = true,
        }
      end
    })

    use({
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        as.block_reload(function()
        require('todo-comments').setup({
          highlight = {
            exclude = { 'org', 'orgagenda', 'vimwiki' },
          },
        })
        as.nnoremap('<leader>lt', '<Cmd>TodoTrouble<CR>', 'trouble: todos')
        end)
      end,
    })

    use({
      "simeji/winresizer",
      setup = function()
        vim.g.winresizer_start_key = '<leader>w'
      end,
    })

    -- prevent select and visual mode from overwriting the clipboard
    use({
      'kevinhwang91/nvim-hclipboard',
      disable = true, -- eo
      event = 'InsertCharPre',
      config = function()
        require('hclipboard').start()
      end,
    })

    use({ 'monaqa/dial.nvim', config = conf('dial') })

    use({
      'jghauser/fold-cycle.nvim',
      config = function()
        require('fold-cycle').setup({})
        as.nnoremap('<BS>', function()
          require('fold-cycle').open()
        end)
      end,
    })

    use({
      'rainbowhxch/beacon.nvim',
      config = function()
        require("as.highlights").plugin('beacon', {
          Beacon = { link = 'Cursor' },
        })
        require 'beacon'.setup({
          minimal_jump = 20,
          ignore_buffers = { 'terminal', 'nofile', 'neorg://Quick Actions' },
          ignore_filetypes = {
            'neo-tree',
            'qf',
            'NeogitCommitMessage',
            'NeogitPopup',
            'NeogitStatus',
            'packer',
            'trouble',
          },
        })
      end,
    })

    use({
      'mfussenegger/nvim-treehopper',
      config = function()
        as.omap('m', ":<C-U>lua require('tsht').nodes()<CR>")
        as.vnoremap('m', ":lua require('tsht').nodes()<CR>")
      end,
    })

    use({
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      config = function()
        require('nvim-autopairs').setup({
          close_triple_quotes = true,
          check_ts = true, -- eo
          ts_config = {
            lua = { 'string', 'source' },
            javascript = { 'string', 'template_string' },
            -- python = { 'string' },
            -- java = false,
          },
          -- map_cw = {},
          enable_afterquote = true,
          fast_wrap = {
            map = '<C-e>', --@eo check christianchurchelli's/lunarvim's config
            chars = { '{', '[', '(', '"', "'" },
            -- pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
            -- offset = 0,
            -- end_key = '$',
            -- keys = 'qwertyuiopzxcvbnmasdfghjkl',
            -- check_comma = true,
            -- highlight = 'PmenuSel',
            -- highlight_grey = "LineNr",
          },
        })
      end,
    })

    use({
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup({
          mappings = { '<C-u>', '<C-d>' }, -- eo
          stop_eof = false,
          hide_cursor = true,
        })
      end,
    })

    -- use({
    --   "mg979/vim-visual-multi",
    --   config = function()
    --     vim.g.VM_highlight_matches = "underline"
    --     vim.g.VM_theme = "codedark"
    --     vim.g.VM_maps = {
    --       ["Find Under"] = "<C-e>",
    --       ["Find Subword Under"] = "<C-e>",
    --       ["Select Cursor Down"] = "\\j",
    --       ["Select Cursor Up"] = "\\k",
    --     }
    --   end,
    -- })

    use({
      'danymat/neogen',
      -- keys = { '<localleader>nc' },
      requires = 'nvim-treesitter/nvim-treesitter',
      module = 'neogen',
      setup = function()
        as.nnoremap('<localleader>nc', require('neogen').generate, 'comment: generate')
        -- require('which-key').register({
        --   ['<localleader>nc'] = 'comment: generate',
        -- })
      end,
      config = function()
        require('neogen').setup({ snippet_engine = 'luansip' })
      end,
    })

    use({
      'j-hui/fidget.nvim',
      event = { "BufNew", "BufNew", "BufRead" },
      config = function()
        require('fidget').setup({
          -- text = { spinner = 'moon' },
          text = { spinner = 'circle_halves' },
        })
      end,
    })

    -- TODO: causes blocking output in headless mode
    use({'rcarriga/nvim-notify', cond = utils.not_headless, config = conf('notify') })

    use({
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      keys = '<leader>u',
      setup = function()
        require('which-key').register({
          ['<leader>u'] = 'undotree: toggle',
        })
      end,
      config = function()
        vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
        as.nnoremap('<leader>u', '<cmd>UndotreeToggle<CR>')
      end,
    })

    use({
      'iamcco/markdown-preview.nvim',
      -- run = 'cd app && yarn install',
      run = function()
        vim.fn['mkdp#util#install']()
      end,
      ft = { 'markdown' },
      config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end,
    })

    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup({ '*' }, {
          RGB = true, -- eo
          RRGGBB = true, -- eo
          names = true, -- eo quick test -> (should be YELLOW) #FFFF32
          mode = 'foreground', -- eo
        })
      end,
    })

    use({
      'moll/vim-bbye',
      config = function()
        as.nnoremap('<leader>qq', '<Cmd>Bwipeout<CR>')
      end,
    })

    -----------------------------------------------------------------------------//
    -- Quickfix
    -----------------------------------------------------------------------------//
    use({
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      event = 'BufReadPre',
      config = function()
        require('as.highlights').plugin('pqf', { qfPosition = { link = 'Tag' } })
        require('pqf').setup({})
      end,
    })

    use({
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        require('as.highlights').plugin('bqf', { BqfPreviewBorder = { foreground = 'Gray' } })
      end,
    })
    --------------------------------------------------------------------------------
    -- Knowledge and task management {{{1
    --------------------------------------------------------------------------------
    use({
      'vimwiki/vimwiki',
      -- branch = 'dev',
      keys = { '<localleader>ww', '<localleader>wt', '<localleader>wi' },
      event = { 'BufEnter *.wiki' },
      setup = conf('vimwiki').setup,
      config = conf('vimwiki').config,
    })

    use({
      'vhyrro/neorg',
      requires = { 'vhyrro/neorg-telescope', 'max397574/neorg-kanban' },
      config = conf('neorg'),
    })

    use({
      'lukas-reineke/headlines.nvim',
      setup = conf('headlines').setup,
      config = conf('headlines').config,
    })
    -- }}}
    --------------------------------------------------------------------------------
    -- Profiling & Startup {{{1
    --------------------------------------------------------------------------------
    -- TODO: this plugin will be redundant once https://github.com/neovim/neovim/pull/15436 is merged
    use({'lewis6991/impatient.nvim'})
    use({
      'dstein64/vim-startuptime',
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
    use({'tpope/vim-eunuch'})
    use({'tpope/vim-sleuth'})
    use({'tpope/vim-repeat'})
    use({'tpope/vim-scriptease'})
    use({
      'tpope/vim-abolish',
      config = function()
        local opts = { silent = false }
        as.nnoremap('<localleader>[', ':S/<C-R><C-W>//<LEFT>', opts)
        as.nnoremap('<localleader>]', ':%S/<C-r><C-w>//c<left><left>', opts)
        as.xnoremap('<localleader>[', [["zy:%S/<C-r><C-o>"//c<left><left>]], opts)
      end,
    })
    -- sets searchable path for filetypes like go so 'gf' works
    use('tpope/vim-apathy')
    use({ 'tpope/vim-projectionist', config = conf('vim-projectionist') })
    use({
      'tpope/vim-surround',
      config = function()
        as.xmap('s', '<Plug>VSurround')
        as.xmap('s', '<Plug>VSurround')
      end,
    })
    -- }}}
    -----------------------------------------------------------------------------//
    -- Filetype Plugins {{{1
    -----------------------------------------------------------------------------//

    use({
      'ray-x/go.nvim',
      disable = true,
      ft = 'go',
      config = function()
        local path = require('nvim-lsp-installer.path')
        local install_root_dir = path.concat({ vim.fn.stdpath('data'), 'lsp_servers' })
        require('go').setup({
          gopls_cmd = { install_root_dir .. '/go/gopls' },
          max_line_len = 100,
          goimport = 'goimport',
          lsp_cfg = true,
          lsp_gofumpt = true,
          lsp_on_attach = as.lsp.on_attach,
          lsp_diag_virtual_text = {
            space = 0,
            prefix = as.style.icons.misc.bug,
          },
        })
        as.augroup('Golang', {
          {
            event = { 'BufWritePre' },
            pattern = { '*.go' },
            command = 'silent! lua require("go.format").goimport()',
          },
        })
      end,
    })

    -- use 'dart-lang/dart-vim-plugin'
    use('mtdl9/vim-log-highlighting')
    use('fladson/vim-kitty')
    use({
      'SmiteshP/nvim-gps',
      requires = 'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-gps').setup({})
      end,
    })
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{1
    --------------------------------------------------------------------------------
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = conf('treesitter'),
      -- wants = { 'null-ls.nvim', 'lua-dev.nvim' },
    })
    use({'RRethy/nvim-treesitter-endwise'})
    use({'p00f/nvim-ts-rainbow'})
    use({'nvim-treesitter/nvim-treesitter-textobjects'})
    use({
      'nvim-treesitter/playground',
      -- keys = '<leader>E',
      cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
      setup = function()
        as.nnoremap(
          '<leader>E',
          '<Cmd>TSHighlightCapturesUnderCursor<CR>',
          'treesitter: highlight cursor group'
        )
        -- require('which-key').register({ ['<leader>E'] = 'treesitter: highlight cursor group' })
      end,
    })
    use({
      'nvim-treesitter/nvim-treesitter-context',
      disable = true,
      config = function()
        require('as.highlights').plugin('treesitter-context',
          { TreesitterContext = { inherit = 'Normal' },
          })
          require("treesitter-context").setup()
      end,
    })

    -- Use <Tab> to escape from pairs such as ""|''|() etc.
    use({
      'abecodes/tabout.nvim',
      wants = { 'nvim-treesitter' },
      after = { 'nvim-cmp' },
      config = function()
        require('tabout').setup({
          completion = false,
          ignore_beginning = false,
        })
      end,
    })

    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{1
    --------------------------------------------------------------------------------

    use({
      "ruifm/gitlinker.nvim",
      disable = true,
      requires = "plenary.nvim",
      keys = { "<localleader>gu", "<localleader>go" },
      setup = function()
        require("which-key").register(
          { gu = "gitlinker: get line url", go = "gitlinker: open repo url" },
          { prefix = "<localleader>" }
        )
      end,
      config = function()
        local linker = require("gitlinker")
        linker.setup({ mappings = "<localleader>go" })
        as.nnoremap("<localleader>go", function()
          linker.get_repo_url { action_callback = require("gitlinker.actions").open_in_browser }
        end)
      end,
    })

    use({
      'lewis6991/gitsigns.nvim',
      event = 'CursorHold',
      config = conf('gitsigns')
    })

    -- use {
    --   'pwntester/octo.nvim',
    --   requires = {
    --     'nvim-lua/plenary.nvim',
    --     'nvim-telescope/telescope.nvim',
    --     'kyazdani42/nvim-web-devicons',
    --   },
    --   cmd = 'Octo',
    --   keys = { '<leader>Oli', '<leader>Olp' },
    --   config = conf('octo'),
    -- }

    use {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      keys = { "<localleader>gs", "<localleader>gl", "<localleader>gp" },
      requires = "plenary.nvim",
      setup = conf("neogit").setup,
      config = conf("neogit").config,
    }

    use({
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      module = "diffview",
      keys = "<localleader>gd",
      setup = function()
        -- require("which-key").register({ ["<localleader>gd"] = "diffview: diff HEAD" })
        as.nnoremap('<localleader>gd', '<Cmd>DiffviewOpen', 'diffview: diff HEAD')
      end,
      config = function()
        require("diffview").setup({
          enhanced_diff_hl = true,
          key_bindings = {
            file_panel = { q = "<Cmd>DiffviewClose<CR>" },
            view = { q = "<Cmd>DiffviewClose<CR>" },
          },
        })
      end,
    })

    use({
      'rlch/github-notifications.nvim',
      disable = true,
      -- don't load this plugin if the gh cli is not installed
      cond = function()
        return as.executable('gh')
      end,
      requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    })
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{1
    --------------------------------------------------------------------------------
    -- use {
    --   "AndrewRadev/splitjoin.vim",
    --   opt = true,
    --   -- disable = true,
    --   config = function()
    --     require("which-key").register { gS = "splitjoin: split", gJ = "splitjoin: join" }
    --   end,
    -- }

    use ({
      'AckslD/nvim-trevJ.lua',
      module = 'trevj',
      setup = function()
        as.nnoremap('gS', function()
          require('trevj').format_at_cursor()
        end, { desc = 'splitjoin: split' })
      end,
      config = function()
        require('trevj').setup()
      end,
    })

    use({
      'Matt-A-Bennett/vim-surround-funk',
      config = conf('surround-funk'),
    })

    use({
      'chaoren/vim-wordmotion',
      opt = true,
      fn = { "<Plug>WordMotion_w" }
    })

    use({
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    })

    use({
      'gbprod/substitute.nvim',
      config = function()
        require('substitute').setup()
        as.nnoremap('S', function()
          require('substitute').operator()
        end)
        as.xnoremap('S', function()
          require('substitute').visual()
        end)
        as.nnoremap('X', function()
          require('substitute.exchange').operator()
        end)
        as.xnoremap('X', function()
          require('substitute.exchange').visual()
        end)
        as.nnoremap('Xc', function()
          require('substitute.exchange').cancel()
        end)
      end,
    })

    use('wellle/targets.vim')
    use({
      'kana/vim-textobj-user',
      requires = {
        'kana/vim-operator-user',
        {
          'glts/vim-textobj-comment',
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
      keys = { { 'n', 's' }, 'f', 'F' },
      config = conf('hop'),
    })

    -- }}}
    --------------------------------------------------------------------------------
    -- Themes  {{{1
    --------------------------------------------------------------------------------
    use({
      'NTBBloodbath/doom-one.nvim',
      config = function()
        require('doom-one').setup({
          pumblend = {
            enable = true,
            transparency_amount = 3,
          },
        })
      end,
    })
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{1
    ---------------------------------------------------------------------------------
    use({ 'rafcamlet/nvim-luapad', cmd = 'Luapad' })
    -- }}}
    ---------------------------------------------------------------------------------
    -- Personal plugins {{{1
    -----------------------------------------------------------------------------//
    use({
      'akinsho/toggleterm.nvim',
      branch = 'main',
      config = conf('toggleterm'),
    })

    use({
      'akinsho/bufferline.nvim',
      branch = 'main',
      config = conf('bufferline'),
      requires = 'nvim-web-devicons',
    })
    --}}}
    ---------------------------------------------------------------------------------
  end,
  log = { level = 'info' },
  config = {
    max_jobs = 50,
    compile_path = PACKER_COMPILED_PATH,
    display = {
      prompt_border = as.style.current.border,
      open_cmd = 'silent topleft 65vnew',
    },
    git = {
      clone_timeout = 240,
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
})

as.command('PackerCompiledEdit', function()
  vim.cmd(fmt('edit %s', PACKER_COMPILED_PATH))
end)

as.command('PackerCompiledDelete', function()
  vim.fn.delete(PACKER_COMPILED_PATH)
  packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
end)

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  as.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

as.augroup('PackerSetupInit', {
  {
    event = 'BufWritePost',
    pattern = { '*/as/plugins/*.lua' },
    description = 'Packer setup & reload',
    command = function()
      as.invalidate('as.plugins', true)
      packer.compile()
    end,
  },
  --- Open a repository from an authorname/repository string
  --- e.g. 'akinso/example-repo'
  {
    event = 'BufEnter',
    buffer = 0,
    command = function()
      as.nnoremap('gf', function()
---@diagnostic disable-next-line: missing-parameter
        local repo = fn.expand('<cfile>')
        if not repo or #vim.split(repo, '/') ~= 2 then
          return vim.cmd 'norm! gf'
        end
        local url = fmt('https://www.github.com/%s', repo)
        fn.jobstart('open ' .. url)
        vim.notify(fmt('Opening %s at %s', repo, url))
      end)
    end,
  },
  {
    event = 'User',
    pattern = 'PackerCompileDone',
    description = 'inform me that packer has finished compiling',
    command = function()
      vim.notify('Packer compile complete', nil, { title = 'Packer' })
    end,
  },
})

as.nnoremap('<leader>ps', [[<Cmd>PackerSync<CR>]])
as.nnoremap('<leader>pc', [[<Cmd>PackerClean<CR>]])

-- vim:foldmethod=marker
