return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = { 'ToggleTerm', 'TermExec' },
    keys = {
      { '<leader>tt', '<cmd>ToggleTerm direction=float<CR>', desc = 'ターミナル（float）' },
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal size=12<CR>', desc = 'ターミナル（横）' },
      { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=60<CR>', desc = 'ターミナル（縦）' },
      { '<C-\\>', '<cmd>ToggleTerm<CR>', desc = 'ターミナル切替' },
    },
    opts = {
      size = 20,
      direction = 'float',
      shade_terminals = false,
      start_in_insert = true,
      persist_size = true,
      close_on_exit = false,
      float_opts = { border = 'rounded' },
    },
  },
}
