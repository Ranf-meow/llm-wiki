# Slide 07 — 教學核心四（Stage 2 MNR Self-Training）

- **Kicker**: 06 · 教學支柱三：免目標原文單階段自訓練
- **Title**: 離線 `.npy` 重用 ＋ 單階段 MNR 三元組如何取代多輪迭代？
- **Core Takeaway**: 預編碼 645 萬篇 Wiki 摘要配對 Hard Negative 三元組，一次微調即可完成任務適配，杜絕多輪錯誤累積。
- **Core Bullets (3 條)**:
  - **免接觸目標文本**：預先用 Stage 1 模型編碼 645 萬篇 Wiki 摘要存成 `.npy`，新任務只需算一次向量 Cosine 相似度即可重用。
  - **單次篩選 ＋ Hard Negative**：挑出 `cos(p, l) > t` 的高信心頁，建構三元組 `(Anchor=Wiki 類別 c, Pos=最相似標籤 l+, Hard Neg=最不相似標籤 l-)`。
  - **MNR Loss 效率優勢**：改用 Multiple Negatives Ranking Loss（Batch 256, lr `2e-5`, 3 epochs, FP16），批次內其餘非正樣本自動作為負樣本；閾值 `t` 為 `0.77 / 0.75 / 0.77`。
- **Visual Spec (`svg-diagram` + `.stat-row`)**:
  - Stage 2 單次三元組構建與 MNR 微調流程 SVG（viewBox `0 0 900 220`）：
    - 左側雙輸入：`預存 645萬篇 Wiki 摘要 (.npy)` ＋ `GPT-4o 描述性標籤向量` → `Cosine Similarity > t (0.75~0.77)` → `三元組 (Anchor c, Pos l+, Hard Neg l-)` → `MNR Loss (Batch 256, 3 epochs, FP16)` → `Task-Specific WC-SBERT`
    - 右下方註記對比框：`vs. 原版 Chi & Jang (2024)`：多輪迭代 + Online Contrastive → 單階段 + MNR，三基準全面微幅超越（`0.840→0.847`、`0.638→0.649`、`0.881→0.886`）。
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§3.3 & §4.1), `wiki/concepts/wc-sbert-and-label-augmentation.md` (§1)
- **Speaker Notes**: 很多同學會好奇：「自訓練不都需要拿目標資料集來生偽標籤嗎？」WC-SBERT 最巧妙的地方就是把 645 萬篇維基百科摘要當成「萬用代理語料」，事先離線編碼成 `.npy` 檔。每換一個新任務，只要拿目標標籤向量去跟 `.npy` 做內積篩選，單次組出含 Hard Negative 的三元組跑 3 個 epoch 就收工，既不碰測試集原文，也避免了多輪迭代越訓越歪的風險。接下來就進入最受關注的環節：這套輕量編碼器對上 Ollama 本地量化 LLM，誰會贏？
