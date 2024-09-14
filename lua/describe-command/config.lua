local M = {}

M.final_config = nil

local default_prompt =
	"You are a Neovim expert. Your task is to provide between one and five alternative commands that match the description provided by the user. Each command must be: \
1. Correct and executable as it is as a string parameter to vim.api.nvim_exec2, with no required additional plugins or specific configuration unless specified. \
2. Verified to ensure it performs the intended action accurately. \
3. Avoid extraneous whitespace and trailing characters. \
4. Order suggestions by quality, where first suggestion is your best candidate command. \
Consider the safety and integrity of the user's Neovim environment, avoiding any destructive commands without confirmation prompts."

M.create_final_config = function(user_config)
	local default_config = {
		openai_api_key_env_var = "OPENAI_API_KEY",
		openai_model = "gpt-4o-mini-2024-07-18",
		openai_system_prompt = default_prompt,
	}
	M.final_config = vim.tbl_extend("keep", user_config or {}, default_config)
end

M.get_system_prompt = function()
	return M.final_config.openai_system_prompt
end

M.get_model = function()
	return M.final_config.openai_model
end

M.get_api_key = function()
	local api_key = nil
	if M.final_config.openai_api_key_command then
		local handle = io.popen(M.final_config.openai_api_key_command)
		if not handle then
			error("Failed to execute command to obtain api key: " .. M.final_config.openai_api_key_command)
		end

		api_key = handle:read("*a"):gsub("\n$", "")

		handle:close()
		if api_key == nil then
			vim.api.nvim_err_writeln("Error: " .. M.final_config.openai_api_key_command .. " did not return any value.")
			error("OpenAI API key missing")
		end
	else
		api_key = os.getenv(M.final_config.openai_api_key_env_var)
		if api_key == nil then
			vim.api.nvim_err_writeln(
				"Error: " .. M.final_config.openai_api_key_env_var .. " environment variable is not set."
			)
			vim.api.nvim_out_write(
				"Please set the "
					.. M.final_config.openai_api_key_env_var
					.. " environment variable to use the describe-command.nvim plugin.\n"
			)
			error("OpenAI API key missing")
		end
	end
	return api_key
end

return M
