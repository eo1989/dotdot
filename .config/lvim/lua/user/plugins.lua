local M = {}

M.config = function()
	lvim.plugins = {
		-- { "arkav/lualine-lsp-progress" },
		{
			"phaazon/hop.nvim",
			event = "BufRead",
			config = function()
				require("hop").setup()
				vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
				vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
			end,
		},
		{ "ggandor/lightspeed.nvim", event = "BufRead" },
		{ "tami5/sql.nvim" },
		{
			"nvim-telescope/telescope-cheat.nvim",
			config = function()
				require("telescope").load_extension("cheat")
			end,
		},
		{
			"kdheepak/cmp-latex-symbols",
			requires = "hrsh7th/nvim-cmp",
		},
		{
			"hrsh7th/cmp-nvim-lua",
			requires = "hrsh7th/nvim-cmp",
		},
		{
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			requires = "hrsh7th/nvim-cmp",
			config = function()
				local tabnine = require("cmp_tabnine.config")
				tabnine:setup({
					max_lines = 100,
					max_num_results = 10,
					sort = true,
				})
			end,
			-- disable = not lvim.builtin.tabnine.active,
		},
		{ "chrisbra/unicode.vim" },
		-- { "sudormrfbin/cheatsheet.nvim" },
		{ "romainl/vim-devdocs" },
		{
			"christoomey/vim-tmux-navigator",
			config = function()
				vim.g.tmux_navigator_no_mappings = 1
				vim.g.tmux_navigator_disable_when_zoomed = 1
				vim.g.tmux_navigator_save_on_switch = 2
				vim.cmd([[
          nnoremap <c-h> <cmd>TmuxNavigateLeft<cr>
          nnoremap <c-j> <cmd>TmuxNavigateDown<cr>
          nnoremap <c-k> <cmd>TmuxNavigateUp<cr>
          nnoremap <c-l> <cmd>TmuxNavigateRight<cr>
      ]])
			end,
		},
		{ "editorconfig/editorconfig-vim" },
		{ "kdheepak/JuliaFormatter.vim", ft = { "julia" } },
		{
			"JuliaEditorSupport/julia-vim",
			-- disable = true,
			-- config = function()
			-- 	vim.g.latex_to_unicode_tab = 1
			-- vim.cmd([[
			--       let g:latex_to_unicode_tab = "insert"
			-- end,
		},
		{
			"dccsillag/magma-nvim",
			run = ":UpdateRemotePlugins",
		},
		{
			"Vimjas/vim-python-pep8-indent",
			ft = { "python" },
		},
		{
			"ahmedkhalf/jupyter-nvim",
			disable = true,
			run = ":UpdateRemotePlugins",
			config = function()
				require("jupyter-nvim").setup()
			end,
			-- ft = { "python", "julia" },
		},
		{
			"bfredl/nvim-ipy",
			-- ft = { "python", "julia" },
		},
		{
			"junegunn/vim-easy-align",
			setup = function()
				vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
				vim.api.nvim_set_keymap("o", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
				vim.api.nvim_set_keymap("v", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
			end,
			keys = "<Plug>(EasyAlign)",
		},
		{
			"rcarriga/nvim-notify",
			disable = true,
			config = function()
				local notify = require("notify")
				notify.setup({
					stages = "fade_in_slide_out", -- fade
					timeout = 3000,
				})

				--- Send a notification
				--@param msg of the notification to show to the user
				--@param level Optional log level
				--@param opts Dict w/ optional options (timeout, etc)
				vim.notify = function(msg, level, opts)
					local l = vim.log.levels
					assert(type(msg) == "string", "msg should be a str")
					assert(type(level) ~= "table", "lvl should be one of vim.log.levels or a str")
					opts = opts or {}
					level = level or l.INFO
					local levels = {
						[l.DEBUG] = "Debug",
						[l.INFO] = "Info",
						[l.WARN] = "Warning",
						[l.ERROR] = "Error",
					}
					opts.title = opts.title or type(level) == "string" and level or levels[level]
					notify(msg, level, opts)
				end
			end,
			-- vim.cmd([[
			--       hi! NotifyERROR      guifg=#e27878
			--       hi! NotifyWARN       guifg=#e2a478
			--       hi! NotifyINFO       guifg=#b4be82
			--       hi! NotifyDEBUG      guifg=#89b8c2
			--       hi! NotifyTRACE      guifg=#c6c8d1
			--       hi! NotifyERRORTitle guifg=#e98989
			--       hi! NotifyWARNTitle  guifg=#e9b189
			--       hi! NotifyINFOTitle  guifg=#c0ca8e
			--       hi! NotifyDEBUGTitle guifg=#95c4ce
			--       hi! NotifyTRACETitle guifg=#d2d4de
			--     ]]),
		},
		{ "milisims/nvim-luaref" },
		{ "bfredl/nvim-luadev" },
		{ "nanotee/luv-vimdocs" },
		{ "tjdevries/nlua.nvim" },
		{
			"chaoren/vim-wordmotion",
			config = function()
				vim.cmd([[
      nmap dw de
      nmap cw ce
      nmap dW dE
      nmap cW cE
      ]])
			end,
		},
		{ "wellle/targets.vim" },
		{
			"kana/vim-textobj-user",
			requires = {
				"kana/vim-operator-user",
				{
					"glts/vim-textobj-comment",
					config = function()
						vim.g.textobj_comment_no_default_key_mappings = 1
						vim.cmd([[
              xmap ax <Plug>(textobj-comment-a)
              omap ax <Plug>(textobj-comment-a)
              xmap ix <Plug>(textobj-comment-i)
              omap ix <Plug>(textobj-comment-i)
          ]])
					end,
				},
			},
		},
		{
			"nvim-treesitter/playground",
			cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
		},
		{ "pechorin/any-jump.vim" },
		{ "tpope/vim-characterize" },
		{ "tpope/vim-surround" },
		-- sets sarchable path for ft's like py, go, so 'gf' works
		{ "tpope/vim-apathy", ft = { "go", "python", "lua", "bash", "julia", "toml", "yaml" } },
		{ "mbbill/undotree" },
		{
			"TimUntersberger/neogit",
			cmd = "Neogit",
			config = function()
				require("neogit").setup({
					disable_signs = false,
					disable_context_highlighting = false,
					signs = {
						-- { CLOSED, OPENED }
						section = { "", "" },
						item = { "+", "-" },
						hunk = { "", "" },
					},
					integrations = {
						diffview = true,
					},
				})
			end,
			requires = {
				{
					"sindrets/diffview.nvim",
					cmd = { "DiffViewOpen" },
				},
				{ "nvim-lua/plenary.nvim" },
			},
		},
		{
			"monaqa/dial.nvim",
			event = "BufRead",
			config = function()
				require("user.dial").config()
			end,
		},
		{
			"tpope/vim-scriptease",
			cmd = { "Messages", "Verbose", "Time", "ScriptNames" },
		},
		{ "lunarvim/colorschemes" },
		{
			"ray-x/lsp_signature.nvim",
			event = "InsertEnter",
			config = function()
				require("user.lsp_signature").config()
			end,
		},
		{
			"folke/lua-dev.nvim",
			config = function()
				local luadev = require("lua-dev").setup({
					lspconfig = lvim.lang.lua.lsp.setup,
				})
				lvim.lang.lua.lsp.setup = luadev
				-- require("user.lua_dev").config()
			end,
			-- ft = "lua",
			-- disable = not lvim.builtin.lua_dev.active,
		},
		{
			"folke/lsp-colors.nvim",
			event = "BufRead",
		},
		{
			"folke/trouble.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("trouble").setup({ auto_close = true, auto_preview = true })
			end,
			cmd = "Trouble",
		},
		{
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("todo-comments").setup()
			end,
			event = "BufRead",
		},
		{ "glepnir/zephyr-nvim" },
		{
			"folke/tokyonight.nvim",
			config = function()
				vim.g.tokyonight_dev = true
				vim.g.tokyonight_style = "storm" -- storm, night, day
				vim.g.tokyonight_hide_inactive_statusline = true
				vim.g.tokyonight_italic_variables = true
				vim.g.tokyonight_italic_functions = true
				vim.g.tokyonight_italic_keywords = true
				vim.g.tokyonight_italic_comments = true
				vim.g.tokyonight_terminal_colors = true
			end,
		},
		{
			"NTBBloodbath/doom-one.nvim",
			config = function()
				vim.g.doom_one_italic_comments = true
				vim.g.doom_one_terminal_colors = true
				vim.g.doom_one_telescope_highlights = true
			end,
		},
		{
			"simrat39/symbols-outline.nvim",
			cmd = "SymbolsOutline",
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("user.indentline")
			end,
		},
		{
			"kevinhwang91/nvim-bqf",
			config = function()
				require("bqf").setup({
					auto_enable = true,
					preview = {
						auto_preview = true,
						win_height = 14,
						win_vheight = 12,
						delay_syntax = 80,
						border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
						wrap = true,
					},
					func_map = {
						vsplit = "",
						ptogglemode = "z,",
						stoggleup = "",
					},
					filter = {
						fzf = {
							action_for = {
								["ctrl-t"] = "tabedit",
								["ctrl-x"] = "split",
								["ctrl-v"] = "vsplit",
								["ctrl-b"] = "signtoggle",
							},
							extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
						},
					},
				})
			end,
		},
		{
			"andymass/vim-matchup",
			event = "CursorMoved",
			config = function()
				vim.g.matchup_matchparen_deferred = 1
				vim.g.matchup_matchparen_offscreen = {
					method = "popup",
					fullwidth = true,
					highlight = "Normal",
				}
			end,
		},
		{
			"p00f/nvim-ts-rainbow",
			-- requires = "nvim-treesitter",
			-- after = "nvim-treesitter",
		},
		{ "Rrethy/nvim-treesitter-textsubjects", requires = "nvim-treesitter", after = "nvim-treesitter" },
		{ "nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter", after = "nvim-treesitter" },
		{ "mtdl9/vim-log-highlighting" },
		{
			"plasticboy/vim-markdown",
			ft = { "markdown" },
		},
		{
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
			ft = { "markdown" },
			config = function()
				vim.g.mkdp_auto_start = 1
				vim.g.mkdp_auto_close = 1
			end,
		},
		{
			"norcalli/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup({ "*" }, {
					RGB = true,
					mode = "foreground",
				})
			end,
		},
		{
			"marko-cerovac/material.nvim",
			config = function()
				vim.g.material_style = "ocean" -- deep ocean, oceanic, darker, lighter, palenight
				vim.g.material_italic_comments = true
				vim.g.material_italic_strings = true
				vim.g.material_italic_keywords = true
				vim.g.material_italic_functions = true
				vim.g.material_italic_variables = true
				vim.g.material_borders = true
			end,
		},
		{
			"sainnhe/edge",
			config = function()
				vim.g.edge_style = "neon" -- default, neon, aura
				vim.g.edge_enable_italic = 1
			end,
		},
		{
			"sainnhe/sonokai",
			config = function()
				-- vim.cmd([[
				vim.g.sonokai_style = "andromeda"
				vim.g.sonokai_enable_italic = 1
				vim.g.sonokai_cursor = "blue"
				-- ]])
				-- atlantis, andromeda or default
			end,
		},
		{ "Th3Whit3Wolf/one-nvim" },
		{ "junegunn/fzf" },
		{ "junegunn/fzf.vim" },
		{
			"rafcamlet/nvim-luapad",
			-- ft = { "lua" },
		},
		{
			"michaelb/sniprun",
			cmd = { "SnipRun" },
			run = "bash ./install.sh",
			config = function()
				require("sniprun").setup({
					display = {
						"VirtualTextOk",
						"VirtualTextErr",
						"LongTempFloatingWindow",
						-- "Terminal",
					},
					snipruncolors = {
						SniprunVirtualTextOk = { fg = "#51AFEF", bg = "#3E4556", ctermbg = "7", ctermfg = "4" },
						SniprunVirtualTextErr = { fg = "#E06C75", bg = "#3E4556", ctermbg = "7", ctermfg = "1" },
						SniprunFloatingWinOk = { fg = "#51AFEF", ctermfg = "4*", ctermbg = "7" },
						SniprunFloatingWinErr = { fg = "#E06C75", ctermfg = "1*", ctermbg = "7" },
					},
				})
			end,
		},
		{ "psliwka/vim-smoothie" },
	}
end

return M
