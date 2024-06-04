return {
	"folke/which-key.nvim",
	config = function()
		require("config.plugins.keymappings.whichkey").setup()
	end,
	cmd = "WhichKey",
	event = "VeryLazy",
}
