local M = {}

local config_shared = function()
	vim.g.vimtex_compiler_latexmk_engines = {
		_ = "-pdflatex",
	}
	vim.g.tex_comment_nospell = 1
	vim.g.vimtex_compiler_progname = "nvr"
	-- vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
	-- vim.g.vimtex_view_general_options_latexmk = '--unique'
end

local config_linux = function()
	vim.g.vimtex_view_general_viewer = "zathura"
end

local config_mac = function()
	vim.g.vimtex_view_general_viewer = "skim"
	vim.g.vimtex_view_method = "skim"
	vim.g.vimtex_view_skim_sync = 1
	vim.g.vimtex_view_skim_activate = 1
end

local config_platform = function()
	local platform = require("utils.platform").platform()
	if platform == "linux" then
		config_linux()
	elseif platform == "mac" then
		config_mac()
	end
end

M.setup = function()
	config_shared()
	config_platform()
end

return M
