return {
  {
    -- あいまい検索（ファイル・grep・LSP など）
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'ファイル検索' },
      { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = '全文検索' },
      { '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'バッファ一覧' },
      { '<leader>fr', function() require('telescope.builtin').oldfiles() end, desc = '最近のファイル' },
      { '<leader>fw', function() require('telescope.builtin').grep_string() end, desc = 'カーソル下の単語を検索' },
      {
        '<leader>fW',
        function()
          local selection = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'))
          require('telescope.builtin').grep_string({ search = table.concat(selection, '\n') })
        end,
        mode = 'v',
        desc = '選択範囲を検索',
      },
      { '<leader>fs', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'ドキュメントシンボル' },
      { '<leader>fS', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, desc = 'ワークスペースシンボル' },
      { '<leader>fR', function() require('telescope.builtin').lsp_references() end, desc = '参照一覧' },
      { '<leader>fd', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, desc = 'このファイルの診断' },
      { '<leader>fD', function() require('telescope.builtin').diagnostics() end, desc = 'ワークスペースの診断' },
      { '<leader>fk', function() require('telescope.builtin').keymaps() end, desc = 'キーマップ一覧' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'ヘルプ検索' },
      { '<leader>fc', function() require('telescope.builtin').commands() end, desc = 'コマンド一覧' },
      { '<leader>fp', function() require('telescope.builtin').git_files() end, desc = 'Git 管理下のファイル' },
    },
    opts = {
      defaults = {
        border = true,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        prompt_prefix = ' ',
        selection_caret = ' ',
        path_display = { 'truncate' },
        sorting_strategy = 'ascending',
        layout_strategy = 'horizontal',
        layout_config = {
          width = 0.9,
          height = 0.85,
          horizontal = { prompt_position = 'top', preview_width = 0.55 },
        },
      },
      pickers = {
        find_files = { hidden = true },
        live_grep = { additional_args = { '--hidden', '--glob', '!.git/*' } },
      },
    },
  },
}
