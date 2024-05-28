-- Vimspector Settings
vim.g.vimspector_enable_mappings = "VISUAL_STUDIO"
vim.g.vimspector_install_gadgets = { "debugpy" }

-- if s:mappings ==# 'VISUAL_STUDIO'
--   nmap <F5>         <Plug>VimspectorContinue
--   nmap <S-F5>       <Plug>VimspectorStop
--   nmap <C-S-F5>     <Plug>VimspectorRestart
--   nmap <F6>         <Plug>VimspectorPause
--   nmap <F8>         <Plug>VimspectorJumpToNextBreakpoint
--   nmap <S-F8>       <Plug>VimspectorJumpToPreviousBreakpoint
--   nmap <F9>         <Plug>VimspectorToggleBreakpoint
--   nmap <S-F9>       <Plug>VimspectorAddFunctionBreakpoint
--   nmap <F10>        <Plug>VimspectorStepOver
--   nmap <F11>        <Plug>VimspectorStepInto
--   nmap <S-F11>      <Plug>VimspectorStepOut
--   nmap <M-8>        <Plug>VimspectorDisassemble

-- vim.api.nvim_set_keymap("n", "<F5>", ":call vimspector#Continue()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<S-F5>", ":call vimspector#Stop()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-S-F5>", ":call vimspector#Restart()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<F6>", ":call vimspector#Pause()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<F8>", ":call vimspector#JumpToNextBreakpoint()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<S-F8>",
-- 	":call vimspector#JumpToPreviousBreakpoint()<CR>",
-- 	{ noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap("n", "<F9>", ":call vimspector#ToggleBreakpoint()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<S-F9>",
-- 	":call vimspector#AddFunctionBreakpoint()<CR>",
-- 	{ noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap("n", "<F10>", ":call vimspector#StepOver()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<F11>", ":call vimspector#StepInto()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<F12>", ":call vimspector#StepOut()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<M-8>", ":call vimspector#Disassemble()<CR>", { noremap = true, silent = true })
