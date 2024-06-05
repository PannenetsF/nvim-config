return {
	"folke/noice.nvim",
	event = "VeryLazy",
	cond = require("utils.functions").firenvim_not_active,
	config = function()
		require("config.plugins.ui.noice").setup()
	end,
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
}
