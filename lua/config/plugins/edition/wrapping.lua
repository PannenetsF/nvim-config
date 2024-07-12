local M = {}
M.setup = function()
	require("wrapping").setup({
		create_keymaps = false,
	})
	vim.api.nvim_set_keymap("n", "<A-z>", "<cmd>ToggleWrapMode<CR>", { noremap = true, silent = true })
end

return M
