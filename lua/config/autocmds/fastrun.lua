local term = require("toggleterm")
local cpp = require("config.autocmds.cpp")
local c = require("config.autocmds.c")

local M = {}

M.compile = function()
	-- get the file extension
	local file_extension = vim.fn.expand("%:e")
	local cmd = ""
	if file_extension == "cpp" then
		cmd = cpp.compile_cpp()
	elseif file_extension == "c" then
		cmd = c.compile_c()
	else
		print("Unsupported file type", file_extension)
	end
	term.exec_command("cmd='" .. cmd .. "'")
end

M.normal_local_key_map = {
	r = {
		name = "Build and Run",
		r = { "<cmd>lua require('config.autocmds.fastrun').compile()<CR>", "Compile" },
	},
}

return M
