# Slide 09 — 實驗對決二（Benchmark Positioning）

- **Kicker**: 08 · 全景基準定位與公平比較
- **Title**: 放回學術版圖：純零樣本、接觸目標集與全監督上限
- **Core Takeaway**: 對照全監督上限與接觸目標原文之自訓練法，釐清「是否偷看目標資料集」是評估 ZSTC 公平性的關鍵分水嶺。
- **Core Bullets (2 條重點)**:
  - **公平性分水嶺**：Gera et al. (2022) 在 DBpedia 達 `0.945` 但需反覆使用目標集無標註文本；WC-SBERT 完全不碰目標原文，卻在 AG News（`0.847 > 0.814`）與 Yahoo（`0.649 > 0.620`）反超。
  - **標籤前處理小細節**：AG News 將 `Sci/Tech` 拆兩類映回、Yahoo 拆含 `&` 複合類、DBpedia 拆駝峰詞（如 `Education institution`），對齊自然語言分布。
- **Visual Spec (`table`)**:
  - 跨路線基準對照表（`<table>`，6 列）：
    - 欄位：`方法 / 模型`｜`設定條件（是否碰目標原文）`｜`AG News`｜`Yahoo`｜`DBpedia`
    - Row 1：`BERT Fully Finetuned (Ding 2022)`｜全監督上限（需完整標註集）｜`0.944`｜`0.753`｜`0.993`
    - Row 2：`Gera et al. (2022)`｜多輪迭代自訓練（**接觸目標原文**）｜`0.814`｜`0.620`｜**`0.945`**
    - Row 3：`Ding et al. (2022)`｜維基預訓練 BERT（純零樣本）｜`0.796`｜`0.573`｜`0.902`
    - Row 4：`Chi & Jang (2024, TIST)`｜原版 WC-SBERT（多輪＋Online Contrastive）｜`0.840`｜`0.638`｜`0.881`
    - Row 5：**`WC-SBERT (Chi 2025)`**｜剪枝＋GPT-4o 標籤＋單階段 MNR（**純零樣本**）｜**`0.847`**｜`0.649`｜`0.886`
    - Row 6：`Gemma 2 (Ollama, ZS / FS)`｜本地量化 LLM（`T=0`, JSON Schema）｜`0.817 / 0.832`｜**`0.659`**` / 0.654`｜`0.903 /` **`0.915`**
- **Citations**: `wiki/benchmarks/zstc-benchmarks.md` (§1–3), `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§4.1–4.2)
- **Speaker Notes**: 讀基準表時，教學上最需要提醒大家的一點是「永遠先看實驗條件，再看數字」。像第二列的 Gera (2022) 在 DBpedia 拿到驚人的 0.945，但它屬於 Transductive 自訓練，已經看過目標資料集的無標註全文；而 WC-SBERT 堅持完全不碰目標文本，依然在 AG News 與 Yahoo 上反超，且逼近全監督上限的八到九成表現。不過，讀完所有亮點後，作為嚴謹的工程師與研究者，我們必須切換到批判性視角：這篇論文有哪些限制與陷阱？
