local M = {}

local commands = {
  "drag-param-backward",
  "drag-param-forward",
  "add-missing-libspec",
  "cycle-coll",
  "cycle-keyword-auto-resolve",
  "clean-ns",
  "cycle-privacy",
  "create-test",
  "demote-fn",
  "drag-backward",
  "drag-forward",
  "destructure-keys",
  "expand-let",
  "create-function",
  "get-in-all",
  "get-in-less",
  "get-in-more",
  "get-in-none",
  "inline-symbol",
  "resolve-macro-as",
  "replace-refer-all-with-alias",
  "restructure-keys",
  "sort-clauses",
  "thread-first-all",
  "thread-first",
  "thread-last-all",
  "thread-last",
  "unwind-all",
  "unwind-thread",
  "forward-slurp",
  "forward-barf",
  "backward-slurp",
  "backward-barf",
  "raise-sexp",
  "kill-sexp",
}

function M.get_client()
  return vim.lsp.get_clients({
    bufnr = 0,
    name = "clojure_lsp",
  })[1]
end

vim.lsp.handlers["clojure/serverInfo/raw"] = function(err, result, context, config)
  vim.print(result)
end
function M.get_server_info()
  local client = M.get_client()
  client.request("clojure/serverInfo/raw", {}, nil, 0)
end

vim.lsp.handlers["clojure/cursorInfo/raw"] = function(err, result, context, config)
  vim.print(result)
end
function M.get_cursor_info()
  local client = M.get_client()
  client.request("clojure/cursorInfo/raw", vim.lsp.util.make_position_params(), nil, 0)
end

function M.open_cljdoc()
  local client = M.get_client()
  client.request(
    "clojure/cursorInfo/raw",
    vim.lsp.util.make_position_params(),
    function(err, result, context, config)
      if result then
        local element = result.elements[1]
        local ns = element.definition.ns
        if ns and string.match(ns, "^clojure%.") then
          local url = string.format("https://clojuredocs.org/%s/%s", ns, element.definition.name)
          vim.ui.open(url)
        end
      end
    end,
    0
  )
end

function M.lsp_start()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.experimental = {
    clojuredocs = true,
    cursorInfo = true,
    projectTree = true,
    serverInfo = true,
    testTree = true,
  }

  vim.lsp.start({
    name = "clojure_lsp",
    cmd = { "clojure-lsp" },
    root_dir = vim.fs.root(
      0,
      { "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", ".git", "bb.edn" }
    ),
    capabilities = capabilities,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = "JPConfigLsp",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    ---@cast client -?
    if client.name == "clojure_lsp" then
      vim.lsp.commands["code-lens-references"] = function(command, ctx)
        local method = vim.lsp.protocol.Methods.textDocument_references
        local uri, row, col = unpack(command.arguments)
        client.request(method, {
          textDocument = { uri = uri },
          position = { line = row - 1, character = col - 1 },
          context = { includeDeclaration = true },
        }, vim.lsp.handlers[method], ctx.bufnr)
      end
    end

    vim.api.nvim_buf_create_user_command(0, "CljLsp", function(info)
      local command = info.args
      local position_params = vim.lsp.util.make_position_params()
      vim.lsp.buf.execute_command({
        command = command,
        arguments = {
          position_params.textDocument.uri,
          position_params.position.line,
          position_params.position.character,
        },
      })
    end, {
      desc = "Run clojure-lsp command",
      nargs = 1,
      complete = function(arg_lead, cmd_line, cursor_pos)
        return vim.tbl_filter(function(s) return s:sub(1, #arg_lead) == arg_lead end, commands)
      end,
    })

    vim.api.nvim_buf_create_user_command(0, "CljDoc", function(info) M.open_cljdoc() end, {
      desc = "Open ClojureDocs",
      nargs = 0,
    })
  end,
})

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = "JPConfigLsp",
    pattern = { "clojure", "edn" },
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "nofile" then M.lsp_start() end
    end,
  })
end

return M
