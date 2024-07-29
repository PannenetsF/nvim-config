return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	config = function()
		require("config.plugins.edition.neotree").setup()
	end,
}
