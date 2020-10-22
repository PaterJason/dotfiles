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

" Tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Navigation
Plug 'justinmk/vim-sneak'
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

" Clojure
Plug 'Olical/conjure', { 'tag': '*' }
Plug 'clojure-vim/vim-jack-in'

" IDE
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
if has('nvim-0.5')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'm00qek/completion-conjure'
  Plug 'nvim-lua/diagnostic-nvim'

  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/telescope.nvim'
else
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'ncm2/float-preview.nvim'
  Plug 'dense-analysis/ale'
  " Fix for deoplete and gitgutter conflict
  Plug 'antoinemadec/FixCursorHold.nvim'
endif

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
  let l:ret = substitute(l:ret, '^<cmd>lua require', '', '')
  let l:ret = substitute(l:ret, '^<cmd>lua vim\.', '', '')
  let l:ret = substitute(l:ret, '^<cmd>', '', '')
  let l:ret = substitute(l:ret, '^\c<c-u>', '', '')
  let l:ret = substitute(l:ret, '^<Plug>', '', '')
  return l:ret
endfunction
let g:WhichKeyFormatFunc = function('WhichKeyFormat')

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

if has('nvim-0.5')
  lua require('lsp_config')
  lua require('telescope_config')
else
  let g:deoplete#enable_at_startup = 1
  let g:float_preview#docked = 0
  call deoplete#custom#option({
        \ 'ignore_sources': {'_': ['around', 'buffer']},
        \ 'min_pattern_length': 1,
        \ })
  call deoplete#custom#source('conjure', 'rank', 600)

  let g:ale_disable_lsp = 1
  let g:ale_virtualtext_cursor = 1
  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(ale_previous)
  nmap <silent> ]g <Plug>(ale_next)
endif
" }}}
" PLUGIN MAPPINGS {{{
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

" vsnip
imap <expr> <C-l> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
smap <expr> <C-l> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
imap <expr> <C-h> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
smap <expr> <C-h> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-h>'

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

" Targets
" Seek next and last text objects
let g:targets_nl = 'nN'
" Only consider targets around cursor
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" Sandwich
" Use vim surround like bindings
runtime macros/sandwich/keymap/surround.vim
" PLUGIN MAPPINGS }}}
