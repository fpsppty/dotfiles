local opt = vim.opt

-- 表示
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.termguicolors = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.showmode = false
opt.laststatus = 3
opt.pumheight = 10
opt.winborder = 'rounded'
opt.fillchars = { eob = ' ' }

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 編集
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
opt.breakindent = true
opt.inccommand = 'split'
opt.confirm = true
opt.hidden = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.completeopt = 'menu,menuone,noselect'

-- 検索
opt.ignorecase = true
opt.smartcase = true

-- ウィンドウ
opt.splitright = true
opt.splitbelow = true

-- ファイル
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.fileformat = 'unix'
opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,terminal'

-- 診断の表示は 0.11 以降のポップアップに寄せる
opt.updatetime = 250
opt.timeoutlen = 300

local undodir = vim.fn.stdpath('state') .. '/undo'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
opt.undodir = undodir

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = '●' },
  severity_sort = true,
  update_in_insert = false,
  float = { border = 'rounded', source = true },
  jump = { float = true },
})
