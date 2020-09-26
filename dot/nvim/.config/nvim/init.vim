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
Plug 'vim-airline/vim-airline'
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
lua require'colorizer'.setup {
      \ '*';
      \ css = { css = true; };
      \ scss = { css = true; };
      \ '!vim-plug';
      \ '!fugitive';
      \ }

" Which Key
function! WhichKeyFormat(mapping) abort
  let l:ret = a:mapping
  let l:ret = substitute(l:ret, '\c<cr>$', '', '')
  let l:ret = substitute(l:ret, '^:', '', '')
  let l:ret = substitute(l:ret, '^<cmd>', '', '')
  let l:ret = substitute(l:ret, '^\c<c-u>', '', '')
  let l:ret = substitute(l:ret, '^<Plug>', '', '')
  return l:ret
endfunction
let g:WhichKeyFormatFunc = function('WhichKeyFormat')

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline_symbols_ascii = 1

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
  lua require('lsp')
  let g:diagnostic_enable_virtual_text = 1
  let g:diagnostic_auto_popup_while_jump = 0

  let g:vsnip_snippet_dir = expand('~/.config/nvim/vsnip')
  let g:completion_chain_complete_list = {
      \ 'default': [
      \   {'complete_items': ['lsp', 'snippet', 'path']},
      \ ],
      \ 'clojure': [
      \   {'complete_items': ['conjure', 'lsp', 'snippet', 'path']},
      \ ],
      \ }
  let g:completion_enable_snippet = 'vim-vsnip'
  autocmd BufEnter * lua require'completion'.on_attach()
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

" Telescope
nmap <silent> <leader>t: <cmd>lua require'telescope.builtin'.commands{}<CR>
nmap <silent> <leader>t? <cmd>lua require'telescope.builtin'.builtin{}<CR>
nmap <silent> <leader>tF <cmd>lua require'telescope.builtin'.find_files{}<CR>
nmap <silent> <leader>tG <cmd>lua require'telescope.builtin'.grep_string{}<CR>
nmap <silent> <leader>tH <cmd>lua require'telescope.builtin'.help_tags{}<CR>
nmap <silent> <leader>tb <cmd>lua require'telescope.builtin'.buffers{}<CR>
nmap <silent> <leader>tc <cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>
nmap <silent> <leader>tf <cmd>lua require'telescope.builtin'.git_files{}<CR>
nmap <silent> <leader>tg <cmd>lua require'telescope.builtin'.live_grep{}<CR>
nmap <silent> <leader>tl <cmd>lua require'telescope.builtin'.loclist{}<CR>
nmap <silent> <leader>tm <cmd>lua require'telescope.builtin'.man_pages{}<CR>
nmap <silent> <leader>tq <cmd>lua require'telescope.builtin'.quickfix{}<CR>
nmap <silent> <leader>tr <cmd>lua require'telescope.builtin'.reloader{}<CR>

nmap <silent> <leader>th: <cmd>lua require'telescope.builtin'.command_history{}<CR>
nmap <silent> <leader>thf <cmd>lua require'telescope.builtin'.oldfiles{}<CR>

" Git
nmap <leader>g<Space> :Git<Space>
nmap <silent> <leader>gb <cmd>Git blame<CR>
nmap <silent> <leader>gd <cmd>Gdiffsplit!<CR>
nmap <silent> <leader>gg <cmd>Git<CR>
nmap <leader>gi :Gina<Space>
nmap <silent> <leader>gG <cmd>Gina status<CR>
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
