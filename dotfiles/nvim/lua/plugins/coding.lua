local langs = {
  rust = {
    ft = 'rust',
    lsp = 'rust-analyzer',
    lspconfig = 'rust_analyzer',
    formatter = 'rustfmt',
    setting = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        -- Add clippy lints for Rust.
        checkOnSave = {
          allFeatures = true,
          pluginsd = "clippy",
          extraArgs = { "--no-deps" },
        },
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
      },
    }
  },
  lua = {
    ft = 'lua',
    lsp = 'lua-language-server',
    lspconfig = 'lua_ls',
    formatter = 'stylua',
    setting = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    }
  },
  markdown = {
    ft = 'markdown',
  },
  markdown_inline = {
    ft = false,
  },
  commonlisp = {
    ft = 'lisp'
  },
  vimdoc = {
    ft = false,
  },
  vue = {
    ft = 'vue',
  },
  python = {
    ft = 'python',
    lsp = 'pyright',
    lspconfig = 'pyright',
    formatter = 'autopep8',
  },
  nix = {
    ft = 'nix',
    lsp = 'nil',
    lspconfig = 'nil_ls',
    formatter = 'nixfmt',
  }
}

local lang_fts = {}
for lang, value in pairs(langs) do
  if value.ft then
    table.insert(lang_fts, lang)
  end
end

return {
  -- mason
  {
    'williamboman/mason.nvim',
    pin = true,
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      local ensure_installed = {}
      for _, lang in pairs(langs) do
        table.insert(ensure_installed, lang.lsp)
        table.insert(ensure_installed, lang.formatter)
      end

      return {
        ensure_installed = ensure_installed,
        PATH = "skip",
        ui = {
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = "󰚌",
          },

          keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
            cancel_installation = "<C-c>",
          },
        },
        max_concurrent_installers = 10,
      }
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})
    end
  },

  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    pin = true,
    opts = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      }

      local on_attach = function(_, bufnr)
        local function buf_set_option(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
      end

      return {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,
    config = function(_, opts)
      local lspconfig = require('lspconfig')

      for _, lang in pairs(langs) do
        if lang.lspconfig ~= nil then
          lspconfig[lang.lspconfig].setup {
            on_attach = opts.on_attach,
            capabilities = opts.capabilities,
            settings = lang.setting,
          }
        end
      end

      vim.api.nvim_create_autocmd('InsertEnter', {
        once = true,
        callback = function()
          vim.api.nvim_exec_autocmds("User", {
            pattern = "Cmp"
          })
        end,
      })
    end
  },

  -- cmp
  {
    'hrsh7th/nvim-cmp',
    event = 'User Cmp',
    pin = true,
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        pin = true,
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)

          -- vscode format
          require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
          require("luasnip.loaders.from_vscode").lazy_load { paths = "your path!" }
          require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

          -- snipmate format
          require("luasnip.loaders.from_snipmate").load()
          require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

          -- lua format
          require("luasnip.loaders.from_lua").load()
          require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

          vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
              if
                  require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                  and not require("luasnip").session.jump_active
              then
                require("luasnip").unlink_current()
              end
            end,
          })
        end,
      },
      {
        "windwp/nvim-autopairs",
        pin = true,
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    opts = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        }, {
          { name = 'buffer' },
        })
      }
    end,
    config = function(_, opts)
      require('cmp').setup(opts)
    end,
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    ft = lang_fts,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ':TSUpdate',
    opts = function()
      local ensure_installed = {}

      for lang, _ in pairs(langs) do
        table.insert(ensure_installed, lang)
      end

      return {
        ensure_installed = ensure_installed,
        sync_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- conform
  {
    'stevearc/conform.nvim',
    pin = true,
    ft = lang_fts,
    opts = function()
      local formatters = {}
      for _, lang in pairs(langs) do
        formatters[lang.ft] = { lang.formatter }
      end
      return {
        formatters_by_ft = formatters,
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      }
    end,
  },

  -- outline
  {
    'hedyhli/outline.nvim',
    pin = true,
    ft = lang_fts,
    dependencies = {
      'neovim/nvim-lspconfig'
    },
    keys = {
      { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle Outline' }
    },
    config = true,
  },

  -- lua
  {
    "folke/neodev.nvim",
    ft = 'lua',
    dependencies = {
      'hedyhli/outline.nvim',
      'stevearc/conform.nvim',
    },
    config = true,
  },

  -- vue


  -- markdown
  {
    'lukas-reineke/headlines.nvim',
    pin = true,
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      require('headlines').setup({
        markdown = {
          query = vim.treesitter.query.parse(
            'markdown',
            [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
                (block_quote (paragraph (block_continuation) @quote))
                (block_quote (block_continuation) @quote)
            ]]
          ),
          headline_highlights = { 'Headline' },
          codeblock_highlight = 'CodeBlock',
          dash_highlight = 'Dash',
          dash_string = '-',
          quote_highlight = 'Quote',
          quote_string = '┃',
          fat_headlines = true,
          fat_headline_upper_string = ' ',
          fat_headline_lower_string = ' ',
        },
        rmd = {
          query = vim.treesitter.query.parse(
            'markdown',
            [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
                (block_quote (paragraph (block_continuation) @quote))
                (block_quote (block_continuation) @quote)
            ]]
          ),
          treesitter_language = 'markdown',
          headline_highlights = { 'Headline' },
          codeblock_highlight = 'CodeBlock',
          dash_highlight = 'Dash',
          dash_string = '-',
          quote_highlight = 'Quote',
          quote_string = '┃',
          fat_headlines = true,
          fat_headline_upper_string = '',
          fat_headline_lower_string = '',
        },
      })
    end,
  },

  -- oil
  {
    'stevearc/oil.nvim',
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
    lazy = false,
  }
}
