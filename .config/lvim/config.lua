-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.format_on_save = false
lvim.lint_on_save = true
lvim.colorscheme = "edge"
vim.opt.scrolloff = 3
vim.opt.cmdheight = 2
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.timeoutlen = 400
vim.opt.guifont = "Fira Code Nerd Font Retina:h15"
vim.opt.pumheight = 12
vim.g.list = false
vim.opt.path:append({ "**" })
-- vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })

vim.g["python3_host_prog"] = "/Users/eo/.local/pipx/venvs/jupyterlab/bin/python3"
-- vim.g["python3_host_prog"] = "/Users/eo/.pyenv/versions/3.9.0/envs/pynvim/bin/python3"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode[";"] = ":"

lvim.keys.normal_mode["[<space>"] = "<cmd>put! =repeat(nr2char(10), v:count1)<cr>'"
lvim.keys.normal_mode["]<space>"] = "<cmd>put =repeat(nr2char(10), v:count1)<cr>"

vim.api.nvim_set_keymap("n", "<leader>'", [[ciw'<c-r>"'<esc>]], { silent = true })
lvim.keys.normal_mode['<leader>"'] = 'ciw"<c-r>""<esc>'
lvim.keys.normal_mode["<leader>`"] = 'ciw`<c-r>"`<esc>'
lvim.keys.normal_mode["<leader>)"] = 'ciw(<c-r>")<esc>'
lvim.keys.normal_mode["<leader>}"] = 'ciw{<c-r>"}<esc>'
lvim.keys.normal_mode["<leader>]"] = 'ciw[<c-r>"]<esc>'

-- lvim.keys.normal_mode[""]
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>lua require'telescope'.extensions.project.project{}<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	r = { "<cmd>Trouble lsp_references<cr>", "References" },
	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnosticss" },
	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
	w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnosticss" },
}

-- TODO User Config for predefined plugins
-- TODO: User Config for predefined plugins
-- XXX  teh sex
-- XXX: teh sex
-- WARN:
-- NOTE:  User config for predefined shit
-- NOTE User config for predefined shit
-- HACK:  User config for shit
-- HACK User config for shit
-- FUCK: FUCK
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- lvim.lang.lua.lsp.setup.on_init
-- lvim.lang.lua.lsp.setup = {active = lvim.plugins["1"][""]}
-- lvim.builtin.tabnine = { active = true }

lvim.builtin.lualine.active = true
-- lvim.builtin.lualine.options.section_separators = {'', ''}

-- lvim.builtin.lualine.options.component_separators = {'', ''}
-- lvim.builtin.lualine.sections.lualine_c = {lvim.builtin.lualine.extensions}
-- lvim.builtin.lualine.extensions = {enable = true}
-- component_separators = {'', ''}
-- lvim.builtin.lualine.extensions = { enable = "lualine-lsp-progress"}

-- lvim.builtin.lualine.options.theme = "edge"
lvim.builtin.project.active = true
lvim.builtin.bufferline.active = true
lvim.builtin.dashboard.active = false
lvim.builtin.terminal.active = true
lvim.builtin.comment.active = true
lvim.builtin.which_key.active = true
lvim.builtin.gitsigns.active = true
lvim.builtin.nvimtree.active = true
lvim.builtin.nvimtree.width = 23
lvim.builtin.nvimtree.show_icons.tree_width = 23
lvim.builtin.nvimtree.hide_dotfiles = 0
lvim.builtin.nvimtree.allow_resize = 1
lvim.builtin.nvimtree.indent_markers = 1
lvim.builtin.autopairs.active = true
lvim.builtin.autopairs.insert = true
lvim.builtin.autopairs.map_cr = true
-- lvim.lsp.diagnostics.update_in_insert = false
-- lvim.lsp.diagnostics.virtual_text.active = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
	"python",
	"lua",
	"julia",
	"go",
	"bash",
	"rust",
	"html",
	"css",
	"toml",
	"yaml",
	"cpp",
	"typescript",
	"javascript",
	"java",
	"json",
	"jsonc",
	"c",
	"rst",
	"query",
	"comment",
	"tsx",
	"jsdoc",
}

lvim.builtin.treesitter.ignore_install = { "haskell", "verilog", "beancount" }
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.matchup.enable = true
lvim.builtin.treesitter.textsubjects.enable = false
lvim.builtin.treesitter.textobjects.select.enable = false
lvim.builtin.treesitter.textobjects.swap.enable = false
lvim.builtin.treesitter.indent = { enable = true, disable = { "python", "yaml", "toml" } } -- currently broken
lvim.builtin.treesitter.playground.enable = false

-- lvim.builtin.galaxyline.on_config_done = function()
-- 	local glx = require("galaxyline").section
-- 	-- local gsx = glx.section
-- 	-- print(source(glx.right, ',', 1, #glx.right))
-- 	table.remove(glx.right, 7)
-- 	table.remove(glx.right, 8)
-- 	table.remove(glx.right, 9)
-- 	table.remove(glx.right, 10)
-- 	table.remove(glx.right, 11)
-- end

-- NOTE:
-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- USAGE:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
---@vararg any
function P(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
end

require("user.plugins").config()

-- lvim.plugins = {
--   {
--     "tzachar/cmp-tabnine",
--       run = "./install.sh",
--       requires = "hrsh7th/nvim-cmp",
--       config = function()
--         local tabnine = require("cmp_tabnine.config")
--         tabnine:setup {
--           max_lines = 1000,
--           max_num_results = 10,
--           sort = true,
--       }
--       end,
--       disable = not lvim.builtin.tabnine.active,
--   },
-- 	{ "chrisbra/unicode.vim" },
-- 	{ "sudormrfbin/cheatsheet.nvim" },
-- 	{ "romainl/vim-devdocs" },
-- 	{
-- 		"christoomey/vim-tmux-navigator",
-- 		config = function()
-- 			vim.g.tmux_navigator_no_mappings = 1
-- 			vim.g.tmux_navigator_disable_when_zoomed = 1
-- 			vim.g.tmux_navigator_save_on_switch = 2
-- 			vim.cmd([[
--           nnoremap <c-h> <cmd>TmuxNavigateLeft<cr>
--           nnoremap <c-j> <cmd>TmuxNavigateDown<cr>
--           nnoremap <c-k> <cmd>TmuxNavigateUp<cr>
--           nnoremap <c-l> <cmd>TmuxNavigateRight<cr>
--       ]])
-- 		end,
-- 	},
-- 	-- { "editorconfig/editorconfig-vim" },
-- 	{ "kdheepak/JuliaFormatter.vim" },
-- 	{
-- 		"JuliaEditorSupport/julia-vim",
-- 		-- config = function()
-- 		-- 	vim.g.latex_to_unicode_tab = 1
-- 		-- vim.cmd([[
-- 		--       let g:latex_to_unicode_tab = "insert"
-- 		-- end,
-- 	},
-- 	{
-- 		"dccsillag/magma-nvim",
-- 		run = ":UpdateRemotePlugins",
-- 	},
-- 	{
-- 		"Vimjas/vim-python-pep8-indent",
-- 		ft = { "python" },
-- 	},
-- 	{
-- 		"ahmedkhalf/jupyter-nvim",
-- 		run = ":UpdateRemotePlugins",
-- 		config = function()
-- 			require("jupyter-nvim").setup()
-- 		end,
-- 		-- ft = { "python", "julia" },
-- 	},
-- 	{
-- 		"bfredl/nvim-ipy",
-- 		-- ft = { "python", "julia" },
-- 	},
-- 	{
-- 		"junegunn/vim-easy-align",
-- 		setup = function()
-- 			vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
-- 			vim.api.nvim_set_keymap("o", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
-- 			vim.api.nvim_set_keymap("v", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
-- 		end,
-- 		keys = "<Plug>(EasyAlign)",
-- 	},
-- 	{
-- 		"rcarriga/nvim-notify",
-- 		config = function()
-- 			local notify = require("notify")
-- 			notify.setup({
-- 				stages = "fade_in_slide_out", -- fade
-- 				timeout = 3000,
-- 			})

-- 			--- Send a notification
-- 			--@param msg of the notification to show to the user
-- 			--@param level Optional log level
-- 			--@param opts Dict w/ optional options (timeout, etc)
-- 			vim.notify = function(msg, level, opts)
-- 				local l = vim.log.levels
-- 				assert(type(msg) == "string", "msg should be a str")
-- 				assert(type(level) ~= "table", "lvl should be one of vim.log.levels or a str")
-- 				opts = opts or {}
-- 				level = level or l.INFO
-- 				local levels = {
-- 					[l.DEBUG] = "Debug",
-- 					[l.INFO] = "Info",
-- 					[l.WARN] = "Warning",
-- 					[l.ERROR] = "Error",
-- 				}
-- 				opts.title = opts.title or type(level) == "string" and level or levels[level]
-- 				notify(msg, level, opts)
-- 			end
-- 		end,
-- 		-- vim.cmd([[
-- 		--       hi! NotifyERROR      guifg=#e27878
-- 		--       hi! NotifyWARN       guifg=#e2a478
-- 		--       hi! NotifyINFO       guifg=#b4be82
-- 		--       hi! NotifyDEBUG      guifg=#89b8c2
-- 		--       hi! NotifyTRACE      guifg=#c6c8d1
-- 		--       hi! NotifyERRORTitle guifg=#e98989
-- 		--       hi! NotifyWARNTitle  guifg=#e9b189
-- 		--       hi! NotifyINFOTitle  guifg=#c0ca8e
-- 		--       hi! NotifyDEBUGTitle guifg=#95c4ce
-- 		--       hi! NotifyTRACETitle guifg=#d2d4de
-- 		--     ]]),
-- 	},
-- 	{ "milisims/nvim-luaref" },
-- 	{ "bfredl/nvim-luadev" },
-- 	{ "nanotee/luv-vimdocs" },
-- 	{ "tjdevries/nlua.nvim" },
-- 	{
-- 		"chaoren/vim-wordmotion",
-- 		config = function()
-- 			vim.cmd([[
--       nmap dw de
--       nmap cw ce
--       nmap dW dE
--       nmap cW cE
--       ]])
-- 		end,
-- 	},
-- 	{ "wellle/targets.vim" },
-- 	{
-- 		"kana/vim-textobj-user",
-- 		requires = {
-- 			"kana/vim-operator-user",
-- 			{
-- 				"glts/vim-textobj-comment",
-- 				config = function()
-- 					vim.g.textobj_comment_no_default_key_mappings = 1
-- 					vim.cmd([[
--           xmap ax <Plug>(textobj-comment-a)
--           omap ax <Plug>(textobj-comment-a)
--           xmap ix <Plug>(textobj-comment-i)
--           omap ix <Plug>(textobj-comment-i)
--           ]])
-- 				end,
-- 			},
-- 		},
-- 	},
-- 	{
-- 		"nvim-treesitter/playground",
-- 		cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
-- 	},
-- 	{ "pechorin/any-jump.vim" },
-- 	{ "tpope/vim-characterize" },
-- 	{
-- 		"tpope/vim-surround",
-- 		config = function()
-- 			vim.cmd([[
--       xmap s <Plug>VSurround
--       ]])
-- 			-- omap s <Plug>VSurround
-- 		end,
-- 	},
-- 	-- sets sarchable path for ft's like py, go, so 'gf' works
-- 	{ "tpope/vim-apathy", ft = { "go", "python", "lua", "bash", "julia", "toml", "yaml" } },
-- 	{ "mbbill/undotree" },
-- 	{
-- 		"TimUntersberger/neogit",
-- 		cmd = "Neogit",
-- 		config = function()
-- 			require("neogit").setup({
-- 				disable_signs = false,
-- 				disable_context_highlighting = false,
-- 				signs = {
-- 					-- { CLOSED, OPENED }
-- 					section = { "", "" },
-- 					item = { "+", "-" },
-- 					hunk = { "", "" },
-- 				},
-- 				integrations = {
-- 					diffview = true,
-- 				},
-- 			})
-- 		end,
-- 		requires = {
-- 			{
-- 				"sindrets/diffview.nvim",
-- 				cmd = { "DiffViewOpen" },
-- 			},
-- 			{ "nvim-lua/plenary.nvim" },
-- 		},
-- 	},
-- 	{
-- 		"monaqa/dial.nvim",
-- 		event = "BufRead",
-- 		config = function()
-- 			require("user.dial").config()
-- 		end,
-- 	},
-- 	{
-- 		"tpope/vim-scriptease",
-- 		cmd = { "Messages", "Verbose", "Time", "ScriptNames" },
-- 	},
-- 	{ "lunarvim/colorschemes" },
-- 	{
-- 		"ray-x/lsp_signature.nvim",
-- 		event = "InsertEnter",
-- 		config = function()
-- 			require("user.lsp_signature").config()
-- 		end,
-- 	},
-- 	{
--     "folke/lua-dev.nvim",
--     config = function()
--       require("user.lua_dev.lua").config()
--     end ,
--     ft = "lua",
--     disable = not lvim.builtin.lua_dev.active,
--   },
-- 	{ "folke/lsp-colors.nvim" },
-- 	{
-- 		"folke/trouble.nvim",
-- 		requires = "kyazdani42/nvim-web-devicons",
-- 		config = function()
-- 			require("trouble").setup({ auto_close = true, auto_preview = true })
-- 		end,
--     cmd = "Trouble",
-- 	},
-- 	{
-- 		"folke/todo-comments.nvim",
-- 		requires = "nvim-lua/plenary.nvim",
-- 		config = function()
-- 			require("todo-comments").setup()
-- 		end,
-- 		event = "BufRead",
-- 	},
-- 	{ "glepnir/zephyr-nvim" },
-- 	{
-- 		"folke/tokyonight.nvim",
-- 		config = function()
-- 			vim.g.tokyonight_dev = true
-- 			vim.g.tokyonight_style = "storm" -- storm, night, day
-- 			vim.g.tokyonight_hide_inactive_statusline = true
-- 			vim.g.tokyonight_italic_variables = true
-- 			vim.g.tokyonight_italic_functions = true
-- 			vim.g.tokyonight_italic_keywords = true
-- 			vim.g.tokyonight_italic_comments = true
-- 			vim.g.tokyonight_terminal_colors = true
-- 		end,
-- 	},
-- 	{
-- 		"NTBBloodbath/doom-one.nvim",
-- 		config = function()
-- 			vim.g.doom_one_italic_comments = true
-- 			vim.g.doom_one_terminal_colors = true
-- 			vim.g.doom_one_telescope_highlights = true
-- 		end,
-- 	},
-- 	{
-- 		"simrat39/symbols-outline.nvim",
-- 		cmd = "SymbolsOutline",
-- 	},
-- 	{
-- 		"lukas-reineke/indent-blankline.nvim",
-- 		config = function()
-- 			require("user.indentline")
-- 		end,
-- 	},
-- 	{
-- 		"kevinhwang91/nvim-bqf",
-- 		config = function()
-- 			require("bqf").setup({
-- 				auto_enable = true,
-- 				preview = {
-- 					auto_preview = true,
-- 					win_height = 14,
-- 					win_vheight = 12,
-- 					delay_syntax = 80,
-- 					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
-- 					wrap = true,
-- 				},
-- 				func_map = {
-- 					vsplit = "",
-- 					ptogglemode = "z,",
-- 					stoggleup = "",
-- 				},
-- 				filter = {
-- 					fzf = {
-- 						action_for = {
-- 							["ctrl-t"] = "tabedit",
-- 							["ctrl-x"] = "split",
-- 							["ctrl-v"] = "vsplit",
-- 							["ctrl-b"] = "signtoggle",
-- 						},
-- 						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
-- 					},
-- 				},
-- 			})
-- 		end,
-- 	},
-- 	{
-- 		"andymass/vim-matchup",
-- 		event = "CursorMoved",
-- 		after = "nvim-treesitter",
-- 		config = function()
-- 			vim.g.matchup_matchparen_offscreen = {
-- 				method = "popup",
-- 				fullwidth = true,
-- 				highlight = "Normal",
-- 			}
-- 		end,
-- 	},
-- 	{
-- 		"p00f/nvim-ts-rainbow",
-- 		requires = "nvim-treesitter",
-- 		after = "nvim-treesitter",
-- 	},
-- 	-- { "Rrethy/nvim-treesitter-textsubjects", requires = "nvim-treesitter", after = "nvim-treesitter" },
-- 	-- { "nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter", after = "nvim-treesitter" },
-- 	{ "mtdl9/vim-log-highlighting" },
-- 	{
-- 		"plasticboy/vim-markdown",
-- 		ft = { "markdown" },
-- 	},
-- 	{
-- 		"iamcco/markdown-preview.nvim",
-- 		run = function()
-- 			vim.fn["mkdp#util#install"]()
-- 		end,
-- 		ft = { "markdown" },
-- 		config = function()
-- 			vim.g.mkdp_auto_start = 1
-- 			vim.g.mkdp_auto_close = 1
-- 		end,
-- 	},
-- 	{
-- 		"norcalli/nvim-colorizer.lua",
-- 		config = function()
-- 			require("colorizer").setup({ "*" }, {
-- 				RGB = true,
-- 				mode = "foreground",
-- 			})
-- 		end,
-- 	},
-- 	{
-- 		"marko-cerovac/material.nvim",
-- 		config = function()
-- 			vim.g.material_style = "ocean" -- deep ocean, oceanic, darker, lighter, palenight
-- 			vim.g.material_italic_comments = true
-- 			vim.g.material_italic_strings = true
-- 			vim.g.material_italic_keywords = true
-- 			vim.g.material_italic_functions = true
-- 			vim.g.material_italic_variables = true
-- 			vim.g.material_borders = true
-- 		end,
-- 	},
-- 	{
-- 		"sainnhe/edge",
-- 		config = function()
-- 			vim.g.edge_style = "neon" -- default, neon, aura
-- 			vim.g.edge_enable_italic = 1
-- 		end,
-- 	},
-- 	{
-- 		"sainnhe/sonokai",
-- 		config = function()
-- 			-- vim.cmd([[
-- 			vim.g.sonokai_style = "andromeda"
-- 			vim.g.sonokai_enable_italic = 1
-- 			vim.g.sonokai_cursor = "blue"
-- 			-- ]])
-- 			-- atlantis, andromeda or default
-- 		end,
-- 	},
-- 	{ "Th3Whit3Wolf/one-nvim" },
-- 	{ "junegunn/fzf" },
-- 	{ "junegunn/fzf.vim" },
-- 	{
-- 		"rafcamlet/nvim-luapad",
-- 		-- ft = { "lua" },
-- 	},
-- 	{
-- 		"michaelb/sniprun",
-- 		cmd = { "SnipRun" },
-- 		run = "bash ./install.sh",
-- 		config = function()
-- 			require("sniprun").setup({
-- 				display = {
-- 					-- "VirtualTextOk",
-- 					"VirtualTextErr",
-- 					"LongTempFloatingWindow",
-- 					-- "Terminal",
-- 				},
-- 				snipruncolors = {
-- 					SniprunVirtualTextOk  = { fg = "#51AFEF", bg = "#3E4556", ctermbg = "7", ctermfg = "4" },
-- 					SniprunVirtualTextErr = { fg = "#E06C75", bg = "#3E4556", ctermbg = "7", ctermfg = "1" },
-- 					SniprunFloatingWinOk  = { fg = "#51AFEF", ctermfg = "4*", ctermbg = "7" },
-- 					SniprunFloatingWinErr = { fg = "#E06C75", ctermfg = "1*", ctermbg = "7" },
-- 				},
-- 			})
-- 		end,
-- 	},
-- 	{ "psliwka/vim-smoothie" },
-- }

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- set a formatter if you want to override the default lsp one (if it exists)
-- lvim.lang.python.formatters = {
--   {
--     exe = "black",
--     args = {}
--   }
-- }
-- set an additional linter
-- lvim.lang.python.linters = {
--   {
--     exe = "flake8",
--     args = {}
--   }
-- }

-- Additional Plugins
-- lvim.plugins = {
--     {"folke/tokyonight.nvim"}, {
--         "ray-x/lsp_signature.nvim",
--         config = function() require"lsp_signature".on_attach() end,
--         event = "InsertEnter"
--     }
-- }

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
-- 	{ "BufWinEnter", "julia", "setlocal ts=4 sw=4 softtabstop=4" },
-- }
-- lvim.autocommands.custom_groups = {
-- 	"BufWinEnter,BufEnter",
-- 	"*.jl",
-- 	"lua cmd = {{'julia', '--startup-file=no', '--history-file=no', vim.fn.expand('~/.config/lvim/lua/lsp-julia/run-lsp.jl')}; require'lspconfig'.julials.setup{cmd = cmd, on_new_config = function(new_config, _) new_config.cmd = cmd end, filetypes = {'julia'}} vim.lsp.set_log_level('debug')",
-- }
