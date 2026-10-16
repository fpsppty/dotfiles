-- mason が入れた実行ファイルを解決する（Windows の .cmd も考慮）
local function mason_bin(name)
  local path = vim.fn.exepath(name)
  return path ~= '' and path or name
end

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- capabilities を注入するため先に読み込む
      { 'saghen/blink.cmp' },
      {
        'mason-org/mason.nvim',
        opts = { ui = { border = 'rounded' } },
      },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = {
          -- automatic_enable = true（既定）で導入済みサーバが自動で enable される
          ensure_installed = {
            'lua_ls',
            'vtsls',
            'eslint',
            'basedpyright',
            'ruff',
            'jdtls',
            'marksman',
            'jsonls',
            'yamlls',
            'taplo',
            'bashls',
          },
        },
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
          ensure_installed = {
            -- フォーマッタ / リンタ
            'stylua',
            'prettier',
            'shfmt',
            'shellcheck',
            'taplo',
            'ruff',
            -- デバッガ
            'js-debug-adapter',
            'debugpy',
            'java-debug-adapter',
            'java-test',
          },
        },
      },
      {
        'j-hui/fidget.nvim',
        opts = {
          progress = { suppress_on_insert = true },
          notification = { window = { winblend = 0 } },
        },
      },
      -- Java は nvim-jdtls でテスト実行とデバッグまで面倒を見る
      { 'mfussenegger/nvim-jdtls', ft = 'java' },
      {
        'folke/trouble.nvim',
        cmd = 'Trouble',
        opts = {},
        keys = {
          { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = '診断一覧' },
          { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'このファイルの診断' },
          { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<CR>', desc = 'シンボル一覧' },
          { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', desc = 'LSP 定義・参照' },
          { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = 'QuickFix' },
        },
      },
    },
    config = function()
      -- blink.cmp の LSP capabilities を全サーバに適用する
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- lua_ls: Neovim 設定を書くときに vim を認識させる
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file('', true),
            },
            completion = { callSnippet = 'Replace' },
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
          },
        },
      })

      -- TypeScript / JavaScript
      vim.lsp.config('vtsls', {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
            updateImportsOnFileMove = { enabled = 'always' },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              variableTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
            updateImportsOnFileMove = { enabled = 'always' },
          },
        },
      })

      -- eslint は整形を prettier に任せるのでフォーマット機能だけ無効化する
      vim.lsp.config('eslint', {
        settings = {
          workingDirectories = { mode = 'auto' },
          format = false,
        },
      })

      -- Python
      vim.lsp.config('basedpyright', {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'standard',
              autoImportCompletions = true,
              inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
              },
            },
          },
        },
      })
      vim.lsp.config('ruff', {
        init_options = {
          settings = {
            lineLength = 100,
          },
        },
      })

      -- Dart / Flutter: mason には無いので SDK 同梱の language-server を使う
      -- fvm 管理のプロジェクトでは cmd を { 'fvm', 'dart', 'language-server', '--protocol=lsp' } に差し替える
      local dart = vim.fn.exepath('dart')
      vim.lsp.config('dartls', {
        cmd = { dart ~= '' and dart or 'dart', 'language-server', '--protocol=lsp' },
        init_options = {
          closingLabels = true,
          outline = true,
          flutterOutline = true,
        },
        settings = {
          dart = {
            completeFunctionCalls = true,
            showTodos = true,
            updateImportsOnRename = true,
          },
        },
      })

      -- LSP がアタッチしたバッファにキーマップを入れる
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user_lsp_attach', {}),
        callback = function(ev)
          local buf = ev.buf
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = buf, desc = desc })
          end

          map('gd', vim.lsp.buf.definition, '定義へ')
          map('gD', vim.lsp.buf.declaration, '宣言へ')
          map('gi', vim.lsp.buf.implementation, '実装へ')
          map('gy', vim.lsp.buf.type_definition, '型定義へ')
          map('gr', vim.lsp.buf.references, '参照一覧')
          map('K', vim.lsp.buf.hover, 'ホバー')
          map('<C-k>', vim.lsp.buf.signature_help, 'シグネチャ')
          map('<leader>cr', vim.lsp.buf.rename, 'リネーム')
          map('<leader>ca', vim.lsp.buf.code_action, 'コードアクション')
          map('<leader>ci', vim.lsp.buf.incoming_calls, '呼び出し元')
          map('<leader>co', vim.lsp.buf.outgoing_calls, '呼び出し先')
        end,
      })

      -- Java: jdtls を nvim-jdtls 経由で起動し、デバッグ用バンドルを渡す
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user_jdtls', {}),
        pattern = 'java',
        callback = function()
          local mason = vim.fn.stdpath('data') .. '/mason/packages'
          local bundles = vim.list_extend(
            vim.fn.glob(mason .. '/java-debug-adapter/extension/server/*.jar', false, true),
            vim.fn.glob(mason .. '/java-test/extension/server/*.jar', false, true)
          )

          require('jdtls').start_or_attach({
            cmd = { mason_bin('jdtls') },
            root_dir = vim.fs.root(0, {
              'settings.gradle',
              '.git',
              'mvnw',
              'gradlew',
              'settings.gradle.kts',
              'pom.xml',
              'build.gradle',
              'build.gradle.kts',
            }),
            init_options = { bundles = bundles },
            settings = {
              java = {
                signatureHelp = { enabled = true },
                contentProvider = { preferred = 'fernflower' },
                completion = { favoriteStaticMembers = { 'org.junit.jupiter.api.Assertions.*' } },
                sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
                codeGeneration = {
                  toString = { template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}' },
                  hashCodeEquals = { useJava7Objects = true },
                  useBlocks = true,
                },
              },
            },
            on_attach = function()
              -- デバッグとテスト実行を有効にする
              pcall(function()
                require('jdtls.dap').setup_dap({ hotcodereplace = 'auto' })
                require('jdtls.setup').add_commands()
              end)
            end,
          })
        end,
      })
    end,
  },
}
