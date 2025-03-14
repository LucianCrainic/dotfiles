return {
  {
    -- LSPS
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "ruff",
        "clangd",
        "robotframework_ls",
        "dockerls",
        "docker_compose_language_service"
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    -- FORMATTERS
    opts = {
      ensure_installed = {
        "stylua",
        "yamlfmt"
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- DEBUGGERS
    opts = {
      ensure_installed = {
        "python",
      },
    },
  },
}
