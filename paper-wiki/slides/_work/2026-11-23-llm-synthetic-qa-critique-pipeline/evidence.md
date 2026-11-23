# Evidence Pack — LLM 合成問答與 Critique 過濾管線

- **生成節點**：`N1: Wiki Retriever`
- **更新日期**：2026-11-23
- **C0 素材覆蓋度檢查**：`PASS`（涵蓋 1 篇核心論文頁、2 篇概念頁、1 篇主題綜述頁、2 篇公開基準頁；所有實驗數據均附完整實驗條件與批判備註）

---

## 1. 檢索來源清單
1. `wiki/concepts/llm-synthetic-qa-critique-pipeline.md` — 核心管線架構、角色扮演、四維度 Critique 門檻、異質分工與拒答雙面刃。
2. `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` — Wu (2024) NTU 碩論完整實驗設定、數據表（Table 4.2–4.10）、附錄 Prompt 實作落差與批判點。
3. `wiki/concepts/raft.md` — RAFT 開書考微調格式 `{P, C, Q, A}`、80%/20% 比例與 QLoRA 參數。
4. `wiki/topics/domain-specific-llm-adaptation.md` — TAPT、純 RAG、合成 SFT/Bonito 與 RAFT 四大路線比較。
5. `wiki/benchmarks/pubmedqa.md` & `wiki/benchmarks/privacyqa.md` — 英文公開基準數據與開書/閉書比較公平性警示。

---

## 2. 鎖定核心事實與實驗數據（含條件，供 Phase 2 Grounding 核對）

### A. 語料與系統背景
- **論文出處**：吳葦誠（Wei-Cheng Wu），指導教授周承復，NTU CSIE 碩士論文（2024 年 7 月），DOI：`10.6342/NTU202401905`。
- **封閉領域語料**：台大醫院耳鼻喉科未公開之繁體中文遺傳性聽力損失文件，**12 份 PDF，不含參考文獻共 112 頁**。
- **候選繁中模型**：**Breeze-7B** vs. **TAIDE-8B**（`taide/llama3-taide-lx-8b-chat-alpha1`）。
- **建置時間效益**：全自動資料集生成耗時約 **4–8 小時至不到 1 週**（對比專家人工標註需數週至數月）。

### B. 資料前處理與繁中 Chunking（Table 4.2 & 4.4）
- **切分器**：Recursive Text Splitter，繁中／英文斷點表包含：`\n`、`\n\n`、`" "`、`.`、`,`、`\u200B`（零寬空白）、`，`（`\uff0c`）、`、`（`\u3001`）、`．`（`\uff0e`）、`。`（`\u3002`）。
- **Embedding**：INTSIG `aspire/acge_text_embedding`（基於 Matryoshka Representation Learning）。
- **關鍵字抽取**：使用 LLM 為每個 chunk 抽出約 3 個關鍵字存為 metadata（Fig. 3.2 例：`性聯遺傳, POU3F4(DFNX2), 粒線體遺傳`）。
- **Chunk Size × Overlap 檢索命中率（Top-5 皆達 1.000）**：
  - `(256, 0)`：458 chunks｜Top-1 Breeze `0.6289`、TAIDE `0.5942`
  - `(256, 100)`：688 chunks｜Top-1 Breeze `0.5174`、TAIDE `0.5032`（原文筆誤 5032）
  - **`(512, 0)`**：243 chunks｜Top-1 **Breeze `0.6748`**、**TAIDE `0.6482`**
  - `(512, 100)`：265 chunks｜Top-1 Breeze `0.5720`、TAIDE `0.5714`

### C. 多角色生成與四維度 Critique 過濾（Sec. 3.2, 4.2, Table 4.5 & 4.6）
- **Question Generator**（扮演病患／資淺醫師）：整段 5 題 ＋ 關鍵字各 2 題 = **11 題 / chunk**。
- **Answer Generator**（扮演資深醫師）：純依該 chunk 每題產 **3 個候選答案**，`max_new_tokens = 600`。
- **Critique LLM（4 指標，1–5 分）**：
  - 指標：`Groundedness`、`Relevance`、`Standalone`（出現「在內文中」「在檔案中」強制 1 分）、`Similarity`（過濾複述題目之回答）。
  - 門檻：**四項皆 ≥ 3 分 且 總分 ≥ 13 / 20** 判定為 `Good Quality`。
  - 格式控管：強制輸出 `評分:` 與 `評估:`，解析失敗自動重試；速度與錯誤率：Breeze `3.259s/query`（`0.161%`）、TAIDE `4.280s/query`（`0.176%`）。
- **審查通過率差異（Table 4.6）**：
  - Critique = Breeze：Gen Breeze `35.73%`、Gen TAIDE `37.26%`（嚴格）
  - Critique = TAIDE：Gen Breeze `88.45%`、Gen TAIDE `79.91%`（寬鬆）
- **低品質回收拒答**：挑選部分 Low Quality 問題將答案改為「非常不好意思，目前沒辦法回答您的問題」混入訓練集。

### D. RAFT 微調與消融實驗（Sec. 3.3, Table 4.7–4.10）
- **RAFT 訓練設定**：格式 `{P, C, Q, A}`（訓練與推論 `P` 一致），每次 `top-k = 5` 段 chunks；**80%** 含 1 正解＋4 隨機干擾，**20%** 為 5 全干擾；**QLoRA** `rank = 64`、`max_seq_length = 1600`、Cross-Entropy Loss。
- **評估方式（封閉領域）**：醫師審定每題至多 3 個關鍵字計算 Precision/Recall/F1（全未中記 `FP = 1`），另以 `BAAI/bge-large-zh-v1.5` 算 Cosine Similarity。
- **8 組合冠軍（`TAIDE Gen + Breeze Critique + Breeze Final`）**：
  - 含低品質拒答樣本（Table 4.7）：P `0.6667` / R `0.3048` / **F1 `0.4184`** / Sim `74.32%`
  - 移除低品質拒答樣本（Table 4.8，全正例測試集）：**P `0.7931` / R `0.4275` / F1 `0.5556` / Sim `75.35%`**
  - 次佳對照（Table 4.8）：`Breeze/Breeze/Breeze` F1 `0.5327`；`Breeze/TAIDE/Breeze` F1 `0.5180`；`TAIDE/TAIDE/Breeze` F1 `0.5061`；`TAIDE/TAIDE/TAIDE` F1 `0.4171`。
- **四設定消融（Table 4.9，Breeze-7B，不含低品質樣本）**：
  - Vanilla Breeze：P `0.5650` / R `0.2577` / F1 `0.3592` / Sim `73.75%`
  - Breeze w/ Fine-tuned：P `0.5882` / R `0.2602` / F1 `0.3608` / Sim `74.13%`
  - Breeze w/ RAG：P `0.5726` / R `0.2491` / F1 `0.3471` / Sim `73.96%`
  - **Breeze w/ Fine-tuned & RAG**：**P `0.7931` / R `0.4275` / F1 `0.5556` / Sim `75.35%`**
- **英文公開基準（Table 4.10，Llama-2 + 英文 Prompt + RAG）**：
  - PubMedQA（Train 211,269 / Test 10,563，Yes/No F1）：TAPT `25.1` vs. Bonito `27.0` vs. Wu (2024) `95.6`
  - PrivacyQA（Train/Test 各 10,923，F1）：TAPT `42.0` vs. Bonito `56.9` vs. Wu (2024) `66.3`

### E. 必須保留的批判觀察（Pitfalls）
1. **Groundedness Prompt 漏餵 Answer**：內文 4.2.3 稱評答案，但附錄 Fig. A.1 實際僅餵入 `Question + Context`，復現時必須改為 `(Context, Q, A)`。
2. **小語料庫檢索偏差**：僅 112 頁（243–688 chunks）使 Top-5 輕鬆 100%，大規模部署需補 Hybrid Search / Reranker。
3. **關鍵字評估盲區與摘要落差**：摘要提人工評分與幻覺，第 4 章實際僅報關鍵字 F1 與語意相似度，無法偵測「中關鍵字但醫療邏輯錯誤」的幻覺。
4. **公開基準開書公平性**：PubMedQA `95.6` vs. Bonito `27.0` 需確認推論檢索條件是否對等。
