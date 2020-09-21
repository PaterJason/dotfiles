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
