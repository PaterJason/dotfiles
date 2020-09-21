" Which Key
nnoremap <silent> <leader> :<c-u>WhichKey '<leader>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<leader>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey '<localleader>'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '<localleader>'<CR>

"Plug
nmap <silent> <leader>pc :PlugClean<CR>
nmap <silent> <leader>pd :PlugDiff<CR>
nmap <silent> <leader>pi :PlugInstall<CR>
nmap <silent> <leader>ps :PlugStatus<CR>
nmap <silent> <leader>pu :PlugUpdate<CR>
nmap <silent> <leader>pU :PlugUpgrade<CR>

" FZF
nmap <leader>fm <plug>(fzf-maps-n)
xmap <leader>fm <plug>(fzf-maps-x)
omap <leader>fm <plug>(fzf-maps-o)

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <silent> <leader>f: :Commands<CR>
nmap <silent> <leader>fb :Buffers<CR>
nmap <silent> <leader>ff :Files<CR>
nmap <silent> <leader>fF :Filetypes<CR>
nmap <silent> <leader>fgC :BCommits<CR>
nmap <silent> <leader>fgc :Commits<CR>
nmap <silent> <leader>fgf :GFiles<CR>
nmap <silent> <leader>fgs :GFiles?<CR>
nmap <silent> <leader>fh/ :History/<CR>
nmap <silent> <leader>fh: :History:<CR>
nmap <silent> <leader>fhf :History<CR>
nmap <silent> <leader>fH :Helptags<CR>
nmap <silent> <leader>fl :BLines<CR>
nmap <silent> <leader>fL :Lines<CR>
nmap <silent> <leader>fr :Rg<CR>
nmap <silent> <leader>fs :Snippets<CR>
nmap <silent> <leader>ft :BTags<CR>
nmap <silent> <leader>fT :Tags<CR>
nmap <silent> <leader>fw :Windows<CR>

" Git
nmap <leader>g<Space> :Git<Space>
nmap <silent> <leader>gb :Git blame<CR>
nmap <silent> <leader>gd :Gdiffsplit!<CR>
nmap <silent> <leader>gg :Git<CR>
nmap <leader>gi :Gina<Space>
nmap <silent> <leader>gG :Gina status<CR>
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
vmap <leader>gs <Plug>(GitGutterStageHunk)

" Grepper
nmap <leader>G :Grepper<CR>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" Undo
nmap <silent> <leader>u :MundoToggle<CR>

" Targets
" Seek next and last text objects
let g:targets_nl = 'nN'
" Only consider targets around cursor
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" Sandwich
" Use vim surround like bindings
runtime macros/sandwich/keymap/surround.vim
