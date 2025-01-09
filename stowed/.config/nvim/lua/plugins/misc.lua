MiniDeps.now(function()
  MiniDeps.add({
    source = "catppuccin/nvim",
    name = "catppuccin",
  })

  require("catppuccin").setup({
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.none },
        CursorLine = { bg = colors.mantle },
      }
    end,
    -- default_integrations = false,
    integrations = {
      blink_cmp = true,
      dap = true,
      markdown = true,
      mason = true,
      mini = {
        enabled = true,
        indentscope_color = "overlay0",
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      semantic_tokens = true,
      treesitter = true,
      treesitter_context = true,
    },
  })
  vim.cmd("colorscheme catppuccin")
end)
