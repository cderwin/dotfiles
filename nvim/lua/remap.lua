local which_key = require "which-key"
local builtin = require "telescope.builtin"

local newtab = function()
    local current_path = vim.api.nvim_buf_get_name(0)
    vim.cmd("tabnew")
    if vim.uv.fs_stat(current_path) then
        require("oil").open(vim.fs.dirname(current_path))
    else
        require("oil").open(vim.fn.getcwd())
    end
end

local teletab = function()
    vim.cmd("tabnew")
    builtin.find_files()
end

local mappings = {
    { "<leader><leader>", "<CMD>write<CR>", desc = "Write current file" },
    { "<leader>q", "<CMD>wq<CR>", desc = "Save and quit current buffer" },
    { "<leader>t", newtab, desc = "open new tab" },
    { "<leader>T", teletab, desc = "open telescope in new tab"},
    { "<s-l>", "gt", desc = "go-to next tab" },
    { "<s-h>", "gT", desc = "go-to previous tab" },
    { "-", "<CMD>Oil<CR>", desc = "Open oil file browser" },
    { "<leader>f", builtin.find_files, desc = "Fuzzy search working directory" },
    { "<leader>g", builtin.git_files, desc = "Fuzzy search git files" },
    { "<leader>/", builtin.live_grep, desc = "Search files with ripgrep" },
    { "<leader>d", builtin.diagnostics, desc = "Browse lsp diagnostics messages" },
    { "Q", "@q", desc = "Invoke macro stored to q" },
    { "<leader>F", vim.lsp.buf.format, desc = "Format current buffer" },
}

which_key.add(mappings)

