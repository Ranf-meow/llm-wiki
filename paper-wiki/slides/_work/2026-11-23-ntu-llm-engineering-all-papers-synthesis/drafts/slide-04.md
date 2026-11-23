# Slide 04 — 論文①精要（吳葦誠 2024）

- **Kicker**: 03 · Layer 1 — Data Synthesis & RAFT Fine-Tuning
- **Title**: 吳葦誠 (2024)：封閉領域合成問答 ＋ Critique ＋ RAFT
- **Core Takeaway**: 面對 112 頁未公開繁中醫療 PDF，單用微調或純 RAG 皆幾乎無效，唯有過濾合成資料搭配 RAFT 開書微調才實現 F1 大幅躍升。
- **Visual Spec (`bar-chart` + `.card`)**:
  - 左欄（`.card.primary`）：**三段工程巧思**：
    - **標點斷點 Chunking**：含全形標點 `chunk=512, overlap=0`（Top-1 `0.6748` 完勝 `overlap=100` `0.5720`）。
    - **雙軌產題 ＋ 嚴格 Critique**：每 chunk 11 題、每題 3 答案；4 指標（各 ≥ 3、總分 ≥ 13），由 **TAIDE 生題 ＋ Breeze 嚴審**（通過率 36% vs TAIDE 84%）。
    - **RAFT 開書微調**：80%「1 正解 + 4 干擾」、20%「5 干擾」，QLoRA (`r=64`) 訓練。
  - 右欄（`.card.teal`）：**四設定消融長條圖（Table 4.9，台大耳科測試集 F1）**：
    - Vanilla Breeze（裸模型）：`0.3592`
    - 僅 Fine-tuned（無 RAG）：`0.3608`
    - 僅 RAG（無微調）：**`0.3471`**（反略降！）
    - **Fine-tuned ＋ RAG（RAFT）**：**`0.5556`**（+0.1964）
- **Citations**: `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` (§3–4, Tables 4.4 / 4.8 / 4.9)
- **Speaker Notes**: 第一層聚焦吳葦誠 (2024)。手邊只有 12 份未公開的台大耳科 PDF，既沒人標資料、小模型也沒讀過這些知識。他的關鍵發現非常震撼：右邊消融圖清楚顯示，在 7B 小模型上「只微調」幾乎沒進步，「只接 RAG」甚至因為 5 段檢索干擾而倒退；必須先用 TAIDE 生題、Breeze 嚴格審查濾出乾淨資料，再用 RAFT 開書格式教模型辨認哪段才是正解，F1 才一口氣從 0.359 衝上 0.556。但如果模型本身已經懂基礎醫學，還需要微調嗎？我們看第二層吳承光 (2024)。
