return {
  "morhetz/gruvbox",
  priority = 1000,
  init = function()
    vim.g.gruvbox_contrast_dark = "medium"
    vim.g.gruvbox_transparent_bg = 1
  end,
  config = function()
    vim.o.background = "dark"
    vim.cmd.colorscheme "gruvbox"
    -- Ensure transparency by removing background from Normal and NormalNC
    local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    hl.bg = nil
    vim.api.nvim_set_hl(0, "Normal", hl)
    
    local hl_nc = vim.api.nvim_get_hl(0, { name = "NormalNC" })
    hl_nc.bg = nil
    vim.api.nvim_set_hl(0, "NormalNC", hl_nc)
  end,
}
