return {
  {
    -- ディレクトリをバッファとして編集するタイプのファイラ（ツリー表示ではない）
    -- 遅延読み込みは README で非推奨とされているので lazy = false にする
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- nvim . や :e <dir> で oil を開く（netrw を置き換える）
      default_file_explorer = true,
      columns = { 'icon' },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      -- 外部でファイルが増減したら追従する
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
        natural_order = 'fast',
      },
      float = {
        padding = 2,
        max_width = 0.6,
        max_height = 0.6,
        border = 'rounded',
      },
      keymaps = {
        -- 既定で閉じるのは <C-c> のみ。Esc でも閉じられるようにする
        -- （ユーザー定義は既定キーマップを上書きするだけで、他は残る）
        ['<Esc>'] = { 'actions.close', mode = 'n' },
      },
    },
    keys = {
      { '<leader>e', function() require('oil').toggle_float() end, desc = 'ファイルエクスプローラ' },
      { '<leader>E', function() require('oil').open(vim.fn.getcwd()) end, desc = 'カレントディレクトリを開く' },
    },
  },
}
