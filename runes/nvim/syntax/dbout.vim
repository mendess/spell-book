" Vim syntax file
" " Language: db output
" " Maintainer: Jason Munro

syn region Heading start=/^ \l/ end=/[-+]\+$/
syn match Border "|"
syn match IntVal " \d\+\(\n\| \)"
syn match NullVal " NULL\(\n\| \)"
syn match NegVal " -\d\+\(\n\| \)"
syn match FloatVal " \d\+\.\d\+\(\n\| \)"
syn match NegFloatVal " -\d\+\.\d\+\(\\n\| \)"
syn match DateTime "\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}\(\.\d\{1,}\|\)"
syn match TrueVal " t\(\n\| \)"
syn match FalseVal " f\(\n\| \)"

hi def Heading ctermfg=246
hi def IntVal ctermfg=229
hi def FalseVal ctermfg=88
hi def NullVal ctermfg=242
hi def Border ctermfg=240
hi def NegFloatVal ctermfg=160
hi def FloatVal ctermfg=230
hi def NegVal ctermfg=160
hi def DateTime ctermfg=111
hi def TrueVal ctermfg=64
