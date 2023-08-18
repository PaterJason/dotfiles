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

    local miniclue = require "mini.clue"
    miniclue.setup {
      triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "<LocalLeader>" },
        { mode = "x", keys = "<LocalLeader>" },
        -- Built-in completion
        { mode = "i", keys = "<C-x>" },
        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },
        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        -- Window commands
        { mode = "n", keys = "<C-w>" },
        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      },
      clues = {
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
      window = {
        config = {
          width = 60,
          border = "none",
        },
      },
    }

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
