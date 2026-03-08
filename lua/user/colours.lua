-- To find name of a colour, place cursor on text and use one of the following
-- vim commands:
--     :Inspect!
--     :highlight
--     :filter /markdown/ highlight
-- https://neovim.io/doc/user/api.html#nvim_set_hl()

-- Silence global vim warning.
---@diagnostic disable: undefined-global
-- local vim = vim
local hl = vim.api.nvim_set_hl
local madd = vim.fn.matchadd
local cmd = vim.cmd
---@diagnostic enable: undefined-global

-- Parameter hints etc.
hl(0, "LspInlayHint", { fg = "#222222" })

---- Tweaks to zenburn... I only like red to mean a problem.
hl(0, "Boolean", { fg = "#bfbfbf", ctermfg = 181 })
hl(0, "Character", { fg = "#a3aca3", ctermfg = 181 })
hl(0, "Constant", { fg = "#a3dcdc", bold = true, ctermfg = 181 })
hl(0, "SpecialChar", { fg = "#a3a3dc", bold = true, ctermfg = 181 })
hl(0, "String", { fg = "#53BB83", ctermfg = 174 })
hl(0, "Tag", { fg = "#93e893", bold = true, ctermfg = 181 })
hl(0, "javaTSVariable", { fg = "#CEDF99" })

-- Show white space characters
hl(0, "NonText", { bold = true, fg = "#505050" })
hl(0, "Whitespace", { bold = true, fg = "#505050" })

-- Highlight cursor line/column
hl(0, "CursorColumn", { bg = "#0A396F" })
hl(0, "CursorLine", { bg = "#0A396F" })

-- Git changes and margins
hl(0, "GitSignsAdd", { fg = "#4FC53D", bg = "#343434" })
hl(0, "GitSignsDelete", { fg = "#E13D3D", bg = "#343434" })
hl(0, "GitSignsChange", { fg = "#5585DA", bg = "#343434" })
hl(0, "GitSignsCurrentLineBlame", { bold = true, fg = "Black", bg = "#0A396F" })
cmd("highlight default link gitblame GitSignsCurrentLineBlame")

-- Selected area colour
hl(0, "Visual", { bold = true, fg = "#ffffff", bg = "#ff0000" })

-- Search hit colour, also the colour of selection when yanked!
hl(0, "Search", { bold = true, fg = "Black", bg = "#00ffff" })

-- Spelling
hl(0, "SpellBad", { sp = "Red", undercurl = true, fg = "NONE" })
hl(0, "SpellLocal", { sp = "Orange", fg = "NONE" })
hl(0, "SpellCap", { sp = "Pink", fg = "NONE" })
hl(0, "SpellRare", { sp = "Yellow", fg = "NONE" })

-- Pop-up and Float menu
hl(0, "Pmenu", { fg = "Wheat", bg = "Black" })
hl(0, "PmenuSbar", { bg = "Gray35" })
hl(0, "PmenuThumb", { bg = "Wheat" })
hl(0, "PmenuSel", { bold = true, fg = "Black", bg = "Wheat" })
hl(0, "NormalFloat", { fg = "Wheat", bg = "Black" })
hl(0, "NormalNC", { bg = "Black" })
hl(0, "VertSplit", { fg = "#444444", bg = "Black" })

-- Line number colour
hl(0, "LineNr", { fg = "RoyalBlue1", bg = "Gray19" })
hl(0, "CursorLineNr", { fg = "Yellow", bg = "Gray19" })

-- Diff colours
hl(0, "DiffAdd", { fg = "#999999", bg = "#115511" })
hl(0, "DiffChange", { bg = "#222266" })
hl(0, "DiffDelete", { fg = "#552222", bg = "#552222" })
hl(0, "DiffText", { fg = "#CC2222", bg = "#222266" })

-- LSP colours
hl(0, "LspDiagnosticsDefaultError", { fg = "#F44747" })
hl(0, "LspDiagnosticsDefaultWarning", { fg = "#FF8800" })
hl(0, "LspDiagnosticsDefaultInformation", { fg = "#FFCC66" })
hl(0, "LspDiagnosticsDefaultHint", { fg = "#4FC1FF" })

hl(0, "LspDiagnosticsFloatingError", { fg = "#F44747" })
hl(0, "LspDiagnosticsFloatingWarning", { fg = "#FF8800" })
hl(0, "LspDiagnosticsFloatingWarn", { fg = "#FF8800" })
hl(0, "LspDiagnosticsFloatingInformation", { fg = "#FFCC66" })
hl(0, "LspDiagnosticsFloatingInfor", { fg = "#FFCC66" })
hl(0, "LspDiagnosticsFloatingHint", { fg = "#4FC1FF" })

hl(0, "LspDiagnosticsSignError", { fg = "#F44747" })
hl(0, "LspDiagnosticsSignWarning", { fg = "#FF8800" })
hl(0, "LspDiagnosticsSignInformation", { fg = "#FFCC66" })
hl(0, "LspDiagnosticsSignHint", { fg = "#4FC1FF" })

hl(0, "LspDiagnosticsUnderlineError", { bg = "#F44747" })
hl(0, "LspDiagnosticsUnderlineWarning", { bg = "#FF8800" })
hl(0, "LspDiagnosticsUnderlineInformation", { bg = "#FFCC66" })
hl(0, "LspDiagnosticsUnderlineHint", { bg = "#4FC1FF" })

hl(0, "LspDiagnosticsVirtualTextError", { fg = "#F44747" })
hl(0, "LspDiagnosticsVirtualTextWarning", { fg = "#FF8800" })
hl(0, "LspDiagnosticsVirtualTextInformation", { fg = "#FFCC66" })
hl(0, "LspDiagnosticsVirtualTextHint", { fg = "#4FC1FF" })

-- Matching parenthesis
hl(0, "MatchParen", { bold = true, fg = "Black", bg = "Cyan" })

-- Highlight git merge conflict markers.
hl(0, "gitMergeConflictStart", { fg = "Black", bg = "Red" })
madd("gitMergeConflictStart", "^<\\{7\\} .*$", 60)

hl(0, "gitMergeConflictMid", { fg = "Yellow", bg = "Red" })
madd("gitMergeConflictMid", "^=\\{7\\}$", 60)

hl(0, "gitMergeConflictEnd", { fg = "Black", bg = "Red" })
madd("gitMergeConflictEnd", "^>\\{7\\} .*$", 60)

-- Highlight spaces at end of line
hl(0, "TrailingWhitespace", { bg = "black", fg = "Red" })

-- Highlight #! lines... Both good and bad.
hl(0, "sheBangGood", { bold = true, italic = true, underline = true, fg = "#7fdf7f", bg = "NONE" })
madd(
    "sheBangGood",
    "^#!/usr/bin/env \\(bash\\|-S bash -e\\|sh\\|python3\\|zsh\\|groovy\\|perl\\|ruby\\|nix-shell\\|kotlin\\)$",
    20
)

hl(0, "sheBangNix", { bold = true, italic = true, underline = true, fg = "#54db54", bg = "NONE" })
madd("sheBangNix", "^#! nix-shell .*$", 20)

hl(0, "sheBangBad", { bold = true, fg = "#E46600", bg = "NONE" })
madd("sheBangBad", "^#!.*")

-- current word highlighting
hl(0, "IncSearch", { bold = true, bg = "#007D9E" })

hl(0, "HighlightUrl", { underline = true, bold = true, fg = "#0099FF", sp = "#0099FF" })

hl(0, "Tag", { bold = true, fg = "Pink" })
hl(0, "Todo", { bold = true, fg = "LightGreen" })

-- Highlight folds
hl(0, "Folded", { fg = "#777777", bg = "#000000" })

-- Copilot colours
hl(0, "CopilotSuggestion", { fg = "#025FB0", ctermfg = 8 })

-- Highlight markers
hl(0, "markerStart", { fg = "#777777", bg = "#000000" })
hl(0, "markerEnd", { fg = "#777777", bg = "#000000" })
madd("markerStart", "^.*{\\{3\\}.*$", 50)
madd("markerEnd", "^.*}\\{3\\}.*$", 50)

-- Highlight my marker lines, Lines ending in 5 or more "." or "-" or "#" or "="
hl(0, "markerLineCommentGrey", { fg = "#000000", bg = "#999999" }) -- +++++
madd("markerLineCommentGrey", "[^ ]*[+]\\{5,\\}$", 50)
hl(0, "markerLineCommentGreen", { fg = "#000000", bg = "#009900" }) -- -----
madd("markerLineCommentGreen", "[^ ]*[-#]\\{5,\\}$", 50) -- #####
hl(0, "markerLineCommentAmber", { fg = "#000000", bg = "#999900" }) -- .....
madd("markerLineCommentAmber", "[^ ]*\\.\\{5,\\}$", 50)
hl(0, "markerLineCommentRed", { fg = "#000000", bg = "#990000" }) -- =====
madd("markerLineCommentRed", "[^ ]*=\\{5,\\}$", 50)
hl(0, "markerLineCommentBrightRed", { fg = "#000000", bg = "#FF0000" }) -- *****
madd("markerLineCommentBrightRed", "[^ ]*\\*\\{5,\\}$", 50)

-- Deprecated words
hl(0, "deprecatedWord", { fg = "#FFFFFF", bg = "#442222" })
madd("deprecatedWord", "[Dd][Ee][Pp][Rr][Ee][Cc][Aa][Tt][Ee][Dd]", 50)

-- Hop colours
hl(0, "HopNextKey", { bold = true, fg = "#ff007c" })
hl(0, "HopNextKey1", { bold = true, fg = "#00ccff" })
hl(0, "HopNextKey2", { bold = true, fg = "#0099ff" })
hl(0, "HopUnmatched", { fg = "#888888" })
