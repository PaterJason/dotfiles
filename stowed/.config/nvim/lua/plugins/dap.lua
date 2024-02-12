MiniDeps.now(function()
  MiniDeps.add({
    source = "mfussenegger/nvim-dap",
    depends = { "theHamsta/nvim-dap-virtual-text" },
  })

  local dap = require("dap")
  require("nvim-dap-virtual-text").setup({
    highlight_new_as_changed = true,
  })

  local widgets = require("dap.ui.widgets")
  dap.defaults.fallback.terminal_win_cmd = "tabnew"

  vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue" })
  vim.keymap.set("n", "<Leader>dr", dap.repl.toggle, { desc = "Toggle repl" })
  vim.keymap.set({ "n", "v" }, "<Leader>dh", widgets.hover, { desc = "Hover" })
  vim.keymap.set(
    "n",
    "<Leader>df",
    function() widgets.centered_float(widgets.frames) end,
    { desc = "Frames" }
  )
  vim.keymap.set(
    "n",
    "<Leader>ds",
    function() widgets.centered_float(widgets.scopes) end,
    { desc = "Scopes" }
  )

  -- JavaScript & TypeScript
  dap.adapters.firefox = {
    type = "executable",
    command = "firefox-debug-adapter",
  }
  dap.configurations.javascript = {
    {
      name = "Debug with Firefox",
      type = "firefox",
      request = "launch",
      reAttach = true,
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
    },
  }
  dap.configurations.typescript = dap.configurations.javascript

  -- C, C++ & Rust
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}" },
    },
  }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input({
          prompt = "Path to executable: ",
          default = vim.uv.cwd() .. "/",
          completion = "file",
        })
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp

  -- Golang
  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "localhost:${port}" },
    },
  }
  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    -- works with go.mod packages and sub packages
    {
      type = "delve",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
  }
end)
