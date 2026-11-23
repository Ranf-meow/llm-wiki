# Slide 04 — Step 1 繁中 Chunking 與 0 Overlap

- **Kicker**: `03 · Step 1 — Data Pre-processing`
- **Title**: `繁中標點 Chunking：為何 overlap = 0 反而更準？`
- **Core Bullets**:
  - Recursive Splitter 補齊繁中全形標點斷點，避免句子腰斬。
  - LLM 取代 TF-IDF 抽 ~3 個關鍵字存 metadata（例：`性聯遺傳, POU3F4(DFNX2), 粒線體遺傳`）。
- **Visual Spec (`bar-chart` + `pill-row`)**:
  - 左卡：`pill-row` 展示 Table 4.2 斷點（`\n`, `\n\n`, `" "`, `.`, `,`, `\u200B`, `，`, `、`, `．`, `。`）＋ Fig. 3.2 關鍵字實例。
  - 右卡：`bar-chart` 展示 Table 4.4（`acge_text_embedding`，Top-5 皆 100%）Top-1 命中率：
    - `(512, 0)` Breeze **67.48%**（243 chunks）vs `(512, 100)` **57.20%**（265 chunks）
    - `(256, 0)` Breeze **62.89%**（458 chunks）vs `(256, 100)` **51.74%**（688 chunks）
    - `(512, 0)` TAIDE **64.82%**（對比 `(512, 100)` 57.14%）
- **Citations**: `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` (Table 4.2, 4.4)
- **Speaker Notes**: `進入 Stage 1 的第一個反直覺發現：大家做 RAG 常習慣設 overlap=100，但實測顯示配合全形標點斷點後，overlap=0 在兩款模型上都比 overlap=100 高出約 10 個百分點。原因在於重疊文字會讓相鄰 chunk 向量過於接近、干擾 Top-1 排名。切好段落並抽出關鍵字後，下一頁看怎麼用角色扮演量產問答。`
