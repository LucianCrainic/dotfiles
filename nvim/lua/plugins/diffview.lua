return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      commit_log_panel = {
        win_config = {
          win_opts = {},
        },
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {
        diff_buf_read = function(bufnr)
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.relativenumber = false
        end,
      },
      keymaps = {
        disable_defaults = false,
        view = {
          {
            "n",
            "<tab>",
            function()
              require("diffview.actions").select_next_entry()
            end,
            { desc = "Open next file" },
          },
          {
            "n",
            "<s-tab>",
            function()
              require("diffview.actions").select_prev_entry()
            end,
            { desc = "Open previous file" },
          },
          {
            "n",
            "gf",
            function()
              require("diffview.actions").goto_file()
            end,
            { desc = "Open file in a new split" },
          },
          {
            "n",
            "<C-w><C-f>",
            function()
              require("diffview.actions").goto_file_split()
            end,
            { desc = "Open file in a new split" },
          },
          {
            "n",
            "<C-w>gf",
            function()
              require("diffview.actions").goto_file_tab()
            end,
            { desc = "Open file in a new tab" },
          },
          {
            "n",
            "<leader>e",
            function()
              require("diffview.actions").focus_files()
            end,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>b",
            function()
              require("diffview.actions").toggle_files()
            end,
            { desc = "Toggle the file panel" },
          },
          {
            "n",
            "g<C-x>",
            function()
              require("diffview.actions").cycle_layout()
            end,
            { desc = "Cycle through available layouts" },
          },
          {
            "n",
            "[x",
            function()
              require("diffview.actions").prev_conflict()
            end,
            { desc = "Go to previous conflict" },
          },
          {
            "n",
            "]x",
            function()
              require("diffview.actions").next_conflict()
            end,
            { desc = "Go to next conflict" },
          },
        },
        diff1 = {},
        diff2 = {},
        diff3 = {
          {
            { "n", "x" },
            "2do",
            function()
              require("diffview.actions").diffget("ours")
            end,
            { desc = "Obtain diff hunk from the OURS version" },
          },
          {
            { "n", "x" },
            "3do",
            function()
              require("diffview.actions").diffget("theirs")
            end,
            { desc = "Obtain diff hunk from the THEIRS version" },
          },
        },
        diff4 = {
          {
            { "n", "x" },
            "1do",
            function()
              require("diffview.actions").diffget("base")
            end,
            { desc = "Obtain diff hunk from the BASE version" },
          },
          {
            { "n", "x" },
            "2do",
            function()
              require("diffview.actions").diffget("ours")
            end,
            { desc = "Obtain diff hunk from the OURS version" },
          },
          {
            { "n", "x" },
            "3do",
            function()
              require("diffview.actions").diffget("theirs")
            end,
            { desc = "Obtain diff hunk from the THEIRS version" },
          },
        },
        file_panel = {
          {
            "n",
            "j",
            function()
              require("diffview.actions").next_entry()
            end,
            { desc = "Bring cursor to next file entry" },
          },
          {
            "n",
            "<down>",
            function()
              require("diffview.actions").next_entry()
            end,
            { desc = "Bring cursor to next file entry" },
          },
          {
            "n",
            "k",
            function()
              require("diffview.actions").prev_entry()
            end,
            { desc = "Bring cursor to previous file entry" },
          },
          {
            "n",
            "<up>",
            function()
              require("diffview.actions").prev_entry()
            end,
            { desc = "Bring cursor to previous file entry" },
          },
          {
            "n",
            "<cr>",
            function()
              require("diffview.actions").select_entry()
            end,
            { desc = "Open diff for the selected entry" },
          },
          {
            "n",
            "o",
            function()
              require("diffview.actions").select_entry()
            end,
            { desc = "Open diff for the selected entry" },
          },
          {
            "n",
            "<2-LeftMouse>",
            function()
              require("diffview.actions").select_entry()
            end,
            { desc = "Open diff for the selected entry" },
          },
          {
            "n",
            "-",
            function()
              require("diffview.actions").toggle_stage_entry()
            end,
            { desc = "Stage/unstage the selected entry" },
          },
          {
            "n",
            "S",
            function()
              require("diffview.actions").stage_all()
            end,
            { desc = "Stage all entries" },
          },
          {
            "n",
            "U",
            function()
              require("diffview.actions").unstage_all()
            end,
            { desc = "Unstage all entries" },
          },
          {
            "n",
            "X",
            function()
              require("diffview.actions").restore_entry()
            end,
            { desc = "Restore entry to the state on the left side" },
          },
          {
            "n",
            "L",
            function()
              require("diffview.actions").open_commit_log()
            end,
            { desc = "Open commit log panel" },
          },
          {
            "n",
            "zo",
            function()
              require("diffview.actions").open_fold()
            end,
            { desc = "Expand fold" },
          },
          {
            "n",
            "h",
            function()
              require("diffview.actions").close_fold()
            end,
            { desc = "Collapse fold" },
          },
          {
            "n",
            "zc",
            function()
              require("diffview.actions").close_fold()
            end,
            { desc = "Collapse fold" },
          },
          {
            "n",
            "za",
            function()
              require("diffview.actions").toggle_fold()
            end,
            { desc = "Toggle fold" },
          },
          {
            "n",
            "zR",
            function()
              require("diffview.actions").open_all_folds()
            end,
            { desc = "Expand all folds" },
          },
          {
            "n",
            "zM",
            function()
              require("diffview.actions").close_all_folds()
            end,
            { desc = "Collapse all folds" },
          },
          {
            "n",
            "<c-b>",
            function()
              require("diffview.actions").scroll_view(-0.25)
            end,
            { desc = "Scroll the view up" },
          },
          {
            "n",
            "<c-f>",
            function()
              require("diffview.actions").scroll_view(0.25)
            end,
            { desc = "Scroll the view down" },
          },
          {
            "n",
            "<tab>",
            function()
              require("diffview.actions").select_next_entry()
            end,
            { desc = "Open diff for next file" },
          },
          {
            "n",
            "<s-tab>",
            function()
              require("diffview.actions").select_prev_entry()
            end,
            { desc = "Open diff for previous file" },
          },
          {
            "n",
            "gf",
            function()
              require("diffview.actions").goto_file()
            end,
            { desc = "Open file in previous tabpage" },
          },
          {
            "n",
            "<C-w><C-f>",
            function()
              require("diffview.actions").goto_file_split()
            end,
            { desc = "Open file in a new split" },
          },
          {
            "n",
            "<C-w>gf",
            function()
              require("diffview.actions").goto_file_tab()
            end,
            { desc = "Open file in a new tab" },
          },
          {
            "n",
            "i",
            function()
              require("diffview.actions").listing_style()
            end,
            { desc = "Toggle between list and tree style" },
          },
          {
            "n",
            "f",
            function()
              require("diffview.actions").toggle_flatten_dirs()
            end,
            { desc = "Flatten empty subdirectories in tree listing style" },
          },
          {
            "n",
            "R",
            function()
              require("diffview.actions").refresh_files()
            end,
            { desc = "Update stats and entries in the file list" },
          },
          {
            "n",
            "<leader>e",
            function()
              require("diffview.actions").focus_files()
            end,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>b",
            function()
              require("diffview.actions").toggle_files()
            end,
            { desc = "Toggle the file panel" },
          },
          {
            "n",
            "g<C-x>",
            function()
              require("diffview.actions").cycle_layout()
            end,
            { desc = "Cycle through available layouts" },
          },
          {
            "n",
            "[x",
            function()
              require("diffview.actions").prev_conflict()
            end,
            { desc = "In the merge tool: jump to previous conflict" },
          },
          {
            "n",
            "]x",
            function()
              require("diffview.actions").next_conflict()
            end,
            { desc = "In the merge tool: jump to next conflict" },
          },
        },
        file_history_panel = {
          {
            "n",
            "g!",
            function()
              require("diffview.actions").options()
            end,
            { desc = "Open option panel" },
          },
          {
            "n",
            "<C-A-d>",
            function()
              require("diffview.actions").open_in_diffview()
            end,
            { desc = "Open commit in diffview" },
          },
          {
            "n",
            "y",
            function()
              require("diffview.actions").copy_hash()
            end,
            { desc = "Copy commit hash" },
          },
          {
            "n",
            "L",
            function()
              require("diffview.actions").open_commit_log()
            end,
            { desc = "Show commit details" },
          },
          {
            "n",
            "zR",
            function()
              require("diffview.actions").open_all_folds()
            end,
            { desc = "Expand all folds" },
          },
          {
            "n",
            "zM",
            function()
              require("diffview.actions").close_all_folds()
            end,
            { desc = "Collapse all folds" },
          },
          {
            "n",
            "j",
            function()
              require("diffview.actions").next_entry()
            end,
            { desc = "Bring cursor to next file entry" },
          },
          {
            "n",
            "<down>",
            function()
              require("diffview.actions").next_entry()
            end,
            { desc = "Bring cursor to next file entry" },
          },
          {
            "n",
            "k",
            function()
              require("diffview.actions").prev_entry()
            end,
            { desc = "Bring cursor to previous file entry" },
          },
          {
            "n",
            "<up>",
            function()
              require("diffview.actions").prev_entry()
            end,
            { desc = "Bring cursor to previous file entry" },
          },
          {
            "n",
            "<cr>",
            function()
              require("diffview.actions").select_entry()
            end,
            { desc = "Open diff for the selected entry" },
          },
          {
            "n",
            "o",
            function()
              require("diffview.actions").select_entry()
            end,
            { desc = "Open diff for the selected entry" },
          },
          {
            "n",
            "<2-LeftMouse>",
            function()
              require("diffview.actions").select_entry()
            end,
            { desc = "Open diff for the selected entry" },
          },
          {
            "n",
            "<c-b>",
            function()
              require("diffview.actions").scroll_view(-0.25)
            end,
            { desc = "Scroll the view up" },
          },
          {
            "n",
            "<c-f>",
            function()
              require("diffview.actions").scroll_view(0.25)
            end,
            { desc = "Scroll the view down" },
          },
          {
            "n",
            "<tab>",
            function()
              require("diffview.actions").select_next_entry()
            end,
            { desc = "Open diff for next file" },
          },
          {
            "n",
            "<s-tab>",
            function()
              require("diffview.actions").select_prev_entry()
            end,
            { desc = "Open diff for previous file" },
          },
          {
            "n",
            "gf",
            function()
              require("diffview.actions").goto_file()
            end,
            { desc = "Open file in previous tabpage" },
          },
          {
            "n",
            "<C-w><C-f>",
            function()
              require("diffview.actions").goto_file_split()
            end,
            { desc = "Open file in a new split" },
          },
          {
            "n",
            "<C-w>gf",
            function()
              require("diffview.actions").goto_file_tab()
            end,
            { desc = "Open file in a new tab" },
          },
          {
            "n",
            "<leader>e",
            function()
              require("diffview.actions").focus_files()
            end,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>b",
            function()
              require("diffview.actions").toggle_files()
            end,
            { desc = "Toggle the file panel" },
          },
          {
            "n",
            "g<C-x>",
            function()
              require("diffview.actions").cycle_layout()
            end,
            { desc = "Cycle through available layouts" },
          },
        },
        option_panel = {
          {
            "n",
            "<tab>",
            function()
              require("diffview.actions").select()
            end,
            { desc = "Change selection" },
          },
          {
            "n",
            "q",
            function()
              require("diffview.actions").close()
            end,
            { desc = "Close option panel" },
          },
        },
        help_panel = {
          {
            "n",
            "q",
            function()
              require("diffview.actions").close()
            end,
            { desc = "Close help panel" },
          },
        },
      },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings or {}
      maps.n = maps.n or {}

      -- Diffview specific mappings with which-key group
      maps.n["<Leader>gd"] = { desc = "Diffview" }

      maps.n["<Leader>gdo"] = {
        "<Cmd>DiffviewOpen<CR>",
        desc = "Open Diffview",
      }

      maps.n["<Leader>gdc"] = {
        "<Cmd>DiffviewClose<CR>",
        desc = "Close Diffview",
      }

      maps.n["<Leader>gdh"] = {
        "<Cmd>DiffviewFileHistory<CR>",
        desc = "File History",
      }

      maps.n["<Leader>gdH"] = {
        "<Cmd>DiffviewFileHistory %<CR>",
        desc = "Current File History",
      }

      maps.n["<Leader>gdt"] = {
        "<Cmd>DiffviewToggleFiles<CR>",
        desc = "Toggle Files Panel",
      }

      maps.n["<Leader>gdf"] = {
        "<Cmd>DiffviewFocusFiles<CR>",
        desc = "Focus Files Panel",
      }

      maps.n["<Leader>gdr"] = {
        "<Cmd>DiffviewRefresh<CR>",
        desc = "Refresh Diffview",
      }

      -- Git range selection for diffview
      maps.n["<Leader>gdm"] = {
        "<Cmd>DiffviewOpen origin/main...HEAD<CR>",
        desc = "Compare with origin/main",
      }

      maps.n["<Leader>gds"] = {
        "<Cmd>DiffviewOpen --staged<CR>",
        desc = "Staged changes",
      }

      return opts
    end,
  },
}
