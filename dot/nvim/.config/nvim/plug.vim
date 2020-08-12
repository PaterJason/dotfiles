call plug#begin('~/.local/share/nvim/plugged')

" Util
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/vim-slash'
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'
nmap <leader>u :MundoToggle<CR>

" Key binds
Plug 'tpope/vim-unimpaired'
Plug 'liuchengxu/vim-which-key'
nnoremap <silent> <leader> :<c-u>WhichKey '<leader>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<leader>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey '<localleader>'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '<localleader>'<CR>
Plug 'junegunn/vim-peekaboo'

" Tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Navigation
Plug 'easymotion/vim-easymotion'
Plug 'mhinz/vim-grepper'
nmap <leader>G :Grepper<CR>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
Plug 'junegunn/fzf.vim'
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
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
  \ 'header':  ['fg', 'Comment'] }
" Start fzf in a popup window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" FZF maps
nmap <leader>fb :Buffers<CR>
nmap <leader>fc :Commands<CR>
nmap <leader>ff :Files<CR>
nmap <leader>fF :Filetypes<CR>
nmap <leader>fgC :BCommits<CR>
nmap <leader>fgc :Commits<CR>
nmap <leader>fgf :GFiles<CR>
nmap <leader>fgs :GFiles?<CR>
nmap <leader>fh :Helptags<CR>
nmap <leader>fl :BLines<CR>
nmap <leader>fL :Lines<CR>
nmap <leader>fm :Maps<CR>
nmap <leader>fr :Rg<CR>
nmap <leader>fs :Snippets<CR>
nmap <leader>ft :BTags<CR>
nmap <leader>fT :Tags<CR>
nmap <leader>fw :Windows<CR>

" Edit
Plug 'wellle/targets.vim'
" Seek next and last text objects
let g:targets_nl = 'nN'
" Only consider targets around cursor
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)

" Parens
Plug 'machakann/vim-sandwich'
let g:textobj_sandwich_no_default_key_mappings = 1
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" Git
Plug 'tpope/vim-fugitive'
nmap <leader>gb :Gblame<CR>
nmap <leader>gd :Gdiffsplit!<CR>
nmap <leader>gg :Git<Space>
nmap <leader>gs :Gstatus<CR>
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'
nmap <leader>gv :GV<CR>
nmap <leader>gV :GV!<CR>

" Clojure
Plug 'Olical/conjure', {'tag': '*'}
Plug 'clojure-vim/vim-jack-in'

" Deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
Plug 'ncm2/float-preview.nvim'
set completeopt-=preview
let g:float_preview#docked = 0
Plug 'Shougo/neco-syntax'

" Lint
Plug 'dense-analysis/ale'
let g:ale_disable_lsp=1
let g:ale_virtualtext_cursor=1
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(ale_previous)
nmap <silent> ]g <Plug>(ale_next)

" Pretty
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

" Plug maps
nmap <leader>pc :PlugClean<CR>
nmap <leader>pd :PlugDiff<CR>
nmap <leader>pi :PlugInstall<CR>
nmap <leader>ps :PlugStatus<CR>
nmap <leader>pu :PlugUpdate<CR>
nmap <leader>pU :PlugUpgrade<CR>

let g:nord_underline=1
colorscheme nord
let g:lightline = { 'colorscheme': 'nord' }
lua require'colorizer'.setup()
