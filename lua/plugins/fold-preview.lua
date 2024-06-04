return {
	"anuvyklack/fold-preview.nvim",
	requires = "anuvyklack/keymap-amend.nvim",
	config = function()
		require("fold-preview").setup({
			-- Your configuration goes here.
		})
	end,
}
