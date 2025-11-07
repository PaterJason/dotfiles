local cmds = {
  { 'ab', 'drag-param-backward', 'Drag param backward' }, --`[file-uri,row,col]`
  { 'af', 'drag-param-forward', 'Drag param forward' }, --`[file-uri,row,col]`
  { 'ai', 'add-missing-import', 'Add import to namespace' }, --`[file-uri,row,col[,name]]`
  { 'am', 'add-missing-libspec', 'Add missing require' }, --`[file-uri,row,col]`
  -- { 'as', 'add-require-suggestion', 'Add require suggestion' }, --`[file-uri,row,col,ns,alias,refer]`
  { 'cc', 'cycle-coll', 'Cycle collection `(#{}, {}, [], ())`' }, --`[file-uri,row,col]`
  { 'ck', 'cycle-keyword-auto-resolve', 'Cycle keyword auto-resolve' }, --`[file-uri,row,col]`
  { 'cn', 'clean-ns', 'Clean namespace' }, --`[file-uri,row,col]`
  { 'cp', 'cycle-privacy', 'Cycle privacy of def/defn' }, --`[file-uri,row,col]`
  { 'ct', 'create-test', 'Create test' }, --`[file-uri,row,col]`
  { 'df', 'demote-fn', 'Demote fn to #()' }, --`[file-uri,row,col]`
  { 'db', 'drag-backward', 'Drag backward' }, --`[file-uri,row,col]`
  { 'df', 'drag-forward', 'Drag forward' }, --`[file-uri,row,col]`
  { 'dk', 'destructure-keys', 'Destructure keys' }, --`[file-uri,row,col]`
  -- { 'ed', 'extract-to-def', 'Extract to def' }, --`[file-uri,row,col,name]`
  -- { 'ef', 'extract-function', 'Extract function' }, --`[file-uri,row,col,name]`
  { 'el', 'expand-let', 'Expand let' }, --`[file-uri,row,col]`
  { 'fe', 'create-function', 'Create function from example' }, --`[file-uri,row,col]`
  { 'ga', 'get-in-all', 'Move all expressions to get/get-in' }, --`[file-uri,row,col]`
  { 'gl', 'get-in-less', 'Remove one element from get/get-in' }, --`[file-uri,row,col]`
  { 'gm', 'get-in-more', 'Move another expression to get/get-in' }, --`[file-uri,row,col]`
  { 'gn', 'get-in-none', 'Unwind whole get/get-in' }, --`[file-uri,row,col]`
  -- { 'il', 'introduce-let', 'Introduce let' }, --`[file-uri,row,col,name]`
  { 'is', 'inline-symbol', 'Inline Symbol' }, --`[file-uri,row,col]`
  { 'ma', 'resolve-macro-as', 'Resolve macro as' }, --`[file-uri,row,col]`
  -- { 'mf', 'move-form', 'Move form' }, --`[file-uri,row,col,filename]`
  -- { 'ml', 'move-to-let', 'Move expression to let' }, --`[file-uri,row,col,name]`
  -- { 'pf', 'promote-fn', 'Promote #() to fn, or fn to defn' }, --`[file-uri,row,col,fn-name]`
  -- { 'rr', 'replace-refer-all-with-refer', "Replace ':refer :all' with ':refer [...]'" }, --`[file-uri,row,col,refers]`
  { 'ra', 'replace-refer-all-with-alias', "Replace ':refer :all' with alias" }, --`[file-uri,row,col]`
  { 'rk', 'restructure-keys', 'Restructure keys' }, --`[file-uri,row,col]`
  -- { 'sc', 'change-coll', 'Switch collection to `{}, (), #{}, []`' }, --`[file-uri,row,col,"map"/"list"/"set"/"vector"]`
  { 'sl', 'sort-clauses', 'Sort map/vector/list/set/clauses' }, --`[file-uri,row,col]`
  { 'tf', 'thread-first-all', 'Thread first all' }, --`[file-uri,row,col]`
  { 'th', 'thread-first', 'Thread first expression' }, --`[file-uri,row,col]`
  { 'tl', 'thread-last-all', 'Thread last all' }, --`[file-uri,row,col]`
  { 'tt', 'thread-last', 'Thread last expression' }, --`[file-uri,row,col]`
  { 'ua', 'unwind-all', 'Unwind whole thread' }, --`[file-uri,row,col]`
  { 'uw', 'unwind-thread', 'Unwind thread once' }, --`[file-uri,row,col]`
  { 'fs', 'forward-slurp', 'Paredit: forward slurp' }, --`[file-uri,row,col]`
  { 'fb', 'forward-barf', 'Paredit: forward barf' }, --`[file-uri,row,col]`
  { 'bs', 'backward-slurp', 'Paredit: backward slurp' }, --`[file-uri,row,col]`
  { 'bb', 'backward-barf', 'Paredit: backward barf' }, --`[file-uri,row,col]`
  { 'rs', 'raise-sexp', 'Paredit: Raise sexp' }, --`[file-uri,row,col]`
  { 'ks', 'kill-sexp', 'Paredit: Kill sexp' }, --`[file-uri,row,col]`
  { 'gt', 'go-to-test', 'Go to test' }, --`[file-uri,row,col]`
}

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'CljLsp', function(info)
    if #info.fargs == 0 then
      vim.ui.select(cmds, {
        format_item = function(item) return item[3] end,
      }, function(item, _idx)
        if item ~= nil then vim.cmd({ cmd = 'CljLsp', args = { item[2] } }) end
      end)
    end
    local command = info.args
    local position_params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client:exec_cmd({
      title = 'CljLsp',
      command = command,
      arguments = {
        position_params.textDocument.uri,
        position_params.position.line,
        position_params.position.character,
      },
    }, {}, function(_err, _result, _context) end)
  end, {
    desc = 'Run clojure-lsp command',
    nargs = '?',
    complete = function(arg_lead, _cmd_line, _cursor_pos)
      return vim.tbl_filter(
        function(s) return s:sub(1, #arg_lead) == arg_lead end,
        vim.iter(cmds):map(function(t) return t[2] end):totable()
      )
    end,
  })

  for _, value in ipairs(cmds) do
    vim.keymap.set('n', '<LocalLeader>' .. value[1], function()
      vim.go.operatorfunc = ([[-> execute('CljLsp %s')}]]):format(value[2])
      return 'g@l'
    end, {
      expr = true,
      buffer = bufnr,
      desc = value[3],
    })
  end
end

---@type vim.lsp.Config
return {
  ---@type table<string,fun(command: lsp.Command, ctx: table)>
  commands = {
    ['code-lens-references'] = function(_command, _ctx) vim.lsp.buf.references() end,
    ['go-to-test'] = function(command, ctx) vim.print({ 'go-to-test', command, ctx }) end,
  },
  ---@type table<string, lsp.Handler>
  handlers = {
    ['clojure/serverInfo/raw'] = function(_err, result, _ctx) vim.print(result) end,
    ['clojure/cursorInfo/raw'] = function(_err, result, _ctx) vim.print(result) end,
  },
  on_attach = on_attach,
}
