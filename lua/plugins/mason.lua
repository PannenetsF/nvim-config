return {
	"williamboman/mason.nvim",
	config = function()
		require("config.plugins.mason").setup()
	end,
	ensure_installed = {
		"cmakelang",
		"pyright",
		"lua-language-server",
	},
	cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	build = function()
		pcall(function()
			require("mason-registry").refresh()
		end)
	end,
	event = "User FileOpened",
	lazy = true,
}
