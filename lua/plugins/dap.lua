return {
	{
		"leoluz/nvim-dap-go"
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			-- dap set up
			local dap, dapui = require("dap"), require("dapui")
			require("dap-go").setup({
				-- Additional dap configurations can be added.
				-- dap_configurations accepts a list of tables where each entry
				-- represents a dap configuration. For more details do:
				-- :help dap-configuration
				dap_configurations = {
					{
						-- Must be "go" or it will be ignored by the plugin
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
				-- delve configurations
				delve = {
					-- the path to the executable dlv which will be used for debugging.
					-- by default, this is the "dlv" executable on your PATH.
					path = "dlv",
					-- time to wait for delve to initialize the debug session.
					-- default to 20 seconds
					initialize_timeout_sec = 20,
					-- a string that defines the port to start delve debugger.
					-- default to string "${port}" which instructs nvim-dap
					-- to start the process in a random available port
					port = "${port}",
					-- additional args to pass to dlv
					args = {},
					-- the build flags that are passed to delve.
					-- defaults to empty string, but can be used to provide flags
					-- such as "-tags=unit" to make sure the test suite is
					-- compiled during debugging, for example.
					-- passing build flags using args is ineffective, as those are
					-- ignored by delve in dap mode.
					build_flags = "",
				},
			})
			require("dapui").setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.keymap.set("n", "<leader>dr", function()
				require("dap").continue()
			end)
			vim.keymap.set("n", "<leader>de", function()
				require("dap").toggle_breakpoint()
			end)
			vim.keymap.set("n", "<leader>dn", function()
				require("dap").step_over()
			end)
			vim.keymap.set("n", "<leader>ds", function()
				require("dap").step_into()
			end)
			vim.keymap.set("n", "<leader>do", function()
				require("dap").step_out()
			end)
			vim.keymap.set("n", "<leader>dc", function()
				require("dap").disconnect()
			end)
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},
}
