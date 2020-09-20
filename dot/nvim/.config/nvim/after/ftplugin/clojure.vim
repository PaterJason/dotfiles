let g:clojure_maxlines = 0
let g:clojure_align_subforms = 1

" Conjure
fun! CompleteEmpty(findstart, base)
  if a:findstart
    return 1
  else
    return []
  endif
endfun
let g:conjure#completion#fallback="CompleteEmpty"
