# Evidence Pack（`N1: Wiki Retriever`）

- **簡報主題**：零樣本主題分類：WC-SBERT vs. 本地量化 LLM（戚得郁, 2025 教學精讀）
- **Slug**：`2026-11-23-zero-shot-topic-classification-wc-sbert-vs-llm`
- **受眾與目標**：課程學習者與讀書會成員（20 分鐘教學型簡報，約 11 頁）
- **檢索日期**：2026-11-23
- **C0 覆蓋度檢查**：**PASS**（4 篇高度關聯 Wiki 頁面，所有核心數據皆附完整實驗條件與批判備註）

---

## 1. 綁定 Wiki 來源清單
1. `wiki/papers/2025-chi-zero-shot-topic-classification.md` — 戚得郁 (2025) 台大資工博士論文（DOI: `10.6342/NTU202504846`）完整導讀、方法參數、消融表、本地 LLM 對比與批判觀察。
2. `wiki/concepts/wc-sbert-and-label-augmentation.md` — 三大核心支柱：維基類別共現圖與度數剪枝、GPT-4o 描述性標籤 vs. APE、免目標原文單階段 MNR 自訓練。
3. `wiki/benchmarks/zstc-benchmarks.md` — AG News / Yahoo! Answers / DBpedia-14 規格、前處理細節、全監督／迭代自訓練／純零樣本／本地量化 LLM 完整對照表。
4. `wiki/topics/llm-inference-efficiency-and-deployment.md` — 模型降維選型（WC-SBERT）與本地 4-bit Ollama 量化部署之推論效率與成本脈絡（連結陳冠錞 2025）。

---

## 2. 核心論點與關鍵數據（均附實驗條件）

### A. 問題定義與既有 ZSTC 三大痛點（來源：`2025-chi` §1、`zstc-benchmarks` §1-2）
- **情境**：零樣本主題分類（Zero-Shot Topic Classification, ZSTC）— 商業場景（新聞監控、文件歸檔）缺乏標註訓練資料且類別動態變動。
- **三大痛點**：
  1. **偽零樣本依賴**：既有迭代自訓練法（如 Gera et al., 2022）需接觸目標資料集無標註原文並多輪訓練，違反純零樣本情境且易累積錯誤。
  2. **單字標籤語意單薄**：直接編碼短標籤（如 `World`、`Artist`、`Building`）造成嵌入空間高度重疊（例：DBpedia 中 `Building` 有 `3,599` 筆誤分為 `Village`，`Artist` 與 `Album` 高度混淆）。
  3. **雲端 LLM 成本與隱私瓶頸**：面對數萬至數十萬筆分類任務（Yahoo `60,000` 筆、DBpedia `70,000` 筆），API 費用、延遲與資料外洩均受限。

### B. Stage 1：Wikipedia 類別共現圖 ＋ Degree-based Pruning（來源：`2025-chi` §3.1、`wc-sbert` §1）
- **基座模型與語料**：`all-mpnet-base-v2`；HuggingFace Wikipedia `6,458,670` 篇條目、爬蟲補齊 `1,563,194` 個類別，展開為 `187,720,848` 筆同頁類別正樣本對（MNR Loss，batch=128，max_len=128，lr=`2e-5`）。
- **長尾與維護標籤雜訊**：原始類別呈典型 Zipf 長尾（最大度數 `1,013,030`），夾雜無主題意義的編務類別（如 `Articles containing video clips`、`Use British English`）。
- **分層度數剪枝規則**：
  - 低頻（$d < 5$）：隨機抽 **20%**
  - 中頻（$5 \le d \le 500$）：**100% 保留**
  - 高頻（$d > 500$）：隨機抽 **2%**
- **剪枝統計與效益（Table 5.6）**：類別數 `1,563,194 → 989,730`（`-36.7%`）；最大度數 `1,013,030 → 23,467`；熵 `12.11 → 12.95`；語意覆蓋率維持 `0.9910`（相似度矩陣 Pearson $r = 0.9174$）；AG News 零樣本 Accuracy 從未剪枝 `0.695` 躍升至 **`0.749`（+7.8%）**（相較原始 SBERT `0.654` 提升 `+14.5%`）。

### C. 描述性標籤增強：GPT-4o 人工引導 vs. 全自動 APE（來源：`2025-chi` §3.2 & §4.1、`wc-sbert` §1）
- **三層演進（皆使用剪枝後 WC-SBERT，AG News / Yahoo / DBpedia Accuracy）**：
  - 原始單字標籤（`label only`）：`0.749` / `0.570` / `0.614`（Table 5.6, 5.8）
  - 手寫模板（`"This news article is about {label}"`）：`0.813` (+8.6%) / `0.622` (+9.2%) / `0.718` (+17.0%)（Table 5.8）
  - **GPT-4o 人工引導描述性標籤**：**`0.836`** (+2.8%) / **`0.643`** (+3.4%) / **`0.883`** (+23.0% 相對，+16.5 個百分點)（Table 5.13）
- **GPT-4o 提示設計三規則（Appendix A.1）**：① 強制所有類別一致句型前綴（例：`"This news article reports on ..."`）；② 15–30 字、客觀學術語氣；③ 明確要求類別間禁止重複關鍵措辭以拉開嵌入距離。
- **對決全自動 APE（AutoPrompt，兩階段 Ranking + Generation，GPT-4o `T=0.8` 各 5 步，Table 5.16）**：
  - AG News Accuracy：APE 僅 **`0.693`** vs. GPT-4o 引導 **`0.836`**（相差 14.3 個百分點）。
  - 失敗原因：APE 缺乏句型與目標語意約束，偏向產生抽象百科定義（例：`"World is a term that encompasses the entire planet Earth..."`）且各類句式不一，反而破壞 Bi-Encoder 嵌入空間穩定度。

### D. Stage 2：免目標原文單階段 MNR Loss 自訓練（來源：`2025-chi` §3.3 & §4.1、`wc-sbert` §1）
- **兩大改良（對比 ACM TIST 2024 原版）**：
  1. 預先將 `645 萬` 篇 Wiki 摘要編碼存成 `.npy`（可跨任務重用），以 $\cos(p, l) > t$ **單次**篩出高信心頁面建立三元組，**完全不接觸下游測試集原文**，省算力且避免多輪錯誤累積。
  2. 損失函數由 Online Contrastive Loss 改為 **MNR Loss**，三元組為 `(Anchor=Wiki 類別 c, Pos=最相似標籤 l+, Hard Neg=最不相似標籤 l-)`，批次內其他非正標籤自動為負樣本。
- **超參數**：Batch `256`、lr `2e-5`、3 epochs、FP16；閾值 $t$：AG News `0.77`、Yahoo `0.75`、DBpedia `0.77`。
- **最終表現（Table 5.18, 5.20）**：AG News **`0.847`** (+1.3%)、Yahoo **`0.649`** (+0.9%)、DBpedia **`0.886`** (+0.3%)，全面微幅超越原版 Chi & Jang (2024)（`0.840 / 0.638 / 0.881`）。

### E. WC-SBERT 正面對決本地量化 LLM 與跨路線對照（來源：`2025-chi` §3.4 & §4.2、`zstc-benchmarks` §3）
- **三大資料集規模與標籤前處理**：
  - AG News（`7,600` 筆，4 類；`Sci/Tech` 拆為 `Science` + `Technology` 映回）
  - Yahoo! Answers（`60,000` 筆，10 類；含 `&` 複合類拆為雙標籤映回）
  - DBpedia-14（`70,000` 筆，14 類；駝峰詞拆空白）
- **LLM 統一推論控制**：透過 **Ollama** 本地部署開源量化模型（Gemma 2、Llama 3.1、Llama 3.2）對比 GPT-4o mini；API 強制 `temperature = 0` ＋ **JSON Schema Format Control**（`{"label": <integer>}`）；Few-shot 範例由 GPT-4o 為每類預先生成 1 筆。
- **核心 Accuracy 數據（Table 5.19 & Table 5.2）**：
  - **WC-SBERT（Chi, 2025 最終版，純零樣本）**：AG News **`0.847`**（奪冠）｜Yahoo `0.649`｜DBpedia `0.886`
  - **Gemma 2（Ollama 本地量化，ZS / FS）**：AG News `0.817 / 0.832`｜Yahoo **`0.659`** `/ 0.654`｜DBpedia `0.903 /` **`0.915`**
  - **GPT-4o mini（API，ZS / FS）**：AG News `0.574 / 0.655`｜Yahoo `0.453 / 0.509`｜DBpedia `0.765 / 0.841`（高度依賴 Few-shot，+7.6%~+8.1%）
  - **Llama 3.1（Ollama，ZS / FS）**：AG News `0.673 / 0.680`｜Yahoo `0.528 / 0.572`｜DBpedia `0.707 / 0.761`
  - **Llama 3.2（Ollama，ZS / FS）**：AG News `0.532 / 0.601`｜Yahoo `0.425 / 0.461`｜DBpedia `0.592 / 0.649`（作者推測受小模型量化損失影響）
  - **其他基準參考**：
    - 全監督上限 BERT（Ding et al., 2022）：`0.944 / 0.753 / 0.993`
    - 全監督 SBERT Triplet+1NN（Chi, 2025）：`0.935 / 0.695 / 0.988`
    - 接觸目標原文自訓練 Gera et al. (2022)：`0.814 / 0.620 / 0.945`
    - 維基預訓練 BERT Ding et al. (2022)：`0.796 / 0.573 / 0.902`

### F. 批判性閱讀與實務避坑（來源：`2025-chi` §5、`llm-inference-efficiency` §2-3）
1. **Stage 2 邊際效益 vs. 真正功臣**：DBpedia 最大躍升來自 GPT-4o 標籤（`0.718 → 0.883`，+16.5 個百分點），Stage 2 自訓練僅微增 `+0.3%`（`0.883 → 0.886`），AG News 亦僅 `+1.1` 個百分點；實務上「剪枝預訓練＋GPT 標籤」已吃下九成以上紅利。
2. **Table 5.19 實驗規格缺漏**：未標明 Gemma 2 / Llama 3.1 / 3.2 具體參數量（如 9B/27B、8B/70B、1B/3B）與確切量化格式（`q4_0` vs `q4_K_M`），亦缺乏實測推論延遲（ms/sample）與能耗（J）對比（與陳冠錞 2025 互補）。
3. **手動閾值與勘誤細節**：閾值 $t$（0.75–0.77）仍需人工微調（尚未改為自動分位數）；Ch.6 p.80 寫 DBpedia 升 `18.5%` 與 Table 5.13 實測（絕對 +16.5 pp / 相對 +23.0%）略有出入。
4. **Bi-Encoder 本質邊界與混合路由機會**：對上下文高度交織的類別（如 `Building` 有 3,599 筆誤分為 `Village`）存在上限；作者建議未來結合 WC-SBERT（高信心秒回）＋ LLM（低 Margin 樣本複核）的 Hybrid Routing。

---

## 3. 讀書會討論題（來源：`2025-chi` §6）
1. 為什麼沒有目標分布錨定的全自動 APE（`0.693`）會慘敗給人工引導 GPT-4o 標籤（`0.836`）？
2. 若以 WC-SBERT Top-1 與 Top-2 相似度差值（Margin）當信心門檻、只將低信心樣本路由給 Gemma 2，能否同時兼顧 90%+ 準確率與毫秒級延遲？
3. DBpedia 中 `Building` 有 3,599 筆被誤分為 `Village`，這揭露了 Bi-Encoder 向量池化的什麼本質限制？
