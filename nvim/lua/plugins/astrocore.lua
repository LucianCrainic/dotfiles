return {
  "AstroNvim/astrocore",
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = false, -- highlight URLs at start
      notifications = false,
    },
  
    diagnostics = {
      virtual_text = {
        enabled = true, -- enable virtual text
        source = "if_many", -- show source when there are multiple diagnostics
        spacing = 4, -- number of spaces after diagnostics text and before virtual text
        prefix = "●", -- prefix for virtual text
        severity = { min = vim.diagnostic.severity.HINT }, -- show all severities including hints
      },
      underline = true,
      signs = true, -- enable signs in the sign column
      update_in_insert = false, -- don't update diagnostics while in insert mode
      severity_sort = true, -- sort diagnostics by severity
    },
   
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
      },
    },
    
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

      },
    },
  },
}
