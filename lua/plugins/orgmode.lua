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
	end,
}
