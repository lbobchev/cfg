;; extends

; The Roslyn language server escapes the markdown punctuation in a C# doc
; comment. The hover float then shows "max\." and "\-or\-". The Neovim query
; highlights a backslash escape, but it does not conceal the backslash. This
; rule conceals the backslash and keeps the character after it. The offset
; moves the end of the capture back by one character, so the capture covers
; the backslash alone.
((backslash_escape) @conceal
  (#offset! @conceal 0 0 0 -1)
  (#set! conceal ""))
