local mysql = require('mysql')
local M = {}

-- function M.hello() vim.notify("Hello from lua") end
--
-- /usr/local/mysql-8.0.25-macos11-x86_64/lib/libmysqlclient.21.dylib
-- /usr/local/mysql-8.0.25-macos11-x86_64/lib/libmysqlclient.21.dylib
-- fd -sa -e dylib --type f --color never --max-depth 6 ^libmysqlclient /usr

local function query(query_string)
    local conn = mysql.connect('127.0.0.1', 'root', 'localdev', 'gridunity',
                               'utf8', 3306)
    conn:query(query_string)
    local result = conn:store_result()
    conn:close()
    return result
end

function M.hello2()
    local conn = mysql.connect('127.0.0.1', 'root', 'localdev', 'gridunity',
                               'utf8', 3306)
    -- conn:query("select id, name from Company")
    conn:query("show tables")
    local result = conn:store_result()
    conn:close()
    for i, name in result:rows() do vim.notify(' ' .. name) end

    result:free()
end

function M.hello()
    local result_set = query("show tables")
    local db_tables = {}
    local longest_name = 0
    for idx, table_name in result_set:rows() do
        table.insert(db_tables, '' .. table_name)
        longest_name = math.max(longest_name, #table_name)
    end

    local tables_buffer = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_lines(tables_buffer, 0, 0, false, db_tables)
    vim.api.nvim_buf_set_option(tables_buffer, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(tables_buffer, 'swapfile', false)
    vim.api.nvim_buf_set_option(tables_buffer, 'buflisted', false)

    local pane_size = tostring(math.floor(longest_name * 1.25))
    vim.cmd('leftabove ' .. pane_size .. 'vsplit')
    vim.api.nvim_win_set_buf(0, tables_buffer)
end

return M
