MiniDeps.later(function()
  MiniDeps.add({
    source = "mfussenegger/nvim-dap",
    depends = { "theHamsta/nvim-dap-virtual-text" },
  })

  local dap = require("dap")
  local widgets = require("dap.ui.widgets")
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-dap-virtual-text").setup({
    highlight_new_as_changed = true,
  })
  if os.getenv("TMUX") then
    dap.defaults.fallback.external_terminal = {
      command = "/usr/bin/tmux",
      args = { "new-window", "-a", "-d" },
    }
    dap.defaults.fallback.force_external_terminal = true
  else
    dap.defaults.fallback.terminal_win_cmd = "tabnew"
  end

  local winopts = {
    height = 12,
    winfixheight = true,
  }

  ---@type dap.RequestListener<any, any>
  local start_fn = function(_, _, _, _, _) dap.repl.open(winopts) end
  dap.listeners.before.attach["user"] = start_fn
  dap.listeners.before.launch["user"] = start_fn

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
  vim.keymap.set(
    "n",
    "<Leader>dq",
    function() dap.list_breakpoints(true) end,
    { desc = "List breakpoints" }
  )
  vim.keymap.set(
    "n",
    "<Leader>dr",
    function() dap.repl.toggle(winopts) end,
    { desc = "Toggle repl" }
  )
  vim.keymap.set({ "n", "v" }, "<Leader>dh", function() widgets.hover() end, { desc = "Hover" })
  vim.keymap.set({ "n", "v" }, "<Leader>dp", function() widgets.preview() end, { desc = "Preview" })
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
        local sysroot_system_obj = vim.system({ "rustc", "--print", "sysroot" }):wait()
        assert(
          sysroot_system_obj.stdout ~= nil,
          "failed to get rust sysroot using `rustc --print sysroot`: " .. sysroot_system_obj.stderr
        )
        local rustc_sysroot = vim.trim(sysroot_system_obj.stdout)
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
