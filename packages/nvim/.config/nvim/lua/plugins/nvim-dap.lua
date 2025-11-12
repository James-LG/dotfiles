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
                    handlers = {},
                },
            },
        },
        config = function()
            -- Optional: Add any nvim-dap specific setup here
            local dap = require("dap")

            -- Keybinds
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
            vim.keymap.set("n", "<Down>", dap.step_over, { desc = "DAP: Step Over" })
            vim.keymap.set("n", "<Right>", dap.step_into, { desc = "DAP: Step Into" })
            vim.keymap.set("n", "<Up>", dap.step_out, { desc = "DAP: Step Out" })
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })
            vim.keymap.set("n", "<leader>ds", dap.terminate, { desc = "DAP: Stop" })
            vim.keymap.set("n", "<leader>di", function()
                require("dapui").eval()
            end, { desc = "DAP: Evaluate variable" })
            vim.keymap.set("v", "<leader>di", function()
                require("dapui").eval()
            end, { desc = "DAP: Evaluate selection" })

            -- Example: C/C++ (if not using mason-nvim-dap handler)
            -- dap.adapters.cppdbg = { ... }
            -- dap.configurations.cpp = { ... }
        end,
    },

    -- DAP UI plugin
    {
        "rcarriga/nvim-dap-ui",
        -- Load after nvim-dap
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local dapui = require("dapui")
            dapui.setup()

            -- Automatically open/close DAP UI when a session starts/ends
            local dap = require("dap")
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
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
