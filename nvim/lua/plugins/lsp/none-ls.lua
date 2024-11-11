return {
	"nvimtools/none-ls.nvim",
	event = "BufReadPost",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local null_ls_utils = require("null-ls.utils")

		local mason_null_ls = require("mason-null-ls")
		mason_null_ls.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"shfmt",
				"shellcheck", -- bashls automatically uses
				"isort",
				"black",
				-- "pylint",
				-- "eslint",
			},
		})

		local formatting = null_ls.builtins.formatting
		-- local diagnostics = null_ls.builtins.diagnostics

		-- setup Format on Save
		-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			-- add package.json as identifier for root (for typescript monorepos)
			root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
			sources = {
				formatting.google_java_format,
				formatting.gofmt,
				formatting.clang_format,
				formatting.stylua,
				formatting.shfmt,
				formatting.isort,
				formatting.black,
				-- diagnostics.pylint,
			},
		})
	end,
}
