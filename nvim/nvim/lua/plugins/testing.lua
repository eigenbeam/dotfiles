return {
	{
		"rcasia/neotest-java",
		init = function()
      local neotest = require("neotest")
      vim.keymap.set('n', '<leader>tt', function() neotest.run.run(vim.fn.expand("%")) end, {})
      vim.keymap.set('n', '<leader>tr', neotest.run.run, {})
      vim.keymap.set('n', '<leader>tD', function() neotest.run.run({ strategy = "dap"}) end, {})
      vim.keymap.set('n', '<leader>td', function() neotest.run.run({ vim.fn.expand("%"), strategy = "dap"}) end, {})
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			adapters = {
				["neotest-java"] = {
					-- config here
				},
			},
		},
	},
}
