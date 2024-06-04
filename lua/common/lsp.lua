local M = {}
M.setup = function()
	require("mason").setup()
	require("mason-lspconfig").setup()
end

return M
