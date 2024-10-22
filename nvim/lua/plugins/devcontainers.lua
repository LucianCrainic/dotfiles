return {
  "https://codeberg.org/esensar/nvim-dev-container",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    -- Cache images
    cache = true,
    -- Share the local neovim configuration with the container
    attach_mounts = {
      neovim_config = {
        enabled = true,
        options = { "readonly" },
      },
      neovim_data = {
        enabled = false,
        options = {},
      },
    },
  },
}
