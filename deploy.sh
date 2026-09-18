#!/bin/bash
set -e

echo "📥 GitHubから最新状態を取得中..."
git pull origin main || true

ZIP_FILE="ultimate-stats-app.zip"

if [ -f "$ZIP_FILE" ]; then
    echo "📦 $ZIP_FILE を解凍中..."
    unzip -o "$ZIP_FILE" -d ./
    git rm "$ZIP_FILE" || rm -f "$ZIP_FILE"
fi

echo "📥 パッケージを準備中..."
npm install
npm install --save-dev gh-pages

echo "🛠️ アプリをビルド中..."
npm run build

echo "🚀 ソースコードをGitHubへ保存中..."
git add .
git commit -m "Fix build and deploy: $(date '+%Y-%m-%d %H:%M:%S')" || true
git push origin main

echo "🌐 GitHub Pagesへ公開中..."
npx gh-pages -d dist

echo "✅ デプロイが完了しました！"
