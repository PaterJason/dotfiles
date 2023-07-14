return {
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      linehl = false,
      numhl = true,
      show_deleted = false,
      signcolumn = false,
      word_diff = false,
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        if not vim.wo.diff then
          map("n", "]c", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
          map("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Prev hunk" })
        end

        -- Actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
        map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
        map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
        map("n", "<leader>hb", function()
          gs.blame_line { full = true }
        end, { desc = "Blame line" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
      end,
    },
  },
}
