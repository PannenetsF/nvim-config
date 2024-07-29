local M = {}
M.setup = function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"python",
			"cpp",
			"lua",
			"vim",
			"json",
			"toml",
			"vimdoc",
			"c",
			"bash",
			"markdown",
			"markdown_inline",
			"org",
			"query",
		},
		ignore_install = {}, -- List of parsers to ignore installing
		highlight = {
			enable = true, -- false will disable the whole extension
			disable = { "help" }, -- list of language that will be disabled
		},
	})
end
return M
