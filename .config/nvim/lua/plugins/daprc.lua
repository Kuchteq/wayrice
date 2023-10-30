-- This is shit I know but some day when I have the time I'll make it better
DEBUG_MODE_STATUS = false
DEBUGGABLE_MODE_STATUS = false
DEBUG_MODE_BUFFER_NR = -100
DEBUG_MODE_AUTOCMD_ID = -10


local M = {};

P = function(table) print(vim.inspect(table)); end

M._styleNamespace = nil;
M._previousDebugCursorRow = nil;
M._followCursorAutocmdId = nil;

M.toggleEasyDebug = function()
    -- automatically check if there's a launch.json available and add configuration present there
    require('dap.ext.vscode').load_launchjs(".vscode/launch.json");
    if vim.bo.filetype == "java" then
        require('jdtls.dap').setup_dap_main_class_configs()
    end

    local stackmap = require("stackmap")
    local lualine = require("lualine")
    M._styleNamespace = vim.api.nvim_create_namespace("currentCursorNs");
    if DEBUGGABLE_MODE_STATUS == false then
        lualine.setup({ sections = { lualine_b = { { function() return "DBG" end, color = { fg = "#e57474", gui = "bold" } }, "branch", 'diff', "diagnostics" } } })
        stackmap.push("debuggable", "n", {
            { "q", M.debug_mode_toggle, desc = "debuggable" }
        })
    else
        stackmap.pop("debuggable", "n")
        lualine.setup({ sections = { lualine_b = { 'branch', 'diff', 'diagnostics' } } })
    end
    DEBUGGABLE_MODE_STATUS = not DEBUGGABLE_MODE_STATUS
end

M._modeChangeApperance = function(toDebug)
    local lualine = require("lualine")
    local palette = require('everblush.palette')
    if toDebug then
        lualine.setup({ sections = { lualine_a = { { function() return "DEBUG" end, color = { bg = "#e57474", fg = "#000000" } } } } })
        local lineBg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg;
        vim.api.nvim_set_hl(M._styleNamespace, 'CursorLine', { fg = palette.color4, bg = lineBg, bold = true })
        vim.api.nvim_set_hl(M._styleNamespace, 'CursorLineNr', { fg = palette.color4, bg = lineBg })
        vim.api.nvim_set_hl_ns(M._styleNamespace);

        M._previousDebugCursorRow = vim.api.nvim_win_get_cursor(0)[1]
        vim.fn.sign_place(420, "currentCursorNs", "CurrentCursorDebugLine", 1, { lnum = M._previousDebugCursorRow });

        M._followCursorAutocmdId = vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                local currentRow = vim.api.nvim_win_get_cursor(0)[1]
                if M._previousDebugCursorRow ~= currentRow then
                    vim.fn.sign_unplace("currentCursorNs", { buffer = 1, id = 420 });
                    vim.fn.sign_place(420, "currentCursorNs", "CurrentCursorDebugLine", 1, { lnum = currentRow });
                end
                M._previousDebugCursorRow = currentRow;
            end,
        })
    else
        vim.api.nvim_set_hl_ns(0)
        vim.api.nvim_del_autocmd(M._followCursorAutocmdId);
        vim.fn.sign_unplace("currentCursorNs", { buffer = 1, id = 420 });
        lualine.setup({ sections = { lualine_a = { "mode" } } })
    end
end


-- require'dap.breakpoints'.set({},vim.api.nvim_buf_get_number(0), 22) set stuff programatically
M.debug_mode_toggle = function()
    local stackmap = require("stackmap")
    local widgets = require('dap.ui.widgets')
    local varsidebar = widgets.sidebar(widgets.scopes, { width = 50 })
    if DEBUG_MODE_STATUS == false then
        stackmap.pop("debuggable", "n");
        local bufnr = vim.api.nvim_get_current_buf()
        DEBUG_MODE_BUFFER_NR = bufnr
        stackmap.push("debug_mode", "n", {
            {
                "i",
                function()
                    vim.api.nvim_feedkeys('j', 'n', false)
                    require("dap").toggle_breakpoint()
                end,
                {},
                desc = "Toggle Breakpoint"
            },
            { "<esc>", M.debug_mode_toggle,                               desc = "Escape debug" },
            { "A",     function() require("dap").clear_breakpoints() end, {},                               desc = "Clear all breakpoitns" },
            { "c",     function() require("dap").continue(); end,         { silent = true, nowait = true }, desc = "Continue" },
            { "o",     function() require("dap").run_to_cursor() end,     {},                               desc = "Run to Cursor" },
            { "n",     function() require("dap").down() end,              {},                               desc = "Down" },
            { "p",     function() require("dap").up() end,                {},                               desc = "Up" },
            { "r",     function() require("dap").run_last() end,          {},                               desc = "Run Last" },
            { "q",     function() require("dap").terminate() end,         {},                               desc = "Run Last" },
            { "d",     function() require("dap").step_over() end,         { silent = true, nowait = true }, desc = "Step Over" },
            { "U",     function() require("dapui").toggle({}) end,         { silent = true, nowait = true }, desc = "Step Over" },
            { "<c-r>", function() require("dap").repl.toggle() end,       { nowait = true },                desc = "Toggle REPL" },
            { "<c-v>", function() varsidebar.toggle() end, { nowait = true }, desc = "Toggle Variables"
            },
            { "u", function() require("dap").step_back() end,        {},                desc = "Step Back" },
            { "a", function() require("dap.ui.widgets").hover() end, { nowait = true }, desc = "Eval" },
        })
        stackmap.push("with_ui", "v", {
            { "a", function() require("dapui").eval() end, { nowait = true }, desc = "Eval" },
        })
        M._modeChangeApperance(true);
    else
        M._modeChangeApperance(false);
        stackmap.pop("debug_mode", "n")
        stackmap.pop("with_ui", "n")
        stackmap.push("debuggable", "n", { { "q", M.debug_mode_toggle, desc = "debuggable" } })
    end
    DEBUG_MODE_STATUS = not DEBUG_MODE_STATUS
end


local debug_output_term = {
    win_clean_autocmd_id = nil,
    buf_id = nil,
    launch_editor_buf_id = nil,
    init = function(self)
        self.buf_id = api.nvim_create_buf(false, false)
        self.launch_editor_buf_id = api.nvim_create_buf(false, false)
        vim.keymap.set("n", "r", require("dap").run_last, { buffer = self.buf_id, silent = true });
        vim.keymap.set("n", "ę", function()
            if api.nvim_get_current_buf() == self.buf_id then
                api.nvim_set_current_buf(self.launch_editor_buf_id);
                vim.cmd("edit .vscode/launch.json");
                api.nvim_buf_set_option(self.launch_editor_buf_id, "buflisted", false)
            else
                api.nvim_set_current_buf(self.buf_id);
            end
        end);
        api.nvim_create_autocmd({ "BufDelete" }, {
            callback = function()
                self.buf_id = nil
            end,
            buffer = self.buf_id
        })
    end,
    get_sizing = function()
        local nvim_width = vim.go.columns;
        local nvim_height = vim.go.lines;
        local output_width = math.floor(nvim_width * 0.9)
        local output_height = math.floor(nvim_height * 0.9)
        return {
            col = math.floor((nvim_width - output_width) / 2),
            row = math.floor((nvim_height - output_height) / 2) - 1,
            width = output_width,
            height = output_height
        }
    end,
    get_output_win_ids = function()
        return vim.tbl_filter(function(v) return pcall(function() api.nvim_win_get_var(v, "displays_output") end) and true or false end, api.nvim_list_wins())
    end,
    toggle = function(self)
        local output_wins = self.get_output_win_ids()
        if #output_wins > 0 then
            for _, value in ipairs(output_wins) do
                api.nvim_win_close(value, true)
            end
        else
            local previously_inited = self.buf_id
            if not previously_inited then
                self:init()
            end
            local opened_win_id = api.nvim_open_win(self.buf_id, true, vim.tbl_extend("force", { relative = "editor", border = "rounded", style = "minimal" }, self.get_sizing()))
            api.nvim_win_set_var(opened_win_id, "displays_output", true);
        end
    end
}

startInDebug = function()
    -- If there is launch.json
    local launch_json = '.vscode/launch.json'
    local relative_prefix = ""
    local merged = relative_prefix .. launch_json
    local relative_search_dir = vim.fn.fnamemodify(vim.fn.getcwd() .. relative_prefix, ":p")
    while vim.fn.glob(merged) == "" and relative_search_dir ~= "/home/" do
        relative_prefix = "../" .. relative_prefix
        merged = relative_prefix .. launch_json
        relative_search_dir = vim.fn.fnamemodify(vim.fn.getcwd() .. "/" .. relative_prefix, ":p")
    end
    if relative_search_dir ~= "/home/" then vim.api.nvim_command("cd " .. relative_search_dir) end
    local potential_service = vim.fn.glob("*Service")
    launch_json = ((vim.fn.glob('.gitlab-ci.yml') ~= "" and potential_service ~= "") and (potential_service .. "/") or "") .. launch_json

    if vim.fn.glob(launch_json) ~= "" then
        require("mason").setup()
        require('plugins.java').config()
        vim.bo.filetype = "java"

        vim.api.nvim_create_autocmd('LspNotify', {
            callback = function(args)
                debug_output_term:init()
                require('dap.ext.vscode').load_launchjs(launch_json);
                require('dap').defaults.java.terminal_win_cmd = function()
                    vim.api.nvim_win_set_buf(0, debug_output_term.buf_id); -- Idk why I have to do that if it is supposed to be done on the line below but this way I don't have problems with the displayed numberline
                    vim.cmd.bd(1)
                    return debug_output_term.buf_id, 0
                end
                require("dap").continue();
            end,
            once = true
        })
    else
        vim.fn.system("notify-send 'No project detected'")
    end
end

return {

    "mfussenegger/nvim-dap",
    dependencies = {

        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = "mason.nvim",
            cmd = { "DapInstall", "DapUninstall" },
            config = function()
                local palette = require('everblush.palette')

                vim.api.nvim_create_autocmd({ "FileType" }, {
                    pattern = "dap-float",
                    callback = function(ev)
                        vim.api.nvim_buf_set_keymap(ev.buf, "n", "<esc>", "<cmd>close!<CR>", { silent = true, nowait = true })
                    end,
                })
                vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = palette.color1, bg = '#31353f' })
                vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = palette.color4, bg = '#31353f' })
                vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = palette.color2, bg = '#31353f' })
                vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
                vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
                vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
                vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
                vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

                vim.fn.sign_define('CurrentCursorDebugLine', { text = '>>', texthl = 'CursorLine', linehl = 'CursorLine', numhl = 'CursorLineNr' })
                require("nvim-dap-virtual-text").setup()
                require("mason-nvim-dap").setup({
                    ensure_installed = { "python" },
                    handlers = {}
                })
            end
        },

        { "Alighorab/stackmap.nvim" },
        { "theHamsta/nvim-dap-virtual-text" },
        {
            "rcarriga/nvim-dap-ui",
            -- stylua: ignore
            keys = {
                { "<space>D", function() require("dapui").toggle({}) end, desc = "Dap UI" },
            },
            config = function(_, opts)
                local dapui = require("dapui")
                dapui.setup({
                    layouts = { {
                        elements = { {
                            id = "scopes",
                            size = 0.40
                        }, {
                            id = "watches",
                            size = 0.35
                        }, {
                            id = "stacks",
                            size = 0.25
                        }, },
                        position = "left",
                        size = 40
                    }, },
                })
            end,
        }
    },
    -- stylua: ignore
    keys = {
        { "<leader>q", function()
            M.toggleEasyDebug()
            if DEBUG_MODE_STATUS == false and DEBUGGABLE_MODE_STATUS or DEBUG_MODE_STATUS == true and DEBUGGABLE_MODE_STATUS == false then
                M.debug_mode_toggle()
            end
        end },
        { "»", function()
            debug_output_term:toggle()
        end } },
    config = function()
        local dap = require('dap')
        -- dap.listeners.before['event_terminated']['my-plugin'] = function(session, body)
        --     print('Session terminated', vim.inspect(session), vim.inspect(body))
        -- end
        require('dap').listeners.before['launch']['startnotifier'] = function(session)
            vim.fn.system("notify-send 'Debug starting: " .. session.config.name .. "'")
        end
        dap.defaults.fallback.terminal_win_cmd = function()
            debug_output_term:init()
            return debug_output_term.buf_id
        end

        local mason_registry = require("mason-registry")
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = mason_registry.get_package("cpptools"):get_install_path() .. '/extension/debugAdapters/bin/OpenDebugAD7',
        }
        dap.configurations.c = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    local toCompile = vim.api.nvim_buf_get_name(0)
                    -- local checksum = vim.spl vim.fn.system({"md5sum", toCompile})
                    local outFile = vim.fn.expand("%:t:r") .. "-debug.out"
                    vim.fn.system({ "gcc", "-g", toCompile, "-o", vim.fn.getcwd() .. "/" .. outFile })
                    return outFile
                end,
                cwd = '${workspaceFolder}',
                externalConsole = true
                --stopAtEntry = true,
            } }
        -- C section
        -- dap.configurations.c = {
        --     {
        --         name = "Launch file",
        --         type = "gdb",
        --         request = "launch",
        --         program = function()
        --             local toCompile = vim.api.nvim_buf_get_name(0)
        --             -- local checksum = vim.spl vim.fn.system({"md5sum", toCompile})
        --             local outFile = vim.fn.expand("%:t:r") .. "-debug.out"
        --             vim.fn.system({ "gcc", "-g", toCompile, "-o", vim.fn.getcwd() .. "/" .. outFile })
        --             return outFile
        --         end,
        --         cwd = '${workspaceFolder}',
        --         stopOnEntry = false,
        --     },
        -- }
        -- dap.adapters.gdb = {
        --     type = "executable",
        --     command = "gdb",
        --     args = { "-i", "dap" }
        -- }
    end
}
