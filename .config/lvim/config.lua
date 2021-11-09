-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.debug = true
-- general
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.colorscheme = "onedarker"
lvim.transparent_window = false
vim.go.scrolloff = 3
vim.go.cmdheight = 2
vim.go.relativenumber = true
vim.go.number = true
vim.go.timeoutlen = 400
vim.go.guifont = "FiraCode Nerd Font:h14:style=Retina"
-- vim.o.guifont = "JuliaMono BlackItalic"
-- vim.o.guifont = "Iosevka Nerd Font"
-- vim.o.
vim.go.pumheight = 12
vim.g.list = false
-- vim.go.path = vioom.g { "**" }
-- vim.opt.tw = 80
-- vim.opt.colorcolumn = "80"

-- vim.g.vimsyn_embed = "lPr"
-- local opts = {}
lvim.builtin.notify.active = true
-- lvim.builtin.autopairs.map_char.all = true
lvim.lsp.code_lens_refresh = true
lvim.lsp.document_highlight = true
-- lvim.lsp.automatic_servers_installation = false

-- local opts = {}
local manager = require "lvim.lsp.manager"
manager.setup "sumneko_lua"
-- manager.setup "julials"
-- manager.setup("pylsp", lvim.lang.python.lsp)
-- manager.setup "bashls"
-- manager.setup "gopls"
-- manager.setup "json-language-server"

-- manager.init_defaults { "lua", "markdown", "yaml", "bash", "go", "rust", "json" }
vim.list_extend(lvim.lsp.override, { "pyright" })
lvim.line_wrap_cursor_movement = false
-- require "os"
-- local path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
-- local function path_join(...)
--   return table.concat(vim.tbl_flatten { ... }, path_sep)
-- end
-- vim.g.python3_host_prog = path_join(os.getenv "HOME", "/.local/pipx/venvs/jupyterlab/bin/python3")

vim.g["python3_host_prog"] = "/Users/eo/.local/pipx/venvs/jupyterlab/bin/python3" -- Must use this python binary as pyenvpython doesnt have jupyter_client
-- vim.g["python_host_prog"] = 1
-- vim.g["python3_host_prog"] = "/Users/eo/.pyenv/versions/3.9.0/envs/pynvim/bin/python3"
-- vim.g.lsp_settings_settings_dir = vim.fn.stdpath "cache" .. "/lspconfig"

-- lvim.lsp.templates_dir = join_paths(get_runtime_dir(), "after", "ftplugin")

-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode[";"] = ":"
lvim.keys.normal_mode["<esc><esc>"] = "<cmd>nohlsearch<cr>"
lvim.keys.normal_mode["<leader>c"] = "<cmd>:BufferDelete<cr>"

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
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}

-- order matters? apparently sets priority
lvim.builtin.cmp.sources = {
  { name = "nvim_lua" },
  { name = "nvim_lsp" },
  { name = "cmp_tabnine" },
  { name = "path" },
  { name = "buffer", max_item_count = 3, keyword_length = 3 },
  { name = "luasnip", max_item_count = 4 },
  { name = "latex_symbols" },
}
lvim.builtin.cmp.formatting.duplicates = { luasnip = 1, nvim_lsp = 1 }
-- lvim.lsp.diagnostics.severity_sort = { "warning", "error" }
-- lvim.lsp.diagnostics.virtual_text = { enabled = false }

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

lvim.builtin.bufferline.active = true
lvim.builtin.terminal.active = true
lvim.builtin.comment.active = true
lvim.builtin.which_key.active = true
lvim.builtin.gitsigns.active = true
lvim.builtin.nvimtree.active = true
lvim.builtin.autopairs.active = true
lvim.builtin.lualine.active = true
lvim.builtin.lualine.style = "lvim" -- torn between "default (powerlineish)" and "lvim"
lvim.builtin.lualine.sections.lualine_b = { "filename", "branch" }

-- lvim.builtin.lualine.options.component_separators = { left = "╲", right = "╱" } -- "》"
-- M.separators = {
--   arrow = { '', '' },
--   rounded = { '', '' },
--   blank = { '', '' },
-- { left = "", right = "" }
-- vim.o.showbreak = string.rep(" ", 3)
vim.go.ttyfast = true
vim.go.signcolumn = "yes"
-- vim.o.colorcolumn = "+1"

lvim.builtin.lualine.options.section_separators = { left = "", right = "" }
lvim.builtin.lualine.options.component_separators = { left = "╲", right = "╱" }
-- lvim.builtin.lualine.extensions
-- lvim.builtin.lualine.sections.lualine_c = {"lsp_progress"}
-- $$\0x09234$$
-- lvim.builtin.lualine.extensions["1"]

-- lvim.builtin.lualine.options.section_separators = {left = "╱", right = "╲"}

lvim.builtin.dashboard.active = false
lvim.builtin.project.active = false

lvim.builtin.nvimtree.width = 23
lvim.builtin.nvimtree.show_icons.tree_width = 23
lvim.builtin.nvimtree.hide_dotfiles = 0
lvim.builtin.nvimtree.allow_resize = 1
lvim.builtin.nvimtree.indent_markers = 1

lvim.builtin.cmp.confirm_opts = {
  select = false,
}

-- lvim.lsp.templates_dir = join_paths(get_runtime_dir(), "after", "ftplugin")

lvim.lsp.diagnostics.virtual_text = false

lvim.log = {
  ---@USAGE can be {"trace", "debug", "info", "warn", "error", "fatal"},
  level = "warn",
  viewer = {
    ---@USAGE: this will fallback on "less +F" if not found
    cmd = "lnav",
    layout_config = {
      ---@usage direction = 'vertical' | 'horizontal' | 'window' | 'float',
      direction = "horizontal",
      float_opts = {},
      open_mapping = "",
      size = 30,
    },
  },
  -- currently disabled due to instabilities
  override_notify = false,
}

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
  "tsx",
  "jsdoc",
}

lvim.builtin.treesitter.ignore_install = { "haskell", "verilog", "beancount" }
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.matchup.enable = true
lvim.builtin.treesitter.textsubjects.enable = true
lvim.builtin.treesitter.textobjects.select = {
  enable = true,
  -- automatically jump forward to textobj, similar to targets.vim
  lookahead = true,
  keymaps = {
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    -- ["ab"] = "@block.outer",
    -- ["ib"] = "@block.inner",
  },
}
-- you can of course just store one of them if you want
lvim.builtin.treesitter.textobjects.swap = {
  enable = true,
  swap_next = {
    -- ["sp"] = "@parameter.inner",
    ["<leader>x"] = "@parameter.inner",
    -- ["sf"] = "@function.outer",
    -- ["sc"] = "@class.outer",
    -- ["ss"] = "@statement.outer",
    -- ["sb"] = "@block.outer",
  },
  swap_previous = {
    -- ["sP"] = "@parameter.inner",
    ["<leader>X"] = "@parameter.inner",
    -- ["sF"] = "@function.outer",
    -- ["sC"] = "@class.outer",
    -- ["sS"] = "@statement.outer",
    -- ["sB"] = "@block.outer",
  },
}
lvim.builtin.treesitter.textobjects = {
  lsp_interop = {
    enable = true,
    border = "none",
    -- peek_definition_code = {
    --   ["df"] = "@function.outer",
    --   ["dF"] = "@class.outer",
    -- },
  },
}
lvim.builtin.treesitter.textobjects.move = {
  enable = true,
  goto_next_start = {
    ["]f"] = "@function.outer",
    ["]]"] = "@class.outer",
  },
  goto_next_end = {
    ["]F"] = "@function.outer",
    ["]["] = "@class.outer",
  },
  goto_previous_start = {
    ["[f"] = "@function.outer",
    ["[["] = "@class.outer",
  },
  goto_previous_end = {
    ["[F"] = "@function.outer",
    ["[]"] = "@class.outer",
  },
}
lvim.builtin.treesitter.indent = { enable = true, disable = { "python" } } -- currently broken
lvim.builtin.treesitter.playground.enable = false
-- lvim.builtin.treesitter.query_linter = {
--   enable = true,
--   use_virtual_text = true,
--   lint_events = { "BufWrite", "CursorHold" },
-- }

-- local function test1(args1)
--   args1:
--   print("hello hellow" * 3)
-- end

-- NOTE:
-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- USAGE:
-- FIXME
-- FIXME:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
---@vararg any
function P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

-- https://sw.kovidgoyal.net/kitty/faq/#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
--https://github.com/ssbanerje/dotfiles/blob/master/editors/lvim-config/config.lua
if vim.env.TERM == "xterm-kitty" then
  vim.cmd [[let &t_ut='']]
end

require("user.plugins").config()

-- P(lvim.autocommands._general_settings.1)
-- vim.api.nvim_exec(
--   [[
--   augroup cd
--     autocmd!
--     autocmd VimEnter * cd %:p:h
--   augroup end
-- ]],
--   false
-- )
-- lvim.autocommands.custom_groups({
--   "TextChanged, BufChangedI, BufWinEnter * let w:m1=matchadd('Search', '\\%81v.\\%>80v', -1)",
-- }, "column_limit")
