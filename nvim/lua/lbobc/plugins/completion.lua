return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip", -- exposes LuaSnip snippets as a cmp source
  },
  config = function()
    local cmp = require("cmp")

    -- nvim-cmp draws its documentation window with the deprecated
    -- vim.lsp.util.stylize_markdown. That function decodes some HTML entities,
    -- but its table has no `&nbsp;` entry. The Roslyn language server
    -- separates the parameter names in a C# doc comment with `&nbsp;`, so the
    -- window shows the literal text "&nbsp;". This wrapper replaces the entity
    -- with a space before nvim-cmp fills the window.
    --
    -- The wrapper changes the entity only. It keeps the backslash that Roslyn
    -- puts before a punctuation mark. A backslash protects the character from
    -- the markdown syntax, and this window renders markdown with Vim syntax
    -- rules. An underscore in an identifier becomes italic text if the
    -- backslash goes away.
    --
    -- The hover float needs no wrapper. Neovim conceals `&nbsp;` there with a
    -- treesitter query. See lua/lbobc/plugins/render-markdown.lua.
    local entry = require("cmp.entry")
    local get_documentation = entry.get_documentation
    entry.get_documentation = function(self)
      local lines = get_documentation(self)
      if type(lines) ~= "table" then
        return lines
      end
      for i, line in ipairs(lines) do
        lines[i] = (line:gsub("&nbsp;", " "))
      end
      return lines
    end

    cmp.setup({
      snippet = {
        -- REQUIRED if using snippets
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
        ["<C-j>"] = cmp.mapping.select_next_item(),         -- Navigate next
        ["<C-k>"] = cmp.mapping.select_prev_item(),         -- Navigate previous
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- This sources from your LSP clients, including Roslyn
        { name = "luasnip" },  -- Snippets
      }, {
        { name = "buffer" },   -- Also suggests words from the current file
      })
    })
  end,
}
