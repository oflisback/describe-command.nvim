local M = {}
local config = require("describe-command.config")
local curl = require("plenary.curl")

M.get_suggestions = function(description)
	local json_body = {
		model = config.get_model(),
		messages = {
			{
				role = "system",
				content = config.get_system_prompt(),
			},
			{
				role = "user",
				content = description,
			},
		},
		response_format = {
			type = "json_schema",
			json_schema = {
				name = "alternatives",
				strict = true,
				schema = {
					type = "object",
					additionalProperties = false,
					required = { "commands" },
					properties = {
						commands = {
							type = "array",
							items = {
								type = "string",
								description = "A command that matches the question",
							},
						},
					},
				},
			},
		},
	}

	local body = vim.fn.json_encode(json_body)

	local result = curl.request({
		url = "https://api.openai.com/v1/chat/completions",
		method = "POST",
		body = body,
		on_error = function(res)
			print("describe-commands suggestion request failed: " .. res.message)
		end,
		headers = {
			content_type = "application/json",
			Authorization = "Bearer " .. config.get_api_key(),
		},
	})

	local choices = vim.json.decode(result.body).choices
	if choices == nil then
		print("No command suggestions received, is your OpenAI API key valid?")
		return nil
	end
	local embeddedJson = choices[1].message.content
	local embeddedTable, err = select(1, vim.json.decode(embeddedJson))

	if err then
		error("Error while parsing embedded JSON string: " .. err)
	end

	local commands = {}
	for i, command in ipairs(embeddedTable.commands) do
		commands[i] = vim.trim(command)
	end

	return commands
end

return M
