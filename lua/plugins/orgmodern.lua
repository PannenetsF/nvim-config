return {
	"danilshvalov/org-modern.nvim",
	config = function()
		local Menu = require("org-modern.menu")
		require("orgmode").setup({
			ui = {
				menu = {
					handler = function(data)
						Menu:new():open(data)
					end,
				},
			},
		})
	end,
}
