# Paper LLM Wiki 知識庫

這是一座參考 Andrej Karpathy **LLM Wiki** 概念打造的論文知識庫，專為**課程學習、讀書會導讀與簡報大綱整理**設計，採用純 Markdown 格式，可直接在 VS Code 或 GitHub 瀏覽。

完整的 Agent 行為規範、頁面模板與工作流程請見 [AGENTS.md](./AGENTS.md)。

## 快速入口

- **知識總目錄**：[wiki/index.md](./wiki/index.md)
- **操作紀錄日誌**：[wiki/log.md](./wiki/log.md)
- **原始論文資料（唯讀）**：`raw/papers/`、`raw/assets/`
- **簡報大綱產出**：`slides/`

## 目錄結構

```text
paper-wiki/
├── AGENTS.md           # Agent 規則、模板與四大工作流入口
├── README.md           # 本說明檔
├── workflows/          # 進階 StateGraph 工作流規範（如 slide-graph.md）
├── scripts/            # 靜態驗證腳本（如 validate-slides.ps1）
├── raw/
│   ├── papers/         # 【唯讀】原始 PDF 或 arXiv/DOI 本地快照
│   └── assets/         # 【唯讀】從論文擷取的圖表
├── wiki/
│   ├── index.md        # 內容導向總目錄
│   ├── log.md          # 時間序操作日誌
│   ├── papers/         # 單篇論文導讀頁
│   ├── concepts/       # 核心概念與演算法頁
│   ├── benchmarks/     # 資料集、指標與實驗數據對照頁
│   └── topics/         # 主題綜述、比較表與 Mermaid 演進圖
└── slides/             # 互動式 HTML 投影片與 _work/<slug>/ 中間狀態
```

## 常用對話指令範例

1. **消化新論文（Ingest）**
   - 把 PDF 放進 `raw/papers/` 後說：「請依照 `AGENTS.md` 幫我 ingest `raw/papers/xxx.pdf`，先進入階段一跟我討論重點。」
   - 或直接給連結：「請依照 `AGENTS.md` 收錄這篇 arXiv 論文：`https://arxiv.org/abs/xxxx.xxxxx`，先做階段一討論。」
2. **跨論文提問（Query）**
   - 「根據目前 wiki，比較 A 和 B 在某個問題上的做法與實驗差異。」
3. **產出讀書會互動簡報（Slide StateGraph）**
   - 「請依照 `workflows/slide-graph.md` 從 wiki 幫我做一份 20 分鐘的 HTML 簡報，先產出大綱給我（H1）確認。」
4. **知識庫健檢（Lint）**
   - 「請對整個 `paper-wiki` 執行一次 Lint 健檢，檢查斷鏈、雙向連結、缺頁概念與數據矛盾。」
