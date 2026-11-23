# Slide 10 — 批判性閱讀與工程避坑（Critical Reading）

- **Kicker**: 09 · 批判閱讀與實務避坑
- **Title**: 讀論文不能只看亮點：四大實務限制與檢視要點
- **Core Takeaway**: 實務導入前須看清四件事：Stage 2 邊際效益極小、本地 LLM 規格與延遲缺漏、閾值仍需手調，以及 Bi-Encoder 語意混淆上限。
- **Core Bullets (4 張批判卡片 `.grid-2`)**:
  - **避坑① Stage 2 邊際效益有限**：DBpedia 靠 GPT-4o 標籤大漲 +16.5 pp（`0.718→0.883`），但整個 Stage 2 自訓練僅微增 `+0.3%`（`0.883→0.886`）；實務 MVP 可先省去 Stage 2。
  - **避坑② 量化規格與推論延遲缺漏**：Table 5.19 未標明 Gemma 2 / Llama 的確切參數量與量化後綴（`q4_0` vs `q4_K_M`），亦缺實測延遲（ms）與耗電（J）數據。
  - **避坑③ 手動閾值與細節勘誤**：Stage 2 閾值 `t`（0.75–0.77）仍靠人工微調，尚未自動化為分位數門檻；另 Ch.6 p.80 寫 DBpedia 升 18.5%，與 Table 5.13 實測（+16.5 pp / 相對 +23.0%）略有出入。
  - **避坑④ Bi-Encoder 語意混淆上限**：DBpedia 有 `3,599` 筆 `Building` 誤分為 `Village`（建築簡介常提所在村莊），反映向量平均池化難以區分「主體 vs. 背景」。
- **Visual Spec (`cards` + `.stat-row`)**:
  - 4 張 2×2 警示卡片（`.grid-2`，分別搭配 amber / rose / primary / teal 上邊條強調）。
  - 底部精簡對照提示（`.callout.amber`）：對照本 Wiki 收錄之陳冠錞 (2025) 語意快取能耗量測，可補齊本篇缺少的「延遲與能耗」維度。
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§5), `wiki/topics/llm-inference-efficiency-and-deployment.md` (§2–3)
- **Speaker Notes**: 真正會讀論文的人，不會只背結論數字，還會看實驗表的邊界與漏網之魚。這裡整理四個最關鍵的批判觀察：第一，做商業 PoC 時，光是剪枝預訓練加 GPT-4o 描述性標籤就拿了九成以上紅利，不一定要急著做 Stage 2；第二，Table 5.19 沒有寫明本地 LLM 的參數量、量化格式與實際推論毫秒數，這也是論文最可惜的缺口；第三，閾值 t 還得人工調，且正文與表格有一處百分比勘誤；第四，Building 誤判成 Village 提醒我們 Bi-Encoder 很難區分主體與背景詞。最後一頁，我們把這些洞見收斂成一套可直接帶走的工程決策清單。
