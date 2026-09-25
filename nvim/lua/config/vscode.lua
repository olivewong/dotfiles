if not vim.g.vscode then
  return
end

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

map("n", "<C-n>", "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
map("n", "<C-P>", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
map("n", "<leader>/", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
map("n", "<leader>ag", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
map("n", "<leader>w", "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>")
map("n", "<leader>wq", "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>")
map("n", "<leader>vs", "<Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>")
map("n", "<leader>sp", "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
map("n", "<leader>;", "<Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>")
map("n", "<leader>'", "<Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>")
map("n", "<leader>pr", "<Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>")
map("n", "<C-S-r>", ":!yarn local-install<CR>", { noremap = true, silent = false })
map("n", "<leader>q", "<Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>")
