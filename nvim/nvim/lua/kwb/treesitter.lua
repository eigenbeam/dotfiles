local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
	return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
  ensure_installed = { "markdown", "markdown_inline", "bash", "java", "javascript", "python" },
  ensure_installed = "all",
	ignore_install = { "" },
	sync_install = false,
	autopairs = {
		enable = true,
	},
})
