return {
	"nvim-treesitter/nvim-treesitter",
	enabled = function()
		if vim.g.is_mac then
			return true
		end
		return false
	end,
	event = "VeryLazy",
	build = ":TSUpdate",
	config = function()
		require("config.plugins.treesitter")
	end,
}
