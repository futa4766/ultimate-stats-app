#!/bin/bash
set -e

ZIP_FILE="ultimate-stats-app.zip"

echo "=========================================="
echo " 1. GitHubから最新のmainを取得"
echo "=========================================="
git checkout main
git pull origin main || true

echo "=========================================="
echo " 2. ZIPファイルの確認と解凍処理"
echo "=========================================="
if [ -f "$ZIP_FILE" ]; then
    echo "📦 $ZIP_FILE を検出しました。解凍処理を開始します..."

    # 一時フォルダの作成と解凍
    rm -rf temp_unzip
    mkdir temp_unzip
    unzip -q "$ZIP_FILE" -d temp_unzip

    # 既存の主要ファイルを一旦クリーンアップ（不要・古いファイルの残留防止）
    rm -rf src public index.html vite.config.ts vite.config.js tsconfig.json package.json package-lock.json

    # ZIP内にサブフォルダが挟まっているか判定して配置
    INNER_DIR=$(find temp_unzip -mindepth 1 -maxdepth 1 -type d)
    NUM_DIRS=$(echo "$INNER_DIR" | wc -l)

    if [ "$NUM_DIRS" -eq 1 ] && [ -n "$INNER_DIR" ]; then
        echo "📂 フォルダ構造を検出: $INNER_DIR から直下に配置します"
        cp -r "$INNER_DIR"/* .
        cp -r "$INNER_DIR"/.* . 2>/dev/null || true
    else
        echo "📂 直下に配置します"
        cp -r temp_unzip/* .
        cp -r temp_unzip/.* . 2>/dev/null || true
    fi

    # 後片付け
    rm -rf temp_unzip "$ZIP_FILE"
    echo "✅ ZIPの解凍と展開が完了しました"
else
    echo "⚠️ $ZIP_FILE が見つかりません。現在のコードでデプロイを進めます。"
fi

echo "=========================================="
echo " 3. main ブランチへ変更をコミット＆Push"
echo "=========================================="
git add .
if ! git diff-index --quiet HEAD --; then
    git commit -m "Update source from zip $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "✅ mainブランチへPush完了"
else
    echo "ℹ️ ソースコードに変更はありませんでした"
fi

echo "=========================================="
echo " 4. キャッシュ削除と完全再ビルド"
echo "=========================================="
echo "🧹 古いビルド成果物とViteキャッシュを破棄中..."
rm -rf dist node_modules/.vite

echo "📦 依存パッケージの確認..."
npm install --silent

echo "🛠️ アプリのビルドを実行中..."
npm run build

echo "=========================================="
echo " 5. gh-pages へ強制デプロイ"
echo "=========================================="
npx gh-pages -d dist -m "Force deploy $(date +'%Y-%m-%d %H:%M:%S')"

echo "=========================================="
echo " 🎉 すべての処理が完了しました！"
echo "=========================================="
