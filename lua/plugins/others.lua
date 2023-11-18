return {

	{
		"tpope/vim-commentary",
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		cmd = "Git",
		config = function()
			vim.cmd.cnoreabbrev([[git Git]])
			vim.cmd.cnoreabbrev([[gp Git push]])
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require('gitsigns').setup()
		end,
	},
}
