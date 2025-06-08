return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings or {}
      maps.n = maps.n or {}
      
      -- Telescope file search with split options
      maps.n["<Leader>f"] = { desc = "Find" }
      
      -- Find files and open in split
      maps.n["<Leader>fs"] = {
        function()
          require("telescope.builtin").find_files({
            attach_mappings = function(_, map)
              -- Open in vertical split to the right
              map("i", "<C-v>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("vsplit " .. selection.path)
              end)
              -- Open in horizontal split below
              map("i", "<C-x>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("split " .. selection.path)
              end)
              return true
            end,
          })
        end,
        desc = "Find files with split options",
      }
      
      -- Quick split right after file search
      maps.n["<Leader>fv"] = {
        function()
          require("telescope.builtin").find_files({
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("vsplit " .. selection.path)
              end)
              return true
            end,
          })
        end,
        desc = "Find files and open in vertical split",
      }
      
      -- Quick split below after file search
      maps.n["<Leader>fx"] = {
        function()
          require("telescope.builtin").find_files({
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("split " .. selection.path)
              end)
              return true
            end,
          })
        end,
        desc = "Find files and open in horizontal split",
      }

      -- Basic live grep (word search)
      maps.n["<Leader>fw"] = {
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Find words (live grep)",
      }

      -- Live grep with split options
      maps.n["<Leader>fws"] = {
        function()
          require("telescope.builtin").live_grep({
            attach_mappings = function(_, map)
              -- Open in vertical split to the right
              map("i", "<C-v>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("vsplit " .. vim.fn.fnameescape(selection.filename))
                -- Set cursor position after a small delay to ensure file is loaded
                vim.schedule(function()
                  vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col - 1})
                end)
              end)
              -- Open in horizontal split below
              map("i", "<C-x>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("split " .. vim.fn.fnameescape(selection.filename))
                -- Set cursor position after a small delay to ensure file is loaded
                vim.schedule(function()
                  vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col - 1})
                end)
              end)
              return true
            end,
          })
        end,
        desc = "Find words with split options",
      }

      -- Quick grep with vertical split
      maps.n["<Leader>fwv"] = {
        function()
          require("telescope.builtin").live_grep({
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("vsplit " .. vim.fn.fnameescape(selection.filename))
                -- Set cursor position after a small delay to ensure file is loaded
                vim.schedule(function()
                  vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col - 1})
                end)
              end)
              return true
            end,
          })
        end,
        desc = "Find words and open in vertical split",
      }

      -- Quick grep with horizontal split
      maps.n["<Leader>fwx"] = {
        function()
          require("telescope.builtin").live_grep({
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("split " .. vim.fn.fnameescape(selection.filename))
                -- Set cursor position after a small delay to ensure file is loaded
                vim.schedule(function()
                  vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col - 1})
                end)
              end)
              return true
            end,
          })
        end,
        desc = "Find words and open in horizontal split",
      }

      -- Buffer search with split options
      maps.n["<Leader>fbs"] = {
        function()
          require("telescope.builtin").buffers({
            attach_mappings = function(_, map)
              -- Open in vertical split to the right
              map("i", "<C-v>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("vsplit | buffer " .. selection.bufnr)
              end)
              -- Open in horizontal split below
              map("i", "<C-x>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("split | buffer " .. selection.bufnr)
              end)
              return true
            end,
          })
        end,
        desc = "Find buffers with split options",
      }

      -- Find references of the symbol under cursor
      maps.n["<Leader>fr"] = {
        function()
          require("telescope.builtin").lsp_references()
        end,
        desc = "Find references",
      }

      -- Find references with split options
      maps.n["<Leader>frs"] = {
        function()
          require("telescope.builtin").lsp_references({
            attach_mappings = function(_, map)
              -- Open in vertical split to the right
              map("i", "<C-v>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("vsplit " .. vim.fn.fnameescape(selection.filename))
                -- Set cursor position after a small delay to ensure file is loaded
                vim.schedule(function()
                  vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col})
                end)
              end)
              -- Open in horizontal split below
              map("i", "<C-x>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("split " .. vim.fn.fnameescape(selection.filename))
                -- Set cursor position after a small delay to ensure file is loaded
                vim.schedule(function()
                  vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col})
                end)
              end)
              return true
            end,
          })
        end,
        desc = "Find references with split options",
      }

      -- Quick references with vertical split
      maps.n["<Leader>frv"] = {
        function()
          require("telescope.builtin").lsp_references({
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("vsplit " .. vim.fn.fnameescape(selection.filename))
                -- Set cursor position after a small delay to ensure file is loaded
                vim.schedule(function()
                  vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col})
                end)
              end)
              return true
            end,
          })
        end,
        desc = "Find references and open in vertical split",
      }

      -- Quick references with horizontal split
      maps.n["<Leader>frx"] = {
        function()
          require("telescope.builtin").lsp_references({
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("split " .. vim.fn.fnameescape(selection.filename))
                -- Set cursor position after a small delay to ensure file is loaded
                vim.schedule(function()
                  vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col})
                end)
              end)
              return true
            end,
          })
        end,
        desc = "Find references and open in horizontal split",
      }

      -- Additional LSP-related telescope mappings
      maps.n["<Leader>fd"] = {
        function()
          require("telescope.builtin").lsp_definitions()
        end,
        desc = "Find definitions",
      }

      maps.n["<Leader>fi"] = {
        function()
          require("telescope.builtin").lsp_implementations()
        end,
        desc = "Find implementations",
      }

      maps.n["<Leader>ft"] = {
        function()
          require("telescope.builtin").lsp_type_definitions()
        end,
        desc = "Find type definitions",
      }

      -- Resume last telescope search
      maps.n["<Leader>f."] = {
        function()
          require("telescope.builtin").resume()
        end,
        desc = "Resume last telescope search",
      }

      opts.mappings = maps
      return opts
    end,
  },
}
