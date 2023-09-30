return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

      -- don't override the built-in and fugitive keymaps
      local gs = package.loaded.gitsigns
      vim.keymap.set({ 'n', 'v' }, ']g', function()
        if vim.wo.diff then return ']g' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
      vim.keymap.set({ 'n', 'v' }, '[g', function()
        if vim.wo.diff then return '[g' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
      vim.keymap.set({ 'n' }, '<leader>gr', function()
        if vim.wo.diff then return '<leader>gr' end
        vim.schedule(function() gs.reset_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Reset this hunk" })
      vim.keymap.set({ 'v' }, '<leader>gr', function()
        if vim.wo.diff then return '<leader>gr' end
        vim.schedule(function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Reset this hunk" })
      vim.keymap.set({ 'n' }, '<leader>gR', function()
        if vim.wo.diff then return '<leader>gR' end
        vim.schedule(function() gs.reset_buffer() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Reset this buffer" })
    end,
  },
}
