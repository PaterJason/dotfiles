" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

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
Plug 'wellle/targets.vim'

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
Plug 'Olical/conjure'
Plug 'clojure-vim/vim-jack-in'

" IDE
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/completion-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Pretty
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  PlugInstall --sync | runtime plugins.vim
else

" PLUGIN CONFIG {{{
" Nord
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

" Sneak
highlight Sneak guifg=#3B4252 guibg=#8FBCBB ctermfg=0 ctermbg=14
highlight SneakScope guifg=#3B4252 guibg=#8FBCBB ctermfg=0 ctermbg=14

" Target
let g:targets_nl = 'nN'
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

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

let g:gitgutter_sign_priority = 50

lua require('init')

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
endif
