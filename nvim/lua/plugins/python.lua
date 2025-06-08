-- Python support and shortcuts
return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Extend the existing mappings
      local maps = opts.mappings or {}
      maps.n = maps.n or {}
      
      -- Python specific mappings with which-key group
      maps.n["<Leader>p"] = { desc = "🐍 Python" }
      
      maps.n["<Leader>pr"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          -- Check if current file is a Python file
          if file_extension ~= "py" then
            vim.notify("Not a Python file", vim.log.levels.WARN)
            return
          end
          
          -- Run the current Python file
          local cmd = string.format('python "%s"', current_file)
          
          -- Run the command in a new terminal buffer
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify(string.format("Running Python file: %s", vim.fn.expand("%:t")), vim.log.levels.INFO)
        end,
        desc = "🚀 Run current Python file",
      }
      
      maps.n["<Leader>pi"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "py" then
            vim.notify("Not a Python file", vim.log.levels.WARN)
            return
          end
          
          -- Run Python file in interactive mode
          local cmd = string.format('python -i "%s"', current_file)
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Running Python file in interactive mode", vim.log.levels.INFO)
        end,
        desc = "💬 Run Python file in interactive mode",
      }
      
      maps.n["<Leader>pt"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "py" then
            vim.notify("Not a Python file", vim.log.levels.WARN)
            return
          end
          
          -- Run Python tests using pytest
          local cmd = string.format('python -m pytest "%s" -v', current_file)
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Running pytest on current file", vim.log.levels.INFO)
        end,
        desc = "🧪 Run pytest on current file",
      }
      
      maps.n["<Leader>pd"] = {
        function()
          local current_dir = vim.fn.expand("%:p:h")
          
          -- Run all Python tests in current directory
          local cmd = string.format('cd "%s" && python -m pytest . -v', current_dir)
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Running all tests in current directory", vim.log.levels.INFO)
        end,
        desc = "📁 Run all tests in current directory",
      }
      
      maps.n["<Leader>pc"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "py" then
            vim.notify("Not a Python file", vim.log.levels.WARN)
            return
          end
          
          -- Check Python syntax
          local cmd = string.format('python -m py_compile "%s"', current_file)
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Checking Python syntax", vim.log.levels.INFO)
        end,
        desc = "✅ Check Python syntax",
      }
      
      maps.n["<Leader>pf"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "py" then
            vim.notify("Not a Python file", vim.log.levels.WARN)
            return
          end
          
          -- Format Python file with black (if available)
          local cmd = string.format('black "%s"', current_file)
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Formatting Python file with black", vim.log.levels.INFO)
        end,
        desc = "🎨 Format Python file with black",
      }
      
      maps.n["<Leader>pl"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "py" then
            vim.notify("Not a Python file", vim.log.levels.WARN)
            return
          end
          
          -- Lint Python file with flake8 (if available)
          local cmd = string.format('flake8 "%s"', current_file)
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Linting Python file with flake8", vim.log.levels.INFO)
        end,
        desc = "🔍 Lint Python file with flake8",
      }
      
      maps.n["<Leader>pv"] = {
        function()
          -- Show current Python version and virtual environment
          local cmd = "python --version && echo 'Virtual Environment:' && echo $VIRTUAL_ENV"
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Showing Python version and virtual environment", vim.log.levels.INFO)
        end,
        desc = "📋 Show Python version and virtual environment",
      }
      
      maps.n["<Leader>ps"] = {
        function()
          vim.cmd("VenvSelect")
        end,
        desc = "🔄 Select Python virtual environment",
      }
      
      maps.n["<Leader>pa"] = {
        function()
          vim.cmd("VenvSelectCached")
        end,
        desc = "⚡ Activate cached virtual environment",
      }
      
      maps.n["<Leader>pm"] = {
        function()
          -- Open Python REPL
          vim.cmd("split")
          vim.cmd("terminal python")
          vim.cmd("startinsert")
          
          vim.notify("Opening Python REPL", vim.log.levels.INFO)
        end,
        desc = "🔧 Open Python REPL",
      }
      
      opts.mappings = maps
      return opts
    end,
  },
}
