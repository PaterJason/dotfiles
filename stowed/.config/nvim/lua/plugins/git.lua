return {
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local gitsigns = require "gitsigns"
      gitsigns.setup {
        numhl = true,
        signcolumn = false,
        signs = {
          add = { show_count = false },
          change = { show_count = false },
          delete = { show_count = true },
          topdelete = { show_count = true },
          changedelete = { show_count = true },
        },
        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          vim.keymap.set({ "n", "v" }, "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gitsigns.next_hunk { greedy = false }
            end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
          vim.keymap.set({ "n", "v" }, "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gitsigns.prev_hunk { greedy = false }
            end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })

          -- Actions
          map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
          map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })
          map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diffthis" })
          map("n", "<leader>hb", function()
            gitsigns.blame_line { full = true }
          end, { desc = "Blame line" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
        preview_config = { border = "none" },
      }
    end,
  },
}
