return {
    -- Better motions, still my favourite.
    {
        "smoka7/hop.nvim",
        event = "BufRead",
        config = function()
            require("hop").setup()
        end,
    },
}
