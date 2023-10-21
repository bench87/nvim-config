return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- cmd = { "/Users/mason/Documents/Developments/llvm-project/build/bin/clangd" },
          cmd = { "/Users/mason/.espressif/tools/xtensa-clang/14.0.0-38679f0333/xtensa-esp32-elf-clang/bin/clangd" },
        },
        -- whatever other language servers you want
      },
    },
  },
}
