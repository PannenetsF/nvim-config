return {
	"neovim/nvim-lspconfig",
	event = { "BufRead", "BufNewFile" },
	config = function()
		require("config.plugins.lsp")
	end,
}
