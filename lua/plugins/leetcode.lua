return {
  "kawre/leetcode.nvim",
  lazy = leet_arg ~= vim.fn.argv()[1],
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    arg = leet_arg,
    lang = "scala",
    hooks = {
      ["enter"] = {},

      ["question_enter"] = {
        function()
          vim.cmd("Copilot disable")
        end,
      },

      ["leave"] = {},
    },
  },
}
