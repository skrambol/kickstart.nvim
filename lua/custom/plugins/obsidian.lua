local M = {
  "epwalsh/obsidian.nvim",
  lazy = true,
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- remove event to make plugin (specifically commands) global?
    "BufReadPre /mnt/d/obsidian/**.md",
    "BufNewFile /mnt/d/obsidian/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim"
  },
  config = function()
    local obsidian = require('obsidian')
    obsidian.setup({
      dir = '/mnt/d/obsidian/notes',
      notes_subdir = '',
      daily_notes = {
        folder = 'journal',
        date_format = '%Y-%m-%d',
        alias_format = '%Y-%m-%d',
        template = 'journal.md'
      },
      templates = {
        subdir = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {}
      },
      disable_frontmatter = true, -- TODO: does not add frontmatter when creating daily note
      overwrite_mappings = true,
      mappings = {
        ['gf'] = {
          action = function()
            return obsidian.util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true }
        },
      }
    })

    vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianToday<CR>', { silent = true, desc = 'obsidian.nvim open note today' })
    vim.keymap.set('n', '<leader>oc', '<cmd>enew<CR><cmd>ObsidianTemplate dev.md<CR>',
      { silent = true, desc = 'obsidian.nvim create new dev.md note' })

  end
}

-- TODO: create keymap to create/open file from vault

return M
