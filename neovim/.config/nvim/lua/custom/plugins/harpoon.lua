return {
  {
    'ThePrimeagen/harpoon',
    config = function ()
      vim.keymap.set('n', '<leader>m', require("harpoon.mark").add_file, { desc = '[M]ark as harpoon file' })
      vim.keymap.set('n', '<C-e>', require("harpoon.ui").toggle_quick_menu)
      vim.keymap.set('n', '<leader>1', function () require('harpoon.ui').nav_file(1) end, { desc = 'Go to harpoon [1]' })
      vim.keymap.set('n', '<leader>2', function () require('harpoon.ui').nav_file(2) end, { desc = 'Go to harpoon [2]' })
      vim.keymap.set('n', '<leader>3', function () require('harpoon.ui').nav_file(3) end, { desc = 'Go to harpoon [3]' })
      vim.keymap.set('n', '<leader>4', function () require('harpoon.ui').nav_file(4) end, { desc = 'Go to harpoon [4]' })
    end
  }
}
