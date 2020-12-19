set hidden
set noswapfile
set spelllang=en

" Leader
let mapleader = ' '
let maplocalleader = ','

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
au TextYankPost * silent! lua vim.highlight.on_yank {higroup='IncSearch', timeout=200}

set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
set list
set listchars=tab:»\ ,trail:·,nbsp:·
set fillchars=fold:\ ,diff:\ 

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
set signcolumn=auto:2

" Completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=menuone,noinsert,noselect

runtime plugins.vim
