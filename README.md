### :lotus_position: Purpose

Instead of trying to remember all the Vim and Neovim commands available, this plugin lets the user describe a command and then have an OpenAI model come up with a command to execute or a few suggestions to choose from.

### :movie_camera: Demo

#### DescribeCommandSuggest

![demo](assets/describe-command-suggest.gif?raw=true)

In the demo `:DescribeCommandSuggest` is mapped to a keyboard shortcut using [which-key.nvim](https://github.com/folke/which-key.nvim):

```
  { "<leader>ao", ":DescribeCommandSuggest<cr>", desc = "Suggest described command" },
```

#### DescribeCommandExecute

![demo](assets/describe-command-execute.gif?raw=true)

In the demo `:DescribeCommandExecute` is mapped to a keyboard shortcut using [which-key.nvim](https://github.com/folke/which-key.nvim):

```
  { "<leader>ae", ":DescribeCommandExecute<cr>", desc = "Execute described command" },
```

### :mechanic: Installation

1. Make sure you have [curl](https://curl.se/) installed on your system and available on your `PATH`.

2. Install `describe-command.nvim`, here's how to do it with the [Lazy](https://github.com/folke/lazy.nvim) package manager:

```lua
{
"oflisback/describe-command.nvim",
dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
config = function() require("describe-command").setup() end,
lazy = false,
}
```

2. You'll have to provide an OpenAI API key for the plugin to work, by default it looks for the key in an environment variable `OPENAI_API_KEY`. But you can also provide it via another environment variable:

```
  config = function() require("describe-command").setup({ openai_api_key_env_var = "MY_ALTERANTIVE_ENV_VARIABLE_NAME" }) end,
```

A better alternative than to expose your API key in an environment variable is to have an executable that provides it, such as:

```
  config = function() require("describe-command").setup({ openai_api_key_command = "~/echo-openai-api-key.sh" }) end,
```

### :gear: Configuration

Apart from `openai_api_key_env_var` and `openai_api_key_command` a few more options are available. These are the default values:

```lua
{
    openai_model = "gpt-4o-mini-2024-07-18",
    openai_system_prompt = -- See lua/describe-command/config.lua,
}

Note that the model must support [structured output](https://openai.com/index/introducing-structured-outputs-in-the-api/).

```

### :keyboard: Commands

- `:DescribeCommandExecute` This command directly executes the command that best matches the given description. If no description is given the user will be prompted for one.
- `:DescribeCommandSuggest` This command shows a list of suggestions that match the given description. If no description is given the user will be prompted for one.

:bulb: Feel free to suggest additional useful commands via issue or PR.

### :people_holding_hands: Contributing

Contributions, bug reports and suggestions are very welcome.

If you have a suggestion that would make the project better, please fork the repo and create a pull request.
