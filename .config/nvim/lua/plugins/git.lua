return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end

        map('n', ']h', function() gs.nav_hunk('next') end, '次の hunk')
        map('n', '[h', function() gs.nav_hunk('prev') end, '前の hunk')
        map('n', '<leader>gs', gs.stage_hunk, 'hunk をステージ')
        map('n', '<leader>gr', gs.reset_hunk, 'hunk を破棄')
        map('n', '<leader>gp', gs.preview_hunk, 'hunk をプレビュー')
        map('n', '<leader>gd', gs.diffthis, 'このファイルの差分')
        map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'blame を表示')
        map('n', '<leader>gB', gs.toggle_current_line_blame, 'blame を行内に表示')
      end,
    },
  },

  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>gg', '<cmd>Neogit<CR>', desc = 'Neogit' },
    },
    opts = {},
  },
}
