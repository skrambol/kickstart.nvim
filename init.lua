---@diagnostic disable: missing-fields
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },

  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'nordfox'
      vim.o.cursorlineopt = "number"
      vim.o.cursorline = true
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'nordfox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require('kickstart.plugins.debug'),
  { import = 'custom.plugins' },
  -- require('kickstart.plugins.autoformat'),
}, {})

-- [[ Setting options ]]

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'
vim.keymap.set({ 'n', 'i', 'v' }, '<LeftMouse>', '<Nop>')
vim.keymap.set({ 'n', 'i', 'v' }, '<RightMouse>', '<Nop>')

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamed'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.wrap = false
vim.o.scrolloff = 9999
vim.o.sidescrolloff = 4
vim.o.pumheight = 10

vim.o.showmode = false
vim.o.tabstop = 2

vim.o.fixeol = false

vim.g.netrw_banner = 0
vim.g.netrw_fastbrowse = 0

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- fugitive
vim.keymap.set('n', '<leader>gs', '<cmd>G<CR><C-w><C-o>', { silent = true, desc = 'git status' })
vim.keymap.set('n', '<leader>gl', '<cmd>Git log<CR>', { silent = true, desc = 'git log' })
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<CR>', { silent = true, desc = 'git blame' })

-- move lines
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { silent = true, desc = 'move selection down one line' })
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', { silent = true, desc = 'move selection up one line' })
vim.keymap.set('v', '>', '>gv', { silent = true, desc = 'add indentation to selection' })
vim.keymap.set('v', '<', '<gv', { silent = true, desc = 'remove indentation from selection' })

-- buffers
-- vim.keymap.set('n', '<leader>d', '<cmd>bdel<CR>', { silent = true, desc = '[d]elete buffer' })
vim.keymap.set('n', '<leader><Space>', '<C-^>', { silent = true, desc = 'Open previous file' })
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { silent = true, desc = 'write to current buffer' })
vim.keymap.set('i', '<C-s>', '<esc><cmd>w<CR>', { silent = true, desc = 'write to current buffer' })

local function wrap_list(list, command)
  local tbl = {}

  if list == "c" then
    tbl = vim.fn.getqflist()
  elseif list == "l" then
    tbl = vim.fn.getloclist(0)
  end

  if next(tbl) == nil then
    print("[!] cannot move to next file. list is blank")
    return
  end

  if pcall(function() vim.cmd({ cmd = list .. command }, {}) end) then
    return
  end

  if command == 'next' then
    wrap_list(list, 'first')
  else
    wrap_list(list, 'last')
  end
end
vim.keymap.set('n', ']q', function() wrap_list('c', 'next') end, { silent = true, desc = 'Next quickfix item' })
vim.keymap.set('n', '[q', function() wrap_list('c', 'prev') end, { silent = true, desc = 'Previous quickfix item' })

vim.keymap.set('n', '<F3>', '<cmd>Ex<CR>')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.o.list = true
vim.opt.listchars = {
  trail = '·',
  tab = '┊ ',
  precedes = "<",
  extends = ">",
  multispace = " ",
  nbsp = "␣",
}
local function update_lead()
  local lcs = vim.opt_local.listchars:get()
  local tab = vim.fn.str2list(lcs.tab)
  local space = vim.fn.str2list(lcs.multispace or lcs.space)
  local lead = { tab[1] }
  for i = 1, vim.bo.tabstop - 1 do
    lead[#lead + 1] = space[i % #space + 1]
  end
  vim.opt_local.listchars:append({ leadmultispace = vim.fn.list2str(lead) })
  -- vim.print(vim.fn.expand('%') .. ' ' .. vim.bo.filetype .. vim.bo.tabstop .. vim.inspect(vim.opt_local.listchars:get()["leadmultispace"]))
end
vim.api.nvim_create_autocmd("OptionSet", { pattern = { "listchars", "tabstop", "filetype" }, callback = update_lead })
vim.api.nvim_create_autocmd("BufRead", { callback = update_lead})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
