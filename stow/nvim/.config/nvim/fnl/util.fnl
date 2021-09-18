(module util)

(def keymap-opts {:noremap true
                  :silent true})

(defn keymap [mode lhs rhs opts]
  (vim.api.nvim_set_keymap mode lhs rhs (or opts keymap-opts)))

(defn buf-keymap [bufnr mode lhs rhs opts]
  (vim.api.nvim_buf_set_keymap bufnr mode lhs rhs (or opts keymap-opts)))

(defn keymaps [coll]
  (each [_ args (ipairs coll)]
    (keymap (unpack args))))

(defn buf-keymaps [bufnr coll]
  (each [_ args (ipairs coll)]
    (buf-keymap bufnr (unpack args))))
