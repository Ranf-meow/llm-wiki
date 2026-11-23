# Evidence Pack（`N1: Wiki Retriever` — 全館跨論文統整）

- **簡報主題**：台大 LLM 工程實戰全景：從資料合成微調、診斷推理到推論降本減碳（全館 4 篇獨立碩博論文教學統整）
- **Slug**：`2026-11-23-ntu-llm-engineering-all-papers-synthesis`
- **受眾與目標**：課程學習者與讀書會成員（25 分鐘跨論文教學總覽，12 頁）
- **檢索日期**：2026-11-23
- **去重稽核備註**：使用者歷次共上傳 5 份 PDF，經 SHA256 比對 `ntu-112-2_(1).pdf` 與 `ntu-112-2_(2).pdf` 雜湊完全相同（`A35FC9D0...88D`，1,705,417 bytes，皆為吳承光 2024），故實際收錄 **4 篇獨立論文**。
- **C0 覆蓋度檢查**：**PASS**（涵蓋全館 4 篇論文頁、2 篇主題綜述頁、5 篇核心概念頁、5 篇基準頁，所有數字均附實驗條件）

---

## 1. 綁定 Wiki 來源清單
1. `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md`（吳葦誠 2024，台大資工碩論，`10.6342/NTU202401905`）
2. `wiki/papers/2024-wu-ck-llm-diagnostic-reasoning.md`（吳承光 2024，台大資工碩論，`10.6342/NTU202403801`）
3. `wiki/papers/2025-chi-zero-shot-topic-classification.md`（戚得郁 2025，台大資工博論，`10.6342/NTU202504846`）
4. `wiki/papers/2025-chen-semantic-caching-energy-tradeoff.md`（陳冠錞 2025，台大土木碩論，`10.6342/NTU202504158`）
5. `wiki/topics/domain-specific-llm-adaptation.md`、`wiki/topics/llm-inference-efficiency-and-deployment.md`
6. `wiki/concepts/heterogeneous-multi-llm-collaboration.md`、`wiki/concepts/semantic-caching-and-benefit-inversion.md`、`wiki/concepts/wc-sbert-and-label-augmentation.md`、`wiki/concepts/llm-synthetic-qa-critique-pipeline.md`

---

## 2. 四篇論文核心機制與關鍵實測數據（均附條件）

### 論文①：吳葦誠 (2024) — 封閉領域合成資料 ＋ RAFT 開書微調（Layer 1：資料與權重層）
- **核心問題**：台大醫院耳科 12 份未公開繁中 PDF（112 頁）不在預訓練語料中，人工標註太慢。
- **核心方法**：繁中標點 Recursive Splitter（`chunk=512, overlap=0` Top-1 `0.6748` 全面勝 `overlap=100` `0.5720`）→ LLM 抽關鍵字雙軌產題（11 題/chunk）→ 四指標 Critique 過濾（各 ≥ 3、總分 ≥ 13）→ RAFT 開書格式（80% 1 正解+4 干擾、20% 5 干擾）＋ QLoRA (`r=64`)。
- **關鍵實驗數據（台大耳科測試集，不含低品質拒答樣本，Table 4.8–4.9）**：
  - 異質最佳組合：`TAIDE-8B (Gen) + Breeze-7B (Critique 通過率 36% vs TAIDE 84%) + Breeze-7B (Final)` 奪冠（F1 **`0.5556`**）。
  - 四設定消融：Vanilla Breeze `0.3592`｜僅微調 `0.3608`｜僅 RAG **`0.3471`**（反而略降！）｜**微調 + RAG（RAFT）`0.5556`**（+0.196）。
  - 英文公開基準：PubMedQA `95.6` F1、PrivacyQA `66.3` F1（對比 TAPT/Bonito 需註記開書條件差異）。
- **批判要點**：Appendix A.1.2 Groundedness Prompt 實際只審 `Q + Context` 未審 `Answer`；加入拒答樣本令全正例 F1 從 `0.5556` 降至 `0.4184`；摘要稱人工評估幻覺但第 4 章未列人工評分表。

### 論文②：吳承光 (2024) — 免微調臨床診斷 CoT ＋ 異質多代理共享記憶（Layer 2：推理與記憶層）
- **核心問題**：不改 LLM 權重，能否激發醫療問診（資訊蒐集）與診斷預測能力，並在串流環境持續自我進化？
- **核心方法**：① LLM 標準化病人多輪問診框架（最多 8 輪）；② Zero-Shot JSON 臨床模板 **`ZS-DRCoT`**（陽性表現、陰性表現、排序鑑別診斷、下一步提問）；③ **Round-Robin Multi-Agent Memory**（GPT-3.5 / Gemini-1.0 / Claude-3-Haiku 輪詢看診，維持 **$O(1)$** 成本，僅答對 `fb=1` 時寫入 `bge-base-en-v1.5` 共享記憶庫）。
- **關鍵實驗數據（DDXPlus，49 種診斷）**：
  - 資訊蒐集（Ch.4, Table 4.1）：5 大 LLM 平均由 `19.63%` 升至 **`25.10%`**（+5.48% / 相對 +28.39%）；移除陽性表現暴跌 `-7.67%`。
  - 診斷預測（Ch.5, Table 5.1）：Non-streaming Baseline `52.85%` → `ZS-DRCoT` `58.20%` → Streaming Baseline + Single Memory `70.56%` → Streaming `ZS-DRCoT` + Single Memory `80.27%` → **Streaming `ZS-DRCoT` + Multi-Agent Memory `90.48%`**。
- **批判要點**：高歧義主訴「呼吸困難（Shortness of breath）」下 `ZS-DRCoT` 反而**負遷移 `-2.20%`**（Llama3 降 `-10.50%`）；假設每次看診結束皆可即時取得黃金標籤 `fb_t ∈ {0, 1}`。

### 論文③：戚得郁 (2025) — 零樣本主題分類：WC-SBERT vs. 本地量化 LLM（Layer 3：模型降維與選型層）
- **核心問題**：無標註且類別動態變動的主題分類，一定要用昂貴 LLM 嗎？優化後的輕量 SBERT 能否抗衡本地量化 LLM？
- **核心方法**：① 維基 645 萬頁 / 156 萬類共現圖 ＋ **度數區間剪枝**（低頻 20% / 中頻 `5≤d≤500` 100% / 高頻 2%，-36.7% 類別保 0.9910 語意，AG News `+7.8%`）；② **GPT-4o 人工引導描述性標籤**（統一前綴、15–30 字、跨類去重，DBpedia `0.718 → 0.883` 相對 +23.0%，大勝全自動 APE `0.693`）；③ 離線 `.npy` 單階段 MNR 自訓練（0 筆目標原文）。
- **關鍵實驗數據（Table 5.19，Ollama `T=0` + JSON integer schema）**：
  - AG News：**WC-SBERT `0.847`**（奪冠）> Gemma 2 FS `0.832` > Llama 3.1 FS `0.680` > GPT-4o mini FS `0.655` > Llama 3.2 FS `0.601`。
  - Yahoo! Answers：Gemma 2 ZS `0.659` > WC-SBERT `0.649`。
  - DBpedia-14：Gemma 2 FS `0.915` > WC-SBERT `0.886` > GPT-4o mini FS `0.841`。
- **批判要點**：Stage 2 邊際增益僅 `+0.3%`～`+1.3%`；Table 5.19 漏標本地 LLM 參數量、量化後綴與實測延遲/功耗；DBpedia 有 `3,599` 筆 `Building` 誤分為 `Village`。

### 論文④：陳冠錞 (2025) — 語意快取能耗與「效益反轉點」（Layer 4：推論部署與綠能層）
- **核心問題**：推論佔 AI 雲端運算 80–90%，裝上語意快取（GPTCache）究竟省多少焦耳？相似度閾值如何影響總能耗？
- **核心方法**：GKE 單節點（NVIDIA T4 + Ollama 4-bit Mistral-7B + GPTCache + pgvector）＋ Kepler（CPU/DRAM）＋ NVIDIA DCGM（GPU）全棧能耗觀測；QQP 30,141 組重複問句對，10 分鐘 k6 壓測每組重複 5 次並重建 K8s（Clean Slate）。
- **關鍵實驗數據（Table 4.1）**：
  - 無快取 Baseline：`30,294 ms`｜`155.88 W`｜`93,256.2 J`
  - **`0.75`（最佳節能點）**：Hit `99.99%`｜`108.2 ms`（快 280 倍）｜`87.48 W`｜**`52,486.8 J`（-43.7%）**
  - `0.80`（臨界前緣）：Hit `99.30%`（僅降 0.69%）｜能耗驟升 +21 kJ 至 `73,488.6 J`
  - **`0.85`（效益反轉峰值）**：Hit `87.30%`｜`4,634.7 ms`｜`175.22 W`｜**`105,130.2 J`（+12.7% 寄生開銷！）**
- **批判要點**：QQP 壓測 100% 為重複問句（無負例、未測 False Positive 答錯率）；摘要誤將 `105,130 J` 標為 `0.95`（實測表為 `0.85`）；未正規化為每請求焦耳數（J/query）。

---

## 3. 跨論文收斂的三大教學軸線
1. **異質多模型協作紅利（免費升級）**：吳葦誠（離線 TAIDE 生題 + Breeze 嚴審）與吳承光（線上三家 LLM 輪詢共享記憶，成本 $O(1)$）雙篇證實混搭勝單一模型。
2. **結構化格式控制 ＋ 領域約束勝過盲目全自動**：四篇共同驗證（`評分:/評估:`、JSON `ZS-DRCoT`、JSON integer schema、`GPT-4o` 三規則勝全自動 APE）。
3. **四篇合體的下一代混合系統藍圖**：`WC-SBERT` 前置意圖分類 → 依風險分派差異化閾值之 `GPTCache` 語意快取 → 高難度請求依情境路由至 `RAFT` 專家小模型或 `ZS-DRCoT` 異質共享記憶推理。
