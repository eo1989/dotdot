nmap ]x ctrih/^# %%<CR><CR>

nmap <F8> :TagbarToggle<CR>

nnoremap <F7> :UndotreeToggle<CR>

vmap <Enter> <Plug>(EasyAlign)
xmap ga      <Plug>(EasyAlign)
nmap ga      <Plug>(EasyAlign)


nmap  -  <Plug>(choosewin)


 map <Leader><Leader> <Plug>(easymotion-prefix)
 map <Leader>f        <Plug>(easymotion-bd-f)
 map <Leader>f        <Plug>(easymotion-overwin-f)
nmap s                <Plug>(easymotion-overwin-f2)
 map <Leader>L        <Plug>(easymotion-bd-jk)
nmap <Leader>L        <Plug>(easymotion-overwin-line)
 map <Leader>w        <Plug>(easymotion-bd-w)
nmap <Leader>w        <Plug>(easymotion-overwin-w)


nnoremap <leader>v <cmd>CHADopen --nofocus<CR>
nmap <F6> <cmd>CHADopen<CR>

au! TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
au! FileType fzf tunmap <buffer> <Esc>

" Fzf keymapping
nnoremap <silent> <leader>fm :<C-u>CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent> <leader>fp :<C-u>FzfPreviewProjectFiles<CR>
nnoremap <silent> <leader>fb :<C-u>FzfPreviewBuffers<CR>
nnoremap <silent> <leader>fM :<C-u>FzfPreviewOldFiles<CR>

nnoremap          <leader>pf :Files<CR>

inoremap <expr> <c-x><c-f> <Plug>(fzf-complete-path)
inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
			\ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
			\ fzf#wrap({'dir': expand('%:p:h')}))

" context print keymapping
" nnoremap <leader>cp <cmd>lua require("contextprint").add_statement()<cr>
" nnoremap <leader>cp <cmd>lua require("contextprint").add_statement(true)<cr>

" resizing keymapping
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>rp :resize 100<CR>

" 
" Quickly edit/reload the vimrc file
nmap <silent><Leader>re :so $MYVIMRC<CR>
nmap <silent><Leader>e  :e $MYVIMRC<CR>

noremap Y y$
" noremap <Leader>p "+gP<CR>
" noremap XX "+x<CR>
vnoremap x "_d

" greatest remap ever
vnoremap <leader>p "_dP

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

" nnoremap <silent> <leader>sh :terminal<CR>
nnoremap <silent> <leader>sh :<C-u>split<CR> <cmd>Tnew<CR>

"" Switching windows
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l
" nnoremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
xnoremap < <gv
xnoremap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" These were all used at one point. Might be used again in the future.

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
"
" nnoremap <leader>gH :h <C-R>=expand("<cword>")<CR><CR>
" nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>
" nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
" nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<CR>
" nnoremap <leader>pi <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
" nnoremap <leader>pds :lua require'telescope.builtin'.lsp_document_symbols{}<CR>
" nnoremap <leader>pws :lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>
"
" nnoremap <Leader>ee oif err != nil {<CR>log.Fatalf("%+v\n", err)<CR>}<CR><esc>kkI<esc>
" nnoremap <leader>bs /<C-R>=escape(expand("<cWORD>"), "/")<CR><CR>
