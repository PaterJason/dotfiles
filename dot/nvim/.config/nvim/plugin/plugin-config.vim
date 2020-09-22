" Pretty
let g:nord_underline = 1
colorscheme nord
lua require'colorizer'.setup {
      \ '*';
      \ css = { css = true; };
      \ scss = { css = true; };
      \ '!vim-plug';
      \ '!fugitive';
      \ }

" Which Key
function! WhichKeyFormat(mapping) abort
  let l:ret = a:mapping
  let l:ret = substitute(l:ret, '\c<cr>$', '', '')
  let l:ret = substitute(l:ret, '^:', '', '')
  let l:ret = substitute(l:ret, '^<cmd>', '', '')
  let l:ret = substitute(l:ret, '^\c<c-u>', '', '')
  let l:ret = substitute(l:ret, '^<Plug>', '', '')
  return l:ret
endfunction
let g:WhichKeyFormatFunc = function('WhichKeyFormat')

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline_symbols_ascii = 1

" FZF
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment']
      \ }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 , 'border': 'sharp'} }
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }

" Conjure
let g:conjure#mapping#doc_word = 'K'
let g:conjure#log#hud#width = 0.5
let g:conjure#log#hud#height = 0.5

" IDE
let g:gitgutter_sign_priority = 50

let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-l>"
let g:UltiSnipsJumpBackwardTrigger = "<C-h>"

let g:deoplete#enable_at_startup = 1
let g:float_preview#docked = 0
call deoplete#custom#option({
      \ 'ignore_sources': {'_': ['around', 'buffer']},
      \ 'min_pattern_length': 1,
      \ })
call deoplete#custom#source('conjure', 'rank', 600)

if has('nvim-0.5')
  lua require('lsp')
  let g:diagnostic_enable_virtual_text = 1
  let g:diagnostic_auto_popup_while_jump = 0
else
  let g:ale_disable_lsp = 1
  let g:ale_virtualtext_cursor = 1
  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(ale_previous)
  nmap <silent> ]g <Plug>(ale_next)
endif
