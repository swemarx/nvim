-------------
-- Options --
-------------

local vim_opts = {
    backup = false,
    clipboard = "unnamedplus",
    fileencoding = "utf-8",
    hlsearch = true,
    incsearch = false,
    ignorecase = true,
    mouse = "a",
    swapfile = false,
    termguicolors = true,
    timeoutlen = 1000,
    undofile = true,
    updatetime = 500,
    writebackup = false,
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    cursorline = true,
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    wrap = false,
    scrolloff = 8,
    sidescrolloff = 8,
    splitbelow = true,
    splitright = true,
}

for k, v in pairs(vim_opts) do
    vim.opt[k] = v
end

-------------
-- Keymaps --
-------------

local keymap = vim.api.nvim_set_keymap
local keymap_opts = { noremap = true, silent = true }

-- keymap("n", "<Space>", "<Nop>", opts)

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Simpler window navigation
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

-- Open explorer
keymap("n", "<leader>e", ":Lexplore 30<CR>", keymap_opts)

-- Navigate buffers
keymap("n", "S-l", "bnext<CR>", keymap_opts)
keymap("n", "S-h", "bprevious<CR>", keymap_opts)

-------------
-- Plugins --
-------------

local lazy_opts = {
    ui = {
        border = "rounded",
    }
}

-- Init lazy.nvim

require("my.lazy")
require("lazy").setup({
    -- { "ellisonleao/gruvbox.nvim" },
    -- { "catppuccin/nvim" },
    { "navarasu/onedark.nvim",
        config = function()
            local onedark = require("onedark")
            onedark.setup {
                style = "darker"
            }
            onedark.load()
        end
    },
    -- { "folke/tokyonight.nvim", config = function() vim.cmd("colorscheme tokyonight") end },
    { "nvim-lualine/lualine.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "powerline" -- default is "auto"
                }
            })
        end
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            -- LSP Support
            -- { "neovim/nvim-lspconfig" },             -- Required
            -- { "williamboman/mason.nvim" },           -- Optional
            -- { "williamboman/mason-lspconfig.nvim" }, -- Optional
            -- { "simrat39/rust-tools.nvim" },
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({buffer = bufnr})
            end)
            require("lspconfig").lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            }
        end
    },
    { "neovim/nvim-lspconfig" },
    { "L3MON4D3/LuaSnip", -- follow latest release.
	    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    },
    { "williamboman/mason.nvim", config = true },
    { "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup {
                ensure_installed = { "ansiblels", "bashls", "elixirls", "gopls", "jsonls", "lua_ls", "pylsp", "rust_analyzer", "yamlls", "zls" },
                handlers = {
                    require("lsp-zero").default_setup
                }
            }
        end
    },
    { "hrsh7th/nvim-cmp", config = true },
    { "hrsh7th/cmp-nvim-lsp", config = true },
    { "simrat39/rust-tools.nvim",
        config = function()
            require("rust-tools").setup({
                server = {
                    on_attach = function(_, bufnr)
                        -- Hover actions
                        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                        -- Code action groups
                        vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    end,
                },
            })
        end
    },
    { "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "lua", "rust", "toml" },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                ident = { enable = true },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                }
            }
        end
    },
}, lazy_opts)
