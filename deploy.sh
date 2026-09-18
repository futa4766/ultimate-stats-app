#!/bin/bash
set -e

# 1. GitHubから最新の zip を取得 (pull)
echo "📥 GitHubから最新状態を取得中..."
git pull origin main

# 2. zip ファイルが存在するか確認して解凍
ZIP_FILE="ultimate-stats-app.zip"

if [ -f "$ZIP_FILE" ]; then
    echo "📦 $ZIP_FILE を解凍中..."
    unzip -o "$ZIP_FILE" -d ./
    
    # Gitの追跡からzip自体の変更を取り除く（展開されたコードのみをコミットするため）
    git rm "$ZIP_FILE" || rm -f "$ZIP_FILE"
else
    echo "⚠️ $ZIP_FILE が見つかりませんでした。"
    exit 1
fi

# 3. 依存パッケージの更新
echo "📥 パッケージチェック中..."
npm install

# 4. 解凍したコードを GitHub へ反映
echo "🚀 変更をGitHubへ反映中..."
git add .
git commit -m "Auto extracted from uploaded zip: $(date '+%Y-%m-%d %H:%M:%S')" || true
git push origin main

echo "✅ すべての処理が完了しました！"
