return {
	"L3MON4D3/LuaSnip",
	config = function()
		require("luasnip.loaders.from_lua").lazy_load()
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = paths,
		})
		require("luasnip.loaders.from_snipmate").lazy_load()
	end,
	event = "InsertEnter",
	dependencies = {
		"friendly-snippets",
	},
}
