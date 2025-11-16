-- Function to detect Python executable
local function get_python_executable()
  -- Check for virtual environment
  local venv = os.getenv("VIRTUAL_ENV")
  if venv then
    return venv .. "/bin/python"
  end
  
  -- Check for conda environment
  local conda_env = os.getenv("CONDA_DEFAULT_ENV")
  if conda_env then
    local conda_prefix = os.getenv("CONDA_PREFIX")
    if conda_prefix then
      return conda_prefix .. "/bin/python"
    end
  end
  
  -- Check for pyenv
  local pyenv_version = vim.fn.system("pyenv version-name 2>/dev/null"):gsub("\n", "")
  if pyenv_version and pyenv_version ~= "" then
    local pyenv_root = os.getenv("PYENV_ROOT") or (os.getenv("HOME") .. "/.pyenv")
    return pyenv_root .. "/versions/" .. pyenv_version .. "/bin/python"
  end
  
  -- Default to system python
  return "python3"
end

-- Robot Framework support plugin
return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Extend the existing mappings
      local maps = opts.mappings or {}
      maps.n = maps.n or {}
      
      -- Robot Framework specific mappings
      maps.n["<Leader>r"] = { desc = "Robot Framework" }
      
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
        desc = "Run current Robot Framework test case",
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
        desc = "Run all Robot Framework tests in current file",
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
        desc = "Run all Robot Framework tests in current directory",
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
        desc = "Dry run current Robot Framework test case",
      }
      
      maps.n["<Leader>rl"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          local output_dir = vim.fn.expand("%:p:h") .. "/results"
          local log_file = output_dir .. "/log.html"
          
          -- Check if log file exists
          if vim.fn.filereadable(log_file) == 0 then
            vim.notify("Log file not found: " .. log_file .. "\nRun a test first to generate the log.", vim.log.levels.WARN)
            return
          end
          
          -- Open log file in default browser (macOS)
          local cmd = "open " .. vim.fn.shellescape(log_file)
          vim.fn.system(cmd)
          
          vim.notify("Opening log file in browser: " .. log_file, vim.log.levels.INFO)
        end,
        desc = "Open Robot Framework log file in browser",
      }

      maps.n["<Leader>rzf"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          -- Save current cursor position
          local cursor_pos = vim.fn.getpos(".")
          
          -- First, unfold everything to start fresh
          vim.cmd("normal! zR")
          
          local folded_count = 0
          local lines = vim.fn.getline(1, "$")
          local doc_ranges = {}
          
          -- First pass: Find all documentation sections
          for i, line in ipairs(lines) do
            -- Match documentation lines (case insensitive)
            if line:match("^%s*Documentation") or line:match("^%s*DOCUMENTATION") or 
               line:match("^%s*%[Documentation%]") or line:match("^%s*%[DOCUMENTATION%]") then
              
              -- Find the end of the documentation section
              local doc_end = i
              for j = i + 1, #lines do
                local next_line = lines[j]
                -- Documentation continues if line starts with "..." or is indented continuation
                if next_line:match("^%s*%.%.%.") or 
                   (next_line:match("^%s+") and not next_line:match("^%s*$") and 
                    not next_line:match("^%s*%[") and not next_line:match("^%s*Tags") and
                    not next_line:match("^%s*Setup") and not next_line:match("^%s*Teardown") and
                    not next_line:match("^%s*Template") and not next_line:match("^%s*Timeout")) then
                  doc_end = j
                else
                  break
                end
              end
              
              -- Store the range if it spans multiple lines
              if doc_end > i then
                table.insert(doc_ranges, {start = i, finish = doc_end})
              end
            end
          end
          
          -- Second pass: Create folds in reverse order to avoid line number shifts
          for k = #doc_ranges, 1, -1 do
            local range = doc_ranges[k]
            -- Go to the start of the documentation
            vim.fn.cursor(range.start, 1)
            -- Select the range
            vim.cmd("normal! V")
            vim.fn.cursor(range.finish, vim.fn.col("$"))
            -- Create the fold
            vim.cmd("normal! zf")
            folded_count = folded_count + 1
          end
          
          -- Restore cursor position
          vim.fn.setpos(".", cursor_pos)
          
          vim.notify(string.format("Folded %d documentation section(s)", folded_count), vim.log.levels.INFO)
        end,
        desc = "Fold all documentation sections",
      }

      maps.n["<Leader>rzu"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          -- Unfold all folds in the current buffer
          vim.cmd("normal! zR")
          vim.notify("Unfolded all sections", vim.log.levels.INFO)
        end,
        desc = "Unfold all sections",
      }

      -- Fold all test cases
      maps.n["<Leader>rzt"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          local cursor_pos = vim.fn.getpos(".")
          vim.cmd("normal! zR") -- Unfold everything first
          
          local folded_count = 0
          local lines = vim.fn.getline(1, "$")
          local test_ranges = {}
          local in_test_section = false
          
          -- Find test cases section and individual test cases
          for i, line in ipairs(lines) do
            -- Check if we're entering test cases section
            if line:match("^%*%*%*%s*Test Cases%s*%*%*%*") or line:match("^%*%*%*%s*TEST CASES%s*%*%*%*") then
              in_test_section = true
            elseif line:match("^%*%*%*.*%*%*%*") then
              in_test_section = false
            elseif in_test_section and line:match("^[%w]") and not line:match("^%s") then
              -- This is a test case name
              local test_start = i
              local test_end = i
              
              -- Find the end of this test case
              for j = i + 1, #lines do
                local next_line = lines[j]
                -- Test case ends when we hit another test case, section, or EOF
                if next_line:match("^[%w]") and not next_line:match("^%s") and not next_line:match("^%*%*%*") then
                  test_end = j - 1
                  break
                elseif next_line:match("^%*%*%*") then
                  test_end = j - 1
                  break
                elseif j == #lines then
                  test_end = j
                  break
                end
              end
              
              if test_end > test_start then
                table.insert(test_ranges, {start = test_start, finish = test_end})
              end
            end
          end
          
          -- Create folds in reverse order
          for k = #test_ranges, 1, -1 do
            local range = test_ranges[k]
            vim.fn.cursor(range.start, 1)
            vim.cmd("normal! V")
            vim.fn.cursor(range.finish, vim.fn.col("$"))
            vim.cmd("normal! zf")
            folded_count = folded_count + 1
          end
          
          vim.fn.setpos(".", cursor_pos)
          vim.notify(string.format("Folded %d test case(s)", folded_count), vim.log.levels.INFO)
        end,
        desc = "Fold all test cases",
      }

      -- Fold all keywords
      maps.n["<Leader>rzk"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          local cursor_pos = vim.fn.getpos(".")
          vim.cmd("normal! zR") -- Unfold everything first
          
          local folded_count = 0
          local lines = vim.fn.getline(1, "$")
          local keyword_ranges = {}
          local in_keyword_section = false
          
          -- Find keywords section and individual keywords
          for i, line in ipairs(lines) do
            -- Check if we're entering keywords section
            if line:match("^%*%*%*%s*Keywords%s*%*%*%*") or line:match("^%*%*%*%s*KEYWORDS%s*%*%*%*") then
              in_keyword_section = true
            elseif line:match("^%*%*%*.*%*%*%*") then
              in_keyword_section = false
            elseif in_keyword_section and line:match("^[%w]") and not line:match("^%s") then
              -- This is a keyword name
              local keyword_start = i
              local keyword_end = i
              
              -- Find the end of this keyword
              for j = i + 1, #lines do
                local next_line = lines[j]
                -- Keyword ends when we hit another keyword, section, or EOF
                if next_line:match("^[%w]") and not next_line:match("^%s") and not next_line:match("^%*%*%*") then
                  keyword_end = j - 1
                  break
                elseif next_line:match("^%*%*%*") then
                  keyword_end = j - 1
                  break
                elseif j == #lines then
                  keyword_end = j
                  break
                end
              end
              
              if keyword_end > keyword_start then
                table.insert(keyword_ranges, {start = keyword_start, finish = keyword_end})
              end
            end
          end
          
          -- Create folds in reverse order
          for k = #keyword_ranges, 1, -1 do
            local range = keyword_ranges[k]
            vim.fn.cursor(range.start, 1)
            vim.cmd("normal! V")
            vim.fn.cursor(range.finish, vim.fn.col("$"))
            vim.cmd("normal! zf")
            folded_count = folded_count + 1
          end
          
          vim.fn.setpos(".", cursor_pos)
          vim.notify(string.format("Folded %d keyword(s)", folded_count), vim.log.levels.INFO)
        end,
        desc = "Fold all keywords",
      }

      -- Fold current test case or keyword
      maps.n["<Leader>rzc"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          local current_line = vim.fn.line(".")
          local lines = vim.fn.getline(1, "$")
          local item_name = nil
          local item_start = nil
          local item_end = nil
          
          -- First, find what section we're in
          local in_test_section = false
          local in_keyword_section = false
          
          for i = current_line, 1, -1 do
            local line = lines[i]
            if line:match("^%*%*%*%s*Test Cases%s*%*%*%*") or line:match("^%*%*%*%s*TEST CASES%s*%*%*%*") then
              in_test_section = true
              break
            elseif line:match("^%*%*%*%s*Keywords%s*%*%*%*") or line:match("^%*%*%*%s*KEYWORDS%s*%*%*%*") then
              in_keyword_section = true
              break
            elseif line:match("^%*%*%*.*%*%*%*") then
              break -- Found another section
            end
          end
          
          if not in_test_section and not in_keyword_section then
            vim.notify("Not in a test case or keyword section", vim.log.levels.WARN)
            return
          end
          
          -- Find the current test case or keyword
          for i = current_line, 1, -1 do
            local line = lines[i]
            if line:match("^[%w]") and not line:match("^%s") and not line:match("^%*%*%*") then
              item_name = line:gsub("%s+$", "")
              item_start = i
              
              -- Find the end of this item
              for j = i + 1, #lines do
                local next_line = lines[j]
                if next_line:match("^[%w]") and not next_line:match("^%s") and not next_line:match("^%*%*%*") then
                  item_end = j - 1
                  break
                elseif next_line:match("^%*%*%*") then
                  item_end = j - 1
                  break
                elseif j == #lines then
                  item_end = j
                  break
                end
              end
              break
            elseif line:match("^%*%*%*") then
              break -- Hit section boundary
            end
          end
          
          if not item_name or not item_start or not item_end or item_end <= item_start then
            vim.notify("Could not find test case or keyword to fold", vim.log.levels.WARN)
            return
          end
          
          -- Create the fold
          vim.fn.cursor(item_start, 1)
          vim.cmd("normal! V")
          vim.fn.cursor(item_end, vim.fn.col("$"))
          vim.cmd("normal! zf")
          
          local item_type = in_test_section and "test case" or "keyword"
          vim.notify(string.format("Folded %s: %s", item_type, item_name), vim.log.levels.INFO)
        end,
        desc = "Fold current test case or keyword",
      }

      -- Unfold current test case or keyword
      maps.n["<Leader>rzo"] = {
        function()
          local current_file = vim.fn.expand("%:p")
          local file_extension = vim.fn.expand("%:e")
          
          if file_extension ~= "robot" and file_extension ~= "resource" then
            vim.notify("Not a Robot Framework file", vim.log.levels.WARN)
            return
          end
          
          local current_line = vim.fn.line(".")
          local lines = vim.fn.getline(1, "$")
          local item_name = nil
          local item_start = nil
          
          -- First, find what section we're in
          local in_test_section = false
          local in_keyword_section = false
          
          for i = current_line, 1, -1 do
            local line = lines[i]
            if line:match("^%*%*%*%s*Test Cases%s*%*%*%*") or line:match("^%*%*%*%s*TEST CASES%s*%*%*%*") then
              in_test_section = true
              break
            elseif line:match("^%*%*%*%s*Keywords%s*%*%*%*") or line:match("^%*%*%*%s*KEYWORDS%s*%*%*%*") then
              in_keyword_section = true
              break
            elseif line:match("^%*%*%*.*%*%*%*") then
              break -- Found another section
            end
          end
          
          if not in_test_section and not in_keyword_section then
            vim.notify("Not in a test case or keyword section", vim.log.levels.WARN)
            return
          end
          
          -- Find the current test case or keyword
          for i = current_line, 1, -1 do
            local line = lines[i]
            if line:match("^[%w]") and not line:match("^%s") and not line:match("^%*%*%*") then
              item_name = line:gsub("%s+$", "")
              item_start = i
              break
            elseif line:match("^%*%*%*") then
              break -- Hit section boundary
            end
          end
          
          if not item_name or not item_start then
            vim.notify("Could not find test case or keyword to unfold", vim.log.levels.WARN)
            return
          end
          
          -- Go to the start of the item and open any folds
          vim.fn.cursor(item_start, 1)
          vim.cmd("normal! zo")
          
          local item_type = in_test_section and "test case" or "keyword"
          vim.notify(string.format("Unfolded %s: %s", item_type, item_name), vim.log.levels.INFO)
        end,
        desc = "Unfold current test case or keyword",
      }

      -- Set up Robot Framework file type detection and syntax
      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"*.robot", "*.resource"},
        callback = function()
          vim.bo.filetype = "robot"
          vim.bo.commentstring = "# %s"
          -- Disable code lenses for Robot Framework files
          vim.lsp.codelens.clear()
          vim.b.codelens_enabled = false
        end,
      })

      -- Disable code lenses globally for Robot Framework files
      vim.api.nvim_create_autocmd("LspAttach", {
        pattern = {"*.robot", "*.resource"},
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            -- Disable code lens capability for this buffer
            client.server_capabilities.codeLensProvider = nil
            vim.lsp.codelens.clear()
          end
        end,
      })

      opts.mappings = maps
      return opts
    end,
  },
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
        robotframework_ls = {
          settings = {
            robot = {
              python = {
                executable = get_python_executable(),
              },
            },
          },
          -- Disable code lenses for Robot Framework language server
          capabilities = {
            codeLensProvider = false,
          },
        },
      },
      -- Disable code lenses globally if needed
      features = {
        codelens = false, -- This disables code lenses for all language servers
      },
    },
  },
}
