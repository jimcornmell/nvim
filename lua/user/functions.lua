local M = {}

-- Silence global vim warning.
---@diagnostic disable: undefined-global
local vim = vim
local cmd = vim.cmd
local hl = vim.api.nvim_set_hl
local api = vim.api
local fn = vim.fn
local blameline = true
local markerline = true
---@diagnostic enable: undefined-global

-- Utility helpers
local function notify(msg)
    vim.notify(msg, vim.log.levels.INFO)
end

local function normal(keys)
    cmd("normal! " .. keys)
end

local function ShowCommandOutput(lines, title)
    if not lines or #lines == 0 then
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

    local width = math.floor(vim.o.columns * 0.7)
    local height = math.floor(vim.o.lines * 0.4)

    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        border = "rounded",
        title = title,
    })
end

-- Jump, looks under the cursor for a URL, Hex Code, GithubProject, Word...!
function M.JumpToSelection()
    local script_path = "$HOME/bin/vimgj"
    local filepath = fn.expand("%:p")
    local line = fn.line(".")
    local col = fn.col(".")

    local cmd = string.format("%s %q %d %d", script_path, filepath, line, col)
    fn.jobstart(cmd, { detach = true })
    notify("Jumping: " .. filepath .. ":" .. line .. ":" .. col)
end

function M.ExecuteCurrentLine()
    local line = vim.fn.getline(".")
    if line == "" then
        vim.notify("No Text under cursor.", vim.log.levels.WARN)
        return
    end

    -- Split command safely (no shell)
    local args = vim.fn.split(line, [[\s\+]])

    vim.fn.jobstart(args, {
        stdout_buffered = true,
        stderr_buffered = true,

        on_stdout = function(_, data)
            if data then
                ShowCommandOutput(data, "Command Output")
            end
        end,

        on_stderr = function(_, data)
            if data then
                ShowCommandOutput(data, "Command Errors")
            end
        end,
    })

    vim.notify("Running: " .. line, vim.log.levels.INFO)
end

-- Safely disable LSP for the current buffer
function M.LspDetachForCurrentFile()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients()

    if #clients == 0 then
        print("No LSP clients attached to this buffer.")
        return
    end

    for _, client in ipairs(clients) do
        vim.lsp.buf_detach_client(bufnr, client.id)
    end

    print("LSP detached from current buffer (safe for Kotlin).")
end

local function GenerateSequence(initial, step)
    step = step or 1

    -- Visual block start
    local start_row = vim.fn.line("'<")
    local start_col = vim.fn.col("'<")

    -- Visual block end
    local end_row = vim.fn.line("'>")

    -- Increment command (Ctrl-A)
    local incrementer = "\001"

    -- Single-line case: just increment once
    if start_row == end_row then
        vim.cmd("normal! " .. initial .. incrementer)
        return
    end

    -- Multi-line case
    vim.cmd("normal! i" .. initial)

    -- Match original logic: next line starts at initial - 1
    local i = initial - 1

    -- Iterate line-by-line until reaching end_row
    while vim.fn.line(".") ~= end_row do
        -- Move to next line at the same column
        vim.fn.setpos(".", { 0, vim.fn.line(".") + 1, start_col, 0 })

        -- Skip if the current line is too short
        if start_col < vim.fn.col("$") then
            i = i + step
            vim.cmd("normal! i" .. i)
            vim.cmd("normal! " .. incrementer)
        end
    end
end

-- Create sequence in visual mode.
function M.CreateSequence()
    local start_val
    local increment

    vim.ui.input({ prompt = "Start number [default=1]" }, function(start_val_input)
        if start_val_input == nil or start_val_input == "" then
            start_val = 1
        else
            start_val = tonumber(start_val_input)
        end

        vim.ui.input({ prompt = "Increment [default=1]" }, function(increment_input)
            if increment_input == nil or increment_input == "" then
                increment = 1
            else
                increment = tonumber(increment_input)
            end

            -- Save the current selection as a range
            local start_pos = vim.fn.getpos("'<")

            -- Move cursor to start of selection (optional, for functions that rely on cursor)
            vim.fn.setpos(".", start_pos)

            -- Call the Vimscript function without the auto range
            GenerateSequence(start_val, increment)

            -- Restore cursor and notify user
            vim.fn.setpos(".", start_pos)
            vim.notify("Sequence start: " .. start_val .. " increment:" .. increment, vim.log.levels.INFO)
        end)
    end)
end

function M.FigletCurrentLine()
    local line = vim.fn.getline(".")
    local ft = vim.bo.filetype

    vim.notify('Bannerizing "' .. line .. '" - ' .. ft)

    -- Delete the current line
    vim.cmd("normal! dd")

    -- Build command safely (no shell injection)
    local cmd = { vim.fn.expand("~/bin/dotfiles/bin/ban"), "-t", ft, "-s", line }

    -- Capture cursor row for insertion
    local row = vim.api.nvim_win_get_cursor(0)[1]

    -- Run async job
    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if not data then
                return
            end
            vim.schedule(function()
                -- Insert output lines into buffer
                vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, data)
            end)
        end,
        on_stderr = function(_, data)
            if data and #data > 0 then
                vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
            end
        end,
    })
end

function M.SnippetSave()
    local ft = vim.bo.filetype
    local home = os.getenv("HOME")
    local fname = home .. "/.config/nvim/snippets/" .. ft .. ".json"
    local keyName = vim.fn.input("Snippet keys: ")
    local desc = vim.fn.input("Snippet description: ")

    print(".")
    print("Saving snippet: " .. keyName .. '"' .. desc .. '" to ' .. fname)

    local alist = {}

    -- Read existing snippet file
    local lines = vim.fn.readfile(fname)
    for _, line in ipairs(lines) do
        table.insert(alist, line)
    end

    -- Trim last 2 lines (equivalent to [0:len()-3])
    local newlist = {}
    for i = 1, math.max(#alist - 2, 0) do
        table.insert(newlist, alist[i])
    end

    -- Build snippet entry
    table.insert(newlist, "  },")
    table.insert(newlist, '  "' .. keyName .. '": {')
    table.insert(newlist, '    "body": [')

    local txt = vim.fn.split(vim.fn.getreg('"'), "\n")

    for _, line in ipairs(txt) do
        -- Escape backslashes, quotes, and $
        line = line:gsub("\\", "\\\\")
        line = line:gsub('"', '\\"')
        line = line:gsub("%$", "\\\\$")

        table.insert(newlist, '      "' .. line .. '",')
    end

    table.insert(newlist, '      "$0"')
    table.insert(newlist, "    ],")
    table.insert(newlist, '    "description": "' .. desc .. '",')
    table.insert(newlist, '    "prefix": "' .. keyName .. '"')
    table.insert(newlist, "  }")
    table.insert(newlist, "}")

    -- Write file
    vim.fn.writefile(newlist, fname)

    -- Reload file silently
    vim.cmd("silent edit " .. fname)
end

function M.SnippetList()
    local ft = vim.bo.filetype
    local cmd = "snippetsList " .. ft

    -- Open a new buffer named "new.txt" (or create if doesn't exist)
    vim.cmd("edit new.txt")
    local bufnr = vim.api.nvim_get_current_buf()

    -- Toggle spell checking locally
    vim.opt_local.spell = not vim.opt_local.spell

    -- Open terminal in this buffer
    local term_chan = vim.api.nvim_open_term(bufnr, {})

    -- Send the command to the terminal
    vim.api.nvim_chan_send(term_chan, cmd .. "\n")
end

local function get_virtcol_at(line, byte_col)
    api.nvim_win_set_cursor(0, { line, byte_col })
    return fn.virtcol(".")
end

local function find_next_word_col(line_text, start_col)
    local sub = line_text:sub(start_col + 1)
    local s = sub:find("%S")
    if not s then
        return nil
    end
    return start_col + s - 1
end

function M.PushLine()
    local win = 0
    local buf = 0

    local cur = api.nvim_win_get_cursor(win)
    local line = cur[1]
    local col = cur[2]

    -- Edge case: first line has no reference above
    if line == 1 then
        return
    end

    local lines = api.nvim_buf_get_lines(buf, line - 2, line, false)
    local above = lines[1] or ""
    local current = lines[2] or ""

    -- Find next word in current line
    local next_word_col = find_next_word_col(current, col)
    if not next_word_col then
        return
    end

    -- Find matching word position above
    local above_word_col = find_next_word_col(above, col)
    if not above_word_col then
        return
    end

    -- Compute virtual columns (handles tabs & wide chars)
    local clp = get_virtcol_at(line, next_word_col)
    local plp = get_virtcol_at(line - 1, above_word_col)

    local delta = plp - clp

    -- If we need to INSERT spaces
    if delta > 0 then
        local insert_col = next_word_col
        local padding = string.rep(" ", delta)

        local new_line = current:sub(1, insert_col) .. padding .. current:sub(insert_col + 1)

        api.nvim_buf_set_lines(buf, line - 1, line, false, { new_line })

    -- If we need to DELETE spaces
    elseif delta < 0 then
        local remove_start = next_word_col + delta
        if remove_start < 0 then
            remove_start = 0
        end

        local before = current:sub(1, remove_start)
        local after = current:sub(next_word_col + 1)

        api.nvim_buf_set_lines(buf, line - 1, line, false, { before .. after })
    end

    -- Restore cursor and move down like original
    api.nvim_win_set_cursor(win, { line + 1, col })
end

-- Define a function to delete trailing spaces in the current buffer
function M.TrimWhitespace()
    -- Get all lines in the buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    -- Remove trailing spaces from each line
    for i, line in ipairs(lines) do
        lines[i] = line:gsub("%s+$", "")
    end
    -- Set the updated lines back to the buffer
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    print("Trailing spaces removed!")
end

-- Lua function to open help and cheat sheets
function M.OpenHelpAndCheatSheets()
    local folder = "/home/jim/Nextcloud/CheatSheets/"
    local number = 2
    local cheattext = {}
    local cheaturis = {}
    local ft = vim.bo.filetype -- current filetype

    -- Header
    table.insert(cheattext, " ﯭ Cheatsheets and Help for " .. ft)
    table.insert(cheattext, "")

    -- Check if main markdown file exists
    local main_md = folder .. ft .. ".md"
    if vim.fn.filereadable(main_md) == 1 then
        table.insert(cheattext, "   1  Edit פֿ " .. ft .. ".md")
        table.insert(cheaturis, main_md)
        table.insert(cheattext, "")
    end

    -- Get list of PDFs
    local all_files = vim.fn.readdir(folder)

    -- Filter PDFs matching the filetype
    local files = {}
    for _, name in ipairs(all_files) do
        if name:match(ft .. "%.pdf$") or name:match(ft .. "_.*%.pdf$") then
            table.insert(files, name)
        end
    end

    for _, file in ipairs(files) do
        local text = file:gsub("%.pdf$", "")
        text = text:gsub("^" .. ft .. "_", "")
        text = text:gsub("_", " ")
        if text == ft then
            text = "Main Help Document"
        end
        text = string.format("%-40s", text)
        local numberstr = string.format("%2d", number)
        table.insert(cheattext, "  " .. numberstr .. "  " .. text .. "      " .. file)
        table.insert(cheaturis, folder .. file)
        number = number + 1
    end

    if number > 2 then
        table.insert(cheattext, "")
    end

    -- Get list of URLs from Markdown files
    local md_files = {}
    for _, name in ipairs(all_files) do
        if name:match(ft .. "%.md$") then
            table.insert(md_files, name)
        end
    end

    table.insert(md_files, "universal.md")

    for _, file in ipairs(md_files) do
        local lines = vim.fn.readfile(folder .. file)

        for _, line in ipairs(lines) do
            local p = line:find("%]%(")

            if p then
                local text = string.format("%-20s", line:sub(2, p - 1))
                local url = line:sub(p + 2, -2)
                local numberstr = string.format("%2d", number)
                table.insert(cheattext, "  " .. numberstr .. "  " .. text .. "     爵" .. url)
                url = url:gsub("#", "\\#")
                table.insert(cheaturis, url)
                number = number + 1
            end
        end

        table.insert(cheattext, "")
    end

    -- Ask user to choose
    local answer = vim.fn.inputlist(cheattext)

    if answer == 1 and vim.fn.filereadable(main_md) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(main_md))
    elseif answer > 0 and answer <= #cheaturis then
        -- Open file or URL
        vim.fn.system('openf "' .. cheaturis[answer] .. '"')
    end
end

-- Toggle cursorline with custom highlight
local function ToggleColourCursorLine()
    if vim.wo.cursorline then
        vim.wo.cursorline = false
    else
        vim.wo.cursorline = true
        hl(0, "CursorLine", { bg = "#605555" })
    end
end

-- Toggle cursorcolumn with custom highlight
local function ToggleColourCursorColumn()
    if vim.wo.cursorcolumn then
        vim.wo.cursorcolumn = false
    else
        vim.wo.cursorcolumn = true
        hl(0, "CursorColumn", { fg = "#ffffff", bg = "#483d8b" })
    end
end

-- Toggle colorcolumn for long lines
local function ToggleColourLineTooLong()
    if vim.opt.colorcolumn == "" then
        vim.opt.colorcolumn = "80,120,200"
        hl(0, "longLine", { bg = "#5F3F3F" })
    else
        vim.opt.colorcolumn = ""
        hl(0, "longLine", { bg = "NONE" })
    end
end

-- Toggle highlighting whitespace at end of line
local function ToggleColourWhiteSpaceAtEndOfLine()
    -- Get highlight group details (0 = global namespace)
    local current_bg = vim.api.nvim_get_hl(0, { name = "TrailingWhitespace", link = true })

    if current_bg == 0xFF0000 then -- Red
        hl(0, "TrailingWhitespace", { bg = "NONE" })
    else
        hl(0, "TrailingWhitespace", { bg = "black", fg = "Red" })
    end
end

-- Toggle git blame using gitsigns
local function ToggleColourGitBlame()
    blameline = not blameline
    vim.cmd("Gitsigns toggle_current_line_blame")
end

-- Toggle syntax highlighting
local function ToggleColourSyntax()
    if vim.g.syntax_on then
        vim.cmd("syntax off")
    else
        vim.cmd("syntax enable")
    end
end

-- Toggle IncSearch highlighting
local function ToggleColourIncSearch()
    local insS = vim.api.nvim_get_hl(0, { name = "IncSearch", link = true })

    if insS.bg == 0x3f1f1f then
        hl(0, "IncSearch", { bg = "NONE" })
    else
        hl(0, "IncSearch", { bg = "#3f1f1f", bold = true })
    end
end

-- Toggle gutter (line numbers, foldcolumn, gitsigns)
local function ToggleGutter()
    if vim.wo.foldcolumn == "1" then
        vim.wo.foldcolumn = "0"
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.cmd("Gitsigns detach")
    else
        vim.wo.foldcolumn = "1"
        vim.wo.number = true
        hl(0, "LineNr", { fg = "RoyalBlue1", bg = "Gray19" })
        vim.wo.relativenumber = true
        hl(0, "CursorLineNr", { fg = "Yellow", bg = "Gray19" })
        vim.cmd("Gitsigns attach")
    end
end

-- Toggle marker line highlights
local function ToggleMarkerLines()
    if markerline then
        markerline = false
        hl(0, "markerLineCommentAmber", { bg = "NONE" })
        hl(0, "markerLineCommentGreen", { bg = "NONE" })
        hl(0, "markerLineCommentRed", { bg = "NONE" })
        hl(0, "markerLineCommentBrightRed", { bg = "NONE" })
    else
        markerline = true
        hl(0, "markerLineCommentAmber", { fg = "#000000", bg = "#999900" })
        hl(0, "markerLineCommentGreen", { fg = "#000000", bg = "#009900" })
        hl(0, "markerLineCommentRed", { fg = "#000000", bg = "#990000" })
        hl(0, "markerLineCommentBrightRed", { fg = "#000000", bg = "#FF0000" })
    end
end

-- Toggle all page furniture and highlights
function M.ToggleAll()
    ToggleColourCursorColumn()
    ToggleColourLineTooLong()
    ToggleColourWhiteSpaceAtEndOfLine()
    ToggleColourGitBlame()
    ToggleColourIncSearch()
    ToggleMarkerLines()
    vim.opt.spell = not vim.opt.spell
    vim.opt.list = not vim.opt.list
    vim.opt.foldenable = not vim.opt.foldenable
    hl(0, "markerStart", { bg = "NONE" })
    hl(0, "markerEnd", { bg = "NONE" })
    vim.notify("Toggle all page furniture (line numbers, status line, tab line, etc)", vim.log.levels.INFO)
end

function M.FoldingToggle()
    local method = vim.wo.foldmethod -- current window's foldmethod

    if method == "diff" then
        if vim.wo.foldenable then
            vim.wo.foldenable = false
            vim.notify("Folding switched off")
            vim.api.nvim_set_hl(0, "markerStart", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "markerEnd", { bg = "NONE" })
        else
            vim.api.nvim_set_hl(0, "markerStart", { fg = "#777777", bg = "#000000" })
            vim.api.nvim_set_hl(0, "markerEnd", { fg = "#777777", bg = "#000000" })
            vim.wo.foldenable = true
            vim.wo.foldmethod = "manual"
            vim.notify("Folding method set to Manual")
        end
    elseif method == "manual" then
        vim.wo.foldenable = true
        vim.wo.foldmethod = "indent"
        vim.notify("Folding method set to Indent")
    elseif method == "indent" then
        vim.wo.foldenable = true
        vim.wo.foldmethod = "marker"
        vim.notify("Folding method set to Marker")
    elseif method == "marker" then
        vim.wo.foldenable = true
        vim.wo.foldmethod = "syntax"
        vim.notify("Folding method set to Syntax")
    elseif method == "syntax" then
        vim.wo.foldenable = true
        vim.wo.foldmethod = "expr"
        vim.notify("Folding method set to Diff")
    elseif method == "expr" then
        vim.wo.foldenable = true
        vim.wo.foldmethod = "diff"
        vim.notify("Folding method set to Diff")
    end
end

-- function! UpdateChangeHistory()
-- let name = expand('%:p')
-- echo "Update change history information within file" . name
-- silent exec ":!$HOME/bin/updateChangeHistory " . name
-- endfunction
-- keymap(
-- "n",
-- "<leader>jk",
-- ":call UpdateChangeHistory()<CR>",
-- { silent = true, remap = true, desc = "Update change history" .. highlightChar }
-- )

return M

--[[
-- Old VIMSCRIPT below here for reference
--
" Highlight a column in CSV text.
" See: https://vim.fandom.com/wiki/Working_with_CSV_files
" :Csv 1    " highlight first column
" :Csv 12   " highlight twelfth column
" :Csv 0    " switch off highlight
highlight CsvColHeading guifg=Yellow guibg=Black
function! CSVH(colnr)
    if a:colnr > 1
        let n = a:colnr - 1

        execute 'match CsvColHeading /^\([^,]*,\)\{'.n.'}\zs[^,]*/'
        " execute 'match CsvColHighlight /^\([^,|\t]*[,|\t]\)\{'.n.'}\zs[^,|\t]*/'
        execute 'normal! 0'.n.'f,'
        execute 'syntax match csvHeading /\%1l\%(\%("\zs\%([^"]\|""\)*\ze"\)\|\%(\zs[^,"]*\ze\)\)/'
        execute 'highlight csvHeading guifg=Yellow guibg=Black gui=bold'
    elseif a:colnr == 1
        match CsvColHighlight /^[^,|\t]*/
        normal! 0
    else
        match
    endif
endfunction

" let g:loaded_docker_steps = 1
" let g:docker_steps_debug = 0
" Layer-creating instructions
let g:docker_layer_instr = ['FROM','RUN','COPY','ADD','WORKDIR']
" Metadata instructions
let g:docker_meta_instr = ['LABEL','CMD','ENTRYPOINT']

" Create sign types for steps 01-99
if !exists('g:docker_step_signs_defined')
  for i in range(1,99)
    let num = printf('%02d', i)
    execute 'sign define dockerstep' . num . ' text=' . num . ' texthl=Comment'
  endfor

  let g:docker_step_signs_defined = 1
endif

" Determine instruction type
function! s:DockerInstructionType(line) abort
  for instr in g:docker_layer_instr
    if a:line =~? '^\s*' . instr
      return 'layer'
    endif
  endfor
  " for instr in g:docker_meta_instr
    " if a:line =~? '^\s*' . instr
      " return 'meta'
    " endif
  " endfor
  return ''
endfunction

" function! s:DockerInstruction(line) abort
  " for instr in g:docker_layer_instr
    " if a:line =~? '^\s*' . instr
      " return instr
    " endif
  " endfor
  " for instr in g:docker_meta_instr
    " if a:line =~? '^\s*' . instr
      " return instr
    " endif
  " endfor
  " return ''
" endfunction

" Annotate Dockerfile steps
function! DockerfileAnnotateSteps() abort
  let bufnr = bufnr('%')
  silent! execute 'sign unplace * group=DOCKER_STEPS buffer=' . bufnr

  " if g:docker_steps_debug
    " echom 'Cleared previous Dockerfile step signs'
  " endif

  let lines = getline(1,'$')
  let step = 1
  " let prev_type = ''
  " let prev_instra = ''

  for lnum in range(1,len(lines))
    let line = lines[lnum - 1]
    let instr_type = s:DockerInstructionType(line)
    " let instra = s:DockerInstruction(line)

    if instr_type != ''
      let signname = 'dockerstep' . printf('%02d', step)

      execute 'sign place ' . step
            \ . ' line=' . lnum
            \ . ' name=' . signname
            \ . ' group=DOCKER_STEPS buffer=' . bufnr

      " if g:docker_steps_debug
        " echom 'Step ' . step . ' (' . instr_type . '): "' . line . '"'
      " endif

      " Increment step ONLY for layer instructions if previous instruction
      " was not a layer of the same type (simulate caching behavior)
      " if instr_type == 'layer' && prev_type != 'layer'
      " if instr_type == 'layer' && instra != prev_instra && prev_type == 'layer'
        let step += 1
      " endif

      " let prev_type = instr_type
      " let prev_instra = instra
    endif
  endfor

  echom 'A Dockerfile with ' . (step - 1) . ' steps'
endfunction
]]

