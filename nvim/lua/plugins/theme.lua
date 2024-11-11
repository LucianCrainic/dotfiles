return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
		},
		config = function()
			vim.cmd("colorscheme catppuccin")
		end,
	},
}
