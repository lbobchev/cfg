return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = "markdown",
  config = function()
    require("render-markdown").setup({
      -- This plugin also styles the LSP hover float. Neovim gives that float
      -- the `markdown` filetype and the `nofile` buftype, so the plugin
      -- attaches to it. Two plugin defaults make the C# hover text hard to
      -- read.
      --
      -- 1. The plugin sets 'conceallevel' to 3. Level 3 hides concealed text
      --    and ignores the replacement character. The Roslyn language server
      --    separates some words with the `&nbsp;` entity. The Neovim markdown
      --    query conceals `&nbsp;` and puts a space in its place, but level 3
      --    removes that space too. The words then join with no space between
      --    them: "Returns value clamped" shows as "Returnsvalueclamped".
      --    Level 2 keeps the space.
      -- 2. The plugin writes the code fence language on a line of its own.
      --    This adds a "csharp" row above every hover signature. Neovim hides
      --    that line without the plugin.
      --
      -- The override changes `nofile` buffers only. Markdown files keep the
      -- full plugin style.
      overrides = {
        buftype = {
          nofile = {
            win_options = { conceallevel = { rendered = 2 } },
            code = { language_name = false },
          },
        },
      },
    })
  end,
}
