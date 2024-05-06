MiniDeps.later(function()
  MiniDeps.add({ source = "mfussenegger/nvim-lint" })

  local lint = require("lint")

  lint.linters_by_ft = {
    fish = { "fish" },
  }

  local augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup,
    callback = function() lint.try_lint() end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = "stevearc/conform.nvim" })

  require("conform").setup({
    formatters_by_ft = {
      -- clojure = { "zprint" },
      fish = { "fish_indent" },
      lua = { "stylua" },
    },
  })
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    require("conform").format({ async = true, lsp_fallback = true, range = range })
  end, { range = true, desc = "Format with conform.nvim" })
  vim.keymap.set(
    { "n", "v" },
    "<Leader>f",
    ":Format<CR>",
    { silent = true, desc = "Format with conform.nvim" }
  )
end)

MiniDeps.later(function()
  MiniDeps.add({ source = "rafamadriz/friendly-snippets" })

  local dir
  for _, d in ipairs(vim.api.nvim_list_runtime_paths()) do
    if vim.fs.basename(d) == "friendly-snippets" then
      dir = d
      break
    end
  end
  local package_json = vim.fn.json_decode(vim.fn.readfile(vim.fs.joinpath(dir, "package.json")))

  ---@class FriendlySnippet
  ---@field key string
  ---@field body string|string[]
  ---@field prefix string
  ---@field description? string

  ---@type table<string, FriendlySnippet>
  local lang_snippets = {}

  local extended_filetypes = {
    lua = { "luadoc" },
  }

  ---@param lang string
  ---@return FriendlySnippet[]
  local function get_snippets(lang)
    local snippets = lang_snippets[lang]
    if snippets ~= nil then return snippets end

    local snippet_info = package_json.contributes.snippets
    local paths = {}
    for _, value in ipairs(snippet_info) do
      local language = value.language
      if type(language) == "string" then
        if language == lang then paths[#paths + 1] = value.path end
      else
        if vim.list_contains(language, lang) then paths[#paths + 1] = value.path end
      end
    end

    snippets = {}
    for _, path in ipairs(paths) do
      for key, value in vim.spairs(vim.fn.json_decode(vim.fn.readfile(vim.fs.joinpath(dir, path)))) do
        value.key = key
        snippets[#snippets + 1] = value
      end
    end
    lang_snippets[lang] = snippets
    return snippets
  end

  ---@param snippet FriendlySnippet
  local function expand_body(snippet)
    local body = snippet.body
    if type(body) == "string" then
      vim.snippet.expand(body)
    else
      vim.snippet.expand(table.concat(body, "\n"))
    end
  end

  ---@return FriendlySnippet[]
  local function get_buf_snippets()
    local snippets = {}
    local lang = vim.bo.filetype
    vim.list_extend(snippets, get_snippets(lang))
    for _, extlang in ipairs(extended_filetypes[lang] or {}) do
      vim.list_extend(snippets, get_snippets(extlang))
    end
    return snippets
  end

  local function select_snippet()
    vim.ui.select(get_buf_snippets(), {
      format_item = function(item) return item.key end,
      prompt = "Snippets",
    }, function(choice)
      if choice ~= nil then expand_body(choice) end
    end)
  end
  vim.keymap.set("n", "<leader>ss", select_snippet, { desc = "Snippets" })
  vim.keymap.set("i", "<C-h>", select_snippet, { desc = "Select snippet" })

  local function expand_snip_prefix()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_buf_get_text(0, cursor[1] - 1, 0, cursor[1] - 1, cursor[2], {})[1]
    local start, end_ = string.find(line, "%S+$")
    if start == nil or end_ == nil then
      vim.notify("No prefix found")
      return
    end

    local prefix = string.sub(line, start, end_)
    for _, snippet in ipairs(get_buf_snippets()) do
      if prefix == snippet.prefix then
        vim.api.nvim_buf_set_text(0, cursor[1] - 1, start - 1, cursor[1] - 1, end_, {})
        expand_body(snippet)
        return
      end
    end
    vim.notify("No snippet found")
  end
  vim.keymap.set("i", "<C-l>", expand_snip_prefix, { desc = "Expand snippet" })
end)
