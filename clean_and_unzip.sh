#!/bin/bash
set -e

ZIP_FILE="ultimate-stats-app.zip"

echo "=== 1. GitHubの最新状態に手元を強制同期 (git reset) ==="
git fetch origin main
git reset --hard origin/main

if [ ! -f "$ZIP_FILE" ]; then
    echo "エラー: $ZIP_FILE が見つかりません。GitHubにZIPがPushされているか確認してください。"
    exit 1
fi

echo "=== 2. 一時フォルダにZIPを展開 ==="
rm -rf temp_unzip
unzip -o "$ZIP_FILE" -d temp_unzip

echo "=== 3. 解凍パスの特定 ==="
if [ -d "temp_unzip/ultimate-stats-app" ]; then
    SOURCE_DIR="temp_unzip/ultimate-stats-app"
else
    SOURCE_DIR="temp_unzip"
fi

echo "=== 4. 不要な旧ファイルを一括削除 ==="
find . -mindepth 1 -maxdepth 1 \
  ! -name ".git" \
  ! -name "*.sh" \
  ! -name "$ZIP_FILE" \
  ! -name "temp_unzip" \
  ! -name "node_modules" \
  -exec rm -rf {} +

echo "=== 5. 最新ファイルをトップ階層へ移動 ==="
cp -r $SOURCE_DIR/* .
rm -rf temp_unzip

echo "=== 完了 ==="
echo "ファイルの更新が完了しました。git status で確認して deploy.sh を実行してください。"
