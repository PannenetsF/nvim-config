return {
	"nvim-treesitter/nvim-treesitter",
	-- enabled = function()
	-- 	if vim.g.is_mac then
	-- 		return true
	-- 	end
	-- 	return false
	-- end,
	cmd = {
		"TSInstall",
		"TSUninstall",
		"TSUpdate",
		"TSUpdateSync",
		"TSInstallInfo",
		"TSInstallSync",
		"TSInstallFromGrammar",
	},
	event = "User FileOpened",
	-- event = "VeryLazy",
	build = ":TSUpdate",
	config = function()
		require("config.plugins.edition.treesitter").setup()
	end,
}
