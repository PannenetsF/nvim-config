return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("config.plugins.edition.autopairs").setup()
	end,
	enabled = true,
	dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
}
