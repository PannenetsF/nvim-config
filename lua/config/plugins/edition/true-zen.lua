local opts = {
	integrations = {
		tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
		kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
			enabled = false,
			font = "+3",
		},
		twilight = false, -- enable twilight (ataraxis)
		lualine = true, -- hide nvim-lualine (ataraxis)
	},
	modes = { -- configurations per mode
		ataraxis = {
			minimum_writing_area = { -- minimum size of main window
				width = 80,
				height = 44,
			},
			padding = { -- padding windows
				left = 200,
				right = 200,
				top = 0,
				bottom = 0,
			},
		},
		minimalist = {
			options = {
				relativenumber = true,
			},
		},
	},
}
local M = {}
M.setup = function()
	require("true-zen").setup(opts)
end
return M
