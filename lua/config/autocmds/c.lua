local M = {}

-- define a fast g++ compile command
M.compile_c = function()
	local full_cmd = "gcc -Wall "
		.. vim.fn.expand("%")
		.. " -o "
		.. vim.fn.expand("%<")
		.. " && "
		.. vim.fn.expand("%<")
	return full_cmd
end

return M
