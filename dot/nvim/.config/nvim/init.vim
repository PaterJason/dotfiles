" vim: set foldmethod=marker:
" VIM CONFIG {{{

set hidden
set noswapfile
set spelllang=en

" Leader
let mapleader = " "
let maplocalleader = ","

" Mouse
set mouse=a

" Clipboard
set clipboard=unnamedplus

" Display
set title
set termguicolors
set lazyredraw
set colorcolumn=80
set number relativenumber
set noshowmode
if has('nvim-0.5')
  au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=200}
endif

set tabstop=4
set list
set listchars=tab:»\ ,trail:·,nbsp:·
set fillchars=fold:\ ,diff:\ "

" Edit
set nojoinspaces

" Search and replace
set ignorecase smartcase
set inccommand=split

" Wrap
set breakindent
set breakindentopt=sbr
set linebreak
set showbreak=↩

" Diff
set diffopt=filler,vertical,algorithm:histogram,indent-heuristic

" Splits
set splitright splitbelow
set winwidth=90

" Gutter
set updatetime=100

" Completion
set completeopt=menuone,noinsert,noselect
" }}}
" VIM-PLUG {{{
call plug#begin('~/.local/share/nvim/plugged')
" Util
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'

" Key binds
Plug 'tpope/vim-unimpaired'
Plug 'liuchengxu/vim-which-key'

" Tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Navigation
Plug 'easymotion/vim-easymotion'
Plug 'mhinz/vim-grepper'
Plug 'junegunn/fzf.vim'

" Edit
Plug 'wellle/targets.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'

" Parens
Plug 'machakann/vim-sandwich'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'lambdalisue/gina.vim'

" Clojure
Plug 'Olical/conjure', { 'tag': '*' }
Plug 'clojure-vim/vim-jack-in'

" IDE
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ncm2/float-preview.nvim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
if has('nvim-0.5')
  Plug 'neovim/nvim-lspconfig'
  Plug 'Shougo/deoplete-lsp'
  Plug 'nvim-lua/diagnostic-nvim'
else
  Plug 'dense-analysis/ale'
endif
" Fix for deoplete and gitgutter conflict
Plug 'antoinemadec/FixCursorHold.nvim'

" Pretty
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()
" }}}
" PLUGIN CONFIG {{{
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

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline_symbols_ascii = 1

" Maps
nnoremap <silent> <leader> :<c-u>WhichKey '<leader>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<leader>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey '<localleader>'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '<localleader>'<CR>

nmap <silent> <leader>pc :PlugClean<CR>
nmap <silent> <leader>pd :PlugDiff<CR>
nmap <silent> <leader>pi :PlugInstall<CR>
nmap <silent> <leader>ps :PlugStatus<CR>
nmap <silent> <leader>pu :PlugUpdate<CR>
nmap <silent> <leader>pU :PlugUpgrade<CR>

" Mapping selecting mappings
nmap <leader>fm <plug>(fzf-maps-n)
xmap <leader>fm <plug>(fzf-maps-x)
omap <leader>fm <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" Leader
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

nmap <leader>G :Grepper<CR>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

nmap <silent> <leader>u :MundoToggle<CR>

" Text
" Seek next and last text objects
let g:targets_nl = 'nN'
" Only consider targets around cursor
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'
" Use vim surround like bindings
runtime macros/sandwich/keymap/surround.vim

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
" }}}
