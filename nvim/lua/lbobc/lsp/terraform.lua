-- Terraform — terraform-ls
local s = require("lbobc.lsp.shared")

-- An empty .tf file otherwise detects as TinyFugue ("tf").
vim.filetype.add({ extension = { tf = "terraform" } })

vim.lsp.config("terraformls", {
  cmd = { s.mason_bin("terraform-ls"), "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
  -- terraform-ls formats through the terraform CLI; without it each save shows an RPC error.
  on_init = function(client)
    if vim.fn.executable("terraform") == 0 then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
  on_attach = s.on_attach,
  capabilities = s.capabilities,
})
vim.lsp.enable("terraformls")
