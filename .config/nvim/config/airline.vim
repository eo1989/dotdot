" onedark "base16_snazzy" "dracula" "kalisi"

let g:airline_theme = 'base16_snazzy'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = '☰'
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.dirty='⚡'
else
  let g:airline_symbols.crypt = '🔒'
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
endif


let g:airline#extensions#branch#format = 0
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#vimagit#enabled = 1
let g:airline#extensions#grepper#enabled = 0
let g:airline#extensions#fzf#enabled = 1
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#hunks#non_zero_only = 0
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#neomake#enabled = 0
" let g:airline#extensions#nvimlsp#error_symbol = 'E:'
" let g:airline#extensions#nvimlsp#warning_symbol = 'W:'
let g:airline_section_z = " " " disable the line info
let g:airline#extensions#vista#enabled = 0
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#keymap#enabled = 1 "1
let g:airline#extensions#quickfix#quickfix_text = 'QuickFix'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#hunks#coc_git = 0 "1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#current_first = 0 "1
let g:airline#extensions#tabline#show_tabs = 0 "1
let g:airline#extensions#tabline#show_tab_count = 0 "2
let g:airline#extensions#tabline#show_tab_type = 0 "1
let g:airline#extensions#tabline#buffer_nr_show = 0 "1
let g:airline#extensions#tabline#show_close_button = 0 "1
" let g:airline#extensions#tabline#close_symbol = 'X'
let g:airline_whitespace_disabled = 1
let g:airline_section_y = 'W %{winnr()}'
" let airline#extensions#tabline#ignore_bufadd_pat =
"     \ '!\fzf\startify\CHADTree\undotree|tagbar|'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#parts#ffenc#skip_expected_string = 'utf-8'
let g:airline#extensions#wordcount#filetypes =
    \ ['asciidoc', 'help', 'mail', 'markdown', 'nroff', 'org', 'plaintex', 'rst', 'tex', 'text']
" silent! call airline#extensions#whitespace#disable()
