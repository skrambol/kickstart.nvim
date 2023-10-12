return {
  'saccarosium/neomarks',
  config = function ()
    local neomarks = require('neomarks')
    neomarks.setup()

    vim.keymap.set('n', '<leader>h', neomarks.mark_file, {silent=true})
    vim.keymap.set('n', '<C-h>', neomarks.menu_toggle, {silent=true})
    vim.keymap.set('n', '<leader>1', function () neomarks.jump_to(1) end, {silent=true})
    vim.keymap.set('n', '<leader>2', function () neomarks.jump_to(2) end, {silent=true})
    vim.keymap.set('n', '<leader>3', function () neomarks.jump_to(3) end, {silent=true})
    vim.keymap.set('n', '<leader>4', function () neomarks.jump_to(4) end, {silent=true})
    vim.keymap.set('n', '<leader>5', function () neomarks.jump_to(5) end, {silent=true})

  end
}
