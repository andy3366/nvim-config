return {
  --启动界面
{
    "nvimdev/dashboard-nvim",
    event = 'VimEnter',
    dependencies = {"nvim-tree/nvim-web-devicons"},
      lazy = false,
      opts = {
          theme = "doom",
          config = {
              header = {
      " ",
      " ",
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
                  " ",
                  " ",
              },
              center = {
                  {
                      icon = "󰈮  ",
                      desc = " New File",
                      action = "ene | startinsert",
                  },
                  {
                      icon = "  ",
                      desc = " Lazy.nvim",
                      action = "Lazy",
                  },
                  {
                      icon = "  ",
                      desc = " Find File",
                      action = "Telescope find_files",
                  },
                  {
                      icon = "  ",
                      desc = " Mason",
                      action = "Mason",
                  },
                  {
                      icon = "  ",
                      desc = " Quit",
                      action = function() vim.api.nvim_input("<cmd>qa<cr>") end,
                  },                
              },
              footer = { " " },
          },
      },
      config = function(_, opts)
          require("dashboard").setup(opts)
      end,
}}