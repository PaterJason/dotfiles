" Which Key
nnoremap <silent> <leader> <cmd>WhichKey '<leader>'<CR>
vnoremap <silent> <leader> <cmd>WhichKeyVisual '<leader>'<CR>
nnoremap <silent> <localleader> <cmd>WhichKey '<localleader>'<CR>
vnoremap <silent> <localleader> <cmd>WhichKeyVisual '<localleader>'<CR>

"Plug
nmap <silent> <leader>pc <cmd>PlugClean<CR>
nmap <silent> <leader>pd <cmd>PlugDiff<CR>
nmap <silent> <leader>pi <cmd>PlugInstall<CR>
nmap <silent> <leader>ps <cmd>PlugStatus<CR>
nmap <silent> <leader>pu <cmd>PlugUpdate<CR>
nmap <silent> <leader>pU <cmd>PlugUpgrade<CR>

" FZF
nmap <leader>fm <cmd>Maps<CR>
xmap <leader>fm <plug>(fzf-maps-x)
omap <leader>fm <plug>(fzf-maps-o)

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <silent> <leader>f: <cmd>Commands<CR>
nmap <silent> <leader>fb <cmd>Buffers<CR>
nmap <silent> <leader>ff <cmd>Files<CR>
nmap <silent> <leader>fF <cmd>Filetypes<CR>
nmap <silent> <leader>fgC <cmd>BCommits<CR>
nmap <silent> <leader>fgc <cmd>Commits<CR>
nmap <silent> <leader>fgf <cmd>GFiles<CR>
nmap <silent> <leader>fgs <cmd>GFiles?<CR>
nmap <silent> <leader>fh/ <cmd>History/<CR>
nmap <silent> <leader>fh: <cmd>History:<CR>
nmap <silent> <leader>fhf <cmd>History<CR>
nmap <silent> <leader>fH <cmd>Helptags<CR>
nmap <silent> <leader>fl <cmd>BLines<CR>
nmap <silent> <leader>fL <cmd>Lines<CR>
nmap <silent> <leader>fr <cmd>Rg<CR>
nmap <silent> <leader>fs <cmd>Snippets<CR>
nmap <silent> <leader>ft <cmd>BTags<CR>
nmap <silent> <leader>fT <cmd>Tags<CR>
nmap <silent> <leader>fw <cmd>Windows<CR>

" Git
nmap <leader>g<Space> :Git<Space>
nmap <silent> <leader>gb <cmd>Git blame<CR>
nmap <silent> <leader>gd <cmd>Gdiffsplit!<CR>
nmap <silent> <leader>gg <cmd>Git<CR>
nmap <leader>gi :Gina<Space>
nmap <silent> <leader>gG <cmd>Gina status<CR>
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
vmap <leader>gs <Plug>(GitGutterStageHunk)

" Grepper
nmap <leader>G <cmd>Grepper<CR>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" Undo
nmap <silent> <leader>u <cmd>MundoToggle<CR>

" Targets
" Seek next and last text objects
let g:targets_nl = 'nN'
" Only consider targets around cursor
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" Sandwich
" Use vim surround like bindings
runtime macros/sandwich/keymap/surround.vim
