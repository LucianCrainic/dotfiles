return {
  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Extend the existing mappings
      local maps = opts.mappings or {}
      maps.n = maps.n or {}
      
      -- Harpoon specific mappings with which-key group
      maps.n["<Leader>h"] = { desc = "Harpoon" }
      
      maps.n["<Leader>ha"] = {
        function() 
          require("harpoon"):list():append() 
        end,
        desc = "Add file to harpoon",
      }
      
      maps.n["<Leader>hm"] = {
        function() 
          local harpoon = require("harpoon") 
          harpoon.ui:toggle_quick_menu(harpoon:list()) 
        end,
        desc = "Toggle harpoon menu",
      }
      
      maps.n["<Leader>h1"] = {
        function() 
          require("harpoon"):list():select(1) 
        end,
        desc = "Go to harpoon file 1",
      }
      
      maps.n["<Leader>h2"] = {
        function() 
          require("harpoon"):list():select(2) 
        end,
        desc = "Go to harpoon file 2",
      }
      
      maps.n["<Leader>h3"] = {
        function() 
          require("harpoon"):list():select(3) 
        end,
        desc = "Go to harpoon file 3",
      }
      
      maps.n["<Leader>h4"] = {
        function() 
          require("harpoon"):list():select(4) 
        end,
        desc = "Go to harpoon file 4",
      }
      
      maps.n["<Leader>h5"] = {
        function() 
          require("harpoon"):list():select(5) 
        end,
        desc = "Go to harpoon file 5",
      }
      
      maps.n["<Leader>hn"] = {
        function() 
          require("harpoon"):list():next() 
        end,
        desc = "Next harpoon file",
      }
      
      maps.n["<Leader>hp"] = {
        function() 
          require("harpoon"):list():prev() 
        end,
        desc = "Previous harpoon file",
      }
      
      opts.mappings = maps
      return opts
    end,
  },
}
