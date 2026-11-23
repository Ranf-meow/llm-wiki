# Slide 10 — 工程復現避坑指南

- **Kicker**: `09 · Critical Review & Pitfalls`
- **Title**: `復現這套管線前，必須先避開的 4 個陷阱`
- **Core Bullets**:
  - 4 張精簡警戒卡（嚴控字數 ≤ 380 視覺單位）：
    1. **Groundedness 漏餵 Answer**：附錄 Fig. A.1 只餵 `Q + Context` → 復現必改餵 `(Context, Q, A)` 才能擋幻覺。
    2. **小語料檢索偏差**：112 頁讓 Top-5 輕鬆 100% → 大規模須補 Hybrid Search 與 Reranker。
    3. **關鍵字評估盲區**：僅驗 3 關鍵字＋缺摘要所述人工評分表 → 抓不到「中字但因果錯」的醫療幻覺。
    4. **公開基準公平性**：PubMedQA `95.6` vs Bonito `27.0` → 須核對雙方是否同處開書 RAG 條件。
- **Visual Spec (`grid-4`)**:
  - 4 欄等高色彩頂邊卡片（rose / amber / primary / teal），每卡 1 句問題 ＋ 1 句修正，杜絕長段文字牆。
- **Citations**: `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md`, `wiki/benchmarks/pubmedqa.md`
- **Speaker Notes**: `讀書會最有價值的就是幫大家提前排雷！這 4 個坑是我們比對論文正文與附錄抓出來的：最隱蔽的是坑 1，附錄的 Groundedness Prompt 根本沒把 Answer 傳進去；坑 4 則提醒看 PubMedQA 95.6 分時，別忘了核對開書與閉書的比較公平性。最後一頁收斂成 3 條實作 Checklist 與討論題。`
