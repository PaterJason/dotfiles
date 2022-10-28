require("gitsigns").setup {
  linehl = false,
  numhl = true,
  show_deleted = false,
  signcolumn = false,
  word_diff = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Prev hunk" })

    -- Actions
    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>hb", function()
      gs.blame_line { full = true }
    end, { desc = "Blame line" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
    map("n", "<leader>tg", function()
      gs.toggle_deleted()
      gs.toggle_linehl()
      gs.toggle_word_diff()
    end, { desc = "Gitsigns" })

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
  end,
}
