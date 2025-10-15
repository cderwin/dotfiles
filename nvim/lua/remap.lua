local which_key = require "which-key"
local builtin = require "telescope.builtin"

local mappings = {
    { "<leader><leader>", "<CMD>write<CR>", desc = "Write current file" },
    { "<leader>q", "<CMD>wq<CR>", desc = "Save and quit current buffer" },
    { "<leader>t", "<CMD>tabnew<CR>", desc = "open new tab" },
    { "<s-l>", "gt", desc = "go-to next tab" },
    { "<s-h>", "gT", desc = "go-to previous tab" },
    { "-", "<CMD>Oil<CR>", desc = "Open oil file browser" },
    { "<leader>s", builtin.find_files, desc = "Fuzzy search working directory" },
}

which_key.add(mappings)

