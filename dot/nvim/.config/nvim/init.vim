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

set fillchars=fold:\ ,diff:\ 
set tabstop=4
set list
set listchars=tab:»\ ,trail:·,nbsp:⎵

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

" Clojure
let g:clojure_maxlines = 0
let g:clojure_align_subforms = 1

" Gutter
set updatetime=100

" Completion
set completeopt=menuone,noinsert,noselect
" }}}
" VIM-PLUG {{{
silent if plug#begin('~/.local/share/nvim/plugged')
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
Plug 'tpope/vim-surround'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Clojure
Plug 'Olical/conjure', {'tag': '*'}
Plug 'clojure-vim/vim-jack-in'

" IDE
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ncm2/float-preview.nvim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
if has('nvim-0.5')
  Plug 'neovim/nvim-lsp'
  Plug 'Shougo/deoplete-lsp'
  Plug 'nvim-lua/diagnostic-nvim'
else
  Plug 'dense-analysis/ale'
endif

" Pretty
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()
endif
" }}}
" PLUGIN CONFIG {{{
silent if !empty(glob('~/.local/share/nvim/plugged/*'))
" Pretty
let g:nord_underline = 1
colorscheme nord
let g:lightline = { 'colorscheme': 'nord' }
lua require'colorizer'.setup()

" Maps
nnoremap <silent> <leader> :<c-u>WhichKey '<leader>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<leader>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey '<localleader>'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '<localleader>'<CR>

nmap <leader>pc :PlugClean<CR>
nmap <leader>pd :PlugDiff<CR>
nmap <leader>pi :PlugInstall<CR>
nmap <leader>ps :PlugStatus<CR>
nmap <leader>pu :PlugUpdate<CR>
nmap <leader>pU :PlugUpgrade<CR>

" Mapping selecting mappings
nmap <leader>m <plug>(fzf-maps-n)
xmap <leader>m <plug>(fzf-maps-x)
omap <leader>m <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" Leader
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
nmap <leader>fr :Rg<CR>
nmap <leader>fs :Snippets<CR>
nmap <leader>ft :BTags<CR>
nmap <leader>fT :Tags<CR>
nmap <leader>fw :Windows<CR>

nmap <leader>gg :Git<Space>
nmap <leader>gb :Git blame<CR>
nmap <leader>gd :Gdiffsplit!<CR>
nmap <leader>gs :Git<CR>

nmap <leader>G :Grepper<CR>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

nmap <leader>u :MundoToggle<CR>

" Targets
" Seek next and last text objects
let g:targets_nl = 'nN'
" Only consider targets around cursor
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

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
let g:deoplete#enable_at_startup = 1
let g:float_preview#docked = 0
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-l>"
let g:UltiSnipsJumpBackwardTrigger = "<C-h>"
call deoplete#custom#option({
      \ 'ignore_sources': {'_': ['buffer']},
      \ 'min_pattern_length': 1
      \ })
call deoplete#custom#source('conjure', 'rank', 501)
if has('nvim-0.5')
  nnoremap <silent> gd    :lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> <c-]> :lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K     :lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gD    :lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> gK    :lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent> 1gD   :lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> gr    :lua vim.lsp.buf.references()<CR>
  nnoremap <silent> g0    :lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> gW    :lua vim.lsp.buf.workspace_symbol()<CR>

  nmap <silent> [g :PrevDiagnostic<CR>
  nmap <silent> ]g :NextDiagnostic<CR>

  lua require('lsp')
  autocmd BufEnter * lua require'diagnostic'.on_attach()
else
  let g:ale_disable_lsp = 1
  let g:ale_virtualtext_cursor = 1
  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(ale_previous)
  nmap <silent> ]g <Plug>(ale_next)
endif
endif
" }}}
