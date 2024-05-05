return {
	"akinsho/bufferline.nvim",
	event = { "BufEnter" },
	cond = firenvim_not_active,
	config = function()
		require("config.bufferline")
	end,
}
