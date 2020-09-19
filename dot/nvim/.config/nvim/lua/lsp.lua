local vim = vim
local nvim_lsp = require 'nvim_lsp'

local set_keymap = function(bufnr, mode, lhs, rhs)
	local opts = { noremap=true, silent=true }
	vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end

local on_attach = function(client, bufnr)
	require'diagnostic'.on_attach(client, bufnr)

	set_keymap(bufnr, 'n', '[g', ':PrevDiagnostic<CR>')
	set_keymap(bufnr, 'n', ']g', ':NextDiagnostic<CR>')
	set_keymap(bufnr, 'n', '<leader>do', ':OpenDiagnostic<CR>')
	set_keymap(bufnr, 'n', '<leader>ds', ':lua vim.lsp.util.show_line_diagnostics()<CR>')

	set_keymap(bufnr, 'n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
	set_keymap(bufnr, 'n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
	set_keymap(bufnr, 'n', 'K', ':lua vim.lsp.buf.hover()<CR>')
	set_keymap(bufnr, 'n', 'gr', ':lua vim.lsp.buf.references()<CR>')
	set_keymap(bufnr, 'v', '<leader>l=', ":lua require'call'.range_formatting()<CR>")
	set_keymap(bufnr, 'n', '<leader>l=', ':lua vim.lsp.buf.formatting()<CR>')
	set_keymap(bufnr, 'n', '<leader>la', ':lua vim.lsp.buf.code_action()<CR>')
	set_keymap(bufnr, 'n', '<leader>ld', ':lua vim.lsp.buf.document_symbol()<CR>')
	set_keymap(bufnr, 'n', '<leader>li', ':lua vim.lsp.buf.implementation()<CR>')
	set_keymap(bufnr, 'n', '<leader>lr', ':lua vim.lsp.buf.rename()<CR>')
	set_keymap(bufnr, 'n', '<leader>ls', ':lua vim.lsp.buf.signature_help()<CR>')
	set_keymap(bufnr, 'n', '<leader>lt', ':lua vim.lsp.buf.type_definition()<CR>')
	set_keymap(bufnr, 'n', '<leader>lw', ':lua vim.lsp.buf.workspace_symbol()<CR>')
end

local servers = {'bashls', 'cssls', 'html', 'jsonls', 'sumneko_lua', 'vimls'}
for _, server in ipairs(servers) do
	nvim_lsp[server].setup {
		on_attach = on_attach,
	}
end

local clj_on_attach = function(client, bufnr)
	on_attach(client, bufnr)

	set_keymap(bufnr, 'n', '<leader>rcc', ":lua require'call'.clj_lsp_cmd('cycle-coll')<CR>")
	set_keymap(bufnr, 'n', '<leader>rth', ":lua require'call'.clj_lsp_cmd('thread-first')<CR>")
	set_keymap(bufnr, 'n', '<leader>rtt', ":lua require'call'.clj_lsp_cmd('thread-last')<CR>")
	set_keymap(bufnr, 'n', '<leader>rtf', ":lua require'call'.clj_lsp_cmd('thread-first-all')<CR>")
	set_keymap(bufnr, 'n', '<leader>rtl', ":lua require'call'.clj_lsp_cmd('thread-last-all')<CR>")
	set_keymap(bufnr, 'n', '<leader>ruw', ":lua require'call'.clj_lsp_cmd('unwind-thread')<CR>")
	set_keymap(bufnr, 'n', '<leader>rua', ":lua require'call'.clj_lsp_cmd('unwind-all')<CR>")
	set_keymap(bufnr, 'n', '<leader>rml', ":lua require'call'.clj_lsp_cmd('move-to-let', 'Binding name: ')<CR>")
	set_keymap(bufnr, 'n', '<leader>ril', ":lua require'call'.clj_lsp_cmd('introduce-let', 'Binding name: ')<CR>")
	set_keymap(bufnr, 'n', '<leader>rel', ":lua require'call'.clj_lsp_cmd('expand-let')<CR>")
	set_keymap(bufnr, 'n', '<leader>ram', ":lua require'call'.clj_lsp_cmd('add-missing-libspec')<CR>")
	set_keymap(bufnr, 'n', '<leader>rcn', ":lua require'call'.clj_lsp_cmd('clean-ns')<CR>")
	set_keymap(bufnr, 'n', '<leader>rcp', ":lua require'call'.clj_lsp_cmd('cycle-privacy')<CR>")
	set_keymap(bufnr, 'n', '<leader>ris', ":lua require'call'.clj_lsp_cmd('inline-symbol')<CR>")
	set_keymap(bufnr, 'n', '<leader>ref', ":lua require'call'.clj_lsp_cmd('extract-function', 'Function name: ')<CR>")
end

nvim_lsp.clojure_lsp.setup{
	init_options = {
		["ignore-classpath-directories"] = true,
	},
	on_attach = clj_on_attach,
}
