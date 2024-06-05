return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	cond = require("utils.functions").firenvim_not_active,
	config = function()
		require("config.plugins.ui.lualine").setup()
	end,
}
