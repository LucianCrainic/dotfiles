# This snippet allows to fix the clangd offsetEncoding issue.
return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      clangd = {
        -- opts.capabilities.offsetEncoding = { "utf-16" }
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
      }
    },
    -- define supported filetypes
    filetypes = { "c", "cpp", "objcpp" }, -- Disables protobuf!
  },
}
