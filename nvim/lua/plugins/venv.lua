return {
  'linux-cultist/venv-selector.nvim',
  dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
  opts = {
    auto_refresh = true,
    search_venv_managers = true,
    search_workspace = true,
    path = {
      "~/miniconda3/envs",
      "~/.pyenv/versions",
      "~/.virtualenvs",
      "./venv",
      "./.venv",
      "~/venv",
      "~/.venv",
    },
    activate_venv_in_terminal = true,
    set_environment_variables = true,
  },
  lazy = false,
}
