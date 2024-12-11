return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	ft = { "org" },
	config = function()
		-- Setup orgmode
		require("orgmode").setup({
			org_agenda_files = "~/org/**/*",
			org_default_notes_file = "~/org/notes.org",
			org_adapt_indentation = false,
			mappings = {
				org = {
					org_toggle_checkbox = "cic",
				},
			},
		})

		-- NOTE: If you are using nvim-treesitter with `ensure_installed = "all"` option
		-- add `org` to ignore_install
		-- require('nvim-treesitter.configs').setup({
		--   ensure_installed = 'all',
		--   ignore_install = { 'org' },
		-- })
	end,
}
