set shell=/bin/bash

set hidden
set noswapfile
set spelllang=en_gb

" Leader
let g:mapleader = ' '
let g:maplocalleader = ','

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
au TextYankPost * silent! lua vim.highlight.on_yank

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
set diffopt+=vertical

" Splits
set splitright splitbelow
set winwidth=90

" Gutter
set updatetime=100
set signcolumn=auto:2

" Completion
set completeopt=menuone,noselect
set shortmess+=c

" Bootstrap fennel config
function s:bootstrap(user, repo)
  let s:install_path = stdpath('data') . '/site/pack/packer/start/' . a:repo
  if empty(glob(s:install_path)) > 0
    execute('!git clone https://github.com/' . a:user . '/' . a:repo . ' ' . s:install_path)
  endif
endfunction
call s:bootstrap('wbthomason', 'packer.nvim')
call s:bootstrap('Olical', 'aniseed')
let g:aniseed#env = v:true
