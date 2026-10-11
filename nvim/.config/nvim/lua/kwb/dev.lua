-- LSP, completion, formatting, linting, debugging (mirrors emacs/lisp/dev.el).
require("kwb.pack")({
    "neovim/nvim-lspconfig",
    "j-hui/fidget.nvim",
    { src = "saghen/blink.cmp", version = vim.version.range("1.*") },
    "stevearc/conform.nvim",
    "mfussenegger/nvim-lint",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-jdtls",
    "jmbuhr/otter.nvim",
    "quarto-dev/quarto-nvim",
})

local keymap = vim.keymap.set

-- ── LSP ──────────────────────────────────────────────────────────────────
require("fidget").setup({})

-- Neovim 0.11+ maps grn/gra/grr/gri/grt, K, [d/]d, and <C-w>d by default;
-- these are the leader-prefixed aliases that which-key makes discoverable.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buf = event.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
        map("<leader>d", vim.diagnostic.open_float, "Show diagnostics")
        map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "Toggle inlay hints")

        -- Highlight references on cursor hold
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buf = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buf = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buf = event2.buf })
                end,
            })
        end
    end,
})

vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
        },
    },
})

vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
            validate = true,
            format = { enable = false }, -- use prettier via conform
        },
    },
})

-- Servers: clangd (Xcode CLT), pyright/ruff/jdtls/bashls/yamlls/lua_ls/taplo
-- (brew), ts_ls/dockerls (make tools), terraformls (brew tap), julials (see
-- README). Java is started by ftplugin/java.lua through nvim-jdtls.
vim.lsp.enable({
    "clangd",
    "bashls",
    "pyright",
    "lua_ls",
    "yamlls",
    "ts_ls",
    "terraformls",
    "dockerls",
    "taplo",
    "julials",
})

-- ── Completion (blink.cmp) ───────────────────────────────────────────────
require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
    sources = { default = { "lsp", "path" } },
    fuzzy = { implementation = "lua" },
    signature = { enabled = true },
})

-- ── Formatting (conform) ─────────────────────────────────────────────────
-- Matches the apheleia table in emacs/lisp/dev.el. C/C++, Java, and shell
-- deliberately get only whitespace trimming, which also keeps lsp_format's
-- fallback from running jdtls/clangd formatting on save.
require("conform").setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "quarto" then
            return nil -- trailing spaces are hard breaks in prose cells
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        terraform = { "terraform_fmt" },
        toml = { "taplo" },
        c = { "trim_whitespace" },
        cpp = { "trim_whitespace" },
        java = { "trim_whitespace" },
        sh = { "trim_whitespace" },
        bash = { "trim_whitespace" },
        ["_"] = { "trim_whitespace" },
    },
})
keymap("", "<leader>f", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- ── Linting (nvim-lint) ──────────────────────────────────────────────────
local lint = require("lint")
lint.linters_by_ft = {
    python = { "ruff" },
    terraform = { "tflint" },
}
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = function()
        lint.try_lint()
    end,
})
keymap("n", "<leader>ll", function()
    lint.try_lint()
end, { desc = "Lint current file" })

-- ── Debug Adapter Protocol (nvim-dap) ────────────────────────────────────
local dap = require("dap")
local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
keymap("n", "<leader>Db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
keymap("n", "<leader>Dc", dap.continue, { desc = "Continue" })
keymap("n", "<leader>Do", dap.step_over, { desc = "Step over" })
keymap("n", "<leader>Di", dap.step_into, { desc = "Step into" })
keymap("n", "<leader>Du", dapui.toggle, { desc = "Toggle DAP UI" })

-- ── Quarto ───────────────────────────────────────────────────────────────
require("quarto").setup({})
