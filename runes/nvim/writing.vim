autocmd Filetype markdown call SetWritingOpts()
autocmd Filetype tex call SetWritingOpts()
function SetWritingOpts()
    set linebreak
    set tw=80
    inoremap `A A
    inoremap `E É
    inoremap `a à
    inoremap `e é
    inoremap `o ó
    inoremap `u ú
    iabbrev ~a ã
    iabbrev tb também
    iabbrev nao não
    iabbrev sao são
    iabbrev ja já
    iabbrev numero número
    noremap <buffer> <silent> k gk
    noremap <buffer> <silent> j gj
    noremap <buffer> <silent> 0 g0
    noremap <buffer> <silent> $ g$
endfunction

autocmd FileType tex call SetTexOpts()
function SetTexOpts()
    map <leader>s :silent !pdflatex --shell-escape %:p > /dev/null &<Return>
    command! Re !pdflatex --shell-escape %:p
    map <leader>r :silent !test -e %:r.pdf && exec zathura %:r.pdf > /dev/null &<Return>

    inoremap ,tt \texttt{}<Space><++><Esc>T{i
    inoremap ,ve \verb!!<Space><++><Esc>T!i
    inoremap ,bf \textbf{}<Space><++><Esc>T{i
    inoremap ,it \textit{}<Space><++><Esc>T{i
    inoremap ,st \section{}<Return><Return><++><Esc>2kt}a
    inoremap ,sst \subsection{}<Return><Return><++><Esc>2kt}a
    inoremap ,ssst \subsubsection{}<Return><Return><++><Esc>2kt}a
    inoremap ,bit \begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>
    inoremap ,bfi \begin{figure}[H]<CR><CR>\end{figure}<Return><++><Esc>kki<Tab>\centering<CR><Tab>\includegraphics{}<CR>\caption{<++>}<Esc>k$i
    inoremap ,beg \begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l
endfunction

function! BlogPostModified()
    let l:save_cursor = getpos(".")
    let l:st = search('+++', 'c')
    if &modified || l:st == 0
        call cursor(1, 1)
        let l:end = search('+++')
        let l:title_line = search('^#[^#]')
        let l:title = getline(l:title_line)
        let l:title = substitute(l:title, "^#[ ]*", "", "")
        let l:now = strftime('%F')
        if l:st != 1
            call append(0, ['+++',
                        \ 'title =',
                        \ 'date = ',
                        \ '#[extra]',
                        \ '#background = ""',
                        \ '+++'])
            let l:st = 1
            let l:end = 6
        endif
        keepjumps exe l:st . ',' . l:end . 's/^title =.*/title = "' . l:title . '"/'
        keepjumps exe l:st . ',' . l:end . 's/^date =.*/date = ' . l:now . '/'
        call histdel('search', -1)
    endif
    call setpos('.', save_cursor)
endfun
autocmd BufWritePre content/[^p][^a][^g][^e][^s]*.md call BlogPostModified()

autocmd FileType coq inoremap ,for ∀
autocmd FileType coq inoremap ,utf8 Require<Space>Import<Space>Coq.Unicode.Utf8_core.
