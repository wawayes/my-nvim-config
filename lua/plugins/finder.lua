return {

	{
		cmd = "Telescope",
		keys = {
			{ "<leader>p",  ":Telescope find_files<CR>", desc = "find files" },
			{ "<leader>P",  ":Telescope live_grep",      desc = "grep file" },
			{ "<leader>rs", ":Telescope resume",         desc = "resume" },
			{ "<leader>q",  ":Telescope oldfiles",       desc = "oldfiles" },
		},
		'nvim-telescope/telescope.nvim',
		tag = '0.1.4',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
}
