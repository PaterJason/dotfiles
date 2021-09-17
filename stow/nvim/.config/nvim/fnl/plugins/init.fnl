(module plugins
  {autoload {packer packer}})

(packer.startup
  (fn [use]
    (use {1 "Olical/aniseed"
          :config (fn []
                    (set vim.g.aniseed#env true))})
    (use {1 "wbthomason/packer.nvim"
          :config (fn []
                    (let [util (require :util)]
                      (util.set-keymaps [["n" "<leader>pc" "<cmd>PackerCompile<CR>" {}]
                                         ["n" "<leader>ps" "<cmd>PackerSync<CR>" {}]])))})

    (use {1 "arcticicestudio/nord-vim"
          :config (fn []
                    (set vim.g.nord_italic 1)
                    (set vim.g.nord_italic_comments 1)
                    (set vim.g.nord_underline 1)
                    (vim.cmd "colorscheme nord")
                    (vim.cmd "highlight link LspReferenceText Underline")
                    (vim.cmd "highlight link LspReferenceRead Underline")
                    (vim.cmd "highlight link LspReferenceWrite Underline"))})
    (use {1 "itchyny/lightline.vim"
          :config (fn [] (set vim.g.lightline {:colorscheme "nord"}))})

    (use {1 "norcalli/nvim-colorizer.lua"
          :config (fn []
                    (let [colorizer (require :colorizer)]
                      (colorizer.setup {1 "*"
                                        2 "!fugitive"
                                        3 "!packer"
                                        :css {:css true}
                                        :scss {:css true}})))})

    ; Key binds
    (use "tpope/vim-unimpaired")
    (use "christoomey/vim-tmux-navigator")
    (use {1 "folke/which-key.nvim"
          :config (fn []
                    (let [wk (require :which-key)]
                      (wk.setup {})
                      (wk.register {} {:prefix "<localleader>"})))})


    ; Util
    (use "tpope/vim-dispatch")
    (use "tpope/vim-repeat")
    (use "tpope/vim-vinegar")

    ; Edit
    (use {1 "mbbill/undotree"
          :config (fn []
                    (let [util (require :util)]
                      (util.set-keymap "n" "<leader>u" "<cmd>UndotreeToggle<CR>")))})

    (use "tpope/vim-abolish")
    (use "tpope/vim-commentary")
    (use {1 "junegunn/vim-easy-align"
          :config (fn []
                    (let [util (require :util)]
                      (util.set-keymaps [["x" "ga" "<Plug>(EasyAlign)" {}]
                                         ["n" "ga" "<Plug>(EasyAlign)" {}]])))})


    ; Parens
    (use {1 "guns/vim-sexp"
          :requires "tpope/vim-sexp-mappings-for-regular-people"
          :config (fn []
                    (set vim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel"))})
    (use "machakann/vim-sandwich")

    ; Git
    (use "tpope/vim-fugitive")
    (use {1 "lewis6991/gitsigns.nvim"
          :requires "nvim-lua/plenary.nvim"
          :config (fn []
                    (let [gitsigns (require :gitsigns)]
                      (gitsigns.setup {:preview_config {:border "none"}})))})

    ; Completion
    (use {1 "hrsh7th/nvim-cmp"
          :requires ["PaterJason/cmp-conjure"
                     "L3MON4D3/LuaSnip"
                     "saadparwaiz1/cmp_luasnip"
                     "hrsh7th/cmp-nvim-lsp"
                     "hrsh7th/cmp-path"]
          :config (fn [] (require :plugins.cmp))})

    ; Language Server Protocol
    (use {1 "neovim/nvim-lspconfig"
          :config (fn [] (require :plugins.lsp))})

    ; Treesitter
    (use {1 "nvim-treesitter/nvim-treesitter"
          :requires ["nvim-treesitter/nvim-treesitter-textobjects"
                     "nvim-treesitter/nvim-treesitter-refactor"
                     "nvim-treesitter/playground"]
          :branch "0.5-compat"
          :run ":TSUpdate"
          :config (fn [] (require :plugins.treesitter))})

    ; Telescope
    (use {1 "nvim-telescope/telescope.nvim"
          :requires ["nvim-lua/popup.nvim"
                     "nvim-lua/plenary.nvim"
                     "nvim-telescope/telescope-symbols.nvim"]
          :config (fn [] (require :plugins.telescope))})

    (use {1 "Olical/conjure"
          :config (fn []
                    (set vim.g.conjure#mapping#doc_word "K")
                    (set vim.g.conjure#log#hud#border "none")
                    (set vim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed."))})

    (use "clojure-vim/vim-jack-in")))
