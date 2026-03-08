-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options based on this: https://www.lazyvim.org/configuration/general

-- Silence global vim warning, also for rest of file.
---@diagnostic disable: undefined-global
local vim = vim
local opt = vim.opt
local cmd = vim.cmd
---@diagnostic enable: undefined-global

--                                            ___        _   _                                                        --
--                                           / _ \ _ __ | |_(_) ___  _ __  ___                                        --
--                                          | | | | '_ \| __| |/ _ \| '_ \/ __|                                       --
--                                          | |_| | |_) | |_| | (_) | | | \__ \                                       --
--                                           \___/| .__/ \__|_|\___/|_| |_|___/                                       --
--                                                |_|                                                                 --
local visible_space = "·"
opt.listchars = {
    eol = "¶",
    tab = "» ",
    trail = "·",
    extends = ">",
    precedes = "<",
    space = visible_space,
    multispace = visible_space,
    lead = visible_space,
    nbsp = visible_space,
}

-- Enable folding in Neovim
opt.fillchars = vim.opt.fillchars
    + {
        fold = "·", -- folded lines
        foldopen = "", -- open fold marker
        foldclose = "", -- ▸",  -- closed fold marker
    }
opt.foldmethod = "marker" -- Use marker-based folding
opt.foldlevel = 99 -- Open=99, Closed=0 folds

-- Main options.
opt.autoindent = true --  Good auto indent
opt.backup = false -- Disable backup files (optional)
opt.backupdir = vim.fn.expand("~/.vim/backup") -- Custom backup directory
opt.clipboard = "unnamedplus" -- Enable system clipboard support for copy-pasting
opt.colorcolumn = { 80, 120, 200 }
opt.completeopt = { "menu", "menuone", "noselect" } -- Define completion menu options
opt.cursorcolumn = true -- Highlight the column under the cursor
opt.cursorline = true -- Highlight the line under the cursor
opt.directory = vim.fn.expand("~/.vim/swap") -- Custom swap file directory
opt.expandtab = true -- Convert tabs to spaces
opt.hlsearch = true -- Highlight search results
opt.ignorecase = true -- Ignore case in searches
opt.incsearch = true -- Incremental search (shows matches as you type)
opt.linebreak = true
opt.mouse = "a" -- Enable mouse in all modes (normal, insert, etc.)
opt.number = true -- Show absolute line numbers
opt.pumheight = 20 -- Pop up menu height
opt.relativenumber = true -- Show relative line numbers
opt.scrolloff = 3 -- Keep 3 line buffer at top and bottom of the screen
opt.shiftwidth = 4 -- Number of spaces to use for each indentation level
opt.smartindent = true -- Automatically indent code
opt.spell = true -- Switch on spell checking
opt.spellfile = vim.fn.expand("~/bin/dictionaries/dictionary.add") -- Custom spell file location in home directory
opt.spelllang = "en_gb" -- Proper spelling, wot like I do!  Colour ✅, color ❎.
opt.swapfile = false -- Disable swap files (optional)
opt.tabstop = 4 -- Number of spaces a tab character represents
opt.termguicolors = true -- Enable true color support
opt.textwidth = 120 --  Maximum width of text that is being displayed
opt.undodir = vim.fn.expand("~/.vim/undo") -- Set the undo directory
opt.undofile = true -- Enable persistent undo history across sessions
opt.updatetime = 300 --  Faster completion
opt.wrap = false -- Don't wrap lines
opt.wrapmargin = 2 -- Start wrapping 2 characters from the right edge
vim.g.auto_close_tree = 0 -- Disables automatic closing of the file explorer tree (0 = off, 1 = on)
vim.g.auto_complete = true -- Enables auto-completion in insert mode (true = enabled)
vim.g.autoformat = false -- Disables automatic formatting (false = off)
vim.g.format_on_save = false -- Disables automatic formatting when saving files (false = off)
vim.g.ignore_case = true -- Makes searches case-insensitive (true = ignore case in searches)
vim.g.lazyvim_picker = "fzf" -- Sets the file picker to fzf (can also be 'telescope' or 'auto' with `:LazyExtras`)
vim.g.smart_case = true -- Makes searches case-sensitive if uppercase letters are used (true = smart case)
vim.g.timeoutlen = 100 -- Sets the time (in milliseconds) for waiting for a key sequence before it times out (default is 100ms)
vim.g.use_icons = true -- Enables the use of icons in the UI (true = use icons for file types and other elements)
vim.log.level = "warn" -- Sets the log level to 'warn' (can be 'debug', 'info', 'warn', 'error' for logging verbosity)

--                       _    _     _                    _       _   _                        _                       --
--                      / \  | |__ | |__  _ __ _____   _(_) __ _| |_(_) ___  _ __  ___    ___| |_ ___                 --
--                     / _ \ | '_ \| '_ \| '__/ _ \ \ / / |/ _` | __| |/ _ \| '_ \/ __|  / _ \ __/ __|                --
--                    / ___ \| |_) | |_) | | |  __/\ V /| | (_| | |_| | (_) | | | \__ \ |  __/ || (__                 --
--                   /_/   \_\_.__/|_.__/|_|  \___| \_/ |_|\__,_|\__|_|\___/|_| |_|___/  \___|\__\___|                --

-- Useful abbreviations
cmd([[iabbrev #! #!/usr/bin/env zsh]])

-- Currency symbols
cmd([[iabbrev GBP £]])
cmd([[iabbrev EUR €]])

-- Typos
cmd([[iabbrev Appl Application]])
cmd([[iabbrev Attr Attributes]])
cmd([[iabbrev Req Request]])
cmd([[iabbrev Vari Variables]])
cmd([[iabbrev acommodate accommodate]])
cmd([[iabbrev adn and]])
cmd([[iabbrev adnd and]])
cmd([[iabbrev defintion definition]])
cmd([[iabbrev governement government]])
cmd([[iabbrev occured occurred]])
cmd([[iabbrev recieved received]])
cmd([[iabbrev seperated separated]])
cmd([[iabbrev teh the]])
cmd([[iabbrev tehn then]])
cmd([[iabbrev waht what]])

-- Miscellaneous:
cmd([[iabbrev aka also known as]]) -- Expands 'aka' to 'also known as'
cmd([[iabbrev pls please]]) -- Expands 'please'
cmd([[iabbrev repo repository]]) -- Expands 'repo' to 'repository'

--                           _   _                 _____                 _   _                                        --
--                          | | | |___  ___ _ __  |  ___|   _ _ __   ___| |_(_) ___  _ __  ___                        --
--                          | | | / __|/ _ \ '__| | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|                       --
--                          | |_| \__ \  __/ |    |  _|| |_| | | | | (__| |_| | (_) | | | \__ \                       --
--                           \___/|___/\___|_|    |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/                       --
--                                                                                                                    --

vim.api.nvim_create_user_command("SudoWrite", function()
    local path = vim.fn.expand("%:p")

    if path == "" then
        vim.notify("SudoWrite: buffer has no file name", vim.log.levels.ERROR)
        return
    end

    -- Write buffer through sudo tee
    vim.cmd("silent write !sudo tee " .. vim.fn.shellescape(path) .. " >/dev/null")

    -- Reload file to clear modified flag
    vim.cmd("edit!")
end, {})
