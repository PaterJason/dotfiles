(module plugins
  {autoload {packer packer}})

(def- packages
  {"Olical/aniseed"
   {:config (fn [] (set vim.g.aniseed#env true))}
   "wbthomason/packer.nvim" {}

   "arcticicestudio/nord-vim"
   {:config (fn []
              (set vim.g.nord_italic 1)
              (set vim.g.nord_italic_comments 1)
              (set vim.g.nord_underline 1)
              (vim.cmd "colorscheme nord")
              (vim.cmd "highlight link LspReferenceText Underline")
              (vim.cmd "highlight link LspReferenceRead Underline")
              (vim.cmd "highlight link LspReferenceWrite Underline"))}
   "itchyny/lightline.vim"
   {:config (fn [] (set vim.g.lightline {:colorscheme "nord"}))}
   "norcalli/nvim-colorizer.lua"
   {:config (fn []
              (let [colorizer (require :colorizer)]
                (colorizer.setup {1 "*"
                                  2 "!fugitive"
                                  3 "!packer"
                                  :css {:css true}
                                  :scss {:css true}})))}

   ; Key binds
   "tpope/vim-unimpaired" {}
   "christoomey/vim-tmux-navigator" {}
   "folke/which-key.nvim"
   {:config (fn []
              (let [wk (require :which-key)]
                (wk.setup {})
                (wk.register {} {:prefix "<localleader>"})))}

   ; Util
   "tpope/vim-dispatch" {}
   "tpope/vim-repeat" {}
   "tpope/vim-vinegar" {}

   ; Edit
   "mbbill/undotree"
   {:config (fn []
              (let [util (require :util)]
                (util.keymap "n" "<leader>u" "<cmd>UndotreeToggle<CR>")))}
   "tpope/vim-abolish" {}
   "tpope/vim-commentary" {}
   "junegunn/vim-easy-align"
   {:config (fn []
              (let [util (require :util)]
                (util.keymaps [["x" "ga" "<Plug>(EasyAlign)" {}]
                               ["n" "ga" "<Plug>(EasyAlign)" {}]])))}

   ; Parens
   "guns/vim-sexp"
   {:requires "tpope/vim-sexp-mappings-for-regular-people"
    :config (fn []
              (set vim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel"))}
   "machakann/vim-sandwich" {}

   ; Git
   "tpope/vim-fugitive" {}
   "lewis6991/gitsigns.nvim"
   {:requires "nvim-lua/plenary.nvim"
    :config (fn []
              (let [gitsigns (require :gitsigns)]
                (gitsigns.setup {:preview_config {:border "none"}})))}

   ; Completion
   "hrsh7th/nvim-cmp"
   {:requires ["PaterJason/cmp-conjure"
               "L3MON4D3/LuaSnip"
               "saadparwaiz1/cmp_luasnip"
               "hrsh7th/cmp-nvim-lsp"
               "hrsh7th/cmp-path"]
    :config (fn [] (require :plugins.cmp))}

   ; Language Server Protocol
   "neovim/nvim-lspconfig" {:config (fn [] (require :plugins.lsp))}

   ; Treesitter
   "nvim-treesitter/nvim-treesitter"
   {:requires ["nvim-treesitter/nvim-treesitter-textobjects"
               "nvim-treesitter/nvim-treesitter-refactor"
               "nvim-treesitter/playground"]
    :branch "0.5-compat"
    :run ":TSUpdate"
    :config (fn [] (require :plugins.treesitter))}

   ; Telescope
   "nvim-telescope/telescope.nvim"
   {:requires ["nvim-lua/popup.nvim"
               "nvim-lua/plenary.nvim"
               "nvim-telescope/telescope-fzy-native.nvim" 
               "nvim-telescope/telescope-symbols.nvim"]
    :config (fn [] (require :plugins.telescope))}

   "Olical/conjure"
   {:config (fn []
              (set vim.g.conjure#mapping#doc_word "K")
              (set vim.g.conjure#log#hud#border "none")
              (set vim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed."))}

   "clojure-vim/vim-jack-in" {}})

(packer.startup
  (fn [use]
    (each [name cfg (pairs packages)]
      (tset cfg 1 name)
      (use cfg))))

(when (-> (vim.fn.stdpath "config")
          (.. "/plugin/packer_compiled.lua")
          vim.fn.glob
          vim.fn.empty
          (> 0))
  (vim.cmd "PackerSync"))
