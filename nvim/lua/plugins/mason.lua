return {
  {
    -- LSPS
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "clangd",
        "robotframework_ls",
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    -- FORMATTERS
    opts = {
      ensure_installed = {
        "stylua",
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
