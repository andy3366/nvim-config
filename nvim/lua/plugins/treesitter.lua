return {
  --文本高亮
{
  "nvim-treesitter/nvim-treesitter",
  config = function() --配置
  require'nvim-treesitter.configs'.setup {
  -- 添加不同语言
  ensure_installed = {
    "c",
    "cpp",
    "python",
    "java"
  },  -- one of "all" or a list of languages
  auto_install = true, --打开未添加语言文件时自动安装语言
  highlight = { enable = true },
  indent = { enable = true },

  -- 不同括号颜色区分
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}
  end,
}}