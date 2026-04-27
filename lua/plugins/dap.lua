return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        dap.configurations.rust = {
            {
                type = "codelldb",
                name = "Debug",
                request = "launch",
                program = function()
                    if vim.fn.confirm("Build project?", "&yes\n&no", 2) == 1 then
                        vim.cmd("Cargo build")
                    end
                    return "${workspaceFolder}/target/debug/${workspaceFolderBasename}"
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Debug",
                request = "launch",
                program = function()
                    if vim.fn.confirm("Build project?", "&yes\n&no", 2) == 1 then
                        vim.cmd("!dotnet build")
                    end
                    local dll = vim.fn.glob("${workspaceFolder}/bin/Debug/net*/.dll")
                    return dll ~= "" and dll or vim.fn.input("Path to DLL: ")
                end,
                cwd = "${workspaceFolder}",
            },
        }

        dap.configurations.python = {
            {
                type = "python",
                name = "Debug",
                request = "launch",
                program = "${file}",
                cwd = "${workspaceFolder}",
                stopOnEntry = true,
            },
        }

        dap.configurations.cpp = {
            {
                type = "codelldb",
                name = "Debug",
                request = "launch",
                program = function()
                    if vim.fn.confirm("Build project?", "&yes\n&no", 2) == 1 then
                        vim.cmd("!make")
                    end
                    return vim.fn.input("Executable: ", "${workspaceFolder}/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = true,
                args = {},
            },
        }

        dap.configurations.c = dap.configurations.cpp
    end,
}