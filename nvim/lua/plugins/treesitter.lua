return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
	local configs = require "nvim-treesitter.configs"
	configs.setup {
	    ensure_installed = { "c", "lua", "vim", "vimdoc", "java", "javascript", "html", "python", "html", "python", "typescript", "rust", "go" },
	    sync_install = false,
	    highlight = { enable = true },
	    indent = { enable = true },
	}
    end
}
