# Slide 03 — 全覽對照表（Overview Matrix）

- **Kicker**: 02 · Four-Paper Comparison Matrix
- **Title**: 四篇論文定位、核心方法與代表戰績總表
- **Core Takeaway**: 一次對照各篇任務情境、是否更動模型權重、關鍵技術與實測指標，建立跨論文比較座標。
- **Visual Spec (`table`)**:
  - 4 列跨論文總表（`<table>`）：
    - 欄位：`論文與層級`｜`目標任務與場景`｜`改權重？`｜`核心工程突破`｜`代表實測戰績`
    - Row 1：`吳葦誠 (2024) L1`｜繁中封閉耳科問答（12 份 PDF）｜QLoRA (`r=64`)｜Chunk 512/0 ＋ 4 指標 Critique ＋ RAFT｜Breeze F1 `0.359 → 0.556`
    - Row 2：`吳承光 (2024) L2`｜臨床問診與鑑別診斷（DDXPlus）｜**否（純 ICL）**｜JSON `ZS-DRCoT` ＋ Round-Robin 共享記憶｜診斷 `52.85% → 90.48%`（$O(1)$）
    - Row 3：`戚得郁 (2025) L3`｜零樣本主題分類（3 大基準）｜僅輕量 SBERT｜維基度數剪枝 ＋ GPT-4o 標籤 ＋ 單階段 MNR｜AG News `0.847`（勝所有 LLM）
    - Row 4：`陳冠錞 (2025) L4`｜雲端 FAQ 推論節能（GKE T4）｜**否（快取層）**｜GPTCache ＋ Kepler/DCGM 整機焦耳量測｜`0.75` 省電 -43.7%｜`0.85` 反增 +12.7%
- **Callout (teal)**: 觀察第三欄「改權重？」：只有處理**未公開封閉小語料＋7B 小模型**時才真的需要 QLoRA 微調，其餘三層皆靠推理結構、輕量替代或快取架構取得突破。
- **Citations**: `wiki/papers/2024-wu-*.md`, `wiki/papers/2024-wu-ck-*.md`, `wiki/papers/2025-chi-*.md`, `wiki/papers/2025-chen-*.md`
- **Speaker Notes**: 這張表是整場的速查地圖。特別提醒大家看中間那欄「是否改權重」：這四篇涵蓋了 QLoRA 微調、純 In-Context 推理、輕量編碼器預訓練以及不改模型的推論快取層。接下來四頁，我們用每頁約兩分半的節奏，逐一拆解每一篇最核心的技術巧思與數據證據，先從第一層吳葦誠 (2024) 開始。
