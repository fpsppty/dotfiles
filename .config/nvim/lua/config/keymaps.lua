local map = vim.keymap.set

-- 検索ハイライトを消す
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'ハイライトを消す' })

-- 保存
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = '保存' })

-- ターミナルモードから戻る
map('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'ターミナルモードを抜ける' })

-- ウィンドウ移動
map('n', '<C-h>', '<C-w>h', { desc = '左のウィンドウ' })
map('n', '<C-j>', '<C-w>j', { desc = '下のウィンドウ' })
map('n', '<C-k>', '<C-w>k', { desc = '上のウィンドウ' })
map('n', '<C-l>', '<C-w>l', { desc = '右のウィンドウ' })

-- ウィンドウのリサイズ
map('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = '縦に広げる' })
map('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = '縦に狭める' })
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = '横に狭める' })
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = '横に広げる' })

-- バッファ移動
map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = '前のバッファ' })
map('n', '<S-l>', '<cmd>bnext<CR>', { desc = '次のバッファ' })

-- 診断の移動と表示
map('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = '前の診断' })
map('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = '次の診断' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = '診断を表示' })

-- ビジュアルモードのインデントを保持する
map('v', '<', '<gv', { desc = 'インデントを減らす' })
map('v', '>', '>gv', { desc = 'インデントを増やす' })

-- 挿入モードを抜けずに移動
map('i', '<C-h>', '<Left>', { desc = '左へ' })
map('i', '<C-l>', '<Right>', { desc = '右へ' })
