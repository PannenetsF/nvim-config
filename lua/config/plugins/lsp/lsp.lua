local fn = vim.fn
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local utils = require("utils.functions")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

local custom_attach = require("utils.functions").custom_attach

local M = {}

M.setup = function()
	if utils.executable("pylsp") then
		local venv_path = os.getenv("VIRTUAL_ENV")
		local py_path = nil
		-- decide which python executable to use for mypy
		if venv_path ~= nil then
			py_path = venv_path .. "/bin/python3"
		else
			py_path = vim.g.python3_host_prog
		end

		lspconfig.pylsp.setup({
			on_attach = custom_attach,
			settings = {
				pylsp = {
					plugins = {
						-- formatter options
						black = { enabled = true },
						autopep8 = { enabled = false },
						yapf = { enabled = false },
						-- linter options
						pylint = { enabled = false, executable = "pylint" },
						ruff = { enabled = false },
						pyflakes = { enabled = false },
						pycodestyle = { enabled = false },
						-- type checker
						pylsp_mypy = {
							enabled = true,
							overrides = { "--python-executable", py_path, true },
							report_progress = true,
							live_mode = false,
						},
						-- auto-completion options
						jedi_completion = { fuzzy = true },
						-- import sorting
						isort = { enabled = true },
					},
				},
			},
			flags = {
				debounce_text_changes = 200,
			},
			capabilities = capabilities,
		})
	else
		vim.notify("pylsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
	end

	if utils.executable("pyright") then
		lspconfig.pyright.setup({
			on_attach = custom_attach,
			capabilities = capabilities,
		})
	else
		vim.notify("pyright not found!", vim.log.levels.WARN, { title = "Nvim-config" })
	end

	if utils.executable("ltex-ls") then
		lspconfig.ltex.setup({
			on_attach = custom_attach,
			cmd = { "ltex-ls" },
			filetypes = { "text", "plaintex", "tex", "markdown" },
			settings = {
				ltex = {
					language = "en",
				},
			},
			flags = { debounce_text_changes = 300 },
		})
	end

	if utils.executable("clangd") then
		lspconfig.clangd.setup({
			on_attach = custom_attach,
			capabilities = capabilities,
			filetypes = { "c", "cpp", "cc" },
			flags = {
				debounce_text_changes = 500,
			},
		})
	end

	-- set up vim-language-server
	if utils.executable("vim-language-server") then
		lspconfig.vimls.setup({
			on_attach = custom_attach,
			flags = {
				debounce_text_changes = 500,
			},
			capabilities = capabilities,
		})
	else
		vim.notify("vim-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
	end

	-- set up bash-language-server
	if utils.executable("bash-language-server") then
		lspconfig.bashls.setup({
			on_attach = custom_attach,
			capabilities = capabilities,
		})
	end

	if utils.executable("lua-language-server") then
		-- settings for lua-language-server can be found on https://github.com/LuaLS/lua-language-server/wiki/Settings .
		lspconfig.lua_ls.setup({
			on_attach = custom_attach,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files,
						-- see also https://github.com/LuaLS/lua-language-server/wiki/Libraries#link-to-workspace .
						-- Lua-dev.nvim also has similar settings for lua ls, https://github.com/folke/neodev.nvim/blob/main/lua/neodev/luals.lua .
						library = {
							fn.stdpath("data") .. "/lazy/emmylua-nvim",
							fn.stdpath("config"),
						},
						maxPreload = 2000,
						preloadFileSize = 50000,
					},
				},
			},
			capabilities = capabilities,
		})
	end

	-- Change diagnostic signs.
	fn.sign_define("DiagnosticSignError", { text = "🆇", texthl = "DiagnosticSignError" })
	fn.sign_define("DiagnosticSignWarn", { text = "⚠️", texthl = "DiagnosticSignWarn" })
	fn.sign_define("DiagnosticSignInfo", { text = "ℹ️", texthl = "DiagnosticSignInfo" })
	fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

	-- global config for diagnostic
	diagnostic.config({
		underline = false,
		virtual_text = false,
		signs = true,
		severity_sort = true,
	})

	-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
	--   underline = false,
	--   virtual_text = false,
	--   signs = true,
	--   update_in_insert = false,
	-- })

	-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
	lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
end

return M
