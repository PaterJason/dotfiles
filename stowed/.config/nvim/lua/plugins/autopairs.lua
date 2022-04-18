local npairs = require 'nvim-autopairs'

npairs.setup {
  check_ts = true,
  enable_check_bracket_line = false,
}
require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

local lisp_filetypes = {
  'clojure',
  'scheme',
  'lisp',
  'racket',
  'hy',
  'fennel',
  'janet',
  'carp',
  'wast',
  'yuck',
}

vim.list_extend(npairs.get_rule("'")[1].not_filetypes, lisp_filetypes)
npairs.get_rule('(').not_filetypes = lisp_filetypes
npairs.get_rule('{').not_filetypes = lisp_filetypes
npairs.get_rule('[').not_filetypes = lisp_filetypes
