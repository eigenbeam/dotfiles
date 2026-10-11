-- vim.pack wrapper: "user/repo" means GitHub, and installs never prompt
-- because the committed nvim-pack-lock.json is the source of truth.
return function(specs)
    for i, spec in ipairs(specs) do
        if type(spec) == "string" then
            spec = { src = spec }
        end
        if not spec.src:find("://", 1, true) then
            spec.src = "https://github.com/" .. spec.src
        end
        specs[i] = spec
    end
    vim.pack.add(specs, { confirm = false })
end
