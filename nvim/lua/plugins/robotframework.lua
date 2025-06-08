-- Robot Framework support plugin
return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Extend the existing mappings
      local maps = opts.mappings or {}
      maps.n = maps.n or {}
      
      -- Robot Framework specific mappings
      maps.n["<Leader>r"] = { desc = "🤖 Robot Framework" }
      
      maps.n["<Leader>rt"] = {
        function()
          local function run_robot_test()
            local current_file = vim.fn.expand("%:p")
            local file_extension = vim.fn.expand("%:e")
            
            -- Check if current file is a Robot Framework file
            if file_extension ~= "robot" and file_extension ~= "resource" then
              vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
              return
            end
            
            -- Get current line number and search for test case
            local current_line = vim.fn.line(".")
            local lines = vim.fn.getline(1, "$")
            local test_name = nil
            
            -- Search backwards from current line to find the test case name
            for i = current_line, 1, -1 do
              local line = lines[i]
              -- Robot Framework test cases typically start with alphanumeric characters
              -- and don't start with spaces, keywords like "Documentation", "Tags", etc.
              if line:match("^[%w]") and 
                 not line:match("^%s") and 
                 not line:match("^Documentation") and
                 not line:match("^Tags") and
                 not line:match("^Setup") and
                 not line:match("^Teardown") and
                 not line:match("^Template") and
                 not line:match("^Timeout") and
                 not line:match("^%*%*%*") and
                 not line:match("^Library") and
                 not line:match("^Resource") and
                 not line:match("^Variables") and
                 line:gsub("%s+", "") ~= "" then
                test_name = line:gsub("%s+$", "")  -- trim trailing spaces
                break
              end
            end
            
            if not test_name then
              vim.notify("Could not find test case name", vim.log.levels.WARN)
              return
            end
            
            -- Build the robot command with better output formatting
            local output_dir = vim.fn.expand("%:p:h") .. "/results"
            local cmd = string.format('robot -d "%s" -t "%s" "%s"', output_dir, test_name, current_file)
            
            -- Create results directory if it doesn't exist
            vim.fn.mkdir(output_dir, "p")
            
            -- Run the command in a new terminal buffer
            vim.cmd("split")
            vim.cmd("terminal " .. cmd)
            vim.cmd("startinsert")
            
            vim.notify(string.format("Running test: %s", test_name), vim.log.levels.INFO)
          end
          
          run_robot_test()
        end,
        desc = "🚀 Run current Robot Framework test case",
      }
      
      maps.n["<Leader>rf"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          local output_dir = vim.fn.expand("%:p:h") .. "/results"
          local cmd = string.format('robot -d "%s" "%s"', output_dir, current_file)
          
          -- Create results directory if it doesn't exist
          vim.fn.mkdir(output_dir, "p")
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Running all tests in file", vim.log.levels.INFO)
        end,
        desc = "📄 Run all Robot Framework tests in current file",
      }
      
      maps.n["<Leader>rd"] = {
        function()
          local current_dir = vim.fn.expand("%:p:h")
          local output_dir = current_dir .. "/results"
          local cmd = string.format('robot -d "%s" "%s"', output_dir, current_dir)
          
          -- Create results directory if it doesn't exist
          vim.fn.mkdir(output_dir, "p")
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify("Running all tests in directory", vim.log.levels.INFO)
        end,
        desc = "📁 Run all Robot Framework tests in current directory",
      }
      
      maps.n["<Leader>rs"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          -- Get current line and search for test case with tags
          local current_line = vim.fn.line(".")
          local lines = vim.fn.getline(1, "$")
          local test_name = nil
          local tags = {}
          
          -- Search backwards from current line to find the test case
          for i = current_line, 1, -1 do
            local line = lines[i]
            if line:match("^[%w]") and not line:match("^%s") and
               not line:match("^Documentation") and not line:match("^Tags") and
               not line:match("^Setup") and not line:match("^Teardown") and
               not line:match("^Template") and not line:match("^Timeout") and
               not line:match("^%*%*%*") and line:gsub("%s+", "") ~= "" then
              test_name = line:gsub("%s+$", "")
              
              -- Look for tags in the following lines
              for j = i + 1, math.min(i + 10, #lines) do
                local tag_line = lines[j]
                if tag_line:match("^%s+%[Tags%]") or tag_line:match("^%s+Tags") then
                  local tag_content = tag_line:gsub("^%s+%[Tags%]", ""):gsub("^%s+Tags", ""):gsub("^%s+", "")
                  for tag in tag_content:gmatch("%S+") do
                    table.insert(tags, tag)
                  end
                  break
                elseif tag_line:match("^[%w]") and not tag_line:match("^%s") then
                  break  -- Found next test case
                end
              end
              break
            end
          end
          
          if not test_name then
            vim.notify("Could not find test case name", vim.log.levels.WARN)
            return
          end
          
          local output_dir = vim.fn.expand("%:p:h") .. "/results"
          local cmd = string.format('robot -d "%s" --dryrun -t "%s" "%s"', output_dir, test_name, current_file)
          
          vim.fn.mkdir(output_dir, "p")
          
          vim.cmd("split")
          vim.cmd("terminal " .. cmd)
          vim.cmd("startinsert")
          
          vim.notify(string.format("Dry run for test: %s", test_name), vim.log.levels.INFO)
        end,
        desc = "🧪 Dry run current Robot Framework test case",
      }
      
      -- Set up Robot Framework file type detection and syntax
      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"*.robot", "*.resource"},
        callback = function()
          vim.bo.filetype = "robot"
          vim.bo.commentstring = "# %s"
        end,
      })
      
      opts.mappings = maps
      return opts
    end,
  },
}
