local M = {}
local zenmode = require("zen-mode")
M.normal_key_map = {
	["z"] = { zenmode.toggle, "+Zen Mode" },
}

return M
