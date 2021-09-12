let g:clojure_maxlines = 0
let g:clojure_align_subforms = 1

" Only complete with repl connection (empty fallback)
fun! CompleteEmpty(findstart, base)
  if a:findstart
    return -2
  else
    return []
  endif
endfun
let g:conjure#completion#fallback = 'CompleteEmpty'
