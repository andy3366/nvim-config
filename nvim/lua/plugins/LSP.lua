return {
  --mason
{
  "williamboman/mason.nvim",
  dependencies = {  
    {"williamboman/mason-lspconfig.nvim"}, -- 这个相当于mason和lspconfig的桥梁
  },
  config = function()
    require("mason").setup({
      ui = {
          icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
          }
      }
    })
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "clangd", "cmake", "pyright" },
    })
  end,
},
  --luasnip
{
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  config = function()
    local luasnip_loader = require("luasnip.loaders.from_vscode")
    luasnip_loader.lazy_load()

    local luasnip = require("luasnip")
    luasnip.config.setup({
      region_check_events = "CursorHold,InsertLeave,InsertEnter",
      delete_check_events = "TextChanged,InsertEnter",
    })
  end,
  dependencies = {
    { "rafamadriz/friendly-snippets" },
  },
},
  --lsp
{
  "neovim/nvim-lspconfig",
  dependencies = {
    {"hrsh7th/nvim-cmp"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"},
    {"hrsh7th/cmp-cmdline"},
    {"hrsh7th/cmp-nvim-lua"},
    {"f3fora/cmp-spell"},
    {"hrsh7th/cmp-calc"},
    {"kdheepak/cmp-latex-symbols"},
    {"saadparwaiz1/cmp_luasnip"},
    {"ray-x/cmp-treesitter"},
    {"onsails/lspkind.nvim"},
    {"ray-x/lsp_signature.nvim"},
    {"rachartier/tiny-code-action.nvim"},
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local luasnip = require("luasnip")
    local has_words_before = function()

    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local types = require("cmp.types")
    local str = require("cmp.utils.str")
    local lspkind = require("lspkind")
    --cmp setup
    local cmp = require("cmp")

    local kind_icons = {
      Class = "",
      Color = "🖌",
      Constant = "𝜋",
      Constructor = '⌬',
      Enum = "",
      EnumMember = "",
      Event = "",
      Field = "",
      File = "",
      Folder = "",
      Function = "ƒ",
      Interface = "",
      Keyword = "",
      Method = "𝘮",
      Module = "",
      Operator = "≠",
      Property = "∷",
      Reference = "⊷",
      Snippet = '',
      Struct = "",
      Text = "",
      TypeParameter = "×",
      Unit = "()",
      Variable = 'α'
    }

    local select_opts = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
        ["<C-l>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.jumpable(1) then
            luasnip.jump(1)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
          elseif require("luasnip").expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      experimental = {
        ghost_text = false,
      },
      window = {
        --documentation = {
        --border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        --},
        completion = {
          border = "rounded",
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        },
      },
      sources = cmp.config.sources({
        {
          name = "luasnip",
          entry_filter = function()
            -- disable completion in comments
            local context = require("cmp.config.context")
            -- keep command mode completion enabled when cursor is in a comment
            if vim.api.nvim_get_mode().mode == "c" then
              return true
            else
              return (not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment"))
                and (not context.in_treesitter_capture("string") and not context.in_syntax_group("String"))
            end
          end,
        }, -- For luasnip users.
        { name = "nvim_lsp" },
        { name = "copilot" },
        { name = "crates" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        { name = "treesitter" },
        {
          name = "latex_symbols",
          option = {
            strategy = 0, -- mixed
          },
        },
        { name = "calc" },
        { name = "path" },
        { name = "nvim_lua" },
        { name = "spell" },
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
          vim_item.menu = ({
            -- omni = "[VimTex]",
            omni = (vim.inspect(vim_item.menu):gsub('%"', "")),
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            spell = "[Spell]",
            cmdline = "[CMD]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
      --enable catppuccin integration
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
    })
    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
      }, {
        { name = "buffer" },
      }),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    local sign = function(opts)
      vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
      })
    end

    sign({ name = "DiagnosticSignError", text = "✘" })
    sign({ name = "DiagnosticSignWarn", text = "▲" })
    sign({ name = "DiagnosticSignHint", text = "⚑" })
    sign({ name = "DiagnosticSignInfo", text = "󰚢" })

    vim.diagnostic.config({
      virtual_text = true, --代码后面显示错误
      severity_sort = true,
      signs = true,
      update_in_insert = false,
      underline = false,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
------------------------------------------lsp------------------------------------------
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    local lspconfig = require("lspconfig")
    local util = require("lspconfig/util")
    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<space>E", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr })
    local signature_setup = {
      hint_prefix = "🐼 ",}
    require("lsp_signature").on_attach(signature_setup, bufnr)

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- telescope integration
    telescope_builtin = require("telescope.builtin")
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "B", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-b>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wl", function()
       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)

    require("tiny-code-action").setup({
      -- backend = "vim",
      backend = "delta",
    })
    vim.keymap.set("n", "<leader>ca", function()
      require("tiny-code-action").code_action()
    end, bufopts)
    -- vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)

    -- use telescope packer
    --vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "gr", telescope_builtin.lsp_references, bufopts)

    vim.keymap.set("n", "<space>F", function()
      vim.lsp.buf.format({ async = true })
    end, bufopts)
  end

  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }

  local lsp_defaults = lspconfig.util.default_config
  lsp_defaults.capabilities = vim.tbl_deep_extend("force", lsp_defaults.capabilities, capabilities)

  local servers = {
    "clangd",
    "lua_ls",
    "cmake",
  }
  for _, lsp in pairs(servers) do
    if lsp == "lua_ls" then
      lspconfig[lsp].setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
        on_attach = on_attach,
        flags = lsp_flags,
      })
    elseif lsp == "rust_analyzer" then
      lspconfig[lsp].setup({
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = true,
            check = { command = "clippy", features = "all" },
            assist = {
              importGranularity = "module",
              importPrefix = "self",
            },
            diagnostics = {
              enable = true,
              enableExperimental = true,
            },
            cargo = {
              loadOutDirsFromCheck = true,
              features = "all", -- avoid error: file not included in crate hierarchy
            },
            procMacro = {
              enable = true,
            },
            inlayHints = {
              chainingHints = true,
              parameterHints = true,
              typeHints = true,
            },
          },
        },
        on_attach = on_attach,
        flags = lsp_flags,
      })
    else
      lspconfig[lsp].setup({
        on_attach = on_attach,
        flags = lsp_flags,
      })
    end
  end
  end,
}}
