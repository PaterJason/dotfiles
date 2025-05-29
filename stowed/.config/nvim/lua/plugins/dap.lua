MiniDeps.later(function()
  MiniDeps.add({
    source = "mfussenegger/nvim-dap",
    depends = { "igorlfs/nvim-dap-view" },
  })

  local dap = require("dap")
  local dap_view = require("dap-view")
  dap_view.setup({
    winbar = {
      show = true,
      -- You can add a "console" section to merge the terminal with the other views
      sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
    },
  })

  dap.listeners.before.attach["user"] = function() dap_view.open() end
  dap.listeners.before.launch["user"] = function() dap_view.open() end

  vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Continue" })
  vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Step over" })
  vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Step into" })
  vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Step out" })
  vim.keymap.set(
    "n",
    "<Leader>db",
    function() dap.toggle_breakpoint() end,
    { desc = "Toggle breakpoint" }
  )
  vim.keymap.set(
    "n",
    "<Leader>dl",
    function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
    { desc = "Set log point" }
  )
  vim.keymap.set("n", "<Leader>dv", "<Cmd>DapViewToggle<CR>", { desc = "Toggle View" })
  vim.keymap.set({ "n", "v" }, "<Leader>dw", ":DapViewWatch<CR>", { desc = "Watch" })

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

  -- Rust
  dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-dap",
    name = "lldb",
  }
  dap.configurations.rust = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input({
          prompt = "Path to executable: ",
          default = vim.uv.cwd() .. "/target/debug/",
          completion = "file",
        })
      end,
      cwd = "${workspaceFolder}",
      runInTerminal = true,
      stopOnEntry = false,
      args = {},
      initCommands = function()
        local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
        assert(
          vim.v.shell_error == 0,
          "failed to get rust sysroot using `rustc --print sysroot`: " .. rustc_sysroot
        )
        local script_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
        local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

        return {
          ([[!command script import '%s']]):format(script_file),
          ([[command source '%s']]):format(commands_file),
        }
      end,
    },
  }

  -- Go
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
      name = "Debug test",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
  }

  -- Godot GDScript
  dap.adapters.godot = {
    type = "server",
    host = "127.0.0.1",
    port = 6006,
  }
  dap.configurations.gdscript = {
    {
      type = "godot",
      request = "launch",
      name = "Launch scene",
      project = "${workspaceFolder}",
    },
    {
      type = "godot",
      request = "attach",
      name = "Attach to scene",
      project = "${workspaceFolder}",
    },
  }

  MiniDeps.add("mfussenegger/nluarepl")
end)
