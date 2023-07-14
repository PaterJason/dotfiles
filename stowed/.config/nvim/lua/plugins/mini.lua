return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.ai").setup {
      n_lines = 100,
      search_method = "cover",
      custom_textobjects = {
        f = false,
      },
    }

    require("mini.align").setup {}

    require("mini.bracketed").setup {
      comment = { suffix = "/", options = {} },
    }

    require("mini.bufremove").setup {}
    vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete Buffer" })

    require("mini.comment").setup {}

    local hipatterns = require "mini.hipatterns"
    hipatterns.setup {
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    }

    require("mini.doc").setup {}

    require("mini.files").setup {}
    vim.keymap.set("n", "<leader>f", function()
      MiniFiles.open(nil, false)
    end, { desc = "Files" })
    vim.keymap.set("n", "<leader>F", function()
      MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    end, { desc = "Files" })

    require("mini.indentscope").setup {
      draw = {
        animation = require("mini.indentscope").gen_animation.none(),
      },
    }

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
