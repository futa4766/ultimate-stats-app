#!/bin/bash
set -e

ZIP_FILE="ultimate-stats-app.zip"

echo "=== 1. ZIPファイルの存在確認 ==="
if [ ! -f "$ZIP_FILE" ]; then
    echo "エラー: $ZIP_FILE が見つかりません。ZIPをアップロードしてください。"
    exit 1
fi

echo "=== 2. 一時フォルダへ解凍 ==="
rm -rf temp_unzip
mkdir temp_unzip
unzip -q "$ZIP_FILE" -d temp_unzip

echo "=== 3. 既存ソースコード（src/public等）の完全削除 ==="
rm -rf src public index.html vite.config.ts vite.config.js tsconfig.json package.json package-lock.json

echo "=== 4. ZIPの中身を直下に正しく配置 ==="
# ZIP内にフォルダが1つ挟まっているか確認して配置
INNER_DIR=$(find temp_unzip -mindepth 1 -maxdepth 1 -type d)
NUM_DIRS=$(echo "$INNER_DIR" | wc -l)

if [ "$NUM_DIRS" -eq 1 ] && [ -n "$INNER_DIR" ]; then
    echo "フォルダ階層を検出しました。中身を移動します: $INNER_DIR"
    cp -r "$INNER_DIR"/* .
    cp -r "$INNER_DIR"/.* . 2>/dev/null || true
else
    echo "直下に展開します"
    cp -r temp_unzip/* .
    cp -r temp_unzip/.* . 2>/dev/null || true
fi

echo "=== 5. 後片付け ==="
rm -rf temp_unzip "$ZIP_FILE"

echo "=== チェック完了 ==="
git status
