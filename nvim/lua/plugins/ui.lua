return {
  --提示框和ui
{
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    })
  },
  dependencies = {
    {"MunifTanjim/nui.nvim"},
    {"rcarriga/nvim-notify",  --提示框
      event = "VeryLazy",
      opts = {
        timeout = 3000,
        background_colour = "#000000",
        stages = "static",
      },
      config = function(_, opts)
        require("notify").setup(opts)
        vim.notify = require "notify"
      end,
    },
  },
}}