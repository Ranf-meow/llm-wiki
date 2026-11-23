# Slide 06 — 論文③精要（戚得郁 2025）

- **Kicker**: 05 · Layer 3 — Lightweight Encoder vs. Local Quantized LLM
- **Title**: 戚得郁 (2025)：WC-SBERT 正面對決本地量化 LLM
- **Core Takeaway**: 針對結構化零樣本主題分類，結合維基度數剪枝與 GPT-4o 描述性標籤的輕量 SBERT 在 AG News 奪冠（0.847），且遠勝過度量化小 LLM。
- **Visual Spec (`bar-chart` + `.card`)**:
  - 左欄（`.card.amber`）：**三大輕量工程支柱（0 筆目標原文）**：
    - **維基度數剪枝**：保留 100% 中頻（`5≤d≤500`）、低頻抽 20%、高頻抽 2%，刪 36.7% 類別仍保 99.1% 語意，AG News 直升 `+7.8%`。
    - **GPT-4o 描述性標籤**：統一前綴＋15–30 字＋跨類去重，DBpedia 由 `0.718` 暴增至 **`0.883`**（相對 `+23.0%`），大勝全自動 APE（`0.693`）。
    - **離線 `.npy` 單階段 MNR**：重用 645 萬篇 Wiki 摘要向量，單次微調取代多輪迭代。
  - 右欄（`.card.teal`）：**Table 5.19 核心對決（AG News / DBpedia 最佳設定）**：
    - **WC-SBERT（輕量 Encoder）**：AG `0.847 ★`｜DB `0.886`
    - **Gemma 2（Ollama 本地量化 FS）**：AG `0.832`｜DB `0.915 ★`
    - **GPT-4o mini（API FS）**：AG `0.655`｜DB `0.841`
    - **Llama 3.1（Ollama FS）**：AG `0.680`｜DB `0.761`
    - **Llama 3.2（Ollama FS）**：AG `0.601`｜DB `0.649`
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§3–4, Tables 5.6 / 5.13 / 5.19)
- **Speaker Notes**: 第三層來到戚得郁 (2025) 博士論文，它給工程師一記非常清醒的提醒：並不是所有 NLP 任務都該搬 LLM。只要把維基百科的長尾維護標籤洗乾淨，再用 GPT-4o 依照三條約束把短標籤寫成描述句，輕量級的 WC-SBERT 在完全不看目標原文下，不僅在 AG News 以 0.847 擊敗所有受測的 Ollama 本地量化模型，連在 Yahoo 與 DBpedia 也只微幅落後 Gemma 2，而且推論只要毫秒級向量內積。那如果任務真的非跑本地 LLM 不可，線上部署怎麼省電？我們看第四層陳冠錞 (2025)。
