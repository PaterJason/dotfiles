return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.ai").setup {
      n_lines = 100,
      search_method = "cover",
    }
    require("mini.align").setup {}
    require("mini.bracketed").setup {
      comment = { suffix = "/", options = {} },
    }
    require("mini.bufremove").setup {}
    vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Eval" })
    vim.keymap.set("n", "<leader>bw", MiniBufremove.wipeout, { desc = "Eval" })
    require("mini.comment").setup {}
    require("mini.indentscope").setup {
      draw = {
        animation = require("mini.indentscope").gen_animation.none(),
      },
    }
    require("mini.comment").setup {}
    require("mini.pairs").setup {}
    require("mini.statusline").setup {}
    require("mini.surround").setup {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
        suffix_last = "",
        suffix_next = "",
      },
      n_lines = 100,
      search_method = "cover",
    }
    -- Remap adding surrounding to Visual mode selection
    vim.keymap.del("x", "ys")
    vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
    -- Make special mapping for "add surrounding for line"
    vim.keymap.set("n", "yss", "ys_", { remap = true })
  end,
}
