local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-macchiato" }, import = "lazyvim.plugins" },
    -- typescript
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    -- av
    --    { import = "lazyvim.plugins.extras.lang.python" },
    --   { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax", "nord" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- -- https://tamerlan.dev/setting-up-copilot-in-neovim-with-sane-settings/
-- todo install it in order
-- require("copilot").setup({
--   panel = {
--     enabled = false,
--     auto_refresh = false,
--     keymap = {
--       jump_prev = "[[",
--       jump_next = "]]",
--       accept = "<CR>",
--       refresh = "gr",
--       open = "<M-CR>",
--     },
--     layout = {
--       position = "bottom", -- | top | left | right
--       ratio = 0.4,
--     },
--   },
--   suggestion = {
--     enabled = false,
--     auto_trigger = true,
--     debounce = 75,
--     keymap = {
--       accept = false,
--       accept_word = false,
--       accept_line = false,
--       next = "<M-]>",
--       prev = "<M-[>",
--       dismiss = "<C-]>",
--     },
--   },
--   filetypes = {
--     help = false,
--     gitcommit = false,
--     gitrebase = false,
--     hgcommit = false,
--     svn = false,
--     cvs = false,
--     ["."] = false,
--   },
--   copilot_node_command = "node", -- Node.js version must be > 16.x
--   server_opts_overrides = {},
--   on_status_update = require("lualine").refresh,
-- })
--
-- local cmp_status_ok, cmp = pcall(require, "cmp")
-- if not cmp_status_ok then
--   return
-- end
--
-- local snip_status_ok, luasnip = pcall(require, "luasnip")
-- if not snip_status_ok then
--   return
-- end
--
-- require("luasnip/loaders/from_vscode").lazy_load()
--
-- local check_backspace = function()
--   local col = vim.fn.col(".") - 1
--   return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
-- end
--
-- --   פּ ﯟ   some other good icons
-- local kind_icons = {
--   Text = "",
--   Method = "m",
--   Function = "",
--   Constructor = "",
--   Field = "",
--   Variable = "",
--   Class = "",
--   Interface = "",
--   Module = "",
--   Property = "",
--   Unit = "",
--   Value = "",
--   Enum = "",
--   Keyword = "",
--   Snippet = "",
--   Color = "",
--   File = "",
--   Reference = "",
--   Folder = "",
--   EnumMember = "",
--   Constant = "",
--   Struct = "",
--   Event = "",
--   Operator = "",
--   TypeParameter = "",
--   Copilot = "",
-- }
-- -- find more here: https://www.nerdfonts.com/cheat-sheet
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body) -- For `luasnip` users.
--     end,
--   },
--   mapping = {
--     ["<C-k>"] = cmp.mapping.select_prev_item(),
--     ["<C-j>"] = cmp.mapping.select_next_item(),
--     ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
--     ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
--     ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
--     ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
--     ["<C-e>"] = cmp.mapping({
--       i = cmp.mapping.abort(),
--       c = cmp.mapping.close(),
--     }),
--     -- Accept currently selected item. If none selected, `select` first item.
--     -- Set `select` to `false` to only confirm explicitly selected items.
--     ["<CR>"] = cmp.mapping.confirm({ select = true }),
--     ["<Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif require("copilot.suggestion").is_visible() then
--         require("copilot.suggestion").accept()
--       elseif luasnip.expandable() then
--         luasnip.expand()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       elseif check_backspace() then
--         fallback()
--       else
--         fallback()
--       end
--     end, {
--       "i",
--       "s",
--     }),
--     ["<S-Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, {
--       "i",
--       "s",
--     }),
--   },
--   formatting = {
--     fields = { "kind", "abbr", "menu" },
--     format = function(entry, vim_item)
--       -- Kind icons
--       vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
--       -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
--       vim_item.menu = ({
--         nvim_lsp = "[LSP]",
--         luasnip = "[Snippet]",
--         buffer = "[Buffer]",
--         path = "[Path]",
--         copilot = "[Copilot]",
--       })[entry.source.name]
--       return vim_item
--     end,
--   },
--   sources = {
--     -- group index?
--     { name = "copilot" },
--     { name = "nvim_lsp" },
--     { name = "luasnip" },
--     { name = "buffer" },
--     { name = "path" },
--     { name = "cmdline" },
--   },
--   confirm_opts = {
--     behavior = cmp.ConfirmBehavior.Replace,
--     select = false,
--   },
--   window = {
--     documentation = {
--       border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
--     },
--   },
--   experimental = {
--     ghost_text = false,
--     native_menu = false,
--   },
-- })
