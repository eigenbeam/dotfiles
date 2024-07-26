return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        -- TODO: markdown, python, xml
        ensure_installed = { "autotools_ls", "bashls", "clangd", "cmake", "cssls", "clojure_lsp", "dockerls", "fortls", "html", "jsonls", "jdtls", "lua_ls", "ruff", "tsserver" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})

      lspconfig.lua_ls.setup({})
      lspconfig.tsserver.setup({})
    end
  }
}
