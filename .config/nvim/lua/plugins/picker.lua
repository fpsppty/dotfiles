return {
  {
    -- fzf バイナリをそのまま使うのでネイティブビルドが不要
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'FzfLua',
    opts = {
      winopts = {
        border = 'rounded',
        preview = { layout = 'vertical', vertical = 'down:45%' },
      },
      files = { hidden = true, git_icons = true, file_icons = true },
      grep = { hidden = true },
      keymap = {
        fzf = {
          ['ctrl-q'] = 'select-all+accept',
          ['ctrl-a'] = 'toggle-all',
          ['ctrl-d'] = 'half-page-down',
          ['ctrl-u'] = 'half-page-up',
        },
      },
    },
    config = function(_, opts)
      require('fzf-lua').setup(opts)
      -- vim.ui.select / vim.ui.input の見た目を fzf-lua に寄せる
      require('fzf-lua').register_ui_select()
    end,
    keys = {
      { '<leader>ff', function() require('fzf-lua').files() end, desc = 'ファイル検索' },
      { '<leader>fg', function() require('fzf-lua').live_grep() end, desc = '全文検索' },
      { '<leader>fb', function() require('fzf-lua').buffers() end, desc = 'バッファ一覧' },
      { '<leader>fr', function() require('fzf-lua').oldfiles() end, desc = '最近のファイル' },
      { '<leader>fw', function() require('fzf-lua').grep_cword() end, desc = 'カーソル下の単語を検索' },
      { '<leader>fW', function() require('fzf-lua').grep_visual() end, mode = 'v', desc = '選択範囲を検索' },
      { '<leader>fs', function() require('fzf-lua').lsp_document_symbols() end, desc = 'ドキュメントシンボル' },
      { '<leader>fS', function() require('fzf-lua').lsp_live_workspace_symbols() end, desc = 'ワークスペースシンボル' },
      { '<leader>fR', function() require('fzf-lua').lsp_references() end, desc = '参照一覧' },
      { '<leader>fd', function() require('fzf-lua').diagnostics_document() end, desc = 'このファイルの診断' },
      { '<leader>fD', function() require('fzf-lua').diagnostics_workspace() end, desc = 'ワークスペースの診断' },
      { '<leader>fk', function() require('fzf-lua').keymaps() end, desc = 'キーマップ一覧' },
      { '<leader>fh', function() require('fzf-lua').helptags() end, desc = 'ヘルプ検索' },
      { '<leader>fc', function() require('fzf-lua').commands() end, desc = 'コマンド一覧' },
      { '<leader>fp', function() require('fzf-lua').git_files() end, desc = 'Git 管理下のファイル' },
    },
  },
}
