# Static QA 驗證報告（`C3` — `qa_report.md`）

- **目標檔案**：`slides/2026-11-23-zero-shot-topic-classification-wc-sbert-vs-llm.html`
- **執行日期**：2026-11-23
- **執行指令**：`powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate-slides.ps1 -HtmlPath slides/2026-11-23-zero-shot-topic-classification-wc-sbert-vs-llm.html -ExpectedSlides 11`
- **最終結果**：**PASS（exit code 0｜0 Errors｜0 Warnings｜重試次數：0）**

---

## 整體指標摘要
- **總頁數**：`11 / 11`（與 H1 核准大綱一致）
- **非封面頁視覺比例**：**`100%`**（10/10 頁含 `<svg>`、`<table>`、`.chart-group` 或 `.stat-row`；門檻 ≥ 50%）
- **最長連續純文字頁數**：**`0`**（門檻 ≤ 2）
- **單頁 VisualUnits 範圍**：`112` – `402`（全數低於警示線 `440` 與上限 `520`）
- **離線與語法健康**：0 外部 CDN 連結、`<section>`/`<div>`/`<svg>` 標籤開閉平衡、全頁具備非空 `data-title` 與 `data-notes`、頁碼連續正確。

---

## 逐頁量測明細

| Slide | VisualUnits | Bullets | Visual | Notes | Title |
| :---: | :---: | :---: | :---: | :---: | :--- |
| 01 | 213 | 0 | Cover | OK | 封面：零樣本主題分類 WC-SBERT vs. 本地量化 LLM |
| 02 | 270 | 0 | Yes | OK | 問題動機：為什麼零樣本主題分類這麼難？ |
| 03 | 112 | 0 | Yes | OK | 全覽架構：WC-SBERT 兩階段全景 |
| 04 | 123 | 0 | Yes | OK | 支柱一：維基類別共現圖與 Zipf 度數剪枝 |
| 05 | 360 | 0 | Yes | OK | 逐層消融實驗：各階段技術貢獻拆解 |
| 06 | 402 | 0 | Yes | OK | 支柱二：GPT-4o 描述性標籤為何大勝全自動 APE？ |
| 07 | 119 | 0 | Yes | OK | 支柱三：離線 .npy 重用與單階段 MNR 自訓練 |
| 08 | 327 | 0 | Yes | OK | 正面對決：WC-SBERT vs. Ollama 本地量化 LLM |
| 09 | 397 | 0 | Yes | OK | 全景基準定位：純零樣本 vs. 接觸目標集 vs. 全監督 |
| 10 | 373 | 0 | Yes | OK | 批判性閱讀：四大實務限制與工程避坑 |
| 11 | 341 | 6 | Yes | OK | 總結與討論：工程選型清單與讀書會 Q&A |

---

## 警示項目（Warnings）
- 無（0 Errors、0 Warnings）。
