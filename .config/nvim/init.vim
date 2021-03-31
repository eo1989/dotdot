let g:mapleader = "\<Space>"

" source $HOME/.config/nvim/config/mapkeys.vim
source $HOME/.config/nvim/config/Startify_cfg.vim
source $HOME/.config/nvim/config/vista_cfg.vim
source $HOME/.config/nvim/config/clap_cfg.vim
source $HOME/.config/nvim/config/coc.vim
source $HOME/.config/nvim/config/fzf.vim
source $HOME/.config/nvim/config/tagbar.vim
source $HOME/.config/nvim/config/gitgutter.vim
" source $HOME/.config/nvim/config/airline.vim
source $HOME/.config/nvim/config/webdevicons.vim

set mouse="a"
set guifont=Fira\ Code-Retina
set nowrap
set shell=/usr/local/bin/zsh
set cmdheight=2
set expandtab
set ls=2
set switchbuf=useopen,split 	    " reveal already opened files from
		                	" the quick fix window instead of opening new buffers
set updatetime=300 	    " Speed up updatetime so gitgutter & friends are quicker
set timeoutlen=750
set novisualbell
set noerrorbells
set showmatch
set clipboard+=unnamedplus
set gdefault
set hidden      " hide buffers instead of closing them, this means
			    " means that the current buffer can be put to background
			    " w/o being writtn; & that marks & undo hist are
			    " preserved
set tabstop=4
set shiftwidth=4
set softtabstop=4
" set fillchars+=vert:\┃
set smartcase
set ignorecase
" set fo-=c
" set fo-=r
" set fo-=o
set formatoptions+=1    " when wrapping paragraphs, dont end lines
			            " with 1-letter words (looks stupid)
set nobackup
set noundofile            " persistent undos - undo after u re-open the file
set noswapfile
set nowritebackup
set backspace=indent,eol,start
set colorcolumn=80
set signcolumn=auto:3
set list
set showtabline=2
set noshowmode
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

set shortmess+=Ic
set completeopt=noinsert,menuone,noselect
" set omnifunc=v:lua.vim.lsp.omnifunc
set wildignorecase
" set wildmenu
set wildmode=longest,full
" set wildoptions=pum
set wildignore+=*.o,*.obj,*.git,*.rbc,*/node_modules/,*.gem
set wildignore+=*.pyc,*.egg-info,*.pytest_cache,*.mypy_cache,*/__pycache__
set wildignore+=*.zip,*/tmp/**,*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.png,*.gif

"" Switching windows
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l
" nnoremap <C-h> <C-w>h


let g:netrw_liststyle = 3
let g:netrw_banner = 0

" set title for kitty as it moves between windows with kitty-navigator
set title
set termguicolors
let g:nvcode_termcolors=256

let g:semshi#mark_selected_nodes = 2
let g:semshi#always_update_all_highlights = v:true
let g:semshi#filetypes = ['Python']
let g:semshi#error_sign = v:false       " let lsp handle this

let g:python3_host_prog = '~/.pyenv/versions/3.8.2/envs/py3nvim-perm/bin/python' 

autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType vista,CHADTree,tagbar,undotree setlocal signcolumn=no

call plug#begin('~/.vim/plugged')
" Plug 'plasticboy/vim-markdown'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-cheat.sh'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'myusuf3/numbers.vim'

Plug 'kassio/neoterm'
    " au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
    " just in case Julia acts up when running neoterm REPL
Plug 'rhysd/devdocs.vim'
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'

Plug 'andymass/vim-matchup'

Plug 'michaeljsmith/vim-indent-object'

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'GCBallesteros/vim-textobj-hydrogen'
Plug 'GCBallesteros/jupytext.vim'
    let g:jupytext_enabled = 1
    let g:jupytext_fmt = 'md'
    nmap ]x ctrih/^# %%<CR><CR>


Plug 'mhinz/vim-startify'
Plug 'liuchengxu/vim-which-key'
" Plug 'neomake/neomake'
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-lua/lsp-status.nvim'
" Plug 'tjdevries/lsp_extensions.nvim'

Plug 'tpope/vim-surround'
Plug 'machakann/vim-sandwich'
    runtime macros/sandwich/keymap/surround.vim

Plug 'jreybert/vimagit'
Plug 'rhysd/git-messenger.vim'
Plug 'airblade/vim-gitgutter'
    let g:gitgutter_signs = 1
    let g:gitgutter_map_keys = 0
    let g:gitgutter_eager = 1
    let g:gitgutter_realtime = 1
    let g:gitgutter_override_sign_column_highlight = 1
    let g:gitgutter_sign_added = ''
    let g:gitgutter_sign_modified = ''
    let g:gitgutter_sign_removed = ''
    let g:gitgutter_sign_removed_first_line = ''
    let g:gitgutter_sign_modified_removed = ''
Plug 'lambdalisue/vim-gista'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

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


Plug 'rrethy/vim-hexokinase', {'do': 'make hexokinase'}
    let g:Hexokinase_highlighters = ['foregroundfull']

Plug 'scrooloose/nerdcommenter'
    let g:NERDCustomDelimiters = {'json': {'left': '//'}}
    let g:NERDSpaceDelims = 1
    let g:NERDCompactSexyComs = 0
    let g:NERDDefaultAlign = 'left'
    let g:NERDTrimrailingWhiteSpace = 1

" Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
    " let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
    " let g:tagbar_autofocus = 1
    " nmap <F8> :TagbarToggle<CR>


" Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'rizzatti/dash.vim', {'on': 'Dash'}

" Colorschemes
Plug 'embark-theme/vim', {'as': 'embark'}
Plug 'dracula/vim', {'as': 'Dracula'}
Plug 'patstockwell/vim-monokai-tasty', {'as': 'MonokaiTasty'}
Plug 'sonph/onehalf', {'rtp': 'vim', 'as': 'OneHalf'}

Plug 't9md/vim-choosewin'
    let g:choosewin_overlay_enable = 1
    nmap  -  <Plug>(choosewin)

Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins'}

Plug 'google/vim-searchindex'

Plug 'sbdchd/neoformat'

Plug 'luochen1990/rainbow'
    let g:rainbow_active = 1


Plug 'easymotion/vim-easymotion'
    let g:EasyMotion_do_mapping = 1
    let g:EasyMotion_smartcase = 1
    """ EasyMotion default bindings
    "  map <Leader><Leader> <Plug>(easymotion-prefix)
    "  map <Leader>f        <Plug>(easymotion-bd-f)
    "  map <Leader>f        <Plug>(easymotion-overwin-f)
    " nmap s                <Plug>(easymotion-overwin-f2)
    "  map <Leader>L        <Plug>(easymotion-bd-jk)
    " nmap <Leader>L        <Plug>(easymotion-overwin-line)
    "  map <Leader>w        <Plug>(easymotion-bd-w)
    " nmap <Leader>w        <Plug>(easymotion-overwin-w)


Plug 'haya14busa/is.vim'
    let g:is#do_default_mappings = 1
  map n   <Plug>(is-n)     <Plug>(is-nohl)
  map N   <Plug>(is-N)     <Plug>(is-nohl)
  map *   <Plug>(is-*)     <Plug>(is-nohl)
  map #   <Plug>(is-#)     <Plug>(is-nohl)
  map g* <Plug>(is-g*)     <Plug>(is-nohl)
  map g# <Plug>(is-g#)     <Plug>(is-nohl)
" Plug 'Yggdroot/indentLine'
Plug 'glepnir/indent-guides.nvim'

Plug 'glepnir/galaxyline.nvim', {'branch': 'main'}

" Plug 'nathanaelkane/vim-indent-guides'
    " let g:indent_guides_enable_on_vim_startup = 1

Plug 'hrsh7th/vim-vsnip'   | Plug 'hrsh7th/vim-vsnip-integ'
Plug 'seletskiy/ultisnips' | Plug 'honza/vim-snippets'


Plug 'psliwka/vim-smoothie'
Plug 'andrewradev/splitjoin.vim'

Plug 'tjdevries/nlua.nvim'

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
" Plug 'nvim-treesitter/completion-treesitter'
" Plug 'bryall/contextprint.nvim'
Plug 'liuchengxu/vista.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'rafcamlet/coc-nvim-lua'
    " Plug 'vn-ki/coc-clap'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

Plug 'voldikss/vim-skylight'
Plug 'voldikss/fzf-floaterm'
Plug 'voldikss/vim-floaterm'
    let g:floaterm_autoclose = 2
    let g:floaterm_keymap_toggle = '<F5>'
    let g:floaterm_wintype = 'float'
    let g:floaterm_position = 'bottom'
    nnoremap <silent><F5>           :FloatermToggle<CR>
    tnoremap <silent><F5> <C-\><C-n>:FloatermToggle<CR>

    " nnoremap <silent><Leader>fc  :FloatermKill<CR>
    " tnoremap <silent> <F8> <C-\><C-n>:FloatermKill<CR>
    " try w/ Coc & FZF

" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
    " nnoremap <leader>v <cmd>CHADopen --nofocus<CR>
             " nmap <F6> <cmd>CHADopen<CR>
    " lua vim.api.nvim_set_var("chadtree_settings", { use_icons = "emoji" })

Plug 'jpalardy/vim-slime'
    let g:slime_target = "neovim"

" Plug 'knubie/vim-kitty-navigator'
    " let &titlestring='%t - nvim'
    " let g:kitty_navigator_listening_on_address = "unix:/tmp/mykitty"


" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Clojure ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'kovisoft/paredit', {'for': 'Clojure'}
    let g:paredit_smartjump = 1
Plug 'tpope/vim-fireplace', {'for': 'Clojure'}
Plug 'guns/vim-clojure-static', {'for': 'Clojure'}
    let g:clojure_maxlines = 60
    " set lispwords+=match
    let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
Plug 'guns/vim-clojure-highlight', {'for': 'Clojure'}
Plug 'guns/vim-slamhound', {'for': 'Clojure'}
" }}}
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Go! ~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'fatih/vim-go', { 'for': 'Golang', 'do': ':GoInstallBinaries'}
" }}}
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Haskell ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'neovimhaskell/haskell-vim', { 'for': 'Haskell' }
"}}}
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Julia ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'JuliaEditorSupport/julia-vim'
    let g:julia_indent_align_import = 1
    let g:julia_indent_align_brackets = 1
    let g:julia_indent_align_funcargs = 1

" }}}
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Python ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Plug 'microsoft/vscode-python', {'for': 'Python'}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Rust ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'rust-lang/rust.vim', { 'for': 'Rust' }
Plug 'racer-rust/vim-racer', { 'for': 'Rust' }

" }}}
" ---------------------------- C++ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'jackguo380/vim-lsp-cxx-highlight', {'for': 'Cpp'}

" }}}

Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-tree.lua'
    nnoremap <F6> :NvimTreeToggle<CR>
    let g:nvim_tree_width = 25
    let g:nvim_tree_auto_open = 1
    let g:nvim_tree_auto_close = 1
    let g:nvim_tree_follow = 1
    let g:nvim_tree_indent_markers = 1
    let g:nvim_tree_git_hl = 1
    let g:nvim_disable_netrw = 1
    let g:nvim_show_icons = {
                \ 'git': 1,
                \ 'folders': 1,
                \ 'files': 1
                \ }

Plug 'akinsho/nvim-bufferline.lua'
" Plug 'sheerun/vim-polyglot'
call plug#end()


lua << EOF
require('nvim-web-devicons').setup()
require('galaxyline.init')
require('tree-sitter.init')
require('buf_line')
require('indent_guides.init')
EOF

colorscheme Snazzy
highlight Comment cterm=italic
highlight link TSPunctBracket Normal
highlight SignColumn guibg=bg
highlight SignColumn ctermbg=bg

" au! TermOpen * tnoremap <buffer> <C-c> <C-\><C-n>
" au! FileType fzf tunmap <buffer> <Esc>

let g:matchup_surround_enabled = 1
let g:matchup_matchparen_offscreen = {'method': 'popup'}
" let g:markdown_fenced_languages = [
"             \ 'vim' = 'vimls',
"             \ 'lua' = 'lua',
"             \ 'py'  = 'python',
"             \ 'jl'  = 'julia',
"             \ 'go'  = 'golang',
"             \ 'rs'  = 'rust']

let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"


let g:undotree_HighlightChangedWithSign = 1

nnoremap <leader>cp :lua require("contextprint").add_statement()<cr>
nnoremap <leader>cp :lua require("contextprint").add_statement(true)<cr>

" " Quickly edit/reload the vimrc file
nmap <silent><Leader>re :so $MYVIMRC<CR>
nmap <silent><Leader>e  :e $MYVIMRC<CR>


" " nmap <F9> :Vista!!<CR>

noremap Y y$
" noremap <Leader>p "+gP<CR>
" noremap XX "+x<CR>
" vnoremap x "_d

" greatest remap ever
" vnoremap <leader>p "_dP

" jk | escaping!
inoremap kj <Esc>
xnoremap kj <Esc>
cnoremap jk <C-c>

" swap : for ;, no more shift!
nnoremap ; :

"Buffer nav
noremap <Leader>z :bp<CR>
noremap <Leader>x :bn<CR>
" Close Buffer
noremap <Leader>c :bd<CR>


" Splitting
noremap <Leader>hs :<C-u>split<CR>
noremap <Leader>vs :<C-u>vsplit<CR>

" " nnoremap <silent> <leader>sh :terminal<CR>
nnoremap <silent> <leader>sh :<C-u>split<CR> <cmd>Tnew<CR>

" Switching windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Vmap for maintain Visual Mode after shifting > and <
xnoremap < <gv
xnoremap > >gv

"Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" " remmeber cursor pos.
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END



" Julia ctags tagbar info
" let g:tagbar_type_julia = {
"             \ 'ctagstype': 'julia',
"             \ 'kinds'    : ['t: struct', 'f: function', 'm: macro', 'c: const']}


" IndentLine
" let g:indentLine_enabled = 1
" let g:indentLine_concealcursor = 0
" let g:indentLine_faster = 1
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" let g:indentLine_color_term = 6
" let g:indentLine_fileTypeExclude = ['startify', 'coc', 'help', 'dashboard',
"                                   \ 'terminal', 'floaterm', 'vista',
"                                   \ 'CHADTree', 'tagbar', 'undotree']
