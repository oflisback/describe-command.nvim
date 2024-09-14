local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local M = {}

M.execute_command = function(command)
	vim.api.nvim_exec2(command, {})
	vim.cmd('redraw | echo ""')
	print("Described command executed: " .. command)
end

local function on_suggestion_selected(prompt_bufnr)
	local selection = action_state.get_selected_entry()

	actions.close(prompt_bufnr)

	if selection and selection.value then
		M.execute_command(selection.value)
	else
		print("No valid selection, command not executed.")
	end
end

M.show_suggestions = function(suggestions)
	pickers
		.new({}, {
			prompt_title = "Select a command to execute",
			finder = finders.new_table({
				results = suggestions,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(_, map)
				map("i", "<CR>", on_suggestion_selected)
				map("n", "<CR>", on_suggestion_selected)
				return true
			end,
		})
		:find()
end

return M
