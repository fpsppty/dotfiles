local mason = vim.fn.stdpath('data') .. '/mason/packages'

-- 実行可能なパスを先頭から探す
local function first_existing(candidates)
  for _, path in ipairs(candidates) do
    if path and path ~= '' and vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

-- プロジェクトの venv を優先して Python を解決する
local function project_python()
  local root = vim.fn.getcwd()
  return first_existing({
    root .. '/.venv/Scripts/python.exe',
    root .. '/.venv/bin/python',
    root .. '/venv/Scripts/python.exe',
    root .. '/venv/bin/python',
    vim.fn.exepath('python'),
    vim.fn.exepath('python3'),
  })
end

-- debugpy が確実に入っている mason の venv
local function debugpy_python()
  return first_existing({
    mason .. '/debugpy/venv/Scripts/python.exe',
    mason .. '/debugpy/venv/bin/python',
  })
end

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
        opts = {
          icons = { expanded = '', collapsed = '', current_frame = '' },
          layouts = {
            {
              elements = {
                { id = 'scopes', size = 0.35 },
                { id = 'breakpoints', size = 0.25 },
                { id = 'stacks', size = 0.25 },
                { id = 'watches', size = 0.15 },
              },
              size = 40,
              position = 'left',
            },
            {
              elements = {
                { id = 'repl', size = 0.6 },
                { id = 'console', size = 0.4 },
              },
              size = 12,
              position = 'bottom',
            },
          },
          floating = { border = 'rounded' },
        },
      },
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },
      'mxsdev/nvim-dap-vscode-js',
    },
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'ブレークポイント切替' },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input('ブレーク条件: '))
        end,
        desc = '条件付きブレークポイント',
      },
      { '<leader>dc', function() require('dap').continue() end, desc = '実行 / 続行' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'ステップオーバー' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'ステップイン' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'ステップアウト' },
      { '<leader>dt', function() require('dap').terminate() end, desc = '終了' },
      { '<leader>dl', function() require('dap').run_last() end, desc = '前回の構成で実行' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'REPL' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'DAP UI 切替' },
      { '<leader>de', function() require('dapui').eval() end, mode = { 'n', 'v' }, desc = '式を評価' },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dap-ui')

      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
      vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DiagnosticInfo' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DiagnosticError' })
      vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk' })

      dap.listeners.after.event_initialized['dapui'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui'] = function()
        dapui.close()
      end

      -- JavaScript / TypeScript: vscode-js-debug（mason の js-debug-adapter）を使う
      require('dap-vscode-js').setup({
        debugger_path = mason .. '/js-debug-adapter',
        debugger_cmd = { 'js-debug-adapter' },
        adapters = { 'pwa-node', 'pwa-chrome' },
      })

      local node = vim.fn.exepath('node')
      for _, filetype in ipairs({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }) do
        dap.configurations[filetype] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Node を起動（現在のファイル）',
            program = '${file}',
            cwd = '${workspaceFolder}',
            runtimeExecutable = node ~= '' and node or 'node',
            console = 'integratedTerminal',
            sourceMaps = true,
            skipFiles = { '<node_internals>/**' },
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Node にアタッチ',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Chrome を起動',
            url = function()
              return vim.fn.input('URL: ', 'http://localhost:3000')
            end,
            webRoot = '${workspaceFolder}',
          },
        }
      end

      -- Python: アダプタは debugpy 同梱の mason venv で動かし、
      -- デバッグ対象は可能ならプロジェクトの venv を使う
      dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
          cb({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 5678 })
        else
          local python = debugpy_python() or project_python() or 'python'
          cb({ type = 'executable', command = python, args = { '-m', 'debugpy.adapter' } })
        end
      end

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Python を起動（現在のファイル）',
          program = '${file}',
          console = 'integratedTerminal',
          python = function()
            return project_python() or 'python'
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'pytest を実行',
          module = 'pytest',
          args = { '-vv', '-s', '.' },
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          python = function()
            return project_python() or 'python'
          end,
        },
      }

      -- Dart / Flutter: SDK 同梱の debug_adapter を使う
      -- Windows の flutter は .bat なので exepath で解決する
      local dart = vim.fn.exepath('dart')
      local flutter = vim.fn.exepath('flutter')
      dap.adapters.dart = { type = 'executable', command = dart ~= '' and dart or 'dart', args = { 'debug_adapter' } }
      dap.adapters.flutter = {
        type = 'executable',
        command = flutter ~= '' and flutter or 'flutter',
        args = { 'debug_adapter' },
      }
      dap.configurations.dart = {
        {
          type = 'dart',
          request = 'launch',
          name = 'Dart を起動（現在のファイル）',
          program = '${file}',
          cwd = '${workspaceFolder}',
          console = 'internalConsole',
        },
        {
          type = 'flutter',
          request = 'launch',
          name = 'Flutter を起動',
          program = 'lib/main.dart',
          cwd = '${workspaceFolder}',
          console = 'internalConsole',
        },
      }

      -- Java は nvim-jdtls（lua/plugins/lsp.lua）が java-debug-adapter を接続するため、
      -- ここでのアダプタ定義は不要。構成は :DapNew の "Java" から選べる。
    end,
  },
}
