return {
    "nvim-neotest/neotest",
    enabled = true,
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
            "fredrikaverpil/neotest-golang",
            version = "*", -- Optional, but recommended; track releases
            build = function()
                vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
            end,
            config = function()
                require("neotest-golang")({
                    dap_mode = "manual",
                    dap_manual_config = {
                        type = "delve",
                        name = "Debug Nearest Test",
                        request = "launch",
                        mode = "test",
                        program = "${file}",
                    },
                    warn_test_name_dupes = false,
                })
            end,
        },
    },
    config = function()
        local neotest = require("neotest")
        ---@diagnostic disable-next-line: missing-fields
        neotest.setup({
            adapters = {
                require("neotest-golang")({
                    -- We recommend using gotestsum for better output
                    -- 'go install gotest.tools/gotestsum@latest'
                    runner = "gotestsum",
                }),
            },
            -- Example keymaps
            -- These are not set by default
            vim.keymap.set("n", "<leader>tn", function()
                neotest.run.run()
            end, { desc = "Run Nearest Test" }),
            vim.keymap.set("n", "<leader>tf", function()
                neotest.run.run(vim.fn.expand("%"))
            end, { desc = "Run File" }),
            vim.keymap.set("n", "<leader>ts", function()
                neotest.run.run(vim.fn.getcwd())
            end, { desc = "Run Suite" }),
            vim.keymap.set("n", "<leader>to", function()
                neotest.output.open()
            end, { desc = "Open Output" }),
            vim.keymap.set("n", "<leader>td", function()
                neotest.run.run({ suite = false, strategy = "dap" })
            end, { desc = "Debug Nearest" }),
        })
    end,
}
