let g:coc_global_extensions = [
			\ 'coc-json',
			\ 'coc-tabnine',
			\ 'coc-git',
			\ 'coc-fzf-preview',
			\ 'coc-python',
			\ 'coc-lua',
			\ 'coc-sh',
			\ 'coc-julia',
			\ 'coc-marketplace',
			\ 'coc-vimlsp',
			\ 'coc-lists',
			\ 'coc-actions',
			\ 'coc-ultisnips',
			\ 'coc-snippets'
            \]

inoremap <silent><expr> <TAB>
			\ pumvisible() ? coc#_select_confirm() :
			\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump', ''])\<CR>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline(',')[col - 1] =~# '\s'
endfunction

inoremap <expr><S-TAB> pumvisible() ? "\C-p>" : "\<C-h>"

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

inoremap <silent><expr> <c-space> coc#refresh()

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
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


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

    " Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
    " lets try this
    " noremap <silent> K :call CocActionAsnyc('doHover')<CR>

au CursorHold,CursorHoldI,CursorMoved,CursorMovedI * silent :call CocActionAsync('highlight')
" Symbol renaming.
" nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lf  <Plug>(coc-format-selected)

" Highlight the symbol and its references when holding the cursor.

aug mygroup
    au!
" Setup formatexpr specified filetype(s).
	au FileType typescript, json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
aug END

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

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
" coc-python, coc-julia, hls
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

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
"
nnoremap <silent> <leader>lis  :<C-u>CocList -I symbols<cr>

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

" delay loading of CocConfig (again?) which fixes a bug w/ coc-completion
" doesnt work at first strt?
autocmd! VimEnter * call timer_start(200, {tid -> execute('source ~/.config/nvim/config/coc.vim')})
