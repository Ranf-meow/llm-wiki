# Slide 03 — 全覽架構（Architecture）

- **Kicker**: 02 · 系統全景
- **Title**: WC-SBERT 兩階段架構：全程不碰目標測試集原文
- **Core Takeaway**: 先以剪枝後的維基類別圖譜預訓練，再用 GPT-4o 擴寫標籤搭配離線 `.npy` 維基摘要單次自訓練，實現真正零樣本。
- **Core Bullets (3 條精簡重點)**:
  - **Stage 1（通用預訓練）**：在 `all-mpnet-base-v2` 上以剪枝後維基類別共現對訓練主題語意空間。
  - **標籤語意擴增**：用 GPT-4o 把短標籤改寫為結構一致的描述句，拉開類別嵌入距離。
  - **Stage 2（免目標原文自訓練）**：重用離線預編碼的 645 萬篇 Wiki 摘要 `.npy`，單次微調即完成任務適配。
- **Visual Spec (`svg-diagram`)**:
  - 寬幅兩階段流程 SVG（viewBox `0 0 920 270`）：
    - 左群組（Stage 1 通用預訓練）：`Wiki 645萬頁 / 156萬類` → `度數區間剪枝 (-36.7%)` → `MNR Loss 預訓練 (all-mpnet-base-v2)` → `通用 WC-SBERT`
    - 中繼資產節點：`離線編碼 645萬篇 Wiki 摘要 (.npy 可跨任務重用)`
    - 右群組（Stage 2 任務適配）：`目標標籤` → `GPT-4o 描述性標籤` → `Cosine 篩選 (> t) + Hard Neg 三元組` → `單階段 MNR 微調 (3 epochs)` → `Task-Specific WC-SBERT`
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§3), `wiki/concepts/wc-sbert-and-label-augmentation.md` (§1)
- **Speaker Notes**: 這張圖就是整篇論文的骨架。請特別留意虛線區隔的兩個階段：左邊 Stage 1 只需要做一次，透過維基百科的類別共現關係教會輕量模型懂「主題分類」；右邊 Stage 2 在迎接全新任務時，完全不需要拿到任何一筆目標資料集文本，而是把目標標籤擴寫成描述句後，直接拿離線存好的維基摘要向量來做單次自訓練。接著我們逐一拆解其中最具教學價值的三個關鍵設計，先從 Stage 1 的剪枝開始。
