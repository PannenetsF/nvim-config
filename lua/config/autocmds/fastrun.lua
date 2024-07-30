local term = require("toggleterm")
local M = {}

M.compile_c = function()
	local full_cmd = "gcc -Wall "
		.. vim.fn.expand("%")
		.. " -o "
		.. vim.fn.expand("%<")
		.. " && "
		.. vim.fn.expand("%<")
	return full_cmd
end

M.compile_cpp = function()
	local full_cmd = "g++ -Wall "
		.. vim.fn.expand("%")
		.. " -o "
		.. vim.fn.expand("%<")
		.. " && "
		.. vim.fn.expand("%<")
	return full_cmd
end

M.run_bash = function()
	local full_cmd = "python " .. vim.fn.expand("%")
	return full_cmd
end

M.run_python = function()
	local full_cmd = "python " .. vim.fn.expand("%")
	return full_cmd
end

M.run = function()
	-- get the file extension
	local file_extension = vim.fn.expand("%:e")
	local cmd = ""
	if file_extension == "cpp" then
		cmd = M.compile_cpp()
	elseif file_extension == "c" then
		cmd = M.compile_c()
	elseif file_extension == "py" then
		cmd = M.run_python()
	elseif file_extension == "sh" or file_extension == "bash" then
		cmd = M.run_bash()
	else
		print("Unsupported file type", file_extension)
	end
	term.exec_command("cmd='" .. cmd .. "'")
end

M.normal_local_key_map = {
	r = {
		name = "Build and Run",
		r = { "<cmd>lua require('config.autocmds.fastrun').run()<CR>", "Run the script" },
	},
}

return M
