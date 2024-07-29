return {
	"neovim/nvim-lspconfig",
	event = { "BufRead", "BufNewFile" },
	dependencies = {
		{ "jose-elias-alvarez/null-ls.nvim" },
		{ "folke/trouble.nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "williamboman/mason-lspconfig.nvim" },
		{
			"williamboman/mason.nvim",
			build = function()
				pcall(vim.cmd, "MasonUpdate")
			end,
		},
		{ "jay-babu/mason-null-ls.nvim" },
	},
	config = function()
		require("config.plugins.lsp.lsp").setup()
	end,
}
