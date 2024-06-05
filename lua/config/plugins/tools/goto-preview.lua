local M = {}

M.normal_key_map = {
	p = {
		name = "Goto preview",
		d = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", "Preview Definition" },
		t = { "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", "Preview Type Definition" },
		i = { "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", "Preview Implementation" },
		D = { "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", "Preview Declaration" },
		r = { "<cmd>lua require('goto-preview').goto_preview_references()<CR>", "Preview References" },
		P = { "<cmd>lua require('goto-preview').close_all_win()<CR>", "Close All Previews" },
	},
}
return M
