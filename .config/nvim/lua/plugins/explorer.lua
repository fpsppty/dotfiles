return {
  {
    -- netrw を置き換えるツリー型ファイラ
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>e', function() require('neo-tree.command').execute({ toggle = true }) end, desc = 'ファイルエクスプローラ' },
      { '<leader>E', function() require('neo-tree.command').execute({ toggle = true, dir = vim.fn.getcwd() }) end, desc = 'カレントディレクトリを開く' },
      { '<leader>ef', function() require('neo-tree.command').execute({ toggle = true, reveal = true }) end, desc = '編集中のファイルを表示' },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      filesystem = {
        -- nvim . や :e <dir> で neo-tree を開く（netrw を置き換える）
        hijack_netrw_behavior = 'open_default',
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        width = 32,
        mappings = {
          -- 既定で閉じるのは q のみ。Esc でも閉じられるようにする
          ['<Esc>'] = 'close_window',
          ['h'] = 'close_node',
          ['l'] = 'open',
        },
      },
    },
  },
}
