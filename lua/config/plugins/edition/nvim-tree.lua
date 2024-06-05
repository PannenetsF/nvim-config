local M = {}
M.normal_key_map = {
	["e"] = {
		":NvimTreeToggle <CR>",
		"Toggle NvimTree and reveal current file",
	},
	s = {
		name = "Sidebar Management",
		s = { "<cmd>NvimTreeFindFileToggle<CR>", "Locate the file in sidebar" },
		g = { "<cmd>SidebarNvimToggle<CR>", "Toggle Status Bar" },
	},
}

return M
