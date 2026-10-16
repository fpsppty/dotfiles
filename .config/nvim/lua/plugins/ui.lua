return {
  -- カラースキーム（最初に読み込む）
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    opts = {
      flavour = 'mocha',
      term_colors = true,
      integrations = {
        blink_cmp = false,
        gitsigns = true,
        mason = true,
        mini = { enabled = true },
        noice = true,
        notify = true,
        treesitter = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },

  -- アイコン（他プラグインから依存される）
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- ステータスライン
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
        disabled_filetypes = { statusline = { 'dashboard', 'oil' } },
      },
    },
  },

  -- バッファタブ
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        show_close_icon = false,
      },
    },
  },

  -- キーマップのヒント表示
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      spec = {
        { '<leader>a', group = 'テキストオブジェクト' },
        { '<leader>b', group = 'バッファ' },
        { '<leader>c', group = 'コード' },
        { '<leader>d', group = 'デバッグ' },
        { '<leader>f', group = '検索' },
        { '<leader>g', group = 'Git' },
        { '<leader>q', group = 'セッション' },
        { '<leader>t', group = 'ターミナル' },
        { '<leader>x', group = '診断' },
      },
    },
  },

  -- コマンドライン UI
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    lazy = true,
    opts = {
      timeout = 2000,
      stages = 'fade',
    },
  },
}
