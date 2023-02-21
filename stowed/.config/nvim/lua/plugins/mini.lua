return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.ai").setup {}
    require("mini.align").setup {}
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
    require("mini.statusline").setup {
      use_icons = false,
    }
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
    }
    -- Remap adding surrounding to Visual mode selection
    vim.api.nvim_del_keymap("x", "ys")
    vim.api.nvim_set_keymap("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { noremap = true })
    -- Make special mapping for "add surrounding for line"
    vim.api.nvim_set_keymap("n", "yss", "ys_", { noremap = false })
  end,
}
