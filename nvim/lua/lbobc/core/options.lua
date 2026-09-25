-- General editor options
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.scrolloff = 8
vim.opt.splitbelow = true
vim.opt.shellxquote = ""
vim.opt.cursorline = true
vim.opt.guicursor = ""
vim.opt.termguicolors = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.wo.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.cmd([[set colorcolumn=100]])
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = false
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0  -- Hide help banner
vim.g.netrw_winsize = 25 -- Set window width
vim.g.netrw_altv = 1    -- Vertical splits to the right
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- cfg shared theme state: read once at startup. "light" = e-ink grey paper
-- (bright room); default "dark" (e-ink charcoal). Drives nvim's `background` so the
-- built-in default colorscheme (no plugin) repaints syntax text to match.
-- The transparent-editor + float/selection overrides live in a ColorScheme
-- autocmd (autocmds.lua) so they survive every colorscheme reapply, including
-- the deferred one triggered by setting `background` here and any live toggle.
local _xdg = os.getenv("XDG_CONFIG_HOME")
local _cfg_theme_path = (_xdg and _xdg ~= "" and _xdg or vim.fn.expand("~/.config")) .. "/cfg-theme"
local _theme = "dark"
if vim.fn.filereadable(_cfg_theme_path) == 1 then
  local _ok, _lines = pcall(vim.fn.readfile, _cfg_theme_path)
  if _ok and _lines and _lines[1] == "light" then
    _theme = "light"
  end
end
vim.g.cfg_theme = _theme

-- E-ink palettes: syntax in shades of ink, structure by weight and slant, a
-- muted tint for types and functions; diagnostics, diffs and spelling keep the
-- default colorscheme's colours.
local _cfg_palettes = {
  light = {
    paper = "#eeebe3", ink = "#2b2b2b", soft = "#505050", faint = "#6b6b6b", line_nr = "#7a7a7a",
    bar = "#e3dfd6", status = "#d6d2c9", float = "#e5e1d8", sel = "#c8c4bb", search = "#d9cfb0",
    type = "#34507a", func = "#2f5f5a",
  },
  dark = {
    paper = "#212120", ink = "#cfccc4", soft = "#a8a59e", faint = "#8a877f", line_nr = "#75726b",
    bar = "#2c2b29", status = "#3a3936", float = "#2a2927", sel = "#45433f", search = "#4d4636",
    type = "#9aabc8", func = "#8fb8b0",
  },
}

-- Apply transparent editor bg + the e-ink palette above. Done in
-- THREE places for robustness against plugin/colorscheme reapply timing:
--  * inline below (synchronous at startup -- works even when `background` is
--    already the target value and so fires no ColorScheme event, e.g. dark);
--  * a ColorScheme autocmd registered BEFORE `background` is set, so it catches
--    the fire from the dark<->light flip (and any later plugin reapply);
--  * CfgSetTheme() below, which bin/theme-toggle.sh calls on a live toggle.
local _apply_cfg_theme_hl = function()
  local p = _cfg_palettes[vim.g.cfg_theme] or _cfg_palettes.dark
  local set = vim.api.nvim_set_hl
  set(0, "Normal", { bg = "none" })
  set(0, "NormalFloat", { bg = p.float })
  set(0, "FloatBorder", { bg = p.float })
  set(0, "Visual", { bg = p.sel })
  set(0, "PmenuSel", { bg = p.sel })
  set(0, "TelescopeSelection", { bg = p.sel })
  for _, g in ipairs({ "@variable", "Constant", "Identifier", "PreProc",
    "Operator", "Delimiter", "Directory", "Question", "MoreMsg", "QuickFixLine" }) do
    set(0, g, { fg = p.ink })
  end
  for _, g in ipairs({ "Statement", "Title", "Todo" }) do
    set(0, g, { fg = p.ink, bold = true })
  end
  set(0, "Type", { fg = p.type })
  set(0, "Function", { fg = p.func })
  set(0, "@constructor", { link = "Type" })
  set(0, "String", { fg = p.soft })
  set(0, "Special", { fg = p.soft })
  set(0, "Comment", { fg = p.faint, italic = true })
  set(0, "CursorLine", { bg = p.bar })
  set(0, "LineNr", { fg = p.line_nr })
  set(0, "Folded", { fg = p.faint, bg = p.bar })
  set(0, "StatusLine", { fg = p.ink, bg = p.status })
  set(0, "StatusLineNC", { fg = p.faint, bg = p.bar })
  set(0, "TabLine", { fg = p.faint, bg = p.bar })
  set(0, "TabLineFill", { bg = p.bar })
  set(0, "WinBar", { fg = p.faint, bold = true })
  set(0, "WinBarNC", { fg = p.faint })
  set(0, "Pmenu", { fg = p.ink, bg = p.bar })
  set(0, "Search", { fg = p.ink, bg = p.search })
  set(0, "CurSearch", { fg = p.paper, bg = p.ink })
end
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = _apply_cfg_theme_hl })
_apply_cfg_theme_hl()

-- Flip nvim's background to match the terminal palette. Re-applies the default
-- colorscheme; the ColorScheme autocmd above re-runs our overrides after it.
vim.o.background = _theme
_apply_cfg_theme_hl()

-- Entry point for bin/theme-toggle.sh (nvim --server ... --remote-expr).
function _G.CfgSetTheme(theme)
  vim.g.cfg_theme = theme
  vim.o.background = theme
  _apply_cfg_theme_hl()
end
