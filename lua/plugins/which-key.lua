return {
	"folke/which-key.nvim",
	config = function()
		require("config.keybinding.whichkey")
	end,
	cmd = "WhichKey",
	event = "VeryLazy",
}
