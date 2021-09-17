(module util)

(def keymap-opts {:noremap true
                  :silent true})

(defn set-keymap [mode lhs rhs opts]
  (vim.api.nvim_set_keymap mode lhs rhs (or opts keymap-opts)))

(defn buf-set-keymap [mode lhs rhs opts]
  (vim.api.nvim_buf_set_keymap mode lhs rhs (or opts keymap-opts)))

(defn set-keymaps [coll]
  (each [_ args (ipairs coll)]
    (set-keymap (unpack args))))

(defn buf-set-keymaps [coll]
  (each [_ args (ipairs coll)]
    (buf-set-keymap (unpack args))))
