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

set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
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
set signcolumn=auto:2

" Completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=menuone,noinsert,noselect
" }}}
" PLUG BLOCK {{{
call plug#begin('~/.local/share/nvim/plugged')
" Util
Plug 'tpope/vim-dispatch'
if !executable('tmux')
  Plug 'radenling/vim-dispatch-neovim'
endif
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-vinegar'
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'

" Key binds
Plug 'tpope/vim-unimpaired'
Plug 'liuchengxu/vim-which-key'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Navigation
Plug 'justinmk/vim-sneak'
Plug 'mhinz/vim-grepper'

" Edit
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'

" Parens
Plug 'machakann/vim-sandwich'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Clojure
Plug 'Olical/conjure', { 'tag': '*' }
Plug 'clojure-vim/vim-jack-in'

" IDE
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/completion-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Pretty
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'norcalli/nvim-colorizer.lua'
if !has('nvim-0.5')
  Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 200
endif

call plug#end()
" }}}
" PLUGIN CONFIG {{{
" Pretty
let g:nord_underline = 1
colorscheme nord
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }
lua require'colorizer'.setup {
      \ '*';
      \ css = { css = true; };
      \ scss = { css = true; };
      \ '!vim-plug';
      \ '!fugitive';
      \ }

" Sneak
highlight Sneak guifg=#3B4252 guibg=#8FBCBB ctermfg=0 ctermbg=14
highlight SneakScope guifg=#3B4252 guibg=#8FBCBB ctermfg=0 ctermbg=14

" Which Key
function! WhichKeyFormat(mapping) abort
  let l:ret = a:mapping
  let l:ret = substitute(l:ret, '\c<cr>$', '', '')
  let l:ret = substitute(l:ret, '^:', '', '')
  let l:ret = substitute(l:ret, '^<cmd>', '', '')
  let l:ret = substitute(l:ret, '^\c<c-u>', '', '')
  let l:ret = substitute(l:ret, '^lua require', '', '')
  let l:ret = substitute(l:ret, '^lua vim\.', '', '')
  let l:ret = substitute(l:ret, '^<Plug>', '', '')
  return l:ret
endfunction
let g:WhichKeyFormatFunc = function('WhichKeyFormat')

" Conjure
let g:conjure#mapping#doc_word = 'K'
let g:conjure#log#hud#width = 0.5
let g:conjure#log#hud#height = 0.5

" IDE
let g:gitgutter_sign_priority = 50

lua require('_completion')
lua require('_lsp')
lua require('_telescope')
lua require('_treesitter')
" }}}
" PLUGIN MAPPINGS {{{
" Which Key
nnoremap <silent> <leader> <cmd>WhichKey '<leader>'<CR>
vnoremap <silent> <leader> <cmd>WhichKeyVisual '<leader>'<CR>
nnoremap <silent> <localleader> <cmd>WhichKey '<localleader>'<CR>
vnoremap <silent> <localleader> <cmd>WhichKeyVisual '<localleader>'<CR>

" Git
nmap <leader>g<Space> :Git<Space>
nmap <silent> <leader>gb <cmd>Git blame<CR>
nmap <silent> <leader>gd <cmd>Gdiffsplit!<CR>
nmap <silent> <leader>gg <cmd>Git<CR>
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

" Sandwich
" Use vim surround like bindings
runtime macros/sandwich/keymap/surround.vim
" PLUGIN MAPPINGS }}}
