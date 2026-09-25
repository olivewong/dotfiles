return {
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
  {
    -- make the root the repo root/sensible directory revardless of which file open
    -- thisis actually redundatn but im suffering and i hope it works
    "airblade/vim-rooter",
    lazy = false,
    config = function()
      vim.g.rooter_patterns = { ".git", ".svn", "!node_modules", "init.lua" }
      vim.g.rooter_silent_chdir = 1 -- disables the "directory changed" message
    end,
  },
  {
    -- TODO: not use lazy vim
    -- needs to come with an epilepsy warning
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      -- annoying grep thing
      picker = { enabled = false },
      -- 0.11 complaining
      words = { enabled = false },
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- TODO: good themes: aquarium?
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
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { left_pad = 2 },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim", "nvim-tree/nvim-web-devicons" },
  },
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     fat_headline_upper_string = "▃",
  --     fat_headline_lower_string = "🬂",
  --   },
  --   config = true, -- or `opts = {}`
  -- },
}
