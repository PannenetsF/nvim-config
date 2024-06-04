return {
	"puremourning/vimspector",
	init = function()
		vim.g.vimspector_enable_mappings = "VISUAL_STUDIO"
		vim.g.vimspector_install_gadgets = { "debugpy" }
	end,
}
