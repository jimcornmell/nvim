return {
    {
        "snacks.nvim",
        opts = {
            dashboard = {
                preset = {
                    pick = function(cmd, opts)
                        return LazyVim.pick(cmd, opts)()
                    end,
                     header = "PDE configuration built on   + LazyVim for Me 😎",
                    -- stylua: ignore
                    ---@type snacks.dashboard.Item[]
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        { icon = " ", key = "i", desc = "Edit .gitignore", action = ":e .gitignore" },
                        { icon = " ", key = "z", desc = "Edit ~/.zshrc", action = ":e ~/.zshrc" },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = " ", key = "m", desc = "Maint Mason", action = ":Mason" },
                        { icon = " ", key = "x", desc = "Maint Lazy Extras", action = ":LazyExtras" },
                        { icon = "󰒲 ", key = "l", desc = "Maint Lazy", action = ":Lazy" },
                        { icon = " ", key = "h", desc = "Help Cheatsheet", action = ":!xdg-open https://github.com/jimcornmell/lvim/blob/main/media/cheatsheet.png" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
                sections = {
                    {
                        section = "terminal",
                        cmd = "chafa --fill=block --align center " .. vim.fn.stdpath("config") .. "/media/neovim.png",
                    },
                    { section = "header", height = 1, gap = 0, padding = 1 },
                    { section = "keys", icon = "🎹", title = "Keys", indent = 2, gap = 0, padding = 1 },
                    { icon = "📁", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                    { icon = "📂", title = "Projects", section = "projects", indent = 2, padding = 1 },
                    { section = "startup", padding = 1 },
                    {
                        pane = 2,
                        icon = "",
                        desc = "Browse Repository on GitHub/GitLab",
                        padding = 1,
                        key = "b",
                        action = function()
                            Snacks.gitbrowse()
                        end,
                    },

                    {
                        pane = 2,
                        icon = "",
                        title = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = "git status --short --branch --renames",
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },

                    function()
                        local in_git = Snacks.git.get_root() ~= nil
                        local cmds = {
                            {
                                icon = "",
                                title = "Git Status",
                                cmd = "git --no-pager diff --stat -B -M -C",
                                height = 15,
                            },
                        }
                        return vim.tbl_map(function(cmd)
                            return vim.tbl_extend("force", {
                                pane = 2,
                                section = "terminal",
                                enabled = in_git,
                                padding = 1,
                                ttl = 5 * 60,
                                indent = 3,
                            }, cmd)
                        end, cmds)
                    end,
                },
            },
        },
    },
}
