""" Markdown
autocmd! BufEnter *.md set linebreak
autocmd! FileType markdown inoremap ~a ã
autocmd! FileType markdown inoremap `a à
autocmd! FileType markdown inoremap `A A
autocmd! FileType markdown inoremap `e é
autocmd! FileType markdown inoremap `E É
autocmd! FileType markdown inoremap `o ó
autocmd! FileType markdown inoremap `u ú
autocmd! FileType markdown noremap  <buffer> <silent> k gk
autocmd! FileType markdown noremap  <buffer> <silent> j gj
autocmd! FileType markdown noremap  <buffer> <silent> 0 g0
autocmd! FileType markdown noremap  <buffer> <silent> $ g$
autocmd! BufEnter *.md set tw=80
