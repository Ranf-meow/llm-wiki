# Slide 08 — 實戰發現 ② 下游接 RAFT 綜效

- **Kicker**: `07 · Empirical Finding 2`
- **Title**: `下游接 RAFT：單用 RAG 或微調都沒用，合用才爆發`
- **Core Bullets**:
  - RAFT 訓練格式 `{P, C, Q, A}`（訓練與推論 `P` 一致；`top-k = 5`；QLoRA `r=64`、`max_seq_len=1600`）：
    - **80%** 樣本：`1 Oracle + 4 Distractors`（訓練抗干擾抓重點）
    - **20%** 樣本：`5 Distractors`（訓練檢索漏抓時的領域記憶）
- **Visual Spec (`bar-chart` + RAFT Card)**:
  - 左卡：RAFT 80/20 與 QLoRA 超參數精簡 4 條。
  - 右卡：`bar-chart` 展示 Table 4.9（Breeze-7B，不含低品質樣本）：
    - Vanilla Breeze：`F1 0.3592` (P `0.565`)
    - Fine-tuned only：`F1 0.3608` (P `0.588`)
    - RAG only：`F1 0.3471` (P `0.573`)
    - **Fine-tuned & RAG (RAFT)**：**`F1 0.5556`** (**P `0.793`**, **R `0.428`**, Sim `75.35%`)
- **Citations**: `wiki/concepts/raft.md`, `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` (Sec. 3.3, Table 4.9)
- **Speaker Notes**: `看右邊這張消融圖就能明白為什麼要大費周章做合成資料：對 7B 小模型而言，單接 RAG 反而因為 5 段雜訊上下文分心而略降；透過 RAFT 模擬開書考微調後，F1 一次拉升超過 0.19！接著看一個容易踩雷的設計：低品質問題回收轉拒答。`
