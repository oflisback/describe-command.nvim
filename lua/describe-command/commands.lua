local network = require("describe-command.network")
local telescope = require("describe-command.telescope")

local M = {}

M.get_description = function(action)
	local description = vim.fn.input("Describe command to " .. action .. ": ")
	vim.cmd('redraw | echo ""')
	return description
end

M.register = function()
	function DescribeCommandSuggest(description)
		if description == nil or #description == 0 then
			description = M.get_description("get suggestions for")
		end
		print("Getting command suggestions for: " .. description .. " ...")
		local suggestions = network.get_suggestions(description)
		if suggestions ~= nil then
			telescope.show_suggestions(suggestions)
		end
	end
	vim.cmd("command! -nargs=? DescribeCommandSuggest lua DescribeCommandSuggest(<f-args>)")

	function DescribeCommandExecute(description)
		if description == nil or #description == 0 then
			description = M.get_description("execute")
		end
		print("Getting command for: " .. description .. " ...")
		local suggestions = network.get_suggestions(description)
		if suggestions ~= nil then
			telescope.execute_command(suggestions[1])
		end
	end
	vim.cmd("command! -nargs=? DescribeCommandExecute lua DescribeCommandExecute(<f-args>)")
end

return M
