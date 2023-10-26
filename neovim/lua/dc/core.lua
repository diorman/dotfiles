local function setup_options()
  local options = {
    -- Set completeopt to have a better completion experience (recommended for hrsh7th/nvim-cmp)
    completeopt = { "menu", "menuone", "noselect" },

    -- Allows neovim to access the system clipboard
    clipboard = "unnamedplus",

    -- Highlight the text line of the cursor
    cursorline = true,

    -- Set highlight on search
    hlsearch = false,

    -- Makes search act like search in modern browsers
    incsearch = true,

    -- Case insensitive searching UNLESS /C or capital in search
    ignorecase = true,
    smartcase = true,

    -- lukas-reineke/indent-blankline.nvim
    listchars = "tab: →,space:.,lead:.,trail:.",
    list = true,

    -- Enable mouse mode
    mouse = "a",

    -- Show relative line numbers
    number = true,
    relativenumber = true,

    -- Do not display the mode (ie VISUAL, INSERT, etc)
    showmode = false,

    -- Prefer windows splitting to the right (horizontal) or bottom (vertical)
    splitright = true,
    splitbelow = true,

    -- Do not use a swapfile for the buffer
    swapfile = false, -- creates a swapfile

    -- Convert tab to spaces
    expandtab = true,
    tabstop = 2, -- insert 2 spaces for a tab
    shiftwidth = 2, -- the number of spaces inserted for each indentation

    -- Do smart autoindenting when starting a new line
    smartindent = true,

    -- Save undo history
    undofile = true,

    -- 	Minimal number of screen lines to keep above and below the cursor.
    scrolloff = 10,

    -- Set colorscheme
    termguicolors = true,

    -- Decrease update time
    updatetime = 250,
    signcolumn = "yes",

    -- A file that matches with one of these patterns is ignored when expanding |wildcards|...
    wildignore = { "**/.git/*", "**/node_modules/*" },

    -- Disable line wrapping
    wrap = false,
  }

  for k, v in pairs(options) do
    vim.opt[k] = v
  end
end

local function setup_keymaps()
  vim.g.mapleader = " "

  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

  vim.keymap.set("n", "J", "mzJ`z", { desc = "Same as native J but cursor stays in place" })

  -- Half page jumping with. Cursor stays in the middle
  vim.keymap.set("n", "<C-d>", "<C-d>zz")
  vim.keymap.set("n", "<C-u>", "<C-u>zz")

  -- Search term stays in the middle
  vim.keymap.set("n", "n", "nzzzv")
  vim.keymap.set("n", "N", "Nzzzv")

  -- Deletes selected text and paste contents in buffer
  vim.keymap.set("x", "<leader>p", [["_dP]])
  vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

  vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
  vim.keymap.set("n", "<leader>Y", [["+Y]])

  -- Quickfix list navigation
  vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
  vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
  vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
  vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

  -- Buffer navigation
  vim.keymap.set("n", "<C-b>b", "<cmd>b#<CR>") -- alternate last active
  vim.keymap.set("n", "<C-b>p", "<cmd>bprevious<CR>")
  vim.keymap.set("n", "<C-b>n", "<cmd>bnext<CR>")
end

local function setup_autocommands()
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("trim-trailing-whitespace", { clear = true }),
    pattern = { "*" },
    command = [[keeppatterns %s/\s\+$//e]], -- keeppatterns: prevents the \s\+$ pattern from being added to the search history.
  })
end

setup_options()
setup_keymaps()
setup_autocommands()
