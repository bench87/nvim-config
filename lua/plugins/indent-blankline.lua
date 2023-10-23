return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    scope = {
      enabled = false,
    },
    exclude = {
      filetypes = {
        "",
        "Float",
        "OverseerForm",
        "TelescopePrompt",
        "Trouble",
        "alpha",
        "checkhealth",
        "dashboard",
        "help",
        "lazy",
        "lazyterm",
        "lspinfo",
        "man",
        "mason",
        "neo-tree",
        "notify",
        "starter",
        "toggleterm",
      },
    },
  },
}
