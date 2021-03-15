" let g:fzf_preview_fzf_color_option = "always"
" let $FZF_PREVIEW_PREVIEW_BAT_THEME = "Sublime Snazzy"
let g:fzf_preview_use_dev_icons = 1
" let g:fzf_preview_directory_files_command = "$FZF_DEFAULT_COMMAND"
let g:fzf_preview_command = 'bat --color=always --plain {-1}'
let g:fzf_layout = {'window': 'call OpenFloatingWin()'}

command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(
			\ <q-args>,
			\ fzf#vim#with_preview(),
			\ <bang>0)

command! -bang -nargs=? -complete=file GFiles
			\ call fzf#vim#gitfiles(
			\ <q-args>,
			\ fzf#vim#with_preview(),
			\ <bang>0)

nnoremap <silent> <leader>fm :<C-u>CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent> <leader>fp :<C-u>CocCommand fzf-preview.ProjectFiles<CR>
nnoremap <silent> <leader>fb :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> <leader>fM :<C-u>CocCommand fzf-preview.OldFiles<CR>

nnoremap          <leader>pf :Files<CR>

" inoremap <expr> <c-x><c-f> <Plug>(fzf-complete-path)
" inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
"             \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
"             \ fzf#wrap({'dir': expand('%:p:h')}))

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
