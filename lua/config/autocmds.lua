-- Autocmds are automatically loaded on the VeryLazy event
-- Auto Commands: https://vimhelp.org/autocmd.txt.html#autocmd-events
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Silence global vim warning.
---@diagnostic disable: undefined-global
local vim = vim
local autocmd = vim.api.nvim_create_autocmd
---@diagnostic enable: undefined-global

--                         _         _           ____                                          _                       --
--                        / \  _   _| |_ ___    / ___|___  _ __ ___  _ __ ___   __ _ _ __   __| |___                   --
--                       / _ \| | | | __/ _ \  | |   / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|                  --
--                      / ___ \ |_| | || (_) | | |__| (_) | | | | | | | | | | | (_| | | | | (_| \__ \                  --
--                     /_/   \_\__,_|\__\___/   \____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/                  --

-- Create an augroup to avoid duplicate autocommands
vim.api.nvim_create_augroup("FileHighlight", { clear = true })

-- Highlight whitespace a end of lines
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = "*",
    group = "FileHighlight",

    callback = function(args)
        -- Skip non-file buffers
        if vim.bo[args.buf].buftype ~= "" then
            return
        end

        vim.fn.matchadd("TrailingWhitespace", "\\s\\+\\%#\\@<!$")
    end,
})

-- Highlight matching words in buffer.
autocmd("CursorMoved", {
    callback = function()
        local cword = vim.fn.expand("<cword>")
        local escaped = vim.fn.escape(cword, "/\\")
        vim.cmd(string.format("match IncSearch /\\V\\<%s\\>/", escaped))
    end,
})

--                                  ____              _                __ _ _                                          --
--                                 / ___| _   _ _ __ | |_ __ ___  __  / _(_) | ___  ___                                --
--                                 \___ \| | | | '_ \| __/ _` \ \/ / | |_| | |/ _ \/ __|                               --
--                                  ___) | |_| | | | | || (_| |>  <  |  _| | |  __/\__ \                               --
--                                 |____/ \__, |_| |_|\__\__,_/_/\_\ |_| |_|_|\___||___/                               --
--                                        |___/                                                                        --

-- Load Siril syntax file when syntax is enabled
autocmd("Syntax", {
    pattern = "ssf",
    command = "source ~/.config/nvim/syntax/siril.vim",
})

-- Set filetype for .ssf files
autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.ssf",
    command = "set filetype=siril",
})
