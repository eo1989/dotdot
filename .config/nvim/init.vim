" set runtimepath^=~/.vim runtimepath+=~/.vim/after
let g:mapleader = "\<Space>"


autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType vista,CHADTree,tagbar,undotree setlocal signcolumn=no

" set autoread
set mouse=a
" set encoding=utf-8
set guifont=Fira\ Code-Retina:h16:cANSI
set nowrap
set shell=/usr/local/bin/zsh
set cmdheight=2
" set showcmd
" set laststatus=2
" set hls is ai si
set expandtab
set ls=2
set switchbuf=useopen,split 	    " reveal already opened files from
		                	" the quick fix window instead of opening new buffers
set updatetime=300 	    " Speed up updatetime so gitgutter & friends are quicker
set timeoutlen=900
set ttimeoutlen=75
set novisualbell
set noerrorbells
set showmatch
set gdefault
set hidden      " hide buffers instead of closing them, this means
			    " means that the current buffer can be put to background
			    " w/o being writtn; & that marks & undo hist are
			    " preserved
" set lazyredraw
set tabstop=4
set shiftwidth=4
set softtabstop=4
set fillchars+=vert:\┃
" set smarttab
set smartcase
set ignorecase
set formatoptions+=1    " when wrapping paragraphs, dont end lines
			            " with 1-letter words (looks stupid)
set nobackup
set noundofile            " persistent undos - undo after u re-open the file
set noswapfile
set nowritebackup
set backspace=indent,eol,start
set colorcolumn=80
set signcolumn=auto:2
set list
" set listchars=tab:->\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set showtabline=2
set textwidth=0
set wrapmargin=0
set foldenable
set foldmethod=marker
set splitbelow
set splitright
set winblend=5
set pumblend=5
set scrolloff=5
set maxmempattern=5000

" set title for kitty as it moves between windows with kitty-navigator
set title
set fo-=c fo-=r fo-=o

" let g:loaded_python_provider = 0
" let g:loaded_python3_provider = 1
" changing python.plugin to python, to see if semshi loads correctly - 11/01
let g:polyglot_disabled = ['sensible', 'ftdetect', 'autoindent']
" let g:semshi#filetypes = ['Python']
" let g:semshi#error_sign = v:false       " let lsp handle this

" augroup pypy
"   autocmd! Filetype Python setlocal <cmd>Semshi toggle
" augroup END

" set pyxversion=3
" let g:python_highlight_all = 1
" let g:python_highlight_builtins = 1
" let g:python_highlight_class_vars = 1

if executable('pyenv')
    let g:python3_host_prog = '~/.pyenv/versions/py3nvim-perm/bin/python'
else
    let g:python3_host_prog = '/usr/local/bin/python3'
endif



call plug#begin('~/.vim/plugged')

Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-cheat.sh'



Plug 'myusuf3/numbers.vim'

" Plug 'hkupty/iron.nvim'
Plug 'kassio/neoterm'
    au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
    " just in case Julia acts up when running neoterm REPL

Plug 'andymass/vim-matchup'

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'GCBallesteros/vim-textobj-hydrogen'
Plug 'GCBallesteros/jupytext.vim'
    let g:jupytext_fmt = 'py'
    " Sending Cells to iron.repl & move to next cell
    " depends on the txt-obj defined in vim-textobj-hydrogen
    " First need to be connected to IronRepl
    nmap ]x ctrih/^# %%<CR><CR>
    " let g:jupytext_style = 'hydrogen'

" Plug 'untitled-ai/jupyter_ascending.vim'
"     let g:jupyter_ascending_python_executable ="~/.pyenv/versions/3.8.5/bin/python3"
"     let g:jupyter_ascending_match_pattern = "*.synced.py"
"     let g:jupyter_ascending_auto_write = v:true


Plug 'terryma/vim-multiple-cursors'

" Plug 'wsdjeg/vim-scriptease' " What am I using this for?

Plug 'mhinz/vim-grepper', {'on': 'GrepperRg'}

Plug 'mhinz/vim-startify'

Plug 'tpope/vim-surround'

Plug 'airblade/vim-gitgutter' ", {'on': ['gitguttersignstoggle']}
    let g:gitgutter_signs = 1
    let g:gitgutter_map_keys = 0
    let g:gitgutter_eager = 1
    let g:gitgutter_realtime = 1

Plug 'tpope/vim-fugitive'    "git
Plug 'tpope/vim-rhubarb'
" Plug 'tpope/vim-commentary'

Plug 'jiangmiao/auto-pairs'
    let g:AutoPairsMultilineClose = 0
    let g:AutoPairsMapSpace = 0
    let g:AutoPairsFlyMode = 1
    let g:AutoPairsShortcutBackInsert = '<M-b>'
    let g:AutoPairsMapCR = 1
    let g:AutoPairsMapBS = 1

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
    let g:undotree_WindowLayout = 2
    nnoremap <F7> :UndotreeToggle<CR>

Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

Plug 'junegunn/vim-easy-align'
    vmap <Enter> <Plug>(EasyAlign)
    xmap ga      <Plug>(EasyAlign)
    nmap ga      <Plug>(EasyAlign)


Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
    let g:Hexokinase_highlighters = ['foregroundfull']

Plug 'scrooloose/nerdcommenter'
    let g:NERDCustomDelimiters = { 'json': { 'left': '//' } }
    let g:NERDSpaceDelims = 1
    let g:NERDCompactSexyComs = 0
    let g:NERDDefaultAlign = 'left'
    let g:NERDTrimrailingWhiteSpace = 1

" Plug 'kien/tabman.vim', {'on': 'TMToggle'}
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
    let g:tagbar_autofocus = 1
    nmap <F8> :TagbarToggle<CR>

" Plug 'liuchengxu/vista.vim', {'on': 'Vista'}
"     Plug 'liuchengxu/vim-clap', {'do': ':Clap install-binary'}

" Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
" Plug 'hardcoreplayers/spaceline.vim'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'rizzatti/dash.vim', { 'on': 'DashSearch' }

" Colorschemes
Plug 'liuchengxu/space-vim-theme', {'as': 'Space-Vim-Theme'}
Plug 'connorholydak/vim-snazzy', {'as': 'Snazzy'}
Plug 'dracula/vim', {'as': 'Dracula'}
Plug 'patstockwell/vim-monokai-tasty', {'as': 'MonokaiTasty'}
Plug 'ajmwagar/vim-deus', {'as': 'Deus'}
Plug 'sonph/onehalf', {'rtp': 'vim', 'as': 'OneHalf'}
Plug 'tyrannicaltoucan/vim-quantum', {'as': 'Quantum'}


Plug 't9md/vim-choosewin'
    let g:choosewin_overlay_enable = 1
    nmap  -  <Plug>(choosewin)

" Plug 'itchyny/vim-parenmatch'
"     let g:loaded_matchparen = 1


Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins'}

Plug 'google/vim-searchindex'

" Plug 'pedsm/sprint', {'on': 'Sprint'}
" Plug 'skywind3000/asynctasks.vim', {'on': 'Sprint'}
" Plug 'skywind3000/asyncrun.vim', {'on': 'Sprint'}

Plug 'neomake/neomake' ", {'on': ':Make'}

Plug 'luochen1990/rainbow'
    let g:rainbow_active = 1

Plug 'easymotion/vim-easymotion'
    let g:EasyMotion_do_mapping = 0
    let g:EasyMotion_smartcase = 1
    """ EasyMotion default bindings
     map <Leader><Leader> <Plug>(easymotion-prefix)
     map <Leader>f        <Plug>(easymotion-bd-f)
     map <Leader>f        <Plug>(easymotion-overwin-f)
    nmap s                <Plug>(easymotion-overwin-f2)
     map <Leader>L        <Plug>(easymotion-bd-jk)
    nmap <Leader>L        <Plug>(easymotion-overwin-line)
     map <Leader>w        <Plug>(easymotion-bd-w)
    nmap <Leader>w        <Plug>(easymotion-overwin-w)


Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'


Plug 'Yggdroot/indentLine'

" Plug 'hrsh7th/vim-vsnip'   | Plug 'hrsh7th/vim-vsnip-integ'
Plug 'seletskiy/ultisnips' | Plug 'honza/vim-snippets'


Plug 'psliwka/vim-smoothie', {'as': 'smoooth'}

Plug 'vim-utils/vim-man', {'on': '<Plug>Mangrep'}

Plug 'tjdevries/nlua.nvim'

Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'bryall/contextprint.nvim'
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-lua/lsp-status.nvim'
" Plug 'nvim-treesitter/completion-treesitter'
" Plug 'tjdevries/lsp_extensions.nvim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'tjdevries/coc-zsh'
  Plug 'rafcamlet/coc-nvim-lua'
" Plug 'vn-ki/coc-clap', {'do': function('clap#helper#build_all'), 'on': 'Clap'}

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

" get these two to work with CoC and/or LF
" Plug 'kevinhwang91/rnvimr', {'on': 'RnvimrToggle'}
Plug 'voldikss/fzf-floaterm'
Plug 'voldikss/vim-floaterm'
    let g:floaterm_autoclose = 2
    let g:floaterm_keymap_toggle = '<Leader>fo'
    let g:floaterm_keymap_kill = '<Leader>fc'

    nnoremap <silent><Leader>fo  :FloatermToggle<CR>
    tnoremap <silent>       <F7> <C-\><C-n>:FloatermToggle<CR>

    nnoremap <silent><Leader>fc  :FloatermKill<CR>
    tnoremap <silent>       <F8> <C-\><C-n>:FloatermKill<CR>
    " try w/ Coc & FZF

Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
    nnoremap <leader>v <cmd>CHADopen --nofocus<CR>
    " lua vim.api.nvim_set_var("chadtree_settings", { use_icons = "emoji" })

    " hotkey clear quickfix list
    " nnoremap <leader>vc <cmd>call setqflist([])<CR>

Plug 'jpalardy/vim-slime'
    let g:slime_target = "neovim"

Plug 'knubie/vim-kitty-navigator'
    let &titlestring='%t - nvim'
    let g:kitty_navigator_listening_on_address = "unix:/tmp/mykitty"


" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Clojure ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{}}}{{{

Plug 'kovisoft/paredit', {'for': 'Clojure'}
    let g:paredit_smartjump = 1
Plug 'tpope/vim-fireplace', {'for': 'Clojure'}
Plug 'guns/vim-clojure-static', {'for': 'Clojure'}
    let g:clojure_maxlines = 60
    " set lispwords+=match
    let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
Plug 'guns/vim-clojure-highlight', {'for': 'Clojure'}
Plug 'guns/vim-slamhound', {'for': 'Clojure'}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Go! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~}}}

Plug 'fatih/vim-go', { 'for': 'Golang', 'do': ':GoInstallBinaries'}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Haskell ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'neovimhaskell/haskell-vim', { 'for': 'Haskell' }
Plug 'sbdchd/neoformat' ", {'for': ['haskell', 'python']}
"}}}
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Julia ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'JuliaEditorSupport/julia-vim'
    let g:julia_indent_align_import = 1
    let g:julia_indent_align_brackets = 1

augroup JuliaDocPrompt
    autocmd! FileType julia nmap <static> ? <Plug>(JuliaDocPrompt)
augroup END
"}}}
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Python ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Plug 'microsoft/vscode-python', {'for': 'Python'}
Plug 'numirias/semshi', {'for': 'Python', 'do': ':UpdateRemotePlugins'}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Rust ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }

" }}}
" ---------------------------- C++ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'jackguo380/vim-lsp-cxx-highlight', {'for': 'Cpp'}

" }}}



" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TS/JS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
Plug 'MaxMellon/vim-jsx-pretty', {'for': 'javascript'}
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
"}}}
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'sheerun/vim-polyglot'
call plug#end()

" lua require('lsp')
" luafile require('tree')
" lua $HOME/.config/nvim/lua/tree.lua
" luafile $HOME/.config/nvim/lua/repl.lua

let g:nvcode_termcolors=256
" colorscheme dracula
" syntax on
set termguicolors
colorscheme snazzy
" colorscheme monokai_tasty
set background=dark
" if (has("termguicolors"))
"     set termguicolors
"     hi LineNr ctermbg=NONE guibg=NONE
" endif
highlight link TSPunctBracket Normal
highlight link TSPunctDelimiter Normal
highlight link TSPunctSpecial Normal
highlight Comment cterm=italic

" Dont bother telling me about whitespace bruh
let g:airline#extensions#whitespace#enabled = 0
silent! call airline#extensions#whitespace#disable()
tnoremap <Esc> <C-\><C-n>


if executable('rg')
    let g:rg_derive_root='true'
    set grepprg=Rg\ --vimgrep\ --pretty\ --smart-case\ --no-heading\ --color=always\
endif




let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"


" Auto resize splits when nvim gets resized
" autocmd VimResized * wincmd =
"{{{
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
    \   {'type': 'dir'},
    \   {'type': 'files'},
    \   {'type': 'commands'},
    \   ]

" startify bookmarks
let g:startify_bookmarks = [
    \   {'v': '~/.config/nvim'},
    \   {'d': '~/'},
    \   ]

" startify commands
let g:startify_commands = [
    \   {'ch': ['Health Check', ':checkhealth']},
    \   {'ps': ['Plugins Status', ':PlugStatus']},
    \   {'pu': ['Update Plugins', ':PlugUpdate | PlugUpgrade']},
    \   {'uc': ['Update CocPlugins', ':CocUpdate']},
    \   {'h':  ['Help', ':help']},
    \   ]

" startify banner
let g:startify_custom_header = [
 \ '',
 \ '                                                    ▟▙            ',
 \ '                                                    ▝▘            ',
 \ '            ██▃▅▇█▆▖  ▗▟████▙▖   ▄████▄   ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖',
 \ '            ██▛▔ ▝██  ██▄▄▄▄██  ██▛▔▔▜██  ▝██  ██▘  ██  ██▛▜██▛▜██',
 \ '            ██    ██  ██▀▀▀▀▀▘  ██▖  ▗██   ▜█▙▟█▛   ██  ██  ██  ██',
 \ '            ██    ██  ▜█▙▄▄▄▟▊  ▀██▙▟██▀   ▝████▘   ██  ██  ██  ██',
 \ '            ▀▀    ▀▀   ▝▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀  ▀▀  ▀▀  ▀▀',
 \ '',
 \ '',
 \ '',
 \]

"}}}
" {{{ ------------------ vim go (polyglot) settings ------------------------"
" augroup golang
"     autocmd BufRead,BufEnter,BufWinLeave *.ext,*.ext3|<buffer[=N]> 
" augroup end
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_types = 1
" let g:go_highlight_function_parameters = 1
" let g:go_highlight_function_calls = 1
" let g:go_highlight_generate_tags = 1
" let g:go_highlight_format_strings = 1
" let g:go_highlight_variable_declarations = 1
" let g:go_auto_sameids = 1
" }}}


let g:webdevicons_enable = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_startify = 1
let g:webdevicons_enable_flagship_statusline = 1
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:DevIconsEnableFoldersOpenClose = 1

autocmd! BufWinEnter,VimEnter * lua require'nvim-web-devicons'.setup()


lua require('nvim-treesitter.configs').setup({ensure_installed = "all", highlight = {enable = true, use_languagetree = true}, incremental_selection = {enable = true}, indent = {enable = true}, textobjects = { enable = true },})

" do I really need this?
" lua << EOF
" require("nvim-treesitter.highlight")
"     local hlmap = vim.treesitter.highlighter.hl_map
" --Misc
"     hlmap.error = nil
"     hlmap["punctuation.delimiter"] = "Delimiter"
"     hlmap["punctuation.bracket"] = nil
" EOF

" lua require('contextprint').setup({ separator_char = "#", include_class = true, include_function = true, include_method = true, include_if = true, include_for = true})
" lua require('contextprint').add_statement()
" {{{
" let g:completion_auto_change_source = 1
" let g:completion_enable_auto_paren = 1
" let g:completion_enable_snippet = 'Ultisnips'
" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" let g:completion_confirm_key = ""
" inoremap <expr> <TAB> pumvisible() ? complete_info()["selected"] != "-1" ? 
"             \ "\<Plug>(completion_confirm_completion)"  :
"             \ "\<c-e>\<CR>" : "\<CR>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" nmap <tab> <Plug>(completion_smart_tab)
" nmap <s-tab> <Plug>(completion_smart_s_tab)
" }}} 
"{{{
" let g:completion_chain_complete_list = {
"             \'default' : {
"             \	'default' : [
"             \		{'complete_items' : ['lsp', 'snippet']},
"             \		{'complete_items' : ['tabnine']},
"             \		{'complete_items' : ['path'], 'triggered_only': ['/']},
"             \		{'mode' : [ '<TAB>', 'cmd', 'file']}
"             \	],
"             \	{'comment' : []},
"             \	{'string' : ['path', 'triggered_only' = ['/']]},
"             \	},
"             \'vim' : [
"             \	{'complete_items': ['lsp', 'snippet', 'tabnine']},
"             \	{'mode' : 'cmd'},
"             \   {'mode' : '<TAB>'}
"             \	],
"             \'c' : [
"             \	{'complete_items': ['lsp', 'tabnine']},
"             \   {'mode' : '<TAB>'}
"             \	],
"             \'python' : [
"             \	{'complete_items': ['lsp', 'snippet', 'tabnine']},
"             \   {'mode' : '<TAB>'},
"             \   {'mode' : 'cmd'}
"             \	],
"             \'lua' : [
"             \	{'complete_items': ['lsp', 'tabnine', 'snippet']},
"             \   {'mode' : '<TAB>'},
"             \   {'mode' : 'cmd'}
"             \	],
"             \'golang' : [
"             \   {'complete_items': ['lsp', 'snippet', 'tabnine']]},
"             \   {'mode' : '<TAB>'},
"             \   {'mode' : 'cmd'}
"             \   ],
"             \'rust' : [
"             \   {'complete_items': ['lsp', 'snippets', 'tabnine']]},
"             \   {'mode' : '<TAB>'},
"             \   {'mode' : 'cmd'}
"             \   ],
"             \'haskell' : [
"             \   {'complete_items': ['lsp', 'snippet', 'tabnine']]},
"             \   {'mode' : '<TAB>'},
"             \   {'mode' : 'cmd'}
"             \   ],
"             \'bash' : [
"             \   {'complete_items': ['lsp', 'snippets', 'tabnine']},
"             \   {'mode' : '<TAB>'},
"             \   {'mode' : 'cmd'}
"             \   ],
"             \}
"}}}
" {{{
" autocmd BufEnter,BufWinEnter * lua require'completion'.on_attach()
" autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
" autocmd BufEnter,BufWinEnter,TabEnter *.vim :lua require'lsp_extensions'.inlay_hints{}
" autocmd BufEnter,BufWinEnter,TabEnter *.py :lua require'lsp_extensions'.inlay_hints{}
" autocmd BufEnter,BufWinEnter,TabEnter *.go :lua require'lsp_extensions'.inlay_hints{}
" autocmd BufEnter,BufWinEnter,TabEnter *.hs :lua require'lsp_extensions'.inlay_hints{}
" autocmd BufEnter,BufWinEnter,TabEnter *.sh :lua require'lsp_extensions'.inlay_hints{}
" autocmd BufEnter,BufWinEnter,TabEnter *.lua :lua require'lsp_extensions'.inlay_hints{}
" " autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }
" autocmd CursorHold,CursorHoldI *.py :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }

" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" lua require'nvim_lsp'.tsserver.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.clangd.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.gopls.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.rust_analyzer.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.sumneko_lua.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.pyls_ms.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.vimls.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.bashls.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.julials.setup{ on_attach=require'completion'.on_attach }
"
" Statusline for lsp_status
" function! LspStatus() abort
"     if luaeval('#vim.lsp.buf_get_clients() > 0')
"         return luaeval("require('lsp-status').status()")
"     endif

"     return ''
" endfunction
" }}}

set shortmess+=Ic
set completeopt=noinsert,menu,noselect
" set omnifunc=v:lua.vim.lsp.omnifunc
set wildignorecase
" set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,.git,*.rbc,*/node_modules,*.gem
set wildignore+=*.pyc,__pycache__,*.egg-info,*.pytest_cache,*.mypy_cache
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,*/tmp/**,*.DS_Store

" {{{
" LSP Statusline
" function! LspStatus() abort
"     let sl = ''
"     if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
"         let sl .='%#MyStatuslineLSP#E:'
"         let sl .='%#MyStatuslineLSPErrors#%{luaeval("vim.lsp.util.buf_diagnostics_count([[Error])")}'
"         let sl .='%#MyStatuslineLSP# W:'
"         let sl .='%#MyStatuslineLSPWarnings##%{luaeval("vim.lsp.util.buf_diagnostics_count([[Warning]])")}'
"     else
"         let sl .='%#MyStatuslineLSPErrors#off'
"     endif
"     return sl
" endfunction
" let &l:statusline = '%#MyStatuslineLSP#LSP '.LspStatus()

" sign define LspDiagnosticsErrorSign text=E texthl=LspDiagnosticsError linehl= numhl=
" sign define LspDiagnosticsWarningSign text=W texthl=LspDiagnosticsWarning linehl= numhl=
" sign define LspDiagnosticsInformationSign text=I texthl=LspDiagnosticsInformation linehl= numhl=
" sign define LspDiagnosticsHintSign text=H texthl=LspDiagnosticsHint linehl= numhl=
" }}}

" {{{
" nnoremap <leader>gd :lua vim.lsp.buf.definition()<CR>
" nnoremap <leader>gi :lua vim.lsp.buf.implementation()<CR>
" nnoremap <leader>gsh :lua vim.lsp.buf.signature_help()<CR>
" nnoremap <leader>grr :lua vim.lsp.buf.references()<CR>
" nnoremap <leader>grn :lua vim.lsp.buf.rename()<CR>
" nnoremap <leader>gh :lua vim.lsp.buf.hover()<CR>
" nnoremap <leader>gca :lua vim.lsp.buf.code_action()<CR>
" nnoremap <leader>gwk :lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <leader>gty :lua vim.lsp.buf.type_definition()<CR>
" nnoremap <leader>gdc :lua vim.lsp.buf.document_symbol()<CR>
" }}}

" nnoremap <leader>gH :h <C-R>=expand("<cword>")<CR><CR>
" nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
" nnoremap <leader>bs /<C-R>=escape(expand("<cWORD>"), "/")<CR><CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
" nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<CR>
" nnoremap <leader>pi <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
" nnoremap <leader>pds :lua require'telescope.builtin'.lsp_document_symbols{}<CR>
" nnoremap <leader>pws :lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>
nnoremap <Leader>pf :Files<CR>
nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>rp :resize 100<CR>
" nnoremap <Leader>ee oif err != nil {<CR>log.Fatalf("%+v\n", err)<CR>}<CR><esc>kkI<esc>


" map tt :tabnew
" map <M-Right> :tabn<CR>
" imap <M-Right><ESC> :tabn<CR>
" map <M-Left> :tabp<CR>
" imap <M-Left><ESC> :tabp<CR>


" Julia ctags tagbar info
let g:tagbar_type_julia = {
    \ 'ctagstype': 'julia',
    \ 'kinds'    : ['t: struct', 'f: function', 'm: macro', 'c: const']}



map <Leader>re :so ~/.config/nvim/init.vim<CR>

nmap <F6> <cmd>CHADopen<CR>

" nmap <F9> :Vista!!<CR>

"~~~~~~~~~~~~~~~~~~~~~~ vim-airline temp ~~~~~~~~~~~~~~~~~~~~~~~~
" onedark "base16_snazzy" "dracula" "kalisi"

let g:airline_theme = 'base16_snazzy'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = '⭠'
    let g:airline_symbols.readonly = '⭤'
    let g:airline_symbols.linenr = '⭡'
else
   let g:webdevicons_enable = 1 "1
endif

let g:airline#extensions#branch#format = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#grepper#enabled = 1
let g:airline#extensions#fzf#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#neomake#enabled = 1
" let g:airline#extensions#nvimlsp#error_symbol = 'E:'
" let g:airline#extensions#nvimlsp#warning_symbol = 'W:'
let g:airline_section_z = "" " disable the line info
let g:airline#extensions#vista#enabled = 0
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#keymap#enabled = 1 "1
let g:airline#extensions#quickfix#quickfix_text = 'QuickFix'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#hunks#coc_git = 0 "1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#current_first = 1 "1
let g:airline#extensions#tabline#show_tabs = 1 "1
let g:airline#extensions#tabline#show_tab_count = 2 "2
let g:airline#extensions#tabline#show_tab_type = 1 "1
let g:airline#extensions#tabline#buffer_nr_show = 1 "1
let g:airline#extensions#tabline#show_close_button = 1 "1
let g:airline#extensions#tabline#close_symbol = 'X'
let b:airline_whitespace_disabled = 1


set clipboard+=unnamed,unnamedplus

noremap Y "+y
" noremap <Leader>p "+gP<CR>
" noremap XX "+x<CR>


vnoremap x "_d
" greatest remap ever
vnoremap <leader>p "_dP

"Buffer nav
noremap <Leader>z :bp<CR>
noremap <Leader>x :bn<CR>
" Close Buffer
noremap <Leader>c :bd<CR>

" Clean hlsearch
nnoremap <expr><Leader>/ <cmd>nohls<CR>

" let g:incsearch#auto_nohlsearch = 1
" Splitting
noremap <Leader>hs :<C-u>split<CR>
noremap <Leader>vs :<C-u>vsplit<CR>

nnoremap <silent> <leader>sh :terminal<CR>

"" Switching windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
xnoremap < <gv
xnoremap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" {{{ autocmd TextYankPost * silent! lua vim.highlight.on_yank ({timeout=40})


"~~~~~~~~~~~~~~~~~~~~~~~~~~~autocmd rules~~~~~~~~~~~~~~~~~~~~"
" if pc fast enuff, syntax highlight sync from start unless 200 lines
" augroup vimrc-sync-fromstart
"     autocmd!
"     autocmd BufEnter,BufWinEnter,VimEnter * :syntax sync maxlines=600
" augroup END

" " remmeber cursor pos.
" augroup vimrc-remember-cursor-position
"     autocmd!
"     autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" augroup END
" }}}

nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
     set statusline+=%{fugitive#statusline()}
endif

" {{{ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Spaceline ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" let g:spaceline_separate_style = 'slant-cons'
" let g:spaceline_lsp_executive = 'nvim_lsp'
" let g:spaceline_diff_tool = 'gitgutter'
" let g:spaceline_branch_icon = '⭠'
" }}}

"~~~~~~~~~~~~~~~~~~~~~~~~ Coc.Nvim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" let g:coc_node_path = '/usr/local/bin/node'

" let node_client_debug = 1


" autocmd User CocNvimInit call CocAction('runCommand', )
let g:coc_glogal_extensions = [
    \   'coc-json',
    \   'coc-zsh',
    \   'coc-sh',
    \   'coc-marketplace',
    \   'coc-vimlsp',
    \   'coc-lists',
    \   'coc-actions',
    \   'coc-ultisnips',
    \   'coc-snippets']


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"



let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'

" imap <C-j> <Plug>(coc-snippets-expand-jump)

" inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"


" " lets see is <tab> works better below vs. <CR> in both inoremap and imap
" if !exists("*complete_info")
"     inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" else
"     imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" endif


inoremap <silent><expr> <c-space> coc#refresh()

" coc completion popup
" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~""
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" nmap <silent><Leader>hj <Plug>(coc-float-jump)
" nmap <silent><Leader>hi <Plug>(coc-float-hide)

" Use K to show documentation in preview window.
nnoremap <silent> K <cmd>Call <SID>show_documentation()<CR>
" lets try this
" nnoremap <silent> <leader>K :call CocAction('doHover')<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
au CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" python renaming
" augroup PySemshi
"   autocmd!
"       autocmd FileType Python nnoremap <Leader>rn <Plug>(Semshi-rename)<CR>
"     " endif
" augroup END

" Formatting selected code.
xmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lf  <Plug>(coc-format-selected)

aug mygroup
  au!
  " Setup formatexpr specified filetype(s).
  au FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
aug END


" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>ap  <Plug>(coc-codeaction-selected)
nmap <leader>ap  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" " Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" This needs work. TODO -- requires 'textDocument.documentSymbol' support
" from lsp
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver,
" coc-python
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" " attempt at using coc-actions
" xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
" nmap          <leader>a :CocCommand actions.open<CR>

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" {{{
"~~~~~~~~~~~~~~~~~~~~~ Coc-Explorer ~~~~~~~~~~~~~~~~~~~~~~~~~"

" let g:coc_explorer_global_presets = {
" \   '.vim': {
" \     'root-uri': '~/.vim',
" \   },
" \   'tab': {
" \     'position': 'tab',
" \     'quit-on-open': v:true,
" \   },
" \   'floating': {
" \     'position': 'floating',
" \     'open-action-strategy': 'sourceWindow',
" \   },
" \   'floatingTop': {
" \     'position': 'floating',
" \     'floating-position': 'center-top',
" \     'open-action-strategy': 'sourceWindow',
" \   },
" \   'floatingLeftside': {
" \     'position': 'floating',
" \     'floating-position': 'left-center',
" \     'floating-width': 40,
" \     'open-action-strategy': 'sourceWindow',
" \   },
" \   'floatingRightside': {
" \     'position': 'floating',
" \     'floating-position': 'right-center',
" \     'floating-width': 40,
" \     'open-action-strategy': 'sourceWindow',
" \   },
" \   'simplify': {
" \     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
" \   }
" \ }
" noremap <C-o> :CocCommand explorer<CR>
" noremap <Leader><C-o> :CocCommand explorer --preset floating<CR>
" autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

" Use preset argument to open it
" nmap <leader>exd :CocCommand explorer --preset <CR>
" nmap <leader>exf :CocCommand explorer --preset floating<CR>
" List all presets
" nmap <leader>ep :CocList Presets<cr>

" }}}


"~~~~~~~~~~~~~~~~~~~~~~~ Mappings for CoCList ~~~~~~~~~~~~~~~~~~~~~~~~"
"Show all diagnostics.
nnoremap <silent> <leader>ld  :<C-u>CocList diagnostics<cr>

" Manage extensions.
nnoremap <silent> <leader>le  :<C-u>CocList extensions<cr>

" Show commands.
nnoremap <silent> <leader>lc  :<C-u>CocList commands<cr>

" Find symbol of current document.
nnoremap <silent> <leader>lo  :<C-u>CocList outline<cr>

" Search workspace symbols.
nnoremap <silent> <leader>ls  :<C-u>CocList -I symbols<cr>

" Do default action for next item.
nnoremap <silent> <leader>lj  :<C-u>CocNext<CR>

" Do default action for previous item.
nnoremap <silent> <leader>lk  :<C-u>CocPrev<CR>

" Resume latest coc list.
nnoremap <silent> <leader>lp  :<C-u>CocListResume<CR>

" Find files in cwd.
nnoremap <silent> <leader>ll :<C-u>CocList locationlist<CR>

" Find buffers
nnoremap <silent> <leader>lb :<C-u>CocList buffers<CR>
" nnoremap <silent> <leader>te :<C-u>CocActionAsync('')

" CocSEARCH
" nnoremap <silent> <leader>lr :<C-u>CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent> <leader>rw :CocSearch <C-R><C-W><CR>

" Use Marketplace
nnoremap <silent> <leader>lm :<C-u>CocList marketplace<CR>

" Coc-yank
nnoremap <silent> <leader>ly  :<C-u>CocList -A --normal yank<cr>

"{{{
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ WhichKey ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

"let g:maplocalleader = ','
"let g:which_key_sep = '→'
"set timeoutlen=900
"autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
"
"nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
"nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>
"" Hide status line
"
"
"" This dict is necessary to provide group names/descript. text
"let g:which_key_map['w'] = {
"        \ 'name' : '+windows' ,
"        \ 'w' : ['<C-W>w'       , 'other-window']          ,
"        \ 'd' : ['<C-W>c'       , 'delete-window']         ,
"        \ '-' : ['<C-W>s'       , 'split-window-below']    ,
"        \ '|' : ['<C-W>v'       , 'split-window-right']    ,
"        \ '2' : ['<C-W>v'       , 'layout-double-columns'] ,
"        \ 'h' : ['<C-W>h'       , 'window-left']           ,
"        \ 'j' : ['<C-W>j'       , 'window-below']          ,
"        \ 'l' : ['<C-W>l'       , 'window-right']          ,
"        \ 'k' : ['<C-W>k'       , 'window-up']             ,
"        \ 'H' : ['<C-W>5<'      , 'expand-window-left']    ,
"        \ 'J' : [':resize +5'   , 'expand-window-below']   ,
"        \ 'L' : ['<C-W>5>'      , 'expand-window-right']   ,
"        \ 'K' : [':resize -5'   , 'expand-window-up']      ,
"        \ '=' : ['<C-W>='       , 'balance-window']        ,
"        \ 's' : ['<C-W>s'       , 'split-window-below']    ,
"        \ 'v' : ['<C-W>v'       , 'split-window-below']    ,
"        \ '?' : ['Windows'      , 'fzf-window']            ,
"        \ }
" }}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ IndentLine ~~~~~~~~~~~~~~~~~~~~~~~~~"

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_faster = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_color_term = 6
let g:indentLine_fileTypeExclude = ['startify', 'coc', 'help',
                                  \ 'terminal', 'floaterm', 'vista',
                                  \ 'CHADTree', 'tagbar', 'undotree']

" {{{ "~~~~~~~~~~~~~~~~~~~~~~~~ vista.vim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" let g:vista_default_executive = 'coc'
" let g:vista_echo_cursor_strategy = ['both']

" let g:vista_ctags_cmd = {
"     \ 'haskell': 'hasktags -x -o - -c',
"     \ 'go': 'gomodifytags',
"     \ 'python': 'ctags',
"     \}

" if exists('g:vista#renderer#icons') || exists('g:airline_powerline_fonts')
"     let g:vista#renderer#enable_icon = 1
"         let g:vista#renderer#icons = {
"         \ "function": "\uf794",
"         \ "variable": "\uf71b",
"         \}
" endif

" let g:vista_fzf_preview = ['right:60%:wrap']
" let g:vista_executive_for = {
"     \ 'cpp': 'coc-ccls',
"     \ 'py':  'coc-jedi',
"     \ 'rs':  'coc-rls',
"     \ 'lua': 'coc-nvim-lua',
"     \ 'go':  'coc-go',
"     \ 'hs':  'coc',
"     \ 'sh':  'coc-sh',
"     \}

" function! NearestMethodOrFunction() abort
"     return get(b:, 'vista_nearest_method_or_function', '')
" endfunction


" if exists("*NearestMethodOrFunction")
"     set statusline+=%{NearestMethodOrFunction()}
" endif
" to autmoatically show the nearetst fx in statusline automatically
" need to add this:
" autocmd VimEnter * call Vista#RunForNearestMethodOrFunction()

" let g:vista_log_file = expand('~/vista.log')
" }}}
"~~~~~~~~~~~~~~~~~~~~~~~~~ Smaller Extensions ~~~~~~~~~~~~~~~~~~~~~~~"
" Fzf.vim
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'Sublime Snazzy'
let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_directory_files_command = 'rg --files --pretty --hidden --follow --nomessage -g \!"* *"'
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=always --smart-case'
let g:fzf_layout = {'window': 'call OpenFloatingWin()'}

" let g:fzf_action = {
    " \   'ctrl-t': 'tab split',
    " \   'ctrl-x': 'split',
    " \   'ctrl-v': 'vsplit'}

" command! -bang -nargs=* Rg
"         \ call fzf#vim#grep(
"         \   <bang>0 ? fzf#vim#with_preview(
"         \           "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, )
"         \           : fzf#vim#with_preview(),
"         \   <bang>0)

command! -bang -nargs=* Rg
        \   call fzf#vim#grep( "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
        \   1, {'options': '--delimiter : --nth 4..'}, 
        \   <bang>0 )


command! -bang -nargs=? -complete=file GFiles
            \   call fzf#vim#gitfiles(
            \   <q-args>,
            \   fzf#vim#with_preview(),
			\   <bang>0)

nnoremap <silent> <leader>fm :<C-u>FzfPreviewProjectOldFiles<CR>
nnoremap <silent> <leader>fp :<C-u>FzfPreviewProjectFiles<CR>
nnoremap <silent> <leader>fb :<C-u>FzfPreviewBuffers<CR>
nnoremap <silent> <leader>fM :<C-u>FzfPreviewOldFiles<CR>

" nnoremap <Leader>cg :<C-u>CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--nth=3 --resume<Space>


function! OpenFloatingWin()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

" {{{ ------------------- Using Lf & Rnger -----------------------------"
" --------------------------------------------------------------------"
" function! CreateCenteredFloatingWindow(border)
"   let width = float2nr(&columns * 0.9)
"   let height = float2nr(&lines * 0.9)
"   let top = ((&lines - height) / 2) - 1
"   let left = (&columns - width) / 2
"   let opts = {'relative': 'editor',
"               \    'row':      top,
"               \    'col':     left,
"               \  'width':    width,
"               \ 'height':   height,
"               \  'style': 'minimal'
"               \}

"   let top = "╔" . repeat("═", width - 2) . "╗"
"   let mid = "║" . repeat(" ", width - 2) . "║"
"   let bot = "╚" . repeat("═", width - 2) . "╝"
"   let lines = [top] + repeat([mid], height - 2) + [bot]
"   let s:buf = nvim_create_buf(v:false, v:true)
"   if a:border == 0
"     call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
"     call nvim_open_win(s:buf, v:true, opts)
"     set winhl=Normal:Floating
"   endif
"   let opts.row += 1
"   let opts.height -= 2
"   let opts.col += 2
"   let opts.width -= 4
"   call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
"   set winhl=Normal:Floating
"   autocmd BufWipeout <buffer> call CleanupBuffer(s:buf)
" endfunction

" function! CleanupBuffer(buf)
"   if bufexists(a:buf)
"     silent execute 'bwipeout!' '.a:buf'
"   endif
" endfunction

" function! DeleteUnlistedBuffers()
"   for n in nvim_list_bufs()
"     if ! buflisted(n)
"       let name = bufname(n)
"       if name == '[Scratch]' ||
"             \ matchend(name, ":lazygit") ||
"             \ matchend(name, ":lf") ||
"             \ matchend(name, ":zsh") ||
"             \ matchend(name, ":gotop")
"               call CleanupBuffer(n)
"       endif
"     endif
"   endfor
" endfunction

"  ~~~~~~~~~~~~~~~~~~~~~~~~~~ Check lf and lazygit ~~~~~~~~~~~~~~~~~~~~~~"
"  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ swap w/ ranger & tig? ~~~~~~~~~~~~~~~~~~~~"

" function! ToggleBorderTerm(cmd)
"   if empty(bufname(a:cmd))
"     call CreateCenteredFloatingWindow(0)
"     startinsert
"     call termopen(a:cmd, {'on_exit': function('OnTermExit')})
"   else
"     call DeleteUnlistedBuffers()
"   endif
" endfunction

" function! ToggleNoBorderTerm(cmd)
"   if empty(bufname(a:cmd))
"     call CreateCenteredFloatingWindow(1)
"     startinsert
"     call termopen(a:cmd, {'on_exit': function('OnTermExit')})
"   else
"     call DeleteUnlistedBuffers()
"   endif
" endfunction

" " LazyGit
" nnoremap <silent> <leader>tg :call ToggleLazyGit()<CR>
" function! ToggleLazyGit()
"   call ToggleNoBorderTerm('lazygit')
" endfunction

" nnoremap <silent> <Leader>tt :call ToggleGotop()<CR>
" function! ToggleGotop()
"   call ToggleNoBorderTerm('gotop')
" endfunction

" nnoremap <silent> <leader>tf :call ToggleLf()<CR>
" nnoremap <silent> <leader>cf :call ToggleCurrentFile()<CR>

" function! ToggleCurrentFile()
"   call ToggleNoBorderTerm('cd '.expand('%:p:h').' && lf')
" endfunction

" function! ToggleLf()
"   call ToggleNoBorderTerm('lf')
" endfunction

" nnoremap <silent> <leader>ts :call ToggleZsh()<CR>
" function ToggleZsh()
"   call ToggleNoBorderTerm('zsh')
" endfunction

" nnoremap <silent> <Leader>td :call DeleteUnlistedBuffers()<CR>

" function! OnTermExit(job_id, code, event) dict
"   if a:code == 0
"     call DeleteUnlistedBuffers()
"   endif
" endfunction

" function! RefocusFloatingWin()
"   wincmd p
"   startinsert
" endfunction
" }}}
" {{{ ~~~~~~~~~~~~~~~~~~~ Vim-Clap ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
let g:clap_provider_dotfiles = {
    \ 'source': ['~/.config/nvim/init.vim', '~/.zshrc', '~/.tmux.conf'],
    \ 'sink': 'e',
    \}

let g:clap_provider_commands = {
    \ 'source': ['Clap debug', 'UltiSnipsEdit'],
    \ 'sink': { selected -> execute(selected, '')},
    \}
" }}}
"{{{ ~~~~~ UltiSnips, Hs, Rs, Ts, Ale ~~~~~~~~~~~~~~~~~~~~"

" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltisnipsListSnippets='<c-tab>'
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<C-k>"
" let g:UltiSnipsEditSplit="context"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" {{{ Haskell
let g:haskell_conceal_wide = 1
let g:haskell_multiline_strings = 1
"let g:necoghc_enable_detailed_browse = 1
"autocmd Filetype haskell setlocal omnifunc=necoghc#omnifunc
 "}}}

" {{{ Rust
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <Leader>gd <Plug>(rust-doc)
" }}}
" TScript
let g:yats_host_keyword = 1


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ALE Linting~~~~~~~~~~~~~~~~~~~~~~~~~~"
" let g:ale_linters_explicit = 1
" let g:ale_linters = {'python': ['Pylint', 'flake8'], 'javascript': ['eslint']}
" let g:ale_fixers = {
" \   '*': ['remove_trailings_lines', 'trim_whitespace'],
" \   'javascript': ['prettier', 'eslint'],
" \   'python': ['black', 'autopep8', 'mypy']}
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" let g:ale_lint_on_save = 0e
" }}}
