" Vimrc as of 06/21/20
filetype plugin indent on
syntax on
let g:mapleader = "\<Space>"
set termguicolors
" set nocompatible " incase vim is used from time to time


autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType vista,coc-explorer setlocal signcolumn=no

set mouse=a

set guifont=Fira\ Code:h13:cANSI

set shell=/usr/local/bin/zsh
set cmdheight=2
set laststatus=2
set switchbuf=useopen 	    " reveal already opened files from
		                	" the quick fix window instead of opening new buffers
set updatetime=500 	    " Speed up updatetime so gitgutter & friends are quicker
set visualbell 
set noerrorbells
set showmatch
set gdefault
set hidden		" hide buffers instead of closing them, this means
			    " means that the current buffer can be put to background
			    " w/o being written; & that marks & undo hist are
			    " preserved
set rnu nu
" set conceallevel=3
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set fillchars+=vert:\┃
set smarttab
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
set shortmess+=c
set signcolumn=yes
set listchars=tab:->\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set showtabline=2
" set clipboard=unnamedplus 

" au BufEnter * set fo-=c fo-=r fo-=o


call plug#begin('~/.vim/plugged')
Plug 'terryma/vim-multiple-cursors'
Plug 'fatih/vim-go', { 'for': 'Golang', 'do': ':GoInstallBinaries' } 
Plug 'wsdjeg/vim-scriptease'
Plug 'mhinz/vim-grepper'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'	"git
Plug 'tpope/vim-fugitive'	    "git
Plug 'tpope/vim-rhubarb'
  " Use i_^-X_^-O to omnicompl GitHub issues or proj. collab. usernames when
  " editing a commit msg.
  " Use Fugitives :Gbrowse to browse the GitHub URL for the current buffer.
  "Plug 'tpope/vim-commentary'

Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
    let g:undotree_WindowLayout = 2
    nnoremap <F7> :UndotreeToggle<CR>
Plug 'easymotion/vim-easymotion'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'scrooloose/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'} 
Plug 'kien/tabman.vim'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
    nmap <F8> :TagbarToggle<CR>
Plug 'liuchengxu/vista.vim', {'on': 'Vista'} | Plug 'liuchengxu/vim-clap', {'do': ':Clap install-binary'}

" Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes' 
Plug 'rizzatti/dash.vim', { 'on': 'Dash' }

" Colorscheme             
Plug 'liuchengxu/space-vim-theme', {'as': 'space-vim-theme'}
Plug 'connorholyday/vim-snazzy', {'as': 'snazzy'}
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'sheerun/vim-polyglot', {'for': ['haskell',  'julia', 'rust', 'typescript',
                             \'golang', 'javascript', 'scala', '']}
let g:polyglot_disabled = ['python']             
Plug 'joshdick/onedark.vim', {'as': 'onedark'}
Plug 'patstockwell/vim-monokai-tasty', {'as': 'monokai_tasty'}
Plug 't9md/vim-choosewin'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 
                                    \'do': ':UpdateRemotePlugins'}
Plug 'google/vim-searchindex'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'pedsm/sprint'
Plug 'masukomi/rainbow_parentheses.vim'
Plug 'haya14busa/is.vim' | Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'Yggdroot/indentLine'
Plug 'seletskiy/ultisnips' | Plug 'honza/vim-snippets'
Plug 'vn-ki/coc-clap', {'do': function('clap#helper#build_all')}
Plug 'ludovicchabant/vim-gutentags'
Plug 'jpalardy/vim-slime'
    let g:slime_target = "tmux"
Plug 'voldikss/vim-floaterm'

Plug 'nvim-treesitter/nvim-treesitter'

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Clojure
Plug 'kovisoft/paredit', {'for': 'Clojure'}
    let g:paredit_smartjump = 1
Plug 'tpope/vim-fireplace', {'for': 'Clojure'}
Plug 'guns/vim-clojure-static', {'for': 'Clojure'}
    let g:clojure_maxlines = 60
    set lispwords+=match
    let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
Plug 'guns/vim-clojure-highlight', {'for': 'Clojure'}
Plug 'guns/vim-slamhound', {'for': 'Clojure'}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Haskell
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'sbdchd/neoformat', {'for': ['haskell', 'python']}


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Julia
Plug 'JuliaEditorSupport/julia-vim'

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Python
" Plug 'psf/black', {'branch': 'stable' }
Plug 'numirias/semshi', {'for': 'python',
                        \ 'do': ':UpdateRemotePlugins' }

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TS/JS
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
Plug 'MaxMellon/vim-jsx-pretty', {'for': 'javascript'}
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }


call plug#end() 

set completeopt=noselect,menuone,preview
" set completeopt+=longest
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__


let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTrimrailingWhiteSpace = 1

let g:webdevicons_enable = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_startify = 1
let g:webdevicons_enable_flagship_statusline = 1
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:DevIconsEnableFoldersOpenClose = 1

lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "all",
	highlight = {
		enable = true,
		disable = { "c", "haskell", "scala" },
	},
}
EOF

" let g:polyglot_disabled = ['python']             
" let g:semshi#filetypes = ['python']

let g:tabman_toggle = '<leader>mt'
let g:tabman_focus = '<leader>mf'
let g:tabman_width = 20
let g:tabman_side = 'left'


" tab navigation mappings
map tt :tabnew
map <M-Right> :tabn<CR>
imap <M-Right><ESC> :tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left><ESC> :tabp<CR>

" Majutsushi tagbar
let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
let g:tagbar_autofocus = 1

" Julia ctags tagbar info
let g:tagbar_type_julia = {
    \ 'ctagstype': 'julia',
    \ 'kinds'    : [
        \ 't:struct', 'f:function', 'm:macro', 'c:const']
    \}



map <Leader>re :source ~/.vimrc<CR>

nmap <F6> <cmd>CHADopen<CR>

nmap <F9> :Vista!!<CR>

let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<M-b>'
" let g:AutoPairs['<']='>'

"" testing masukomi/rainbowParentheses
augroup RainbowParentheses
    au!
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    au Syntax * RainbowParenthesesLoadChevrons
augroup END


" let g:onedark_hide_endofbuffer = 1
" let g:onedark_terminal_italics = 1


" colorscheme dracula
colorscheme snazzy 
" colorscheme space_vim_theme 
" colorscheme onedark
" monokai_tasty

if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <Leader>p "+gP<CR>
noremap XX "+x<CR>


" Buffer nav
noremap <Leader>z :bp<CR>
noremap <Leader>x :bn<CR>
" Close Buffer
noremap <Leader>c :bd<CR>

" Clean hlsearch
nnoremap <silent><expr><Leader><Space><Space> :noh <CR>

let g:incsearch#auto_nohlsearch = 1
" Splitting
noremap <Leader>hs :<C-u>split<CR>
noremap <Leader>vs :<C-u>vsplit<CR>

nnoremap <silent> <leader>sh :terminal<CR>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" GFiles && RipGrep!
" nnoremap <C-p> :GFiles<CR>
" nnoremap <C-f> :Rg<CR>


highlight ColorColumn ctermbg=0 guibg=lightgrey

nmap  -  <Plug>(choosewin)
" show big letters
let g:choosewin_overlay_enable = 1


" let python_highlight_all = 1

let g:Hexokinase_highlighters = ['virtual']

" save as sudo
ca w!! w !sudo tee "%"


" EasyAlign mapping
"" start interactive EasyAlign in visual mode (eg vipga)
xmap ga <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (eg gaip)
nmap ga <Plug>(EasyAlign)

""" EasyMotion default bindings
map <Leader><Leader> <Plug>(easymotion-prefix)
map <Leader>f <Plug>(easymotion-bd-f)
map <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)


"~~~~~~~~~~~~~~~~~~~~~rm trailing whitespaces~~~~~~~~~~~~~~~~~"
command! FixWhitespace :%s/\s\+$//e



"~~~~~~~~~~~~~~~~~~~~~~~~~~~F(x)~~~~~~~~~~~~~~~~~~~~~"
if !exists('*s:setupWrapping')
    function s:setupWrapping()
        set wrap
        set wm=2
        set textwidth=79
    endfunction
endif


"~~~~~~~~~~~~~~~~~~~~~~~~~~~autocmd rules~~~~~~~~~~~~~~~~~~~~"
" if pc fast enuff, syntax highlight sync from start unless 200 lines
augroup vimrc-sync-fromstart
    autocmd!
    autocmd BufEnter * :syntax sync maxlines=600
augroup END

" remmeber cursor pos.
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" " txt
" augroup vimrc-wrapping
"   autocmd!
"   autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
" augroup END

"augroup vimrc-wrapping
    "autocmd!
    "autocmd BufRead,BufNewFile *.py call s:setupWrapping()
"augroup end


"~~~~~~~~~~~~~~~~~~~~~~ Search mappings temp ~~~~~~~~~~~~~~~~~~~~~~~~
" nnoremap n nzzzv
" nnoremap N Nzzzv


"~~~~~~~~~~~~~~~~~~~~~~~~ Coc.Nvim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
let g:coc_node_path = '/usr/local/bin/node'

let g:coc_glogal_extensions = [  
    \   'coc-json',
    \   'coc-snippets',
    \   'coc-python',
    \   'coc-sh',
    \   'coc-explorer',
    \   'coc-vimlsp',
    \   'coc-git',
    \   'coc-lists',
    \]
    

inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ?
  \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " let g:coc_snippet_next = '<tab>'

"" User <c-space> to trigger completion
"if has ('nvim')
"    inoremap <silent><expr> <c-space> coc#refresh()
"else
"    inoremap <silent><expr> <c-@> coc#refresh()
"endif

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

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>ln <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lf  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,python,markdown,golang,viml setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>ap  <Plug>(coc-codeaction-selected)
nmap <leader>ap  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" This needs work. TODO
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

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"~~~~~~~~~~~~~~~~~~~~~ Coc-Explorer ~~~~~~~~~~~~~~~~~~~~~~~~~"

let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   }
\ }
noremap <C-o> :CocCommand explorer<CR>
noremap <Leader><C-o> :CocCommand explorer --preset floating<CR>
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif 

" Use preset argument to open it
" nmap <space>ed :CocCommand explorer --preset .vim<CR>
" nmap <space>ef :CocCommand explore --preset floating<CR>

" List all presets
nmap <space>ep :CocList explPresets



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

" CocSEARCH
" nnoremap <silent> <leader>lr :<C-u>CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent> <leader>rw :CocSearch <C-R><C-W><CR>

" Use Marketplace
nnoremap <silent> <leader>lm :<C-u>CocList marketplace<CR>

" Coc-yank
nnoremap <silent> <leader>ly  :<C-u>CocList -A --normal yank<cr>


"~~~~~~~~~~~~~~~~~~~~~~~~~~~ Nvim Specific ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

let g:python3_host_prog = '/Users/eo/.pyenv/versions/py3nvim-perm/bin/python'

let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"

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

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ IndentLine ~~~~~~~~~~~~~~~~~~~~~~~~~"

let g:indentLine_enabled = 1 
let g:indentLine_concealcursor = 0 
let g:indentLine_faster = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_color_term = 6
let g:indentLine_fileTypeExclude = ['startify', '', 'help',
                                    \ 'CHADTree', 'coc-explorer']
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ vim-airline temp ~~~~~~~~~~~~~~~~~~~~~~~~
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
    let g:webdevicons_enable = 1
endif

if exists("*fugitive#statusline")
     set statusline+=%{fugitive#statusline()}
endif

" onedark "base16_snazzy" "dracula"

let g:airline_theme = "base16_snazzy"
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#format = 2
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#grepper#enabled = 1
let g:airline#extensions#fzf#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#lsp#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:airline#extensions#vista#enabled = 0

let g:airline#extensions#tabws#enabled = 0
let g:airline#extensions#tagbar#enabled = 1

let g:airline#extensions#keymap#enabled = 1

let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#hunks#coc_git = 1
let g:airline_skip_empty_sections = 1

let g:airline#extensions#windowswap#enabled = 1

let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#tabline#close_symbol = 'X'

let g:airline#extensions#whitespace#enabled = 0   
let b:airline_whitespace_disabled = 1

"~~~~~~~~~~~~~~~~~~~~~~~~ vista.vim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'ctags'
let g:vista_echo_cursor_strategy = ['both']

let g:vista_ctags_cmd = {
    \ 'haskell': 'hasktags -x -o - -c',
    \ 'go': 'gotags',
	\ 'python': 'ctags'
    \}

let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
    \ "function": "\uf794",
    \ "variable": "\uf71b",
    \}
let g:vista_fzf_preview = ['right:60%:wrap']
let g:vista_executive_for = {
    \ 'cpp': 'coc',
    \ 'py':  'coc',
    \ 'rls': 'coc',
    \}

function! NearestMethodOrFunction() abort
	return get(b:, 'vista_nearest_method_or_function', '')
endfunction


if exists("*NearestMethodOrFunction")
	set statusline+=%{NearestMethodOrFunction()}
endif
" to autmoatically show the nearetst fx in statusline automatically
" need to add this:
" autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:vista_log_file = expand('~/vista.log')

"~~~~~~~~~~~~~~~~~~~~~~~~~ Smaller Extensions ~~~~~~~~~~~~~~~~~~~~~~~"
" Fzf.vim
let $BAT_THEME = 'Sublime Snazzy'
let g:fzf_layout = {'window': 'call OpenFloatingWin()'}



" Ripgrep
" let g:rg_command = '/usr/local/bin/rg'
    " let $FZF_DEFAULT_COMMAND = 'rg --files --colors=ansi --hidden --follow --glob "!.git/*"'
    " set grepprg=rg\ --vimgrep
command! -bang -nargs=* Rg 
        \ call fzf#vim#grep(
        \   <bang>0 ? fzf#vim#with_preview()
        \           : fzf#vim#with_preview(),
        \   <bang>0)

command! -bang -nargs=? -complet=dir GFiles
            \   call fzf#vim#gitfiles(
            \   <q-args>,
            \   fzf#vim#with_preview(),
            \   <bang>0)

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
"" GFiles && RipGrep!

" nnoremap <C-p> :GFiles<CR>
" nnoremap <C-f> :Rg<CR>

" Ex: :Rg myterm -g '*.md'
" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column 
            " \--line-number --no-heading --color=always --smart-case " . 
            " <q-args>, 1, <bang>0)

"" Ag
"let g:Ag_command = '/usr/local/bin/ag'
"if executable('ag')
"    let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
"    "set grepprg=ag\ --nogroup\ --nocolor
"endif

"" Pt
"let g:pt_command = '/usr/local/bin/pt' 
"if executable('pt')
"    let $FZF_DEFAULT_COMMAND = 'pt -i -f -h'
"endif

"~~~~~~~~~~~~~~~~~~~ Vim-Clap ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
let g:clap_provider_dotfiles = {
    \ 'source': ['~/.vimrc', '~/.zshrc', '~/.tmux.conf'],
    \ 'sink': 'e',
    \}

let g:clap_provider_commands = {
    \ 'source': ['Clap debug', 'UltiSnipsEdit'],
    \ 'sink': { selected -> execute(selected, '')},
    \}
"~~~~~~~~~~~~~~~~~~~~ UltiSnips ~~~~~~~~~~~~~~~~~~~~"

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsEditSplit="vertical"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Haskell
" let g:haskell_indent_if = 3
" let g:haskell_indent_case = 2
" let g:haskell_indent_let = 4
" let g:haskell_indent_where = 6
" let g:haskell_indent_before_where = 2
" let g:haskell_indent_after_bare_where = 2
" let g:haskell_indent_do = 3
" let g:haskell_indent_in = 1
" let g:haskell_indent_guard = 2
" let g:haskell_indent_case_alternative = 1
let g:haskell_conceal_wide = 1
let g:haskell_multiline_strings = 1
"let g:necoghc_enable_detailed_browse = 1
"autocmd Filetype haskell setlocal omnifunc=necoghc#omnifunc


" Rust
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <Leader>gd <Plug>(rust-doc)

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
" let g:ale_lint_on_save = 0


"~~~~~~~~~~~~~~~~~~~~~ Kite AutoComplete ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" let g:KiteAutoEnable = 0
" let g:kite_supported_languages = ['python']
" let g:kite_auto_complete=1
" let g:kite_snippets=1
" let g:kite_tab_complete=1
" let g:kite_documentation_continual=0
" let g:kite_log=1
" " let g:kite_previous_placeholder = '<C-H>'
" " let g:kite_next_placeholder = '<C-L>'

"  set completeopt+=menuone   " show the popup menu even when there is only 1 match
"  set completeopt+=noinsert  " don't insert any text until user chooses a match
"  set completeopt-=longest   " don't insert the longest common text
"  set completeopt+=preview
" autocmd CompleteDone * if !pumvisible() | pclose | endif


