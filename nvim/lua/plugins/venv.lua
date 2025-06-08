return {
  'linux-cultist/venv-selector.nvim',
  dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
  opts = {
    name = "venv",
    auto_refresh = true,
    search_venv_managers = true,
    search_workspace = true,
    -- Set default paths where venv-selector should look for virtual environments
    path = {
      "~/miniconda3/envs",
      "~/.pyenv/versions",
      "~/.virtualenvs",
      "./venv",
      "./.venv",
      "~/venv",
      "~/.venv",
    },
    -- Automatically activate the detected virtual environment
    activate_venv_in_terminal = true,
    -- Set Python path automatically when switching venvs
    set_environment_variables = true,
  },
  event = 'VeryLazy',
  --branch = "regexp"
  keys = {
  },
}
