-- Bicep — bicep-lsp (Bicep.LangServer on the .NET 10 runtime)
local s = require("lbobc.lsp.shared")

vim.lsp.config("bicep", {
  cmd = { s.mason_bin("bicep-lsp") },
  filetypes = { "bicep", "bicep-params" },
  root_markers = { "bicepconfig.json", ".git" },
  on_attach = s.on_attach,
  capabilities = s.capabilities,
})
vim.lsp.enable("bicep")
