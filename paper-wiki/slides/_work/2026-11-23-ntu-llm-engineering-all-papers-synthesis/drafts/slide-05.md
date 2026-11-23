# Slide 05 — 論文②精要（吳承光 2024）

- **Kicker**: 04 · Layer 2 — Zero-Shot CoT & Shared Memory
- **Title**: 吳承光 (2024)：免微調臨床診斷 `ZS-DRCoT` ＋ 共享記憶
- **Core Takeaway**: 不動任何模型權重，單靠結構化 JSON 臨床思維鏈與 O(1) 輪詢異質共享記憶，即在 DDXPlus 將診斷準確率由 52.85% 推升至 90.48%。
- **Visual Spec (`bar-chart` + `.card`)**:
  - 左欄（`.card.teal`）：**免微調三部曲**：
    - **標準化病人模擬**：Doctor LLM 與 Patient LLM 自然語言多輪問診（最多 8 輪），評估資訊蒐集效率。
    - **Zero-Shot JSON `ZS-DRCoT`**：強制輸出「陽性表現 / 陰性表現 / 排序鑑別診斷 / 下一步提問」，5 模型問診均升 +5.48%（相對 +28.4%）。
    - **Round-Robin 共享記憶**：GPT-3.5 / Gemini-1.0 / Claude-3-Haiku 輪流看診（$O(1)$ 成本），僅答對（`fb=1`）時寫入 `bge-base-en-v1.5` 共享庫。
  - 右欄（`.card.primary`）：**DDXPlus 串流診斷躍升長條圖（Table 5.1，三模型平均）**：
    - Non-streaming Baseline：`52.85%`
    - Non-streaming `ZS-DRCoT`：`58.20%`
    - Streaming Baseline + Single Memory：`70.56%`
    - Streaming `ZS-DRCoT` + Single Memory：`80.27%`
    - **Streaming `ZS-DRCoT` + Multi-Agent Memory**：**`90.48%`**
- **Citations**: `wiki/papers/2024-wu-ck-llm-diagnostic-reasoning.md` (§3–4, Tables 4.1 / 5.1)
- **Speaker Notes**: 同樣是 2024 台大資工的醫療論文，吳承光走了完全不同的路：既然通用 LLM 已經內建基礎醫學知識，那就不改權重！他把醫師看診邏輯寫成四欄位的 JSON `ZS-DRCoT`，並設計了一套極聰明的 Round-Robin 共享記憶——三家異質模型輪流接單，所以每次推論成本跟單模型一樣是 O(1)，但只要誰答對就把推理過程存進共用記憶庫讓大家互相學習，準確率從 52.85% 一路衝到 90.48%。接著看第三層：面對大規模分類，我們連生成式 LLM 都不一定要用。
