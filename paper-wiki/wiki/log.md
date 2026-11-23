# Paper LLM Wiki — 操作日誌（Log）

> 本頁為只追加（Append-Only）的時間序紀錄，格式為 `## [YYYY-MM-DD] <op> | <title>`。

## [2026-11-23] init | 建立 Paper LLM Wiki 骨架與 AGENTS.md
- **摘要**：依據課程學習與讀書會簡報需求，建立純 Markdown / GitHub 相容的論文 LLM Wiki 目錄結構、模板與四大工作流（Ingest / Query / Slide / Lint）。
- **影響檔案**：`AGENTS.md`、`README.md`、`wiki/index.md`、`wiki/log.md` 與各分類資料夾。

## [2026-11-23] ingest | Wu (2024) 基於大型語言模型自非結構化文件建立微調資料集
- **摘要**：完成第一篇論文（NTU 碩論，DOI: `10.6342/NTU202401905`）兩階段互動消化，重點聚焦工程實作之合成資料管線、繁中 Chunking 斷點、Prompt 設計與 RAFT/QLoRA 微調參數，並同步記錄批判觀察與實驗公平性備註。
- **影響檔案**：
  - 新增 `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md`
  - 新增 `wiki/concepts/raft.md`
  - 新增 `wiki/concepts/llm-synthetic-qa-critique-pipeline.md`
  - 新增 `wiki/benchmarks/pubmedqa.md`
  - 新增 `wiki/benchmarks/privacyqa.md`
  - 新增 `wiki/topics/domain-specific-llm-adaptation.md`
  - 更新 `wiki/index.md`、`wiki/log.md`

## [2026-11-23] slide | LLM 合成問答與 Critique 過濾管線（HTML 互動投影片）
- **摘要**：依據 Wiki 概念頁與論文導讀頁，製作 11 頁獨立可離線開啟的互動式 HTML 簡報（內含 SVG 流程圖、數據長條圖、講者筆記、全覽模式、深淺色切換與 PDF 匯出樣式），存放於 `slides/` 並補齊雙向連結。
- **影響檔案**：
  - 新增 `slides/2026-11-23-llm-synthetic-qa-critique-pipeline.html`
  - 更新 `wiki/index.md`、`wiki/log.md`、`wiki/concepts/llm-synthetic-qa-critique-pipeline.md`、`wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md`

## [2026-11-23] schema | 升級 Slide 工作流為 Map-Reduce StateGraph 與靜態 QA 腳本
- **摘要**：將簡報產出流程升級為具檔案化狀態（`slides/_work/<slug>/`）、單一人工確認點（H1 大綱合約）、階段二 Fan-out/Reduce 逐頁產出與跨頁整合、及階段三靜態驗證腳本（`scripts/validate-slides.ps1`）的 StateGraph 工作流，並獨立收納於 `workflows/slide-graph.md` 由 `AGENTS.md` 引用。
- **影響檔案**：
  - 新增 `workflows/slide-graph.md`、`scripts/validate-slides.ps1`
  - 更新 `AGENTS.md`、`README.md`、`wiki/log.md`

## [2026-11-23] slide | StateGraph 重建：LLM 合成問答與 Critique 過濾管線（C3 QA 0 警示通過）
- **摘要**：完整執行 `workflows/slide-graph.md`（Phase 0 證據包 → Phase 1 大綱與 H1 核准 → Phase 2 11 頁 Map-Reduce 並行草稿與連貫整合 → Phase 3 HTML 渲染與 `scripts/validate-slides.ps1` 實測 PASS）。非封面視覺比例由 70% 提升至 90%，單頁最大視覺寬度由 520 降至 333（0 錯誤、0 警示）。
- **影響檔案**：
  - 更新 `slides/2026-11-23-llm-synthetic-qa-critique-pipeline.html`
  - 新增 `slides/_work/2026-11-23-llm-synthetic-qa-critique-pipeline/`（`state.json`、`evidence.md`、`outline.md`、`drafts/slide-01.md`～`slide-11.md`、`deck_content.md`、`qa_report.md`）
  - 更新 `wiki/index.md`、`wiki/log.md`


## [2026-11-23] ingest | 批次收錄三篇台大論文（吳承光 2024、戚得郁 2025、陳冠錞 2025）
- **摘要**：完成使用者上傳 4 份 PDF 之去重（移除重複上傳之吳承光 2024）與三篇獨立台大碩博論文完整收錄（吳承光 2024 資工碩論 `10.6342/NTU202403801`、戚得郁 2025 資工博論 `10.6342/NTU202504846`、陳冠錞 2025 土木碩論 `10.6342/NTU202504158`），涵蓋醫療診斷推理與 Round-Robin 異質共享記憶、零樣本主題分類（WC-SBERT vs. 本地量化 LLM）、以及語意快取能耗權衡與效益反轉點；同步建立跨論文概念頁、第二主題頁並補齊全庫雙向連結（19 份檔案、0 斷鏈、0 Wikilinks）。
- **影響檔案**：
  - 新增 `wiki/papers/2024-wu-ck-llm-diagnostic-reasoning.md`、`wiki/papers/2025-chi-zero-shot-topic-classification.md`、`wiki/papers/2025-chen-semantic-caching-energy-tradeoff.md`
  - 新增 `wiki/concepts/diagnostic-reasoning-cot-and-shared-memory.md`、`wiki/concepts/wc-sbert-and-label-augmentation.md`、`wiki/concepts/semantic-caching-and-benefit-inversion.md`、`wiki/concepts/heterogeneous-multi-llm-collaboration.md`
  - 新增 `wiki/benchmarks/ddxplus.md`、`wiki/benchmarks/zstc-benchmarks.md`、`wiki/benchmarks/qqp-semantic-cache.md`
  - 新增 `wiki/topics/llm-inference-efficiency-and-deployment.md`
  - 更新 `wiki/topics/domain-specific-llm-adaptation.md`、`wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md`、`wiki/concepts/llm-synthetic-qa-critique-pipeline.md`、`wiki/index.md`、`wiki/log.md`


## [2026-11-23] slide | StateGraph 產出：零樣本主題分類：WC-SBERT vs. 本地量化 LLM（C3 QA 0 警示通過）
- **摘要**：完整執行 `workflows/slide-graph.md`（Phase 0 證據包 → Phase 1 大綱與 H1 核准 → Phase 2 11 頁 Map-Reduce 並行草稿與連貫整合 → Phase 3 離線 HTML 渲染與 `scripts/validate-slides.ps1` 實測 PASS）。非封面視覺比例 **100%**（3 張自繪 SVG、2 組分欄長條圖、2 張對照表、3 組統計指標列），單頁 VisualUnits `112–402`（0 錯誤、0 警示、0 重試）。
- **影響檔案**：
  - 新增 `slides/2026-11-23-zero-shot-topic-classification-wc-sbert-vs-llm.html`
  - 新增 `slides/_work/2026-11-23-zero-shot-topic-classification-wc-sbert-vs-llm/`（`state.json`、`evidence.md`、`outline.md`、`drafts/slide-01.md`～`slide-11.md`、`deck_content.md`、`qa_report.md`）
  - 更新 `wiki/index.md`、`wiki/log.md`、`wiki/papers/2025-chi-zero-shot-topic-classification.md`、`wiki/concepts/wc-sbert-and-label-augmentation.md`


## [2026-11-23] slide | StateGraph 產出：台大 LLM 工程實戰全景（全館 4 篇獨立論文統整，C3 QA 0 警示通過）
- **摘要**：完整執行 `workflows/slide-graph.md`（SHA256 去重確認 → Phase 0 全館證據包 → Phase 1 12 頁大綱與 H1 核准 → Phase 2 Map-Reduce 並行草稿與連貫整合 → Phase 3 離線 HTML 渲染與 `scripts/validate-slides.ps1` 實測 PASS）。非封面視覺比例 **100%**（3 張自繪 SVG、3 組消融/對決長條圖、2 張對照表、3 組統計指標列），單頁 VisualUnits `112–399`（0 錯誤、0 警示、0 重試）。
- **影響檔案**：
  - 新增 `slides/2026-11-23-ntu-llm-engineering-all-papers-synthesis.html`
  - 新增 `slides/_work/2026-11-23-ntu-llm-engineering-all-papers-synthesis/`（`state.json`、`evidence.md`、`outline.md`、`drafts/slide-01.md`～`slide-12.md`、`deck_content.md`、`qa_report.md`）
  - 更新 `wiki/index.md`、`wiki/log.md`、`wiki/topics/domain-specific-llm-adaptation.md`、`wiki/topics/llm-inference-efficiency-and-deployment.md`
