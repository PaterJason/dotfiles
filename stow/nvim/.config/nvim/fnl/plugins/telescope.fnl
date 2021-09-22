(module plugins.telescope
  {autoload {util util
             telescope telescope
             actions telescope.actions
             themes telescope.themes}})

(telescope.setup
  {:defaults (vim.tbl_extend
               "keep"
               {:mappings {:n {"<C-x>" false
                               "<C-s>" actions.select_horizontal}
                           :i {"<C-x>" false
                               "<C-s>" actions.select_horizontal}}}
               (themes.get_ivy))
   :pickers {:lsp_code_actions {:theme "cursor"}
             :lsp_range_code_actions {:theme "cursor"}
             :builtin {:previewer false}}})

(telescope.load_extension "fzy_native")

(each [k v (pairs {":" "commands"
                   :b "buffers"
                   :c "current_buffer_fuzzy_find"
                   :f "find_files"
                   :F "file_browser"
                   :g "live_grep"
                   :h "help_tags"
                   :l "loclist"
                   :q "quickfix"
                   :s "spell_suggest"})]
  (util.keymap :n (.. "<leader>f" k) (.. "<cmd>Telescope " v "<CR>")))

(util.keymap "n" "<leader>F" "<cmd>Telescope<CR>")
