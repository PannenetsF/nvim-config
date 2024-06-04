local M = {}
M.setup = function()
	vim.opt.termguicolors = true
	vim.cmd.colorscheme("catppuccin")
	vim.o.lazyredraw = true -- Reduces flickering by not redrawing while executing macros
	vim.o.updatetime = 300 -- Reduce the time it takes to trigger the CursorHold event
end
return M
