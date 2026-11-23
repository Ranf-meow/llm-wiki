# Slide 03 — 端到端架構總覽

- **Kicker**: `02 · End-to-End Architecture`
- **Title**: `三階段模組化流水線：從 PDF 到開書考模型`
- **Core Bullets**:
  - 3 個底部數據摘要卡：`3 大可替換 LLM 模組`、`33 組候選 Q&A / Chunk (11 題×3 答)`、`4 小時～<1 週自動化建置`。
- **Visual Spec (`svg-diagram`)**:
  - 內嵌 3 區塊水平 SVG 流程圖（viewBox `0 0 1080 310`）：
    - `STAGE 1 前處理`：PDF → Recursive Splitter `(512, 0)` → LLM 抽 Keywords ＋ `acge_text_embedding` → Vector DB
    - `STAGE 2 合成與過濾`：Question Gen（11 題）→ Answer Gen（3 答）→ Critique LLM（4 指標各≥3 且總分≥13）→ Good Quality / Low Quality（轉拒答）
    - `STAGE 3 RAFT 微調`：組裝 `{P, C, Q, A}`（80% 含正解 / 20% 純干擾）→ QLoRA (`r=64`) Final LLM ＋ Top-5 RAG 推論
- **Citations**: `wiki/concepts/llm-synthetic-qa-critique-pipeline.md`, `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md`
- **Speaker Notes**: `看完動機，這張架構圖是接下來每一頁的地圖。整套管線分成前處理、合成與審查、以及 RAFT 微調三個階段，最大特色是完全模組化——裡面的開源 LLM 都能各自獨立替換。接下來我們從 Stage 1 的繁中 Chunking 細節切入。`
