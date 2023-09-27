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
      })
    end,
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
}
