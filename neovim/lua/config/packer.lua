return require("packer").startup(function(use)
  use({
    "nvim-tree/nvim-tree.lua",
    requires = "nvim-tree/nvim-web-devicons",
  })

  use({ -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    run = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  })

  use({ -- Additional text objects via treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  })

  use({
    "nvim-telescope/telescope.nvim",
    requires = "nvim-lua/plenary.nvim",
  })

  use({ -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    requires = {
      -- Useful status updates for LSP
      "j-hui/fidget.nvim",
    },
  })

  use({ -- Autocompletion
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
  })

  use("jose-elias-alvarez/null-ls.nvim") -- Use Neovim as a language server to inject LSP features via Lua
  use("lewis6991/gitsigns.nvim") -- Git
  use("numToStr/Comment.nvim") -- Comments
  use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
  use("windwp/nvim-autopairs") -- Autopairs
  use("nvim-lualine/lualine.nvim") -- Fancier statusline
  use("EdenEast/nightfox.nvim") -- Theme
end)
