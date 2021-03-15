let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
let g:tagbar_autofocus = 1

let g:tagbar_type_julia = {
			\ 'ctagstype': 'julia',
			\ 'kinds': ['t: struct', 'f: func', 'm: macro', 'c: const']}

let g:tagbar_type_go = {
            \ 'ctagstype': 'go',
            \ 'kinds': ['p: package', 'i: imports:1', 'c: const', 'v: var',
                \ 't: type', 'n:interface', 'w: field', 'e: embed',
                \ 'm: method', 't: struct', 'f: func',
                \ ],
            \ 'sro': '.',
            \ 'kind2scope': {
                \ 't': 'ctype',
                \ 'n': 'ntype',
                \ },
            \ 'scope2kind': {
                \ 'ctype': 't',
                \ 'ntype': 'n',
                \ },
            \ 'ctagsbin' : 'gotags',
            \ 'ctagsargs': '-sort -silent'
    \ }
