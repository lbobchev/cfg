-- YAML — yaml-language-server (schemas from SchemaStore)
local s = require("lbobc.lsp.shared")

vim.lsp.config("yamlls", {
  cmd = { s.mason_bin("yaml-language-server"), "--stdio" },
  filetypes = { "yaml" },
  root_markers = { ".git" },
  settings = {
    redhat = { telemetry = { enabled = false } },
  },
  on_attach = s.on_attach,
  capabilities = s.capabilities,
})
vim.lsp.enable("yamlls")
