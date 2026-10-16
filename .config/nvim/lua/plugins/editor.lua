return {
  -- テキストオブジェクト・コメント・括弧などの小物をまとめて提供する
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.ai').setup({ n_lines = 500 })
      require('mini.surround').setup()
      require('mini.comment').setup()
      require('mini.pairs').setup()
      require('mini.bufremove').setup()
      require('mini.indentscope').setup()
      require('mini.cursorword').setup()

      -- 行の移動は mini.move に任せる（Vim 標準の J/K は使わない）
      require('mini.move').setup({
        mappings = {
          left = '<A-h>',
          right = '<A-l>',
          down = '<A-j>',
          up = '<A-k>',
          line_down = '<A-j>',
          line_up = '<A-k>',
        },
      })

      vim.keymap.set('n', '<leader>bd', function()
        require('mini.bufremove').delete(0, false)
      end, { desc = 'バッファを閉じる' })
    end,
  },

  -- カーソル移動の高速化
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash でジャンプ' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash で構文ジャンプ' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Flash でリモート移動' },
    },
  },

  -- TODO / FIXME の一覧
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
    keys = {
      { '<leader>ft', '<cmd>TodoQuickFix<CR>', desc = 'TODO 一覧' },
    },
  },

  -- セッションの保存と復元
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'セッションを復元' },
      { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = '直近のセッションを復元' },
      { '<leader>qd', function() require('persistence').stop() end, desc = 'セッション保存を停止' },
    },
  },

  -- Markdown をその場でリッチに描画する
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
}
