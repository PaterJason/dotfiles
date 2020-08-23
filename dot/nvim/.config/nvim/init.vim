" Terminal
" set shell=/usr/bin/fish

" Leader
let mapleader=" "
let maplocalleader=","

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

set fillchars=fold:\ ,diff:\ 
set tabstop=4
set list
set listchars=tab:»\ ,trail:·,nbsp:⎵
"extends:↷,precedes:↶

set spelllang=en

" Edit
set nojoinspaces

" Search and replace
set ignorecase smartcase
set inccommand=split

" Wrap
set breakindent
set linebreak
set showbreak=↩

" Diff
set diffopt+=vertical
set diffopt+=algorithm:histogram
set diffopt+=indent-heuristic

" Splits
set splitright splitbelow
set winwidth=100

" Clojure
let g:clojure_maxlines=0
let g:clojure_align_subforms=1

" Gutter
set signcolumn=auto:2
set updatetime=100

" Plugins
if !empty(globpath(&rtp, 'autoload/plug.vim'))
  source $HOME/.config/nvim/plug.vim
endif
