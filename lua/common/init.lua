local ui = require("common.ui")
local commands = require("common.commands")
local keymappings = require("common.keymappings")
local snip = require("common.snip")
local lsp = require("common.lsp")
local modules = { ui, commands, keymappings, snip, lsp }
local M = {}

M.setup = function()
	for _, module in ipairs(modules) do
		module.setup()
	end
end

return M
