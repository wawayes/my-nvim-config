return {

	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({
				-- add any options here, or leave empty to use the default settings
				opts = {
					library = {
						types = true,
					},
				},
			})
		end,
	},

	{
		event = "VeryLazy",
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
	},
	{
		lazy = true,
		"neovim/nvim-lspconfig",
		dependencies = { 'williamboman/mason-lspconfig.nvim' },
		config = function()
			-- Set up lspconfig.
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- lua_ls
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim", "hs", "gopls" },
						},
						workspace = {
							checkThirdParty = false,
							-- Make the server aware of Neovim runtime files
							library = {
								vim.api.nvim_get_runtime_file("", true),
								"/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
								vim.fn.expand("~/lualib/share/lua/5.4"),
								vim.fn.expand("~/lualib/lib/luarocks/rocks-5.4"),
								"/opt/homebrew/opt/openresty/lualib",
							},
						},
						completion = {
							callSnippet = "Replace",
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			})
			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					-- Buffer
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					--	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})


			require("lspconfig").pyright.setup({
				capabilities = capabilities,
			})
			require("lspconfig").gopls.setup({
				cmd = { "gopls", "serve" },
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							staticcheck = true,
						},
					},
				},
			})
		end,
	},
	{
		event = "VeryLazy",
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.black,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
}
