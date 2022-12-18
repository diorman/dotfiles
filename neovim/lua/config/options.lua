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
