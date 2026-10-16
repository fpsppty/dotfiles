local augroup = vim.api.nvim_create_augroup('user', {})

-- ヤンクした範囲をハイライトする
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  desc = 'ヤンクをハイライト',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- 前回のカーソル位置に戻る
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  desc = 'カーソル位置を復元',
  callback = function(ev)
    if not vim.tbl_contains({ 'gitcommit' }, vim.bo[ev.buf].filetype) then
      local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
      if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  end,
})

-- ウィンドウサイズ変更時に分割を均等にする
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup,
  desc = '分割を均等に',
  command = 'tabdo wincmd =',
})

-- 一時的なバッファを q で閉じられるようにする
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  desc = 'q で閉じる',
  pattern = {
    'checkhealth',
    'dap-float',
    'dap-repl',
    'gitsigns-blame',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'Trouble',
  },
  callback = function(ev)
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = ev.buf, desc = '閉じる' })
  end,
})
