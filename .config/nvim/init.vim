let g:mapleader = "\<Space>"

" source $HOME/.config/nvim/config/mapkeys.vim
source $HOME/.config/nvim/config/Startify_cfg.vim
source $HOME/.config/nvim/config/coc.vim
source $HOME/.config/nvim/config/fzf.vim
source $HOME/.config/nvim/config/tagbar.vim
source $HOME/.config/nvim/config/gitgutter.vim
source $HOME/.config/nvim/config/airline.vim
source $HOME/.config/nvim/config/webdevicons.vim

com! Filename execute ":echo expand('%:p')"
com! Config execute ":e $MYVIMRC"

set mouse=a
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
set ttimeoutlen=75
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
set smartcase
set ignorecase
set formatoptions-=cro
set formatoptions+=1    " when wrapping paragraphs, dont end lines with 1-letter words (looks stupid)
set nobackup
set noundofile            " persistent undos - undo after u re-open the file
set noswapfile
set nowritebackup
set backspace=indent,eol,start
set colorcolumn=80
set signcolumn=auto:2
set list
set showtabline=1
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
set completeopt=menuone,noselect,noinsert 
" set omnifunc=v:lua.vim.lsp.omnifunc
set wildignorecase
" set wildmenu
set wildmode=longest,full
" set wildoptions=pum
set wildignore+=*.o,*.obj,*.git,*.rbc,*/node_modules/,*.gem
set wildignore+=*.pyc,*.egg-info,*.pytest_cache,*.mypy_cache,*/__pycache__
set wildignore+=*.zip,*/tmp/**,*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.png,*.gif



let g:netrw_liststyle = 3
let g:netrw_banner = 0

" set title for kitty as it moves between windows with kitty-navigator
set title
set termguicolors
let g:nvcode_termcolors=256

" let g:polyglot_disabled = ['sensible', 'cpp.plugin']
let g:semshi#mark_selected_nodes = 2
let g:semshi#always_update_all_highlights = v:true
let g:semshi#filetypes = ['Python']
let g:semshi#error_sign = v:false       " let lsp handle this

let g:neoterm_direct_open_repl = 1
let g:neoterm_repl_python = ['ipython', '--no-autoindent']
let g:neoterm_repl_enable_ipython_paste_magic = 1
let g:neoterm_fixedsize = '25'
let g:neoterm_callbacks = {}
function g:neoterm_callbacks.before_new()
    if winwidth('.') > 100
        let g:neoterm_default_mod = 'bot'
    else
        let g:neoterm_default_mod = 'botright vertical'
    endif
endfunction

au! VimEnter,BufRead,BufNewFile *.jl set filetype=julia

augroup Python
    au!
    au! VimEnter,BufEnter,BufWinEnter *.py :call plug#load('semshi')<CR>
    " au! VimEnter,BufEnter,BufWinEnter *.py :call TSBuff<CR>
augroup END

augroup devdocs
    au!
    au! Filetype c,cpp,rust,haskell,python,julia]
                \ nmap <buffer>K <Plug>(devdocs-under-cursor)
augroup END

" let g:smoothie_speed_exponentiation_factor = 2

" if has('nvim')
let g:python3_host_prog = '~/.pyenv/versions/3.8.2/envs/py3nvim-perm/bin/python' 
" endif

au! User GoyoEnter LimeLight
au! User GoyoLeave LimeLight!

autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType vista,CHADTree,tagbar,undotree setlocal signcolumn=no
autocmd FileType lua set ts=2 softtabstop

call plug#begin('~/.vim/plugged')
Plug 'artnez/vim-wipeout'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-cheat.sh'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'myusuf3/numbers.vim'

Plug 'jpalardy/vim-slime', {'for': ['Python', 'Julia']}
    let g:slime_target = "neovim"

Plug 'kassio/neoterm'
Plug 'rhysd/devdocs.vim'
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'


Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'


Plug 'mhinz/vim-startify'
" Plug 'liuchengxu/vim-which-key'
" Plug 'neomake/neomake'
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-lua/lsp-status.nvim'
" Plug 'tjdevries/lsp_extensions.nvim'
" Plug 'vn-ki/coc-clap', {'do': function('clap#helper#build_all'), 'on': 'Clap'}

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

Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'

Plug 'SidOfc/mkdx', {'for': 'Markdown'}
    let g:mkdx#settings = { 'highlight': {'enable': 1},
                           \ 'enter': {'shift': 1},
                           \ 'links': {'external': {'enable': 1}},
                           \ 'toc': {'text': 'Table of Contents', 'update_on_write': 1},
                           \ 'fold': {'enable': 1}}

Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install()}, 'for': ['Markdown', 'vim-plug']}
    let g:mkdp_auto_close = 0
    let g:mkdp_refresh_slow = 1
    let g:mkdp_command_for_global = 0
    let g:mkdp_browser = ''
    let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false
    \ }
    let g:mkdp_port = ''
    let g:mkdp_browserfunc = ''
    let g:mkdp_page_title = '「${name}」'

Plug 'plasticboy/vim-markdown', {'for': 'Markdown'}
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_math = 1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_toml_frontmatter = 1
    let g:vim_markdown_json_frontmatter = 1
    let g:vim_markdown_new_list_item_indent = 1

Plug 'sindresorhus/github-markdown-css', {'for': 'Markdown'}

Plug 'rrethy/vim-hexokinase', {'do': 'make hexokinase'}
    let g:Hexokinase_highlighters = ['foregroundfull']

Plug 'scrooloose/nerdcommenter'
    let g:NERDCustomDelimiters = {'json': {'left': '//'}}
    let g:NERDSpaceDelims = 1
    let g:NERDCompactSexyComs = 0
    let g:NERDDefaultAlign = 'left'
    let g:NERDTrimrailingWhiteSpace = 1

Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
    let g:tagbar_autofocus = 1
    nmap <F8> :TagbarToggle<CR>


Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
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

Plug 'junegunn/rainbow_parentheses.vim'

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


Plug 'haya14busa/is.vim'             
    let g:is#do_default_mappings = 1
   map n <Plug>(is-n)<Plug>(is-nohl)
   map N <Plug>(is-N)<Plug>(is-nohl)
   map * <Plug>(is-*)<Plug>(is-nohl)
   map # <Plug>(is-#)<Plug>(is-nohl)
   map g* <Plug>(is-g*)<Plug>(is-nohl)
   map g# <Plug>(is-g#)<Plug>(is-nohl)

Plug 'Yggdroot/indentLine'

Plug 'hrsh7th/vim-vsnip'   | Plug 'hrsh7th/vim-vsnip-integ'
Plug 'seletskiy/ultisnips' | Plug 'honza/vim-snippets'


Plug 'psliwka/vim-smoothie'
Plug 'andrewradev/splitjoin.vim'


Plug 'neoclide/coc.nvim', {'branch': 'release'} | Plug 'rafcamlet/coc-nvim-lua'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

" Plug 'andymass/vim-matchup'
    " let g:matchup_matchparen_deferred = 1
    " le
" get these two to work with CoC and/or LF
" Plug 'voldikss/fzf-floaterm'
" Plug 'voldikss/vim-floaterm'
"     let g:floaterm_autoclose = 2
    " let g:floaterm_keymap_toggle = '<Leader>fo'
    " let g:floaterm_keymap_kill = '<Leader>fc'

    " nnoremap <silent><Leader>fo  :FloatermToggle<CR>
    " tnoremap <silent> <F7> <C-\><C-n>:FloatermToggle<CR>

    " nnoremap <silent><Leader>fc  :FloatermKill<CR>
    " tnoremap <silent> <F8> <C-\><C-n>:FloatermKill<CR>
    " try w/ Coc & FZF

Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
    nnoremap <leader>v <cmd>CHADopen --nofocus<CR>
     nmap <F6> <cmd>CHADopen<CR>
    " lua vim.api.nvim_set_var("chadtree_settings", { use_icons = "emoji" })

    " hotkey clear quickfix list
    " nnoremap <leader>vc <cmd>call setqflist([])<CR>


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

Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
" }}}
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Haskell ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'neovimhaskell/haskell-vim' " , {'for': 'Haskell'}
"}}}
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Julia ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'JuliaEditorSupport/julia-vim'
    let g:julia_indent_align_import = 1
    let g:julia_indent_align_brackets = 1
    let g:julia_indent_align_funcargs = 1

" aug Julia
"     autocmd FileType julia nmap <silent> ? <Plug>(JuliaDocPrompt)
" aug END
" }}}
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Python ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Plug 'microsoft/vscode-python', {'for': 'Python'}
Plug 'GCBallesteros/vim-textobj-hydrogen'
Plug 'GCBallesteros/jupytext.vim'
    let g:jupytext_enabled = 1
    let g:jupytext_fmt = 'md'
    nmap ]x ctrih/^# %%<CR><CR>


" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Rust ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'rust-lang/rust.vim', { 'for': 'Rust' }
Plug 'racer-rust/vim-racer', { 'for': 'Rust' }

" }}}
" ---------------------------- C++ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

Plug 'jackguo380/vim-lsp-cxx-highlight', {'for': 'Cpp'}

" }}}
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TS/JS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{

" Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
" Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
" Plug 'MaxMellon/vim-jsx-pretty', {'for': 'javascript'}
" Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
"}}}
Plug 'tjdevries/nlua.nvim'
Plug 'norcalli/nvim.lua'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
" Plug 'nvim-treesitter/completion-treesitter'
Plug 'bryall/contextprint.nvim'
" Plug 'sheerun/vim-polyglot'
call plug#end()

lua require'nvim-web-devicons'.setup()
" lua require'bufferline'.setup()
" lua require('lsp')

lua require'tree'
" luafile '$HOME/.config/nvim/lua/tree.lua'

colorscheme Snazzy
highlight Comment cterm=italic
highlight link TSPunctBracket Normal
highlight SignColumn guibg=bg ctermbg=bg



" Change cursor shape for iTerm2 on macOS {
" bar in Insert mode
" inside iTerm2
if $TERM_PROGRAM =~# 'iTerm'
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

  " inside tmux
if exists('$TMUX') && $TERM != 'xterm-kitty'
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
endif

au! TermOpen * tnoremap <buffer> <C-c> <C-\><C-n>
" au! FileType fzf tunmap <buffer> <Esc>

" let g:matchup_surround_enabled = 0
" let g:matchup_matchparen_offscreen = 'status'
" "['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']".
let g:markdown_fenced_languages = [
            \ 'viml=vim',
            \ 'help',
            \ 'lua=lua',
            \ 'py=python',
            \ 'jl=julia',
            \ 'go=golang',
            \ 'rs=rust'
            \]

let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"



let g:undotree_HighlightChangedWithSign = 1

lua require('contextprint').setup({ separator_char = "#", include_class = true, include_function = true, include_method = true, include_if = true, include_for = true})
nnoremap <Leader>cp <cmd>lua require("contextprint").add_statement()<cr>
nnoremap <Leader>cp <cmd>lua require("contextprint").add_statement(true)<cr>


" bufferline quick buffer swap
" nnoremap <leader>0 <cmd>lua require"bufferline".go_to_buffer(num)<CR>

" quickly scroll up/down couple rows while in insert mode, tho u lose the
" ability to copy text from the line above/below the cursor (i_<C-Y/E>)
" [[ This is exactly why reading :h is such a good idea! ]]
" inoremap <C-E> <C-X><C-E>
" inoremap <C-Y> <C-X><C-Y>

" " Quickly edit/reload the vimrc file
nmap <silent><Leader>re :w <bar> :so $MYVIMRC<CR>
nmap <silent><Leader>e  :w <bar> :e $MYVIMRC<CR>

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

" Move to the start of line
nnoremap H ^
" Move to the end of line
nnoremap L $
" Redo
nnoremap U <C-r>

nnoremap Y y$
" noremap <Leader>p "+gP<CR>
" noremap XX "+x<CR>
vnoremap x "_d

vnoremap <leader>p "_dP

" jk | escaping!
inoremap kj <Esc>
xnoremap kj <Esc>
" cnoremap jk <C-c>

" swap : for ;, no more shift!
nnoremap ; :

"Buffer nav
noremap <Leader>z :bp<CR>
noremap <Leader>x :bn<CR>
" Close Buffer
noremap <Leader>c :bd<CR>

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~ Splitting ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
noremap <Leader>hs :<C-u>split<CR>
noremap <Leader>vs :<C-u>vsplit<CR>

" " nnoremap <silent> <leader>sh :terminal<CR>
nnoremap <silent> <leader>sh :<C-u>split<CR><cmd>Tnew<CR>

" ~~~~~~~~~~~~~~~~~~~~~~ remmeber cursor pos ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END


" ~~~~~~~~~~~~~~~~~~~~~~~~~~~ IndentLine ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_faster = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_color_term = 6
let g:indentLine_bufTypeExclude = ['startify', 'coc', 'help', 'fzf', 'Neoterm',
                                  \ 'terminal', 'floaterm', 'vista', 'CHADTree',
                                  \ 'tagbar', 'undotree']
let g:IndentLine_bufNameExclue = ['startify', 'coc', 'fzf', 'Neoterm.*', 'floaterm.*',
                                    \ 'vista.*', 'CHADTree*','tagbar.*', 'undotree.*']
