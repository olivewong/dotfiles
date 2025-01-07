return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "vue",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "dockerfile",
        "proto",
        "python",
        -- "rust",
        "ron",
        "toml",
      })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
  -- colorscheme pastely
  -- todo mayube violet
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = { flavour = "macchiato" } },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    event = "VeryLazy",
    keys = {
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      {
        "<leader>ccc",
        ":CopilotChatToggle<CR>",
        mode = { "n", "x" },
        desc = "CopilotChat",
      },
      {
        "<leader>ccf",
        "<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
        desc = "CopilotChat Fix Diagnostic",
      },
    },
    opts = {},
  },
  { -- extend auto completion
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = true,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates", priority = 750 },
      }))
    end,
  },
  -- painfully slow
  {
    "trunk-io/neovim-trunk",
    lazy = false,
    main = "trunk",
    config = {
      formatOnSave = true,
      formatOnSaveTimeout = 3, -- seconds
      trunkPath = "tools/trunk",
    },
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    -- },
    {
      "nvim-telescope/telescope.nvim",
      -- change some options
      opts = {
        defaults = {
          file_ignore_patterns = { ".git/*", ".vscode/*", "*.foxe" },
        },
      },
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
    {
      "neovim/nvim-lspconfig",
      -- shut up pyright
      -- seems like this is the best way https://www.reddit.com/r/neovim/comments/11k5but/how_to_disable_pyright_diagnostics/
      ft = { "python", "lua" },
      -- https://www.reddit.com/r/neovim/comments/11clka0/comment/ja54ocv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      opts = {
        servers = {
          -- rust_analyzer = {},
          pyright = {
            settings = {
              pyright = {
                disableOrganizeImports = true, -- Using Ruff
              },
              python = {
                analysis = {
                  ignore = { "*" }, -- Using Ruff
                  typeCheckingMode = "off", -- Using mypy
                },
              },
            },
          },
          -- pyright = {
          --   handlers = {
          --     ["textDocument/publishDiagnostics"] = function() end,
          --   },
          --   on_attach = function(client, _)
          --     client.server_capabilities.codeActionProvider = false
          --   end,
          --   settings = {
          --     pyright = {
          --       disableOrganizeImports = true,
          --     },
          --     python = {
          --       analysis = {
          --         autoSearchPaths = true,
          --         typeCheckingMode = "basic",
          --         useLibraryCodeForTypes = true,
          --       },
          --     },
          --   },
          -- },
          ruff_lsp = {
            init_options = {
              settings = {
                args = {},
              },
            },
          },
          taplo = {
            keys = {
              {
                "K",
                function()
                  if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                    require("crates").show_popup()
                  else
                    vim.lsp.buf.hover()
                  end
                end,
                desc = "Show Crate Documentation",
              },
            },
          },
        },
      },
    },
    -- {
    --   "raimon49/requirements.txt.vim",
    --   event = "BufReadPre requirements*.txt",
    -- },
    {
      "mrcjkb/rustaceanvim",
      version = "^5", -- Recommended
      ft = { "rust" },
      opts = {
        server = {
          extraEnv = { "~/av/tools/rustc" },
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>cR", function()
              vim.cmd.RustLsp("codeAction")
            end, { desc = "Code Action", buffer = bufnr })
            vim.keymap.set("n", "<leader>dr", function()
              vim.cmd.RustLsp("debuggables")
            end, { desc = "Rust Debuggables", buffer = bufnr })
            vim.g.rustaceanvim = function()
              local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
              local codelldb_path = extension_path .. "adapter/codelldb"
              local liblldb_path = extension_path .. "lldb/lib/liblldb"
              local this_os = vim.uv.os_uname().sysname

              -- The path is different on Windows
              if this_os:find("Windows") then
                codelldb_path = extension_path .. "adapter\\codelldb.exe"
                liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
              else
                -- The liblldb extension is .so for Linux and .dylib for MacOS
                liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
              end

              local cfg = require("rustaceanvim.config")
              return {
                dap = {
                  adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
              }
            end
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              server = {
                extraEnv = { RUSTC = "~/av/tools/rustc" },
              },
              -- Add clippy lints for Rust.
              check = {
                overrideCommand = {
                  "~/av/tools/rust_check.sh",
                },
                command = {
                  "~/av/tools/rust_check.sh",
                },
              },
              checkOnSave = {
                overrideCommand = {
                  "~/av/tools/rust_check.sh",
                },
              },
              -- procMacro = {
              --   enable = true,
              --   ignored = {
              --     -- ["async-trait"] = { "async_trait" },
              --     -- ["napi-derive"] = { "napi" },
              --     -- ["async-recursion"] = { "async_recursion" },
              --   },
              -- },
            },
          },
        },
      },
      config = function(_, opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
        if vim.fn.executable("rust-analyzer") == 0 then
          LazyVim.error(
            "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
            { title = "rustaceanvim" }
          )
        end
      end,
    },
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          -- python
          -- if having rust problems
          -- https://github.com/LazyVim/LazyVim/discussions/3549
          -- todo align w trunk
          "ruff-lsp", -- lsp
          "ruff", -- linter (but used as formatter)
          --        "pyright", -- lsp
          "black", -- formatter
          "mypy", -- linter
          -- "rust-analyzer",
          "taplo",
          --          "codelldb",
        },
      },
    },
    -- {
    --   "nvimtools/none-ls.nvim",
    --   dependencies = {
    --     "nvim-lua/plenary.nvim", -- Required dependency
    --   },
    --   opts = function(_, opts)
    --     local null_ls = require("null-ls")
    --     local helpers = require("null-ls.helpers")
    --
    --     -- Define a diagnostics generator for the output from rust_check.sh
    --     -- local rust_check = {
    --     --   method = null_ls.methods.DIAGNOSTICS,
    --     --   filetypes = { "rust" }, -- Only run for Rust files
    --     --   generator = helpers.generator_factory({
    --     --     command = "rust_check.sh",
    --     --     args = {},
    --     --     format = "json",
    --     --     on_output = helpers.diagnostics.from_json({
    --     --       attributes = {
    --     --         row = "line_start",
    --     --         col = "column_start",
    --     --         end_row = "line_end",
    --     --         end_col = "column_end",
    --     --         message = "message",
    --     --         source = "rust_check.sh", -- Diagnostic source
    --     --         severity = function(d)
    --     --           return d.level == "error" and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN
    --     --         end,
    --     --       },
    --     --       severity_map = {
    --     --         error = vim.diagnostic.severity.ERROR,
    --     --         warning = vim.diagnostic.severity.WARN,
    --     --         info = vim.diagnostic.severity.INFO,
    --     --         hint = vim.diagnostic.severity.HINT,
    --     --       },
    --     --     }),
    --     --     on_exit = function(code, output, stderr)
    --     --       if code ~= 0 then
    --     --         print("Error running rust_check.sh:", stderr)
    --     --         print(output)
    --     --       end
    --     --     end,
    --     --   }),
    --     -- }
    --
    --     -- Add the rust_check diagnostic source to none-ls setup
    --     -- null_ls.setup({
    --     --   sources = {
    --     --     rust_check,
    --     --     null_ls.builtins.diagnostics.buildifier,
    --     --   },
    --     --   debug = true,
    --     -- })
    --   end,
    -- },
    -- Automatically run diagnostics on save
    -- {
    --   "nvim-lua/plenary.nvim",
    --   event = { "BufWritePost" },
    --   opts = function()
    --     vim.api.nvim_create_autocmd("BufWritePost", {
    --       pattern = "*.rs",
    --       callback = function()
    --         vim.lsp.buf.formatting_sync(nil, 1000)
    --       end,
    --     })
    --   end,
    -- },
  },
}
