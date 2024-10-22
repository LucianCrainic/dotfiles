local logo = [[
	                                                                     
	       ████ ██████           █████      ██                     
	      ███████████             █████                             
	      █████████ ███████████████████ ███   ███████████   
	     █████████  ███    █████████████ █████ ██████████████   
	    █████████ ██████████ █████████ █████ █████ ████ █████   
	  ███████████ ███    ███ █████████ █████ █████ ████ █████  
	 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
]]

return {
  "nvimdev/dashboard-nvim",
  opts = {
    config = {
      -- Apply custom header
      header = vim.split(string.rep("\n", 8) .. logo .. "\n\n", "\n"),
    },
  },
}
