return {
	"akinsho/bufferline.nvim",
	event = { "BufEnter" },
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("config.plugins.bufferline").setup()
	end,
}
