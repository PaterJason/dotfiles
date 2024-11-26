MiniDeps.later(function()
  MiniDeps.add({
    source = "mfussenegger/nvim-dap",
    depends = { "theHamsta/nvim-dap-virtual-text" },
  })

  local dap = require("dap")
  local widgets = require("dap.ui.widgets")
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

  ---@type fun(session: dap.Session, err: any, body: any, request: any, seq: number)
  local function start_fn(session, err, body, request, seq) dap.repl.open({ height = 10 }) end
  dap.listeners.before.attach["user"] = start_fn
  dap.listeners.before.launch["user"] = start_fn

  vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  vim.keymap.set(
    "n",
    "<Leader>dl",
    function() dap.list_breakpoints(true) end,
    { desc = "List breakpoints" }
  )
  vim.keymap.set(
    "n",
    "<Leader>dr",
    function() dap.repl.toggle({ height = 10 }) end,
    { desc = "Toggle repl" }
  )
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
    function() widgets.sidebar(widgets.scopes, { width = 50 }).toggle() end,
    { desc = "Scopes" }
  )

  vim.keymap.set("n", "<F7>", dap.step_back, { desc = "Step back" })
  vim.keymap.set("n", "<F8>", dap.continue, { desc = "Continue" })
  vim.keymap.set("n", "<F9>", dap.step_over, { desc = "Step over" })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    callback = function(ev) require("dap.ext.autocompl").attach() end,
    group = "JPConfig",
    desc = "DAP REPL",
  })

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
      lldb = { showDisassembly = "never" },
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp

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
end)
