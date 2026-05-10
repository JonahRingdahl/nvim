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

        dap.adapters.codelldb = {
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
                command = "codelldb",
                args = { "--port", "${port}" },
            },
        }

        dap.adapters.coreclr = {
            type = "executable",
            command = "netcoredbg",
            args = { "--interpreter=vscode" },
        }

        dap.configurations.cpp = {
            {
                type = "codelldb",
                name = "Debug",
                request = "launch",
                program = function()
                    return vim.fn.input("Executable: ", "${workspaceFolder}/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }

        dap.configurations.c = dap.configurations.cpp

        for _, lang in ipairs({ "cs", "fsharp" }) do
            dap.configurations[lang] = {
                {
                    type = "coreclr",
                    name = "Debug",
                    request = "launch",
                    env = function()
                        local dotnet = require("easy-dotnet")
                        local dll = dotnet.get_debug_dll()
                        return dotnet.get_environment_variables(dll.project_name, dll.absolute_project_path, false) or {}
                    end,
                    program = function()
                        local dotnet = require("easy-dotnet")
                        local dll = dotnet.get_debug_dll()
                        vim.cmd("!dotnet build " .. dll.absolute_project_path)
                        return dll.target_path
                    end,
                    cwd = function()
                        local dotnet = require("easy-dotnet")
                        local dll = dotnet.get_debug_dll()
                        return dll.absolute_project_path
                    end,
                },
            }
        end

        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/continue debugging" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step out" })
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
        vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
    end,
}