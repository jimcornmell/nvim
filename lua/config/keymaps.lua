-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Silence global vim warning.
---@diagnostic disable: undefined-global
local f = require("user.functions")
local vim = vim
local keymap = vim.keymap.set
---@diagnostic enable: undefined-global

-- -------------------------------------------------------------------------- --

-- Convenience alias, highlight char.
local hiC = " 🎫" -- Mark the key map description as from this file.

-- -------------------------------------------------------------------------- --

--Redraw.
keymap("n", "<C-l>", ":nohl<CR><C-l>", { desc = "Redraws the screen and removes any search highlighting." .. hiC })

--Move line up/down.
keymap("n", "<A-Up>", "<cmd>m .-2<CR>==", { silent = true, desc = "Move line up" .. hiC })
keymap("n", "<A-Down>", "<cmd>m .+1<CR>==", { silent = true, desc = "Move line down" .. hiC })
keymap("i", "<A-Up>", "<Esc><cmd>m .-2<CR>==gi", { silent = true, desc = "Move line up" .. hiC })
keymap("i", "<A-Down>", "<Esc><cmd>m .+1<CR>==gi", { silent = true, desc = "Move line down" .. hiC })
keymap("v", "<A-Up>", "<cmd>m '<-2<CR>gv=gv", { silent = true, desc = "Move line up" .. hiC })
keymap("v", "<A-Down>", "<cmd>m '>+1<CR>gv=gv", { silent = true, desc = "Move line down" .. hiC })

--Buffer next and previous with tab.
keymap("n", "<Tab>", ":bnext<CR>", { desc = "Next tab" .. hiC, silent = true })
keymap("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous tab" .. hiC, silent = true })

--Toggle comment and move to next line, or comment selection.
keymap("n", "<C-/>", "gccj", { remap = true, silent = true, desc = "Toggle comment and move to next line" .. hiC })

--Turn off relative numbers
keymap("n", "<leader>A", ":set norelativenumber<CR>", { silent = true, desc = "Absolute line numbers" .. hiC })

--Turn on relative numbers
keymap("n", "<leader>R", ":set relativenumber<CR>", { silent = true, desc = "Relative line numbers" .. hiC })

--Quit.
keymap("n", "<C-q>", ":q<CR>", { desc = "Quit" .. hiC })

--Hop around page.
keymap("n", "S", ":HopWord<cr>", { silent = true, desc = "Fast hop around screen" .. hiC })

--Toggle Whitespace visibility
keymap("n", "<leader>W", ":set list!<CR>", { silent = true, desc = "Toggle whitespace visibility" .. hiC })

--Spell correction shortcut
-- Equivalent to: map z1 z=1
keymap("n", "z1", "z=1", { noremap = true, desc = "Spelling correction options" .. hiC })

--Yank all Equivalent to: map <C-a> <esc>ggVGy+<CR>
keymap("n", "<C-a>", ":%y+<CR>", { noremap = true, silent = true, desc = "Copy/yank all" .. hiC })

--<Ctrl-c> and yy copy to clipboard, paste with <Shift-Insert>
-- Copy current selection to system clipboard
keymap("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy" .. hiC })

--Run macro q with just typing Q
keymap("n", "Q", "@q", { noremap = true, desc = "Quick run macro q" .. hiC })

--Reformat paragraph to X characters
keymap("n", "gF", "gwip<CR>", { silent = true, remap = true, desc = "Format to W chars 'set textwidth=W'" .. hiC })

--Lookup documentation for current word on DevDocs : https://devdocs.io
-- NOTE Needs plugin: "rhysd/devdocs.vim"
keymap(
    "n",
    "gm",
    "<Plug>(devdocs-under-cursor)",
    { remap = true, desc = "Open devdocs.io on word/command under cursor" .. hiC }
)

-- Surround with quotes / characters (vim-surround)
keymap("n", 'g"', 'ysiW"', { remap = true, desc = 'Surround word with "' .. hiC })
keymap("n", "g'", "ysiW'", { remap = true, desc = "Surround word with '" .. hiC })
keymap("n", "g`", "ysiW`", { remap = true, desc = "Surround word with `" .. hiC })
keymap("n", "g*", "ysiW*", { remap = true, desc = "Surround word with *" .. hiC })
keymap("n", "g_", "ysiW_", { remap = true, desc = "Surround word with _" .. hiC })
keymap("n", "g(", "ysiW(", { remap = true, desc = "Surround word with ()" .. hiC })
keymap("n", "g[", "ysiW[", { remap = true, desc = "Surround word with []" .. hiC })
keymap("n", "g{", "ysiW{", { remap = true, desc = "Surround word with {}" .. hiC })

keymap("n", 'gQ', '', { remap = true, desc = 'Surround (ysiWX) with X and comma move' .. hiC })
keymap("n", 'gQ"', 'ysiW"f"hxp', { remap = true, desc = 'Surround (ysiW") with " and comma move' .. hiC })
keymap("n", "gQ'", "ysiW'f'hxp", { remap = true, desc = "Surround (ysiW') with ' and comma move" .. hiC })
keymap("n", "gQ`", "ysiW`f`hxp", { remap = true, desc = "Surround (ysiW`) with ` and comma move" .. hiC })
keymap("n", "gQ*", "ysiW*f*hxp", { remap = true, desc = "Surround (ysiW*) with * and comma move" .. hiC })
keymap("n", "gQ_", "ysiW_f_hxp", { remap = true, desc = "Surround (ysiW_) with _ and comma move" .. hiC })
keymap("n", "gQ(", "ysiW(lxf)hxhxp", { remap = true, desc = "Surround (ysiW() with () and comma move" .. hiC })
keymap("n", "gQ[", "ysiW[lxf]hxhxp", { remap = true, desc = "Surround (ysiW[) with [] and comma move" .. hiC })
keymap("n", "gQ{", "ysiW{lxf}hxhxp", { remap = true, desc = "Surround (ysiW{) with {} and comma move" .. hiC })

--Dial : See: ~/.config/nvim/lua/plugins/plugins.lua
-- Foreground - enabled - True - FATAL
keymap("n", "<C-.>", "<Plug>(dial-increment)", { silent = true, desc = "Increment value" .. hiC })
keymap("n", "<C-,>", "<Plug>(dial-decrement)", { silent = true, desc = "Decrement value" .. hiC })

-- -------------------------------------------------------------------------- --

keymap("n", "gj", f.JumpToSelection, { remap = true, desc = "Jump to selection" .. hiC })

-- -------------------------------------------------------------------------- --

--Execute current line, SHELL.
keymap("n", "gR", f.ExecuteCurrentLine, { remap = true, desc = "Run SHELL command under cursor" .. hiC })
--Execute current line, VIM.
keymap("n", "gV", ":exe getline('.')<CR>", { remap = true, desc = "Run VIM command under cursor" .. hiC })
--Execute current line, LUA.
keymap("n", "gL", ":lua getline('.')<CR>", { remap = true, desc = "Run LUA command under cursor" .. hiC })

--Execute current file, SHELL.
keymap("n", "<A-r>", ":w<CR>:!%:p<CR>", { silent = true, remap = true, desc = "Execute current line in OS" .. hiC })

-- -------------------------------------------------------------------------- --

-- Command `LspDetach`
vim.api.nvim_create_user_command("LspDetach", f.LspDetachForCurrentFile, {})

vim.keymap.set("n", "<leader>ux", f.LspDetachForCurrentFile, { desc = "Disable LSP for current buffer" })

-- -------------------------------------------------------------------------- --

keymap("v", "<leader>I", f.CreateSequence, {
    silent = true,
    noremap = true,
    desc = "Create sequence in visual mode, start = N, increment = M" .. hiC,
})

-- -------------------------------------------------------------------------- --

--Saves a few key presses
keymap({ "n", "v", "o" }, "<C-s>", function()
    local full_path = vim.api.nvim_buf_get_name(0)
    vim.cmd("write")
    vim.notify("File saved: " .. full_path, vim.log.levels.INFO)
end, { remap = true, silent = true, desc = "Save" .. hiC })

-- -------------------------------------------------------------------------- --

--Zen mode.
keymap("n", "<leader>z", function()
    vim.cmd("ZenMode")
    vim.cmd("set nospell")
    vim.notify("Zenmode, use F2 to switch off page furniture.", vim.log.levels.INFO)
end, { silent = true, desc = "Zen Mode, use F3 to switch off furniture" .. hiC })

-- -------------------------------------------------------------------------- --

--Make current file executable
keymap("n", "<A-e>", function()
    local path = vim.fn.expand("%:p")
    vim.fn.system("touch " .. vim.fn.shellescape(path) .. " && chmod a+x " .. vim.fn.shellescape(path))
    vim.notify("File is now executable! chmod a+x", vim.log.levels.INFO)
end, { silent = true, desc = "Make current buffer executable" .. hiC })

-- -------------------------------------------------------------------------- --

keymap("n", "<leader>jB", f.FigletCurrentLine, { silent = true, remap = true, desc = "Figlet current line" .. hiC })

-- -------------------------------------------------------------------------- --

-- Snippets and helpers
keymap("n", "<leader>j", "", { silent = true, remap = true, desc = "JimVim Tools" .. hiC })

keymap("n", "<leader>je", function()
    local fname = os.getenv("HOME") .. "/.config/nvim/snippets/" .. vim.bo.filetype .. ".json"
    vim.cmd("silent edit " .. fname)
end, { silent = true, remap = true, desc = "Snippet edit" .. hiC })

keymap("n", "<leader>jA", function()
    local fname = os.getenv("HOME") .. "/.config/nvim/snippets/all.json"
    vim.cmd("silent edit " .. fname)
end, { silent = true, remap = true, desc = "Snippet edit ALL" .. hiC })

keymap("n", "<leader>js", f.SnippetSave, { silent = true, remap = true, desc = "Save last yank to snippet" .. hiC })

keymap("n", "<leader>jl", f.SnippetList, { silent = true, remap = true, desc = "Snippet list" .. hiC })

-- -------------------------------------------------------------------------- --

--Add (push) spaces to align next word with line above
keymap("n", "<C-P>", f.PushLine, { silent = true, remap = true, desc = "Push spaces to align with line above" .. hiC })

-- -------------------------------------------------------------------------- --

keymap(
    "n",
    "<leader>jE",
    f.TrimWhitespace,
    { silent = true, remap = true, desc = "Delete whitespace at end of all lines" .. hiC }
)

-- -------------------------------------------------------------------------- --

keymap(
    "n",
    "<leader>jh",
    f.OpenHelpAndCheatSheets,
    { silent = true, remap = true, desc = "Open help/cheatsheets" .. hiC }
)

-- ============================FUNCTION KEYS====================================== --

-- stylua: ignore
keymap("n", "<F1>", ":!xdg-open $HOME/bin/libs/cheatsheet.html<CR>:echo 'Open cheatsheet'<CR>", { silent = true, remap = true, desc = "Open help cheat-sheet" .. hiC })
-- stylua: ignore
keymap("n", "<F2>", f.ToggleAll, { silent = true, remap = true, desc = "Toggle all page furniture (line numbers, status line, tab line, etc)" .. hiC, })
keymap("n", "<F3>", "<leader>fF", { silent = true, remap = true, desc = "File search" .. hiC })
keymap("n", "<F4>", "<leader>fe<CR>", { silent = true, remap = true, desc = "Open file explorer" .. hiC })
-- F5 reserved for kitty: open selected (intentionally unmapped)
-- stylua: ignore
keymap("n", "<F6>", ":*&<CR>", { noremap = true, silent = true, desc = "Repeat last range & substitute: * = last range, & = last s/foo/bar/" .. hiC, })
-- stylua: ignore
keymap("n", "<F7>", function() vim.cmd("vsplit") vim.cmd("bnext") vim.cmd("windo diffthis") end, { silent = true, desc = "Diff current buffer with the next one" .. hiC })
keymap("n", "<F8>", "<leader>gg<CR>", { silent = true, remap = true, desc = "Lazy Git" .. hiC })
keymap("n", "<F9>", "<leader>sG", { silent = true, remap = true, desc = "File contents search" .. hiC })
-- F10 reserved for kitty: open new terminal (intentionally unmapped)
-- F11 reserved for kitty: full screen (intentionally unmapped)
keymap("n", "<F12>", f.FoldingToggle, { silent = true, remap = true, desc = "Toggle folding method" .. hiC })

-- ============================FUNCTION KEYS====================================== --
