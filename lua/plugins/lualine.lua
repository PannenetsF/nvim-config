return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		require("config.plugins.ui.lualine").setup()
	end,
}
