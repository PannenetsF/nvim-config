local telescope = require("telescope.builtin")
local M = {}

M.normal_key_map = {
	f = {
		name = "Find",
		f = { telescope.find_files, "Find Files" },
		g = { telescope.live_grep, "Live Grep" },
		b = { telescope.buffers, "Buffers" },
		h = { telescope.help_tags, "Help Tags" },
		p = {
			"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
			"Colorscheme with Preview",
		},
	},
}
return M
