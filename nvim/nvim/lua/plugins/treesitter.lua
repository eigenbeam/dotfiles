return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "asm", "awk", "bash", "c", "clojure", "cmake", "commonlisp", "cpp", "css", "csv", "dockerfile", "forth", "fortran", "haskell", "html", "lua", "java", "javascript", "json", "make", "markdown", "matlab", "python", "racket", "query", "scheme", "terraform", "vim", "xml", "yaml" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
