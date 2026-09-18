import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],

  // GitHub Pagesにデプロイする場合、base はリポジトリ名に合わせて変更してください。
  // 例: リポジトリが https://github.com/your-name/ultimate-stats-app なら
  //     base: "/ultimate-stats-app/"
  // 独自ドメイン（CNAME）を使う場合、または <username>.github.io リポジトリ
  // (ルート直下に公開する場合) は base: "/" にしてください。
  base: "/ultimate-stats-app/",
});
