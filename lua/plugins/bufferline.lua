return {
	"akinsho/bufferline.nvim",
	event = { "BufEnter" },
  cond = require("utils.functions").firenvim_not_active,
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("config.plugins.ui.bufferline").setup()
	end,
}
