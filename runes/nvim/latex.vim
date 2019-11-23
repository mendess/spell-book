""" LaTeX
autocmd BufEnter *.tex set linebreak
autocmd! BufEnter *.tex set tw=80
autocmd FileType tex map <leader>r :silent !pdflatex --shell-escape %:p > /dev/null &<Return>
autocmd BufEnter *.tex command! Re !pdflatex --shell-escape %:p
" LaTeX snippets
autocmd FileType tex inoremap ,tt \texttt{}<Space><++><Esc>T{i
autocmd FileType tex inoremap ,ve \verb!!<Space><++><Esc>T!i
autocmd FileType tex inoremap ,bf \textbf{}<Space><++><Esc>T{i
autocmd FileType tex inoremap ,it \textit{}<Space><++><Esc>T{i
autocmd FileType tex inoremap ,st \section{}<Return><Return><++><Esc>2kt}a
autocmd FileType tex inoremap ,sst \subsection{}<Return><Return><++><Esc>2kt}a
autocmd FileType tex inoremap ,ssst \subsubsection{}<Return><Return><++><Esc>2kt}a
autocmd FileType tex inoremap ,bit \begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>
autocmd FileType tex inoremap ,bfi \begin{figure}[H]<CR><CR>\end{figure}<Return><++><Esc>kki<Tab>\centering<CR><Tab>\includegraphics{}<CR>\caption{<++>}<Esc>k$i
autocmd FileType tex inoremap ,beg \begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l
autocmd FileType tex inoremap ~a ã
autocmd FileType tex inoremap `a à
autocmd FileType tex inoremap `A A
autocmd FileType tex inoremap `e é
autocmd FileType tex inoremap `E É
autocmd FileType tex inoremap `o ó
autocmd FileType tex inoremap `u ú
autocmd FileType tex noremap  <buffer> <silent> k gk
autocmd FileType tex noremap  <buffer> <silent> j gj
autocmd FileType tex noremap  <buffer> <silent> 0 g0
autocmd FileType tex noremap  <buffer> <silent> $ g$
