local M = {}
M.normal_key_map = {
	d = {
		name = "+Vimspector",
		b = { "<Plug>VimspectorBreakpoints", "Show all BPs" },
		c = { ":call vimspector#Continue()<CR>", "Start Debug / Continue to next BP" },
		i = { ":call vimspector#ShowOutput('Console')<CR>", "Interactive Console" },
		e = { ":call vimspector#ShowOutput('stderr')<CR>", "StdErr Output" },
		o = { ":call vimspector#Restart()<CR>", "Restart Debug" },
		r = { ":call vimspector#Reset()<CR>", "Stop debug and close debuggee" },
		s = { ":call vimspector#Stop()<CR>", "Stop Debug" },
		v = { "<Plug>VimspectorBalloonEval", "Balloon Eval" },
		-- Add the custom keybindings
		l = { ":call vimspector#Continue()<CR>", "Continue" },
		R = { ":call vimspector#Restart()<CR>", "Restart" },
		S = { ":call vimspector#Stop()<CR>", "Stop" },
		p = { ":call vimspector#Pause()<CR>", "Pause" },
		-- N = { ":call vimspector#JumpToNextBreakpoint()<CR>", "Next Breakpoint" },
		P = { ":call vimspector#JumpToPreviousBreakpoint()<CR>", "Previous Breakpoint" },
		t = { ":call vimspector#ToggleBreakpoint()<CR>", "Toggle Breakpoint" },
		f = { ":call vimspector#AddFunctionBreakpoint()<CR>", "Function Breakpoint" },
		n = { ":call vimspector#StepOver()<CR>", "Step Over" },
		N = { ":call vimspector#StepInto()<CR>", "Step Into" },
		u = { ":call vimspector#StepOut()<CR>", "Step Out" },
		d = { ":call vimspector#Disassemble()<CR>", "Disassemble" },
	},
}

return M
