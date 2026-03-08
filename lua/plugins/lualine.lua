return {
    {
        "nvim-lualine/lualine.nvim",
        opts = function()
            local lualine_require = require("lualine_require")
            lualine_require.require = require
            local icons = LazyVim.config.icons

            --- Colours, maps and icons
            local colors = {
                typewriteable = "#229900",
                typereadonly = "#FF3300",
                unmodified = "#229900",
                modified = "#FF3300",
                fileformatunix = "#229900",
                fileformatother = "#FF3300",
                filespaces = "#B3F6C0",
                filesymbol = "#B3F6C0",
                filename = "#ffffff",
                -- diagerror = "#F44747",
                -- diagwarning = "#FF8800",
                -- diaginfo = "#FFCC66",
                -- diaghint = "#4FC1FF",
                diagerror = "#ff3c3b",
                diagwarning = "#ECBE7B",
                diaginfo = "#51afef",
                diaghint = "#98be65",
                special = "#aaaaaa",
                currentposition = "#ffffff",
                sectionvimfg = "#000000",
                sectionfolderfg = "#ffffff",
                sectionfilefg = "#aaaaaa",
                sectiondiagfg = "#ffffff",
                sectiongitfg = "#ffffff",
                sectionpositionfg = "#aaaaaa",
                sectionfolderbg = "#000000",
                sectionfilebg = "#494949",
                sectiondiagbg = "#494949",
                sectiongitbg = "#000000",
                sectionpositionbg = "#666666",
            }

            -- For icons see this cheatsheet and just copy and paste the icons: https://www.nerdfonts.com/cheat-sheet
            -- I use the Nerd Font Sauce Code Pro: https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/SourceCodePro
            icons.statsvert = "⬍"
            icons.statshoriz = "⬌"
            icons.statsspace = "⯀"
            icons.statstab = "⯈"
            icons.typewriteable = ""
            icons.typereadonly = ""
            icons.unmodified = "○"
            icons.modified = "●"

            vim.o.laststatus = vim.g.lualine_laststatus
            local custom_theme = require("lualine.themes.tomorrow_night")

            custom_theme.normal.b = custom_theme.normal.b or { bg = "" }
            custom_theme.normal.c = custom_theme.normal.c or { bg = "" }
            custom_theme.normal.x = custom_theme.normal.x or { bg = "" }
            custom_theme.normal.y = custom_theme.normal.y or { bg = "" }
            custom_theme.normal.z = custom_theme.normal.z or { bg = "" }
            custom_theme.normal.b.bg = colors["sectionfolderbg"]
            custom_theme.normal.c.bg = colors["sectionfilebg"]
            custom_theme.normal.x.bg = colors["sectiondiagbg"]
            custom_theme.normal.y.bg = colors["sectiongitbg"]
            custom_theme.normal.z.bg = colors["sectionpositionbg"]
            custom_theme.normal.a.fg = colors["sectionvimfg"]
            custom_theme.normal.b.fg = colors["sectionfolderfg"]
            custom_theme.normal.c.fg = colors["sectionfilefg"]
            custom_theme.normal.x.fg = colors["sectiondiagfg"]
            custom_theme.normal.y.fg = colors["sectiongitfg"]
            custom_theme.normal.z.fg = colors["sectionpositionfg"]

            local opts = {
                options = {
                    theme = custom_theme,
                    globalstatus = vim.o.laststatus == 3,
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
                },

                sections = {
                    -- https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components

                    -- VIM Mode
                    lualine_a = {
                        "mode",

                        -- Search count: e.g: [2/4]
                        "searchcount",

                        -- Noice status
                        {
                            function()
                                return require("noice").api.status.command.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and require("noice").api.status.command.has()
                            end,
                        },
                        -- Noice mode
                        {
                            function()
                                return require("noice").api.status.mode.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and require("noice").api.status.mode.has()
                            end,
                        },
                        -- DAP status
                        {
                            function()
                                return "  " .. require("dap").status()
                            end,
                            cond = function()
                                return package.loaded["dap"] and require("dap").status() ~= ""
                            end,
                        },
                    },

                    -- Folder
                    lualine_b = {
                        function()
                            -- cache git root to avoid repeated system calls
                            if not vim.b._git_root_cache then
                                local git_root =
                                    vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
                                if vim.v.shell_error == 0 and git_root ~= "" then
                                    vim.b._git_root_cache = vim.fn.fnamemodify(git_root, ":t")
                                else
                                    -- if not in git repo use cwd
                                    vim.b._git_root_cache = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                                end
                            end
                            return vim.b._git_root_cache
                        end,
                    },

                    -- File name with pretty path and readonly status.
                    lualine_c = {
                        -- Readonly/writable status icon.
                        {
                            function()
                                local isReadonly = vim.bo.readonly or not vim.bo.modifiable
                                return isReadonly and icons["typereadonly"] or icons["typewriteable"]
                            end,
                            separator = "",
                            padding = { left = 1, right = 0 },
                            color = function()
                                local isReadonly = vim.bo.readonly or not vim.bo.modifiable
                                return { fg = isReadonly and colors["typereadonly"] or colors["typewriteable"] }
                            end,
                        },
                        -- Modified/unmodified status icon.
                        {
                            function()
                                return vim.bo.modified and icons["modified"] or icons["unmodified"]
                            end,
                            separator = "",
                            padding = { left = 1, right = 0 },
                            color = function()
                                return { fg = vim.bo.modified and colors["modified"] or colors["unmodified"] }
                            end,
                        },
                        -- File format - i.e. unix, dos, mac.
                        {
                            "fileformat",
                            separator = "",
                            padding = { left = 1, right = 1 },
                            color = function()
                                local ff = vim.bo.fileformat
                                return { fg = (ff == "unix") and colors["fileformatunix"] or colors["fileformatother"] }
                            end,
                        },

                        -- Spaces or tabs count.
                        {
                            function()
                                return "" .. vim.bo.shiftwidth
                            end,
                            separator = "",
                            padding = { left = 0, right = 0 },
                            color = { fg = colors["filespaces"] },
                        },
                        -- Spaces or tabs symbol.
                        {
                            function()
                                if vim.bo.expandtab then
                                    return icons["statsspace"]
                                else
                                    return icons["statstab"]
                                end
                            end,
                            padding = { left = 0, right = 1 },
                            color = { fg = colors["filesymbol"] },
                        },

                        -- File encoding - i.e. utf-8.
                        {
                            "encoding",
                            padding = { left = 1, right = 1 },
                        },

                        -- Pretty file path.
                        {
                            LazyVim.lualine.pretty_path({ readonly_icon = "" }),
                            padding = { left = 1, right = 1 },
                            color = { fg = colors["filename"] },
                        },
                    },

                    lualine_x = {
                        -- File format - i.e. lua. Also prefixed with icon.
                        {
                            "filetype",
                            separator = "",
                            padding = { left = 0, right = 1 },
                        },

                        -- LSP Diagnostics, errors, warnings, info, hints.
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                            diagnostics_color = {
                                error = { fg = colors["diagerror"] },
                                warn = { fg = colors["diagwarning"] },
                                info = { fg = colors["diaginfo"] },
                                hint = { fg = colors["diaghint"] },
                            },
                            padding = { left = 0, right = 1 },
                        },
                    },

                    -- Diagnostics, profiler, lsp, git branch and diff.
                    lualine_y = {
                        -- Lua profiler status.
                        -- See: https://github.com/folke/snacks.nvim/blob/main/docs/profiler.md#snacksprofilerstatus
                        Snacks.profiler.status(),

                        -- Git branch
                        {
                            "branch",
                            padding = { left = 1, right = 1 },
                        },

                        -- Git change icons.
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed = gitsigns.removed,
                                    }
                                end
                            end,
                        },

                        -- Warnings etc.
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = function()
                                return {
                                    fg = colors["special"],
                                }
                            end,
                        },
                    },

                    -- File size, progress, line/column.
                    lualine_z = {
                        -- File size. e.g. 8.0k, 233b
                        { "filesize" },

                        -- Top/Bot or percentage through file.
                        { "progress", padding = { left = 1, right = 1 } },

                        -- Detailed cursor line and column position.
                        {
                            -- Current line number. %l
                            function()
                                local line = vim.api.nvim_win_get_cursor(0)[1]
                                return string.format("%5i", line)
                            end,
                            separator = icons["statsvert"],
                            padding = { left = 0, right = 0 },
                            color = { fg = colors["currentposition"] },
                        },
                        {
                            -- Total number of lines in the file.
                            function()
                                return string.format("%-4i", vim.fn.line("$"))
                            end,
                            padding = { left = 0, right = 0 },
                        },
                        {
                            -- Current cursor column. %c
                            function()
                                local col = vim.api.nvim_win_get_cursor(0)[2] + 1
                                return string.format("%4i", col)
                            end,
                            separator = icons["statshoriz"],
                            padding = { left = 0, right = 0 },
                            color = { fg = colors["currentposition"] },
                        },
                        {
                            -- Length of the current line.
                            function()
                                return string.format("%-4i", string.len(vim.fn.getline(".")))
                            end,
                            separator = " ",
                            padding = { left = 0, right = 1 },
                        },
                    },
                },

                extensions = { "neo-tree", "lazy", "fzf" },
            }

            -- Do not add trouble symbols if aerial is enabled
            -- And allow it to be overriden for some buffer types (see autocmds)
            if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
                local trouble = require("trouble")
                local symbols = trouble.statusline({
                    mode = "symbols",
                    groups = {},
                    title = false,
                    filter = { range = true },
                    format = "{kind_icon}{symbol.name:Normal}",
                    hl_group = "lualine_c_normal",
                })
                table.insert(opts.sections.lualine_c, {
                    symbols and symbols.get,
                    cond = function()
                        if vim.b.trouble_lualine == false or not symbols.has() then
                            return false
                        end
                        local symbol_text = symbols.get()
                        if not symbol_text then
                            return false
                        end
                        -- check if the symbol text is not too long
                        local max_width = 140
                        return #symbol_text <= max_width
                    end,
                })
            end

            -- Change section and component separators.
            opts.options.section_separators = { left = "", right = "" }
            opts.options.component_separators = { left = "", right = "" }
            return opts
        end,
    },
}
