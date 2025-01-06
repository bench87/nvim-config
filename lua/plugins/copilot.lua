return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      -- I don't find the panel useful.
      panel = { enabled = false },
      suggestion = {
        auto_trigger = true,
        -- Use alt to interact with Copilot.
        keymap = {
          -- Disable the built-in mapping, we'll configure it in nvim-cmp.
          accept = false,
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "/",
        },
      },
      filetypes = { markdown = true },
    },
    config = function(_, opts)
      local cmp = require("cmp")
      local copilot = require("copilot.suggestion")

      require("copilot").setup(opts)

      ---@param trigger boolean
      local function set_trigger(trigger)
        if not trigger and copilot.is_visible() then
          copilot.dismiss()
        end
        vim.b.copilot_suggestion_auto_trigger = trigger
        vim.b.copilot_suggestion_hidden = not trigger
      end

      -- Hide suggestions when the completion menu is open.
      cmp.event:on("menu_opened", function()
        set_trigger(false)
      end)
      cmp.event:on("menu_closed", function() end)
    end,
  },
  {
    "nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "copilot.lua",
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          LazyVim.lsp.on_attach(function(client)
            if client.name == "copilot" then
              copilot_cmp._on_insert_enter({})
            end
          end)
        end,
      },
    },
    config = function(_, opts)
      local cmp = require("cmp")

      -- Inside a snippet, use backspace to remove the placeholder.
      vim.keymap.set("s", "<BS>", "<C-O>s")

      cmp.setup(opts)
    end,
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")
      local symbol_kinds = require("icons").symbol_kinds
      local winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None"
      opts.window = {
        completion = {
          border = "rounded",
          winhighlight = winhighlight,
          scrollbar = true,
        },
        documentation = {
          border = "rounded",
          winhighlight = winhighlight,
          max_height = math.floor(vim.o.lines * 0.5),
          max_width = math.floor(vim.o.columns * 0.4),
        },
      }
      opts.formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr", "menu" },
        format = function(_, vim_item)
          local MAX_ABBR_WIDTH, MAX_MENU_WIDTH = 25, 30
          local ellipsis = require("icons").misc.ellipsis

          -- Add the icon.
          vim_item.kind = (symbol_kinds[vim_item.kind] or symbol_kinds.Text) .. " " .. vim_item.kind

          -- Truncate the label.
          if vim.api.nvim_strwidth(vim_item.abbr) > MAX_ABBR_WIDTH then
            vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, MAX_ABBR_WIDTH) .. ellipsis
          end

          -- Truncate the description part.
          if vim.api.nvim_strwidth(vim_item.menu or "") > MAX_MENU_WIDTH then
            vim_item.menu = vim.fn.strcharpart(vim_item.menu, 0, MAX_MENU_WIDTH) .. ellipsis
          end

          return vim_item
        end,
      }
      opts.snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      }
      opts.preselect = cmp.PreselectMode.None
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<cr>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
        }),
        ["/"] = cmp.mapping.close(),
        -- Overload tab to accept Copilot suggestions.
        ["<Tab>"] = cmp.mapping(function(fallback)
          local copilot = require("copilot.suggestion")

          if copilot.is_visible() then
            copilot.accept()
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.expand_or_locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 100,
      })
    end,
  },
}
