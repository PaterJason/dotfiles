local nvim_lsp = require 'nvim_lsp'

nvim_lsp.bashls.setup{}
nvim_lsp.clojure_lsp.setup{
		init_options = {
				["ignore-classpath-directories"] = true}}
nvim_lsp.cssls.setup{}
nvim_lsp.html.setup{}
nvim_lsp.jsonls.setup{}
nvim_lsp.sumneko_lua.setup{}
nvim_lsp.vimls.setup{}
