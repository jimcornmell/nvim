return {
    {
        "monaqa/dial.nvim",
        recommended = true,
        desc = "Increment and decrement numbers, dates, and more",

        opts = function()
            local augend = require("dial.augend")

            local todo_list = augend.constant.new({
                elements = {
                    "FIX:",
                    "FIXJC:",
                    "FIXME:",
                    "BUG:",
                    "FIXIT:",
                    "ISSUE:",
                    "TODO:",
                    "HACK:",
                    "WARN:",
                    "WARNING:",
                    "XXX:",
                    "PERF:",
                    "OPTIM:",
                    "PERFORMANCE:",
                    "OPTIMIZE:",
                    "NOTE:",
                    "INFO:",
                    "TEST:",
                    "OK:",
                    "ISH:",
                    "BAD:",
                },
                word = false,
                cyclic = true,
            })

            local ordinal_numbers = augend.constant.new({
                -- elements through which we cycle. When we increment, we go down
                -- On decrement we go up
                elements = {
                    "first",
                    "second",
                    "third",
                    "fourth",
                    "fifth",
                    "sixth",
                    "seventh",
                    "eighth",
                    "ninth",
                    "tenth",
                },
                -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
                word = false,
                -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
                -- Otherwise nothing will happen when there are no further values
                cyclic = true,
            })

            local weekdays = augend.constant.new({
                elements = {
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday",
                    "Sunday",
                },
                word = true,
                cyclic = true,
            })

            local months_3_chars = augend.constant.new({
                elements = {
                    "JAN",
                    "FEB",
                    "MAR",
                    "APR",
                    "MAY",
                    "JUN",
                    "JUL",
                    "AUG",
                    "SEP",
                    "OCT",
                    "NOV",
                    "DEC",
                },
                word = false,
                cyclic = true,
            })

            local months = augend.constant.new({
                elements = {
                    "January",
                    "February",
                    "March",
                    "April",
                    "May",
                    "June",
                    "July",
                    "August",
                    "September",
                    "October",
                    "November",
                    "December",
                },
                word = true,
                cyclic = true,
            })

            local capitalized_boolean = augend.constant.new({
                elements = {
                    "True",
                    "False",
                },
                word = true,
                cyclic = true,
            })

            local For_Back =
                augend.constant.new({ elements = { "Foreground", "Background" }, word = true, cyclic = true })
            local for_back =
                augend.constant.new({ elements = { "foreground", "background" }, word = true, cyclic = true })
            local enable_disable =
                augend.constant.new({ elements = { "enable", "disable" }, word = true, cyclic = true })
            local enabled_disabled =
                augend.constant.new({ elements = { "enabled", "disabled" }, word = true, cyclic = true })
            local logical_alias = augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true })
            local yes_no = augend.constant.new({ elements = { "yes", "no" }, word = false, cyclic = true })
            local Yes_No = augend.constant.new({ elements = { "Yes", "No" }, word = false, cyclic = true })
            local LOG_LEVELS = augend.constant.new({
                elements = { "FATAL", "ERROR", "WARN", "INFO", "DEBUG", "TRACE", "OFF" },
                word = false,
                cyclic = true,
            })
            local log_levels = augend.constant.new({
                elements = { "fatal", "error", "warn", "info", "debug", "trace" },
                word = false,
                cyclic = true,
            })
            local access_modifiers =
                augend.constant.new({ elements = { "public", "protected", "private" }, word = false, cyclic = true })

            return {
                dials_by_ft = {
                    css = "css",
                    vue = "vue",
                    javascript = "typescript",
                    typescript = "typescript",
                    typescriptreact = "typescript",
                    javascriptreact = "typescript",
                    json = "json",
                    lua = "lua",
                    markdown = "markdown",
                    sass = "css",
                    scss = "css",
                    python = "python",
                },
                groups = {
                    default = {
                        augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                        augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
                        augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                        augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
                        augend.date.alias["%Y-%m-%d"],
                        augend.date.alias["%H:%M:%S"],
                        augend.date.alias["%H:%M"],
                        augend.hexcolor.new({ case = "lower" }),
                        ordinal_numbers,
                        todo_list,
                        weekdays,
                        months,
                        months_3_chars,
                        capitalized_boolean,
                        augend.constant.alias.bool, -- boolean value (true <-> false)
                        logical_alias,
                        For_Back,
                        for_back,
                        enable_disable,
                        enabled_disabled,
                        logical_alias,
                        yes_no,
                        Yes_No,
                        LOG_LEVELS,
                        log_levels,
                        access_modifiers,
                        augend.integer.alias.octal,
                        augend.integer.alias.binary,
                        augend.constant.alias.bool,
                        augend.semver.alias.semver,
                    },
                    vue = {
                        augend.constant.new({ elements = { "let", "const" } }),
                        augend.hexcolor.new({ case = "lower" }),
                        augend.hexcolor.new({ case = "upper" }),
                    },
                    typescript = {
                        augend.constant.new({ elements = { "let", "const" } }),
                    },
                    css = {
                        augend.hexcolor.new({
                            case = "lower",
                        }),
                        augend.hexcolor.new({
                            case = "upper",
                        }),
                    },
                    markdown = {
                        augend.constant.new({
                            elements = { "[ ]", "[x]" },
                            word = false,
                            cyclic = true,
                        }),
                        augend.misc.alias.markdown_header,
                    },
                    json = {
                        augend.semver.alias.semver, -- versioning (v1.1.2)
                    },
                    lua = {
                        augend.constant.new({
                            elements = { "and", "or" },
                            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                            cyclic = true, -- "or" is incremented into "and".
                        }),
                    },
                    python = {
                        augend.constant.new({
                            elements = { "and", "or" },
                        }),
                    },
                },
            }
        end,
        config = function(_, opts)
            -- copy defaults to each group
            for name, group in pairs(opts.groups) do
                if name ~= "default" then
                    vim.list_extend(group, opts.groups.default)
                end
            end
            require("dial.config").augends:register_group(opts.groups)
            vim.g.dials_by_ft = opts.dials_by_ft
        end,
    },
}
