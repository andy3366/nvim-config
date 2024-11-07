return {
  --文档树
{
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {"nvim-tree/nvim-web-devicons"},
  config = function()
    keys = {
      vim.keymap.set("n","<leader>e",":NvimTreeToggle<CR>") --打开tree
    }
    -- 默认不开启nvim-tree
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  require("nvim-tree").setup()
  end,
}}