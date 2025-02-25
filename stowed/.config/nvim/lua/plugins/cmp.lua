MiniDeps.later(function()
  MiniDeps.add({
    source = "Saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    checkout = "v0.9.2", -- check releases for latest tag
  })

  require("blink.cmp").setup({
    keymap = {
      preset = "default",
      ["<Tab>"] = {},
      ["<S-Tab>"] = {},
    },
    completion = {
      accept = {
        auto_brackets = { enabled = false },
      },
      menu = {
        -- border = "single",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = { border = "single" },
      },
    },
    signature = {
      enabled = true,
      window = { border = "single" },
    },
    snippets = {
      expand = function(snippet) MiniSnippets.default_insert({ body = snippet }) end,
      active = function(filter) return MiniSnippets.session.get(false) ~= nil end,
      jump = function(direction)
        if direction > 0 then
          MiniSnippets.session.jump("next")
        elseif direction < 0 then
          MiniSnippets.session.jump("prev")
        end
      end,
    },
    sources = {
      cmdline = {},
      default = { "lsp", "path" },
    },
  })
end)
