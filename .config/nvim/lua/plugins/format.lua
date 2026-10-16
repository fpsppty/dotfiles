return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        desc = 'フォーマット',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        html = { 'prettier' },
        markdown = { 'prettier' },
        python = { 'ruff_format' },
        dart = { 'dart_format' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        toml = { 'taplo' },
      },
      -- Java は jdtls の LSP フォーマットにフォールバックする
      format_on_save = { timeout_ms = 3000, lsp_format = 'fallback' },
    },
  },

  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'BufReadPost' }, {
        group = vim.api.nvim_create_augroup('user_lint', {}),
        callback = function()
          -- 保存できないバッファでは走らせない
          if vim.bo.modifiable and not vim.bo.readonly then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
