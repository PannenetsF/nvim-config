local M = {}

M.normal_key_map = {
	t = {
		name = "Terminal",
		f = { "<cmd>ToggleTerm direction=float<cr>", "Floating terminal" },
		t = { "<cmd>ToggleTerm direction=tab<cr>", "Table terminal" },
		v = { "<cmd>2ToggleTerm size=20 direction=vertical<cr>", "Vertical terminal" },
		h = { "<cmd>2ToggleTerm size=20 direction=horizontal<cr>", "Horizontal terminal" },
		s = { "<cmd>ToggleTermSendVisualLines size=20 direction=horizontal<cr>", "Horizontal terminal" },
		a = { "<cmd>ToggleTermToggleAll<cr>", "Toggle all terminals" },
	},
}
return M
