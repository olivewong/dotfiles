return {
  -- one of these messed up autocomplete
  -- { -- extend auto completion
  --   "hrsh7th/nvim-cmp",
  --   lazy = false,
  --   dependencies = {
  --     {
  --       "Saecki/crates.nvim",
  --       event = { "BufRead Cargo.toml" },
  --       config = true,
  --     },
  --     -- TODO:
  --     { "hrsh7th/cmp-nvim-lsp" },
  --     { "hrsh7th/cmp-nvim-lua" },
  --     { "hrsh7th/cmp-buffer" },
  --     { "hrsh7th/cmp-cmdline" },
  --   },
  -- },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  -- mappings are c o = choose theirs ]x : go to next etc
  {
    -- make the root the repo root/sensible directory revardless of which file open
    "airblade/vim-rooter",
    lazy = false,
    config = function()
      vim.g.rooter_patterns = { ".git", ".svn", "package.json", "!node_modules", "init.lua" }
      vim.g.rooter_silent_chdir = 1 -- disables the "directory changed" message
    end,
  },
  {
    "tpope/vim-fugitive",
  },
  -- with curr config results in runing analyzer twice
  -- { "folke/neoconf.nvim" },
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
  -- color scheme
  --  this one had weird indentetnation coloring
  -- {
  --   "frenzyexists/aquarium-vim",
  --   lazy = false, -- Load immediately
  --   priority = 1000, -- Ensure it loads before other UI elements
  --   config = function()
  --     vim.g.aquarium_style = "dark"
  --     -- vim.g.aqua_transparency = 1
  --     vim.cmd.colorscheme("aquarium")
  --   end,
  -- },
  {
    -- TODO: not use lazy vim
    -- needs to come with an epilepsy warning
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      -- annoying grep thing
      picker = { enabled = false },
    },
  },
  { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup({})
      vim.cmd.colorscheme("nord")
    end,
  },

  -- colorscheme pastely
  -- todo mayube violet
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   init = function()
  --     vim.cmd.colorscheme("catppuccin-macchiato")
  --   end,
  --   opts = { flavour = "macchiato" },
  -- },
  {
    -- this is painful maybe remove
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.vim" },
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
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  -- painfully slow
  {
    "trunk-io/neovim-trunk",
    lazy = false,
    main = "trunk",
    config = {
      formatOnSave = false, -- so slow
      -- formatOnSaveTimeout = 2, -- seconds
      trunkPath = "tools/trunk",
    },
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
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
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        sections = {
          lualine_c = {
            {
              "filename",
              file_status = true, -- displays file status (readonly status, modified status)
              path = 2, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
        },
      }
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = { timeout_ms = 1000 },
    },
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
  {
    "zbirenbaum/copilot-cmp",
    -- config = function()
    --   require("copilot_cmp").setup()
    -- end,
  },
  {
    -- https://tamerlan.dev/setting-up-copilot-in-neovim-with-sane-settings/
    -- :Copilot auth to authenticate
    "zbirenbaum/copilot.lua",
    lazy = true,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" }, -- Load only for Rust files
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          --           on_attach = function(client, bufnr)
          -- Keybindings for Rust LSP
          -- local function map(mode, lhs, rhs, desc)
          --   vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
          -- end
          -- map("n", "<leader>cR", function()
          --   vim.cmd.RustLsp("codeAction")
          -- end, "Code Action")
          -- map("n", "<leader>dr", function()
          --   vim.cmd.RustLsp("debuggables")
          -- end, "Rust Debuggables")
          -- map("n", "K", function()
          --   vim.cmd.RustLsp({ "hover", "actions" })
          -- end, "Hover Actions")
          --        end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              -- shout out to https://github.com/charlesjsun/kickstart.nvim/blob/d39530a6616f9d0c9659e79f769e327014c3c778/lua/csun-waabi/plugins/lsp.lua#L206
              rustfmt = {
                -- overrideCommand = "trunk fmt",
                extraArgs = { "--edition=2021" },
              },
              check = {
                -- must! not! be! string!
                overrideCommand = { "tools/rust_check.sh" },
              },
              -- see t he zed config for lens, might be things
              diagnostics = {
                -- experimental = {
                --   enable = true,
                -- },
                disabled = { "unresolved-macro-call" },
              },
              runnables = {
                command = "tools/cargo",
              },
              -- rustc = {
              --   source = "Cargo.toml",
              -- },
              cargo = {
                -- buildScripts = {
                --     useRustcWrapper = false,
                -- },
                extraEnv = {
                  RUSTC = "/home/owong/av/tools/rustc",
                },
              },
              buildScripts = {
                enable = true,
              },
              procMacro = {
                enable = false,
              },
            },
          },
        },
        -- DAP configuration
        dap = {},
      }
    end,
  },
}
