MiniDeps.later(
  function()
    MiniDeps.add({
      source = "tpope/vim-fugitive",
    })
  end
)

MiniDeps.later(function()
  MiniDeps.add({
    source = "lewis6991/gitsigns.nvim",
  })
  local gitsigns = require("gitsigns")
  gitsigns.setup({
    signcolumn = false,
    numhl = true,
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      vim.keymap.set({ "n", "v" }, "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gitsigns.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
      vim.keymap.set({ "n", "v" }, "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gitsigns.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })

      -- Actions
      map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
      map(
        "v",
        "<leader>hs",
        function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        { desc = "Stage hunk" }
      )
      map(
        "v",
        "<leader>hr",
        function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        { desc = "Reset hunk" }
      )
      map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
      map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
      map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
      map(
        "n",
        "<leader>hb",
        function() gitsigns.blame_line({ full = true }) end,
        { desc = "Blame line" }
      )
      map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diffthis" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
    end,
  })
end)
