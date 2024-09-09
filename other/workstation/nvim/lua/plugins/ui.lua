return {
  { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      sections = {
        lualine_a = {
          {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 2, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
      },
    },
  },
  -- {
  --   "gbprod/nord.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("nord").setup({})
  --     vim.cmd.colorscheme("nord")
  --   end,
  -- },
  -- TODO: good themes: aquarium?
}
