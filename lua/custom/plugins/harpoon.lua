return {
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function ()
    local harpoon_ui = require('harpoon.ui')

    vim.keymap.set('n', '<leader>h', function () require('harpoon.mark').add_file() end, {silent=true})
    vim.keymap.set('n', '<C-h>', harpoon_ui.toggle_quick_menu, {silent=true})
    vim.keymap.set('n', '<leader>1', function () harpoon_ui.nav_file(1) end, {silent=true})
    vim.keymap.set('n', '<leader>2', function () harpoon_ui.nav_file(2) end, {silent=true})
    vim.keymap.set('n', '<leader>3', function () harpoon_ui.nav_file(3) end, {silent=true})
    vim.keymap.set('n', '<leader>4', function () harpoon_ui.nav_file(4) end, {silent=true})
    vim.keymap.set('n', '<leader>5', function () harpoon_ui.nav_file(5) end, {silent=true})
  end
}
