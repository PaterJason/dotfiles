(module init)

(def opts
  {:shell "/bin/bash"

   :hidden true
   :swapfile false
   :spelllang "en_gb"
   :mouse "a"
   :clipboard "unnamedplus"

   :title true
   :termguicolors true
   :lazyredraw true
   :colorcolumn "80"

   :number true
   :relativenumber true

   :showmode false

   :tabstop 2
   :softtabstop 2
   :shiftwidth 2
   :expandtab true

   :ignorecase true
   :smartcase true

   :breakindent true
   :breakindentopt "sbr"
   :linebreak true
   :showbreak "↩"

   :splitright true
   :splitbelow true
   :winwidth 90

   :updatetime 100
   :signcolumn "auto:2"

   :completeopt "menu,menuone,noselect"})

(each [k v (pairs opts)]
  (tset vim.o k v))

(vim.cmd "au TextYankPost * silent! lua vim.highlight.on_yank()")

(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")

(require :plugins)
