if exists('b:current_syntax')
  finish
end

" The default highlighting.
hi def link qfFileName		Directory
hi def link qfLineNr		LineNr
hi def link qfSeparator1	Delimiter
hi def link qfSeparator2	Delimiter
hi def link qfText		Normal

let b:current_syntax = 'qf'

" vim: ts=8
