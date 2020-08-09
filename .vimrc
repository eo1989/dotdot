" Vimrc as of 06/21/20
filetype plugin indent on
syntax on
let g:mapleader = "\<Space>"
set notermguicolors
set nocompatible " incase vim is used from time to time


call plug#begin('~/.vim/plugged')
Plug 'ryanoasis/vim-devicons'
Plug 'terryma/vim-multiple-cursors'
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'} 
Plug 'mileszs/ack.vim'
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
Plug 'mbbill/undotree'
Plug 'easymotion/vim-easymotion'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'scrooloose/nerdcommenter'
Plug 'liuchengxu/vista.vim'
" Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
" Plug 'liuchengxu/eleline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Colorscheme
Plug 'liuchengxu/space-vim-theme'
Plug 'connorholyday/vim-snazzy'
Plug 'sheerun/vim-polyglot', { 'for': [ 'rust', 'cpp', 'typescript', 'javascript', 'yaml', 'markdown', 'haskell', 'json', 'julia', 'vim' ] }
Plug 't9md/vim-choosewin'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
"Plug 'yuki-ycino/fzf-preview.vim' { 'branch': 'release', "do": ':UpdateRemotePlugins' }
Plug 'vim-scripts/YankRing.vim'
Plug 'google/vim-searchindex'
" Plug 'dense-analysis/ale'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'pedsm/sprint'
Plug 'luochen1990/rainbow'
Plug 'jlanzarotta/bufexplorer'
Plug 'haya14busa/incsearch.vim'
Plug 'Yggdroot/indentLine'

" Haskell
" Plug 'eagletmt/neco-ghc'
Plug 'sdiehl/vim-ormolu', { 'for': 'Haskell' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'Haskell' }
Plug 'sbdchd/neoformat', { 'for': 'Haskell' }

" JS
Plug 'jelera/vim-javascript-syntax', { 'for': 'Javascript' }

" Python
" Plug 'psf/black', {'branch': 'stable' }
Plug 'numirias/semshi', {'for': 'Python', 'do': ':UpdateRemotePlugins'}

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'Rust' }
Plug 'racer-rust/vim-racer', { 'for': 'Rust' }

" Typescript
Plug 'leafgarland/typescript-vim', { 'for': 'Typescript' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'Typescript' }


call plug#end() 

let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<M-b>'

let g:rainbow_active = 1

colorscheme snazzy 
" colorscheme space_vim_theme 
set guifont="Fira Code":h13

set shell=/usr/local/bin/zsh
set cmdheight=2
set laststatus=2
set switchbuf=useopen 	    " reveal already opened files from
		                	" the quick fix window instead of opening new buffers
set updatetime=300 	    " Speed up updatetime so gitgutter & friends are quicker
set visualbell 
set noerrorbells
set showmatch
set gdefault
set wildmenu
set hidden		" hide buffers instead of closing them, this means
			    " means that the current buffer can be put to background
			    " w/o being written; & that marks & undo hist are
			    " preserved
set rnu nu
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set fillchars+=vert:\┆
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
highlight ColorColumn ctermbg=0 guibg=lightgrey


nmap  -  <Plug>(choosewin)
" show big letters
let g:choosewin_overlay_enable = 1


let g:polyglot_disabled = ['python']

let g:semshi#filetypes = ['python']

let g:Hexokinase_highlighters = ['virtual']

" save as sudo
ca w!! w !sudo tee "%"


" EasyAlign mapping
"" start interactive EasyAlign in visual mode (eg vipga)
xmap ga <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (eg gaip)
nmap ga <Plug>(EasyAlign)

""" EasyMotion default bindings
map <Leader> <Plug>(easymotion-prefix)

""" hayabusa incsearch bindings
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" :h g:incsearch#auto_nohlsearch
map n <Plug>(incsearch-nohl-n)
map N <Plug>(incsearch-nohl-N)
map * <Plug>(incsearch-nohl-*)
map # <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <Leader>p "+gP<CR>
noremap XX "+x<CR>

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Buffer nav
noremap <Leader>z :bp<CR>
noremap <Leader>q :bp<CR>
noremap <Leader>x :bn<CR>
noremap <Leader>w :bn<CR>

" Close Buffer
noremap <Leader>c :bd<CR>

" Clean hlsearch
nnoremap <silent> <Leader><space> :noh<cr>


" Splitting
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>


"~~~~~~~~~~~~~~~~~~~~~~~terminal emulation ~~~~~~~~~~~~~~~~~~~~~"
nnoremap <silent> <leader>sh :terminal<CR>

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

" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt,*py call s:setupWrapping()
augroup END

"augroup vimrc-wrapping
    "autocmd!
    "autocmd BufRead,BufNewFile *.py call s:setupWrapping()
"augroup end


"~~~~~~~~~~~~~~~~~~~~~~ Search mappings temp ~~~~~~~~~~~~~~~~~~~~~~~~
" nnoremap n nzzzv
" nnoremap N Nzzzv

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CoC Specific ~~~~~~~~~~~~~~~~~~~~~~~~~~"
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

" User <c-space> to trigger completion
if has ('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
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
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.

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
command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent> <leader>fa  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <leader>fe  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <leader>fc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <leader>fo  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <leader>fs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>fj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>fk  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <leader>fp  :<C-u>CocListResume<CR>
" Find files in cwd.
nnoremap <silent> <leader>ff :<C-u>CocList locationlist<CR>
" Find buffers
nnoremap <silent> <leader>bf :<C-u>CocList buffers<CR>

autocmd FileType json syntax match Comment +\/\/.\+$+









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
let g:indentLine_char = '┆' 
let g:indentLine_faster = 1



"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ vim-airline temp ~~~~~~~~~~~~~~~~~~~~~~~~
" if exists("*fugitive#statusline")
"     set statusline+=%{fugitive#statusline()}
" endif

let g:airline_theme = 'base16_snazzy'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#format = 1
let g:airline#extensions#fugitive#enabled = 1
let g:airline#extensions#fzf#enabled = 1
let g:airline#extensions#lsp#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#vista#enabled = 1
let g:airline#extensions#coc#enabled = 1
"let g:airline#extensions#coc#error_symbol = 'E: '
"let g:airline#extensions#coc#warning_symbol = 'W: '
"let g:airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
"let g:airline#extensions#coc#stl_format_warn = '%W{[%w(#fw)]}'

"let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1

" let g:airline_symbols = 1
" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif
" 
" if !exists('g:airline_powerline_fonts')
"     let g:airline#extensions#tabline#left_sep = ' '
"     let g:airline#extensions#tabline#left_alt_sep = '|'
"    " let g:airline_left_sep          = '▶'
"    " let g:airline_left_alt_sep      = '»'
"    " let g:airline_right_sep         = '◀'
"    " let g:airline_right_alt_sep     = '«'
"     let g:airline#extensions#branch#prefix     = '⤴' 
"     let g:airline#extensions#readonly#symbol   = '⊘'
"     let g:airline#extensions#linecolumn#prefix = '¶'
"     let g:airline#extensions#paste#symbol      = 'ρ'
"     let g:airline_symbols.linenr    = '␊'
"     let g:airline_symbols.branch    = '⎇'
"     let g:airline_symbols.paste     = 'ρ'
"     let g:airline_symbols.paste     = 'Þ'
"     let g:airline_symbols.paste     = '∥'
"     let g:airline_symbols.whitespace = 'Ξ'
" else
"     let g:airline#extensions#tabline#left_sep = ''
"     let g:airline#extensions#tabline#left_alt_sep = ''
" 
" " powerline symbols
"     let g:airline_left_sep = ''
"     let g:airline_left_alt_sep = ''
"     let g:airline_right_sep = ''
"     let g:airline_right_alt_sep = ''
"     let g:airline_symbols.branch = ''
"     let g:airline_symbols.readonly = ''
"     let g:airline_symbols.linenr = ''
" endif


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






" tab navigation mappings
map tt :tabnew 
map <M-Right> :tabn<CR>
imap <M-Right> <ESC>:tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left> <ESC>:tabp<CR>   



"~~~~~~~~~~~~~~~~~~~~~~~~~~ UndoTree ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" nnoremap <F5>:UndotreeToggle<CR>


"~~~~~~~~~~~~~~~~~~~~~ Kite AutoComplete ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" let g:KiteAutoEnable = 0
" let g:kite_supported_languages = ['python', 'javascript', 'go']
" let g:kite_auto_complete=1
" let g:kite_snippets=1
" let g:kite_tab_complete=1
" let g:kite_documentation_continual=0
" let g:kite_log=1
" let g:kite_previous_placeholder = '<C-H>'
" let g:kite_next_placeholder = '<C-L>'

" set completeopt+=menuone   " show the popup menu even when there is only 1 match
" set completeopt+=noinsert  " don't insert any text until user chooses a match
" set completeopt-=longest   " don't insert the longest common text
" set completeopt+=preview

" autocmd CompleteDone * if !pumvisible() | pclose | endif

"~~~~~~~~~~~~~~~~~~~~~~~~~ window mapping ~~~~~~~~~~~~~~~~~"


"~~~~~~~~~~~~~~~~~~~~~~~ webdevicons ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
let g:webdevicons_enable = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_startify = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable_flagship_statusline = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true

"~~~~~~~~~~~~~~~~~~~~~~~~ vista.vim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
let g:vista_echo_cursor_strategy = ['both']

let g:vista_ctags_cmd = {
    \ 'haskell': 'hasktags -o - -c',
    \ 'go': 'gtags',
    \}

let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
    \ "function": "\uf794",
    \ "variable": "\uf71b"}
let g:vista_fzf_preview = ['right:60%:wrap']
let g:vista_executive_for = {
    \ 'cpp': 'coc',
    \ 'py': 'coc',
    \ 'rls': 'coc',
    \ }
" lets see if this works 08/06/20
"autocmd FileType vista,vista_kind nnoremap <buffer> <silent> \
        "/:<c-u>call vista#finder#fzf#Run()<CR>

"let g:vista_log_file = expand('~/vista.log')

"~~~~~~~~~~~~~~~~~~~~~~~~~ Smaller Extensions ~~~~~~~~~~~~~~~~~~~~~~~"
" Fzf.vim
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND = "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o -type f -print -o -type l -print 2> /dev/null"


" Ripgrep
let g:rg_command = '/usr/local/bin/rg'
if executable('Rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --colors=ansi --hidden --follow --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

" Ag
let g:Ag_command = '/usr/local/bin/ag'
if executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
    set grepprg=ag\ --nogroup\ --nocolor
endif

" Pt
let g:pt_command = '/usr/local/bin/pt' 
if executable('pt')
    let $FZF_DEFAULT_COMMAND = 'pt -i -f --hidden'
endif



" ~~~~~~~~~~~~~~~~~~~~ UltiSnips ~~~~~~~~~~~~~~~~~~~~"

"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<C-b>"
"let g:UltiSnipsEditSplit="vertical"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Haskell
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
