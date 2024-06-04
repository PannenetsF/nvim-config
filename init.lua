local globalset = require("global")
local settings = require("config.settings")
settings.load_defaults()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{ import = "plugins" },
})

vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")

local commands = require("config.commands")
commands.load(commands.defaults)
require("config.keymappings").load_defaults()
require("config.keybinding.copilot")

require("mason").setup()
require("mason-lspconfig").setup()
-- require("lsp_signature").setup({})

local viml_conf_dir = vim.fn.stdpath("config") .. "/vim/"
vim.cmd("source " .. viml_conf_dir .. "autocommands.vim")
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
vim.g.UltiSnipsExpandTrigger = "<Tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
-- vim.g.UltiSnipsEnableSnipMate = 0  -- Disable SnipMate compatibility
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" } -- Only load snippets from UltiSnips directory
vim.g.UltiSnipsEditSplit = "vertical" -- Use vertical split for editing snippets
vim.g.UltiSnipsUsePythonVersion = 3 -- Ensure Python3 is used

-- Performance optimizations
vim.o.lazyredraw = true -- Reduces flickering by not redrawing while executing macros
vim.o.updatetime = 300 -- Reduce the time it takes to trigger the CursorHold event

require("gitblame").setup({ enable = true })
