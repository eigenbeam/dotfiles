-- nvim-jdtls attaches per buffer, so this runs for every Java file (the
-- plugin's start_or_attach is idempotent per project).
if vim.fn.executable("jdtls") == 0 then
    return
end

require("jdtls").start_or_attach({
    cmd = { "jdtls" },
    root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
})
