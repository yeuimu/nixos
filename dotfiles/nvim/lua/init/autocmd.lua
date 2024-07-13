vim.opt.shadafile = "NONE"
vim.api.nvim_create_autocmd("CmdlineEnter", {
  once = true,
  callback = function()
    local shada = vim.fn.stdpath("state") .. "/shada/main.shada"
    vim.o.shadafile = shada
    vim.api.nvim_command("rshada! " .. shada)
  end,
})
