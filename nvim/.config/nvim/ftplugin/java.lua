-- nvim-jdtls attaches per buffer, so this runs for every Java file
-- (start_or_attach is idempotent per project). With the java-debug jar
-- from make debug-adapters, jdtls also serves as the DAP adapter.
if vim.fn.executable("jdtls") == 0 then
    return
end

local adapters_dir = vim.fs.normalize("~/.local/share/debug-adapters")
local bundles = vim.fn.glob(adapters_dir .. "/java-debug/com.microsoft.java.debug.plugin-*.jar", true, true)
local root = vim.fs.root(0, { "mvnw", "gradlew", "pom.xml", "build.gradle", ".git" }) or vim.fn.getcwd()

require("jdtls").start_or_attach({
    -- One jdtls workspace per project, so indexes do not collide.
    cmd = { "jdtls", "-data", vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.fnamemodify(root, ":p:h:t") },
    root_dir = root,
    -- vim.lsp.config("*") defaults do not reach nvim-jdtls.
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    init_options = { bundles = bundles },
    on_attach = function()
        if #bundles > 0 then
            require("jdtls.dap").setup_dap({ hotcodereplace = "auto" })
            require("jdtls.dap").setup_dap_main_class_configs()
        end
    end,
})
