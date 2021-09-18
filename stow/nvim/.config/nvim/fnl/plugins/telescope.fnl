(module plugins.telescope
  {autoload {util util
             telescope telescope
             actions telescope.actions}})

(telescope.setup
  {:defaults {:mappings {:n {"<C-x>" false
                             "<C-s>" actions.select_horizontal}
                         :i {"<C-x>" false
                             "<C-s>" actions.select_horizontal}}}})

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
