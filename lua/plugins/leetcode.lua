return {
  "kawre/leetcode.nvim",
  lazy = leet_arg ~= vim.fn.argv()[1],
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    arg = leet_arg,
    hooks = {
      ["enter"] = {},

      ["question_enter"] = {},

      ["leave"] = {},
    },
  },
}
