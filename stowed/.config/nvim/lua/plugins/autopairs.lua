local npairs = require "nvim-autopairs"

npairs.setup {
  check_ts = true,
  enable_check_bracket_line = false,
}
require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
