# Slide 02 — 問題動機（Motivation）

- **Kicker**: 01 · 問題定義與痛點
- **Title**: 為什麼「零樣本主題分類（ZSTC）」這麼難？
- **Core Takeaway**: 無標註且類別動態變動下，既有迭代自訓練違背純零樣本、短標籤歧義嚴重、雲端 LLM 成本過高。
- **Core Bullets (3 cards)**:
  - **痛點① 偽零樣本依賴**：既有自訓練法（如 Gera et al., 2022）需接觸目標集無標註原文並多輪訓練，既違背純零樣本，又容易累積錯誤。
  - **痛點② 單字標籤語意單薄**：Bi-Encoder 直接編碼 `World`、`Artist`、`Building` 等短字易重疊（如 DBpedia 有 3,599 筆 `Building` 誤分為 `Village`）。
  - **痛點③ 雲端 LLM 成本與隱私**：面對 6 萬～7 萬筆商業分類流（Yahoo / DBpedia），呼叫外部 API 的延遲、費用與資料外洩皆成瓶頸。
- **Visual Spec (`cards` + `.stat-row`)**:
  - 上方 3 張並排痛點卡片（`.grid-3`），每張含圖示編號與 1 句核心解釋。
  - 下方 3 枚任務規模指標（`.stat-row`）：AG News `7,600` 筆（4 類）、Yahoo! Answers `60,000` 筆（10 類）、DBpedia-14 `70,000` 筆（14 類）。
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§1), `wiki/benchmarks/zstc-benchmarks.md` (§1–2)
- **Speaker Notes**: 真實世界的新聞監控或文件自動歸檔，經常沒有時間標註訓練資料，而且分類體系還會隨時增減。過去有三條路都各有硬傷：第一，迭代自訓練其實偷看了目標資料集的無標註文本；第二，直接用 SBERT 算單字標籤相似度，光是在 DBpedia 就有 3,599 筆 Building 被誤判成 Village；第三，全丟給雲端 LLM 面對數萬筆文本根本吃不消。這就是 Chi (2025) 提出新一代 WC-SBERT 的出發點，接下來看整體架構怎麼一次拆解這三個難題。
