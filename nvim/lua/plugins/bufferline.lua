return {
  --buffer顶部缓冲区
{
  "akinsho/bufferline.nvim",
  config = function()
    vim.opt.termguicolors = true

    keys = {
      vim.keymap.set("n", "<leader>l", ":bNext<CR>"),     -- 切换buffer
      vim.keymap.set("n", "<leader>h", ":bprevious<CR>"), -- 切换buffer
    }

  require("bufferline").setup {
    options = {
        -- 使用 nvim 内置lsp
        diagnostics = "nvim_lsp",
        -- 左侧让出 nvim-tree 的位置
        offsets = {{
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left"
        }}
    }
}
  end,
  opts = {},
}}