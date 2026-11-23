# Slide 08 — 實驗對決一（WC-SBERT vs. Local Quantized LLM）

- **Kicker**: 07 · 核心實驗對決（Table 5.19）
- **Title**: 正面對決：WC-SBERT vs. Ollama 本地量化 LLM
- **Core Takeaway**: 在 `T=0` 與 JSON 格式控制下，輕量 WC-SBERT 在 AG News 奪冠（0.847），且跨三基準穩定度不輸最強本地 LLM。
- **Core Bullets (3 條解讀)**:
  - **統一嚴謹控制**：Ollama 本地模型與 GPT-4o mini 皆強制 `temperature = 0` ＋ JSON 整數輸出（`{"label": int}`）；Few-shot 為每類 1 筆 GPT-4o 生成範例。
  - **AG News 輕量奪冠**：WC-SBERT `0.847` 擊敗 Gemma 2（FS `0.832` / ZS `0.817`）與所有受測 LLM。
  - **LLM 內部落差懸殊**：Gemma 2 最穩（DBpedia `0.915`、Yahoo `0.659`）；GPT-4o mini 高度依賴 Few-shot（+7.6%~+8.1%）；Llama 3.2 掉點最嚴重（`0.532 / 0.425 / 0.592`）。
- **Visual Spec (`bar-chart`)**:
  - 三基準分組水平長條圖（`.grid-3` 內嵌 `.chart-group`，標註各模型最佳設定 Accuracy）：
    - AG News：WC-SBERT **`0.847`**｜Gemma 2 (FS) `0.832`｜Llama 3.1 (FS) `0.680`｜GPT-4o mini (FS) `0.655`｜Llama 3.2 (FS) `0.601`
    - Yahoo! Answers：Gemma 2 (ZS) **`0.659`**｜WC-SBERT `0.649`｜Llama 3.1 (FS) `0.572`｜GPT-4o mini (FS) `0.509`｜Llama 3.2 (FS) `0.461`
    - DBpedia-14：Gemma 2 (FS) **`0.915`**｜WC-SBERT `0.886`｜GPT-4o mini (FS) `0.841`｜Llama 3.1 (FS) `0.761`｜Llama 3.2 (FS) `0.649`
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§3.4 & §4.2, Table 5.19), `wiki/benchmarks/zstc-benchmarks.md` (§3)
- **Speaker Notes**: 這張表是整場簡報的焦點。作者透過 Ollama 在本地部署開源量化模型，並加上 `temperature=0` 與 JSON 整數格式鎖定，確保輸出乾淨可比。結果非常有意思：千萬別以為「隨便換個 LLM 就會碾壓 BERT」！在 AG News 上，輕量 WC-SBERT 以 0.847 擊敗所有受測 LLM；在 Yahoo 與 DBpedia 上，也只微幅落後表現最強的 Gemma 2，並大幅領先 Llama 3.1、Llama 3.2 甚至統一 Prompt 下的 GPT-4o mini。接下來我們把視野拉更寬，放進整個 ZSTC 學術版圖來定位。
