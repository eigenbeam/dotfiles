-- Syntax-check every Lua file in this config without running any of it.
-- Used by `make lint` (nvim --headless --clean -l lint.lua); loadfile() only
-- compiles, so no plugin is loaded or installed.
local root = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
local ok = true
for _, f in ipairs(vim.fn.glob(root .. "/**/*.lua", true, true)) do
    local fn, err = loadfile(f)
    if not fn then
        ok = false
        io.stderr:write(err .. "\n")
    end
end
if not ok then
    vim.cmd.cquit(1)
end
