local commands = require("describe-command.commands")
local config = require("describe-command.config")

local M = {}

function M.setup(user_config)
	config.create_final_config(user_config)
	commands.register()

	return M
end

return M
