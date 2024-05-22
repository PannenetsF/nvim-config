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
	"LunarVim/bigfile.nvim",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	"nvim-lua/plenary.nvim",
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	"github/copilot.vim",
	"Pocco81/auto-save.nvim",
	"Pocco81/true-zen.nvim",
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
		"folke/which-key.nvim",
		config = function()
			require("config.keybinding.whichkey")
		end,
		cmd = "WhichKey",
		event = "VeryLazy",
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-omni",
			"hrsh7th/cmp-emoji",
			"quangnguyen30192/cmp-nvim-ultisnips",
		},
		config = function()
			require("config.plugins.nvim-cmp")
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp", lazy = true },
	{ "saadparwaiz1/cmp_luasnip", lazy = true },
	{ "hrsh7th/cmp-buffer", lazy = true },
	{ "hrsh7th/cmp-path", lazy = true },
	{
		"hrsh7th/cmp-cmdline",
		lazy = true,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_lua").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = paths,
			})
			require("luasnip.loaders.from_snipmate").lazy_load()
		end,
		event = "InsertEnter",
		dependencies = {
			"friendly-snippets",
		},
	},
	{ "rafamadriz/friendly-snippets", lazy = true },
	{ "VonHeikemen/lsp-zero.nvim" },
	{
		"natecraddock/workspaces.nvim",
		config = function()
			require("workspaces").setup()
		end,
	},
	{ "honza/vim-snippets" },
	{ "SirVer/ultisnips", event = "InsertEnter" },
	{ "dstein64/vim-startuptime" },
})

vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")

local commands = require("config.commands")
commands.load(commands.defaults)
require("config.keymappings").load_defaults()
require("config.keybinding.copilot")

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
