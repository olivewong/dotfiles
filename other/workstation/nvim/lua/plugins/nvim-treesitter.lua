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
        "rust",
        -- "toml"
      })
    end,
  },
  -- painfully slow
  -- {
  --   "trunk-io/neovim-trunk",
  --   lazy = false,
  --   main = "trunk",
  --   config = {
  --     trunkPath = "tools/trunk",
  --   },
  --   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
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
    ft = {"python", "lua",},
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
      },
    },
  },
  -- {
  --   "raimon49/requirements.txt.vim",
  --   event = "BufReadPre requirements*.txt",
  -- },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- python
        -- todo align w trunk
        "ruff-lsp", -- lsp
        "ruff", -- linter (but used as formatter)
        --        "pyright", -- lsp
        "black", -- formatter
        "mypy", -- linter
        "rust-analyzer",
        "taplo",
        "codelldb"

      },
    },
  },
}
