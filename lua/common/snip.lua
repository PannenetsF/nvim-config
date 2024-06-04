local M = {}

M.setup = function()
	vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
	vim.g.UltiSnipsExpandTrigger = "<Tab>"
	vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
	vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
	-- vim.g.UltiSnipsEnableSnipMate = 0  -- Disable SnipMate compatibility
	vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" } -- Only load snippets from UltiSnips directory
	vim.g.UltiSnipsEditSplit = "vertical" -- Use vertical split for editing snippets
	vim.g.UltiSnipsUsePythonVersion = 3 -- Ensure Python3 is used
end

return M
