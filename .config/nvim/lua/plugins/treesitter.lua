return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- main ブランチは Neovim 0.12 以降が必須。
    -- 0.11 で動かす場合は branch = 'master' に切り替える。
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local parsers = {
        'bash',
        'c',
        'comment',
        'css',
        'dart',
        'diff',
        'dockerfile',
        'git_config',
        'gitcommit',
        'gitignore',
        'html',
        'http',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'printf',
        'python',
        'query',
        'regex',
        'scss',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      }

      -- main ブランチには ensure_installed が無いので直接 install する
      require('nvim-treesitter').install(parsers)

      -- パーサ名と Vim の filetype が一致しないもの（tsx -> typescriptreact 等）を補正する
      local filetypes = {}
      for _, parser in ipairs(parsers) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(parser)) do
          filetypes[ft] = true
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user_treesitter', {}),
        pattern = vim.tbl_keys(filetypes),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
          if vim.api.nvim_get_current_buf() == ev.buf then
            vim.opt_local.foldmethod = 'expr'
            vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          end
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require('nvim-treesitter-textobjects.select')
      local move = require('nvim-treesitter-textobjects.move')
      local swap = require('nvim-treesitter-textobjects.swap')

      local function sel(query, desc)
        return function()
          select.select_textobject(query, 'textobjects')
        end
      end

      vim.keymap.set({ 'x', 'o' }, 'am', sel('@function.outer'), { desc = '関数の外側' })
      vim.keymap.set({ 'x', 'o' }, 'im', sel('@function.inner'), { desc = '関数の内側' })
      vim.keymap.set({ 'x', 'o' }, 'ac', sel('@class.outer'), { desc = 'クラスの外側' })
      vim.keymap.set({ 'x', 'o' }, 'ic', sel('@class.inner'), { desc = 'クラスの内側' })
      vim.keymap.set({ 'x', 'o' }, 'ak', sel('@block.outer'), { desc = 'ブロックの外側' })
      vim.keymap.set({ 'x', 'o' }, 'ik', sel('@block.inner'), { desc = 'ブロックの内側' })
      vim.keymap.set({ 'x', 'o' }, 'aa', sel('@parameter.outer'), { desc = '引数の外側' })
      vim.keymap.set({ 'x', 'o' }, 'ia', sel('@parameter.inner'), { desc = '引数の内側' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = '次の関数へ' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end, { desc = '前の関数へ' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = '次のクラスへ' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end, { desc = '前のクラスへ' })

      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next('@parameter.inner')
      end, { desc = '引数を次と入れ替え' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = '引数を前と入れ替え' })
    end,
  },
}
