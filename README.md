# dotfiles

[dotter](https://github.com/SuperCuber/dotter) で管理しています。各ファイルはリポジトリからホームディレクトリへ symlink されます。

## セットアップ

1. dotter をインストールする

   - Windows: `winget install SuperCuber.Dotter`
   - macOS: `brew install dotter`
   - Arch Linux: `yay -S dotter-rs-bin`

2. リポジトリを clone する

   ```sh
   gh auth login
   git clone https://github.com/fpsppty/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

3. ホスト固有の設定ファイルを作成する（gitignore 対象）

   ```sh
   printf 'packages = ["default"]\n' > .dotter/local.toml
   ```

4. デプロイする

   ```sh
   dotter deploy -v
   ```

   既存ファイルを置き換える場合は `dotter deploy -f` を使う。

## 構成

- `.dotter/global.toml` — パッケージ・ファイル定義と OS ごとの条件
- `.config/`, `.gitconfig`, `.zshrc`, `Documents/` — 各ホームディレクトリへ symlink される dotfiles
- `windows/` — Windows のプロビジョニング（WinGet DSC と Flow Launcher テーマ取得）
