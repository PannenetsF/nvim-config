local telescope = require("telescope.builtin")
local M = {}

M.normal_key_map = {
	f = {
		name = "Find",
		f = { telescope.find_files, "Find Files" },
		g = { telescope.live_grep, "Live Grep" },
		b = { telescope.buffers, "Buffers" },
		h = { telescope.help_tags, "Help Tags" },
		c = { telescope.git_branches, "Checkout branch" },
		l = { "<cmd>Telescope resume<cr>", "Resume last search" },
		H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
		p = {
			"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
			"Colorscheme with Preview",
		},
	},
}
return M
