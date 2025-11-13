return {
    -- Main DAP plugin
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- Installs and configures debug adapters
            {
                "jay-babu/mason-nvim-dap.nvim",
                -- Waits to load nvim-dap until mason-nvim-dap has finished
                lazy = false,
                -- You must provide a list of debuggers to install
                -- See :help mason-nvim-dap.ensure_installed
                opts = {
                    ensure_installed = {
                        "cppdbg", -- For C/C++
                        "delve", -- For Go
                        "debugpy", -- For Python
                        -- Add other debuggers you need here
                    },
                    -- This sets up the adapters for nvim-dap
                    handlers = {
                        function(config)
                            -- all sources with no handler get passed here

                            -- Keep original functionality
                            require("mason-nvim-dap").default_setup(config)
                        end,
                        delve = function(config)
                            config.configurations = {
                                {
                                    type = "delve",
                                    name = "Delve: Debug",
                                    request = "launch",
                                    program = "${workspaceFolder}",
                                    outputMode = "remote",
                                },
                                {
                                    type = "delve",
                                    name = "Delve: Debug (Arguments)",
                                    request = "launch",
                                    program = "${workspaceFolder}",
                                    outputMode = "remote",
                                    args = function()
                                        return vim.split(vim.fn.input("Args: "), " ")
                                    end,
                                },
                                {
                                    type = "delve",
                                    name = "Delve: Debug test", -- configuration for debugging test files
                                    request = "launch",
                                    mode = "test",
                                    program = "${file}",
                                    outputMode = "remote",
                                },
                                -- works with go.mod packages and sub packages
                                {
                                    type = "delve",
                                    name = "Delve: Debug test (go.mod)",
                                    request = "launch",
                                    mode = "test",
                                    program = "./${relativeFileDirname}",
                                    outputMode = "remote",
                                },
                            }
                            require("mason-nvim-dap").default_setup(config)
                        end,
                    },
                },
            },
        },
        config = function()
            -- Optional: Add any nvim-dap specific setup here
            local dap = require("dap")
            dap.set_log_level("TRACE")

            -- Keybinds
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
            vim.keymap.set("n", "<Down>", dap.step_over, { desc = "DAP: Step Over" })
            vim.keymap.set("n", "<Right>", dap.step_into, { desc = "DAP: Step Into" })
            vim.keymap.set("n", "<Up>", dap.step_out, { desc = "DAP: Step Out" })
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })
            vim.keymap.set("n", "<leader>ds", dap.terminate, { desc = "DAP: Stop" })

            -- Example: C/C++ (if not using mason-nvim-dap handler)
            -- dap.adapters.cppdbg = { ... }
            -- dap.configurations.cpp = { ... }
        end,
    },

    -- DAP UI plugin
    {
        -- Using this plugin only for the hover evaluation feature
        "rcarriga/nvim-dap-ui",
        enabled = true,
        -- Load after nvim-dap
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dapui = require("dapui")
            dapui.setup()

            -- Automatically open/close DAP UI when a session starts/ends
            -- local dap = require("dap")
            -- dap.listeners.after.event_initialized["dapui_config"] = function()
            --     dapui.open()
            -- end
            -- dap.listeners.before.event_terminated["dapui_config"] = function()
            --     dapui.close()
            -- end
            -- dap.listeners.before.event_exited["dapui_config"] = function()
            --     dapui.close()
            -- end

            vim.keymap.set("n", "<leader>di", function()
                require("dapui").eval()
            end, { desc = "DAP: Inspect variable" })
            vim.keymap.set("v", "<leader>di", function()
                require("dapui").eval()
            end, { desc = "DAP: Inspect selection" })
        end,
    },

    {
        -- Using this plugin since the REPL of nvim-dap-ui is not working for golang output
        "igorlfs/nvim-dap-view",
        enabled = true,
        ---@module 'dap-view'
        opts = {
            -- auto_toggle = true,
        },
        config = function(_, opts)
            local dapview = require("dap-view")
            dapview.setup(opts)

            vim.keymap.set("n", "<leader>dw", function()
                dapview.add_expr()
            end, { desc = "DAP: Add to watch" })
            vim.keymap.set("v", "<leader>dw", function()
                dapview.add_expr()
            end, { desc = "DAP: Add to watch" })

            -- Automatically open/close DAP UI when a session starts/ends
            local dap = require("dap")
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapview.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapview.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapview.close()
            end
        end,
    },

    -- Optional: Virtual text for inline variable display
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("nvim-dap-virtual-text").setup({
                virt_text_pos = "eol", -- Position of virtual text
            })
        end,
    },
}
