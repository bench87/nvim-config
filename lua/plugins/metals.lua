return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "j-hui/fidget.nvim",
      opts = {},
    },
  },
  ft = { "scala", "sbt", "java" },
  keys = {
    {
      "<leader>me",
      function()
        require("telescope").extensions.metals.commands()
      end,
      desc = "Metals commands",
    },
    {
      "<leader>mc",
      function()
        require("metals").compile_cascade()
      end,
      desc = "Metals compile cascade",
    },
  },
  opts = function()
    local map = vim.keymap.set
    local metals_config = require("metals").bare_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    metals_config.settings = {
      showImplicitArguments = true,
      showInferredType = true,
      showImplicitConversionsAndClasses = true,
    }
    metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    -- metals_config.settings.scalafmtConfigPath = "/Users/mason/.scalafmt.conf"
    metals_config.init_options.statusBarProvider = "off"
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    local dap = require("dap")

    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "Run",
        metals = {
          runType = "run",
          --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
    }

    metals_config.on_attach = function(client, bufnr)
      require("metals").setup_dap()

      -- LSP mappings
      map("n", "gD", vim.lsp.buf.definition, { desc = "Go to Definition" })
      map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
      map("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
      map("n", "gds", vim.lsp.buf.document_symbol)
      map("n", "gws", vim.lsp.buf.workspace_symbol)
      map("n", "<leader>cl", vim.lsp.codelens.run)
      map("n", "<leader>sh", vim.lsp.buf.signature_help)
      map("n", "<leader>rn", vim.lsp.buf.rename)
      map("n", "<leader>f", vim.lsp.buf.format)
      map("n", "<leader>ca", vim.lsp.buf.code_action)

      map("n", "<leader>ws", function()
        require("metals").hover_worksheet()
      end)

      -- all workspace diagnostics
      map("n", "<leader>aa", vim.diagnostic.setqflist, { desc = "All workspace diagnostics" })

      -- all workspace errors
      map("n", "<leader>ae", function()
        vim.diagnostic.setqflist({ severity = "E" })
      end, { desc = "All workspace errors" })

      -- all workspace warnings
      map("n", "<leader>aw", function()
        vim.diagnostic.setqflist({ severity = "W" })
      end, { desc = "All workspace warnings" })

      -- buffer diagnostics only
      map("n", "<leader>d", vim.diagnostic.setloclist, { desc = "Buffer diagnostics" })

      map("n", "[c", function()
        vim.diagnostic.goto_prev({ wrap = false })
      end)

      map("n", "]c", function()
        vim.diagnostic.goto_next({ wrap = false })
      end)

      -- Example mappings for usage with nvim-dap. If you don't use that, you can
      -- skip these
      map("n", "<leader>dc", function()
        require("dap").continue()
      end)

      map("n", "<leader>dr", function()
        require("dap").repl.toggle()
      end)

      map("n", "<leader>dK", function()
        require("dap.ui.widgets").hover()
      end)

      map("n", "<leader>dt", function()
        require("dap").toggle_breakpoint()
      end)

      map("n", "<leader>dso", function()
        require("dap").step_over()
      end)

      map("n", "<leader>dsi", function()
        require("dap").step_into()
      end)

      map("n", "<leader>dl", function()
        require("dap").run_last()
      end)
    end
    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
