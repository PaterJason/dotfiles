(module plugins.cmp
  {autoload {util util
             cmp cmp
             luasnip luasnip}})

(cmp.setup
  {:snippet {:expand (fn [args]
                       (luasnip.lsp_expand args.body))}
   :mapping {"<C-d>" (cmp.mapping.scroll_docs 8)
             "<C-u>" (cmp.mapping.scroll_docs -8)
             "<C-Space>" (cmp.mapping.complete)
             "<C-e>" (cmp.mapping.close)
             "<CR>" (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                          :select true})
             "<Tab>" (cmp.mapping (fn [fallback]
                                    (if (= 1 (vim.fn.pumvisible))
                                      (vim.fn.feedkeys (util.replace_termcodes "<C-n>") "n")
                                      (luasnip.expand_or_jumpable)
                                      (vim.fn.feedkeys (util.replace_termcodes "<Plug>luasnip-expand-or-jump") "")
                                      (fallback)))
                                  ["i" "s"])
             "<S-Tab>" (cmp.mapping (fn [fallback]
                                      (if (= 1 (vim.fn.pumvisible))
                                        (vim.fn.feedkeys (util.replace_termcodes "<C-p>") "n")
                                        (luasnip.expand_or_jumpable)
                                        (vim.fn.feedkeys (util.replace_termcodes "<Plug>luasnip-jump-prev") "")
                                        (fallback)))
                                    ["i" "s"])}
   :sources [{:name "conjure"}
             {:name "luasnip"}
             {:name "nvim_lsp"}
             {:name "path"}]})
