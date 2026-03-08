return {
    -- Highlight and search for todo comments
    -- FIX:Something to describe.
    -- FIXJC:Something to describe.
    -- FIXME: Something to describe.
    -- BUG:Something to describe.
    -- FIXIT: Something to describe.
    -- ISSUE: Something to describe.
    -- TODO:Something to describe.
    -- DOING:Something to describe.
    -- HACK:Something to describe.
    -- WARN:Something to describe.
    -- WARNING:Something to describe.
    -- XXX:Something to describe.
    -- PERF:Something to describe.
    -- OPTIM:Something to describe.
    -- PERFORMANCE:Something to describe.
    -- OPTIMIZE:Something to describe.
    -- NOTE:Something to describe.
    -- INFO:Something to describe.
    -- TEST: Test something.
    -- OK: Something.
    -- ISH: Something.
    -- BAD: Something.
    -- :TodoQuickFix
    -- :TodoTelescope
    -- :TodoTrouble
    {
        "folke/todo-comments.nvim",
        event = "BufRead",
        -- stylua: ignore
        keys = {
            { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
            { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
        },
        config = function()
            require("todo-comments").setup({
                keywords = {
                    OK = { icon = "✅", color = "ok" },
                    ISH = { icon = "👋", color = "ish" },
                    BAD = { icon = "❌", color = "bad" },
                    TEST = { icon = " ", color = "test" },
                    FIXJC = { icon = " ", color = "fixjc" },
                    FIXME = { icon = " ", color = "fixjc" },
                    FIX = { icon = " ", color = "fixjc" },
                    BUG = { icon = " ", color = "fixjc" },
                    ISSUE = { icon = " ", color = "fixjc" },
                    FIXIT = { icon = " ", color = "fixjc" },
                    DOING = { icon = "🐝", color = "ish" },
                },
                colors = {
                    ok = { "#10B981" },
                    ish = { "#e0e031" },
                    bad = { "#f06981" },
                    test = { "#f02244" },
                    fixjc = { "#ff0000" },
                },
            })
        end,
    },
}
