return require("packer").startup(function(use)
  use({
    "nvim-tree/nvim-tree.lua",
    requires = "nvim-tree/nvim-web-devicons",
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })

  use({ -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    requires = {
      -- Useful status updates for LSP
      "j-hui/fidget.nvim",
    },
  })

  use("onsails/lspkind.nvim")

  use("lewis6991/gitsigns.nvim")
  use("numToStr/Comment.nvim")

  use({
    "nvim-lualine/lualine.nvim",
    -- requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  })

  use("windwp/nvim-autopairs")

  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-nvim-lua")
  use("hrsh7th/cmp-nvim-lsp")
  use("saadparwaiz1/cmp_luasnip")
  use("L3MON4D3/LuaSnip")
  use("rafamadriz/friendly-snippets")
  use("jose-elias-alvarez/null-ls.nvim")

  use({
    "nvim-telescope/telescope.nvim",
    requires = "nvim-lua/plenary.nvim",
  })

  use("EdenEast/nightfox.nvim")

  use("lukas-reineke/indent-blankline.nvim")
end)
