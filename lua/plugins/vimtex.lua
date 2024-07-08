return {
	"lervag/vimtex",
	opt = true,
	config = function()
		require("config.plugins.tools.vimtex").setup()
	end,
	ft = "tex",
}
