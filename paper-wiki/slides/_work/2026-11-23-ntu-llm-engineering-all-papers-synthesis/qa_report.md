# Static QA 驗證報告（`C3` — `qa_report.md`）

- **目標檔案**：`slides/2026-11-23-ntu-llm-engineering-all-papers-synthesis.html`
- **執行日期**：2026-11-23
- **執行指令**：`powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate-slides.ps1 -HtmlPath slides/2026-11-23-ntu-llm-engineering-all-papers-synthesis.html -ExpectedSlides 12`
- **最終結果**：**PASS（exit code 0｜0 Errors｜0 Warnings｜重試次數：0）**

---

## 整體指標摘要
- **總頁數**：`12 / 12`（與 H1 核准大綱一致）
- **非封面頁視覺比例**：**`100%`**（11/11 頁含 `<svg>`、`<table>`、`.chart-group` 或 `.stat-row`；門檻 ≥ 50%）
- **最長連續純文字頁數**：**`0`**（門檻 ≤ 2）
- **單頁 VisualUnits 範圍**：`112` – `399`（全數低於 400，遠低於警示線 `440` 與上限 `520`）
- **離線與語法健康**：0 外部 CDN 連結、`<section>`/`<div>`/`<svg>` 標籤開閉平衡、全頁具備非空 `data-title` 與 `data-notes`、頁碼連續正確。

---

## 逐頁量測明細

| Slide | VisualUnits | Bullets | Visual | Notes | Title |
| :---: | :---: | :---: | :---: | :---: | :--- |
| 01 | 216 | 0 | Cover | OK | 封面：台大 LLM 工程實戰全景（4 篇統整） |
| 02 | 112 | 0 | Yes | OK | 全景地圖：四篇論文拼出 LLM 工程生命週期 |
| 03 | 365 | 0 | Yes | OK | 全覽總表：四篇論文定位、方法與代表戰績 |
| 04 | 358 | 3 | Yes | OK | Layer 1：吳葦誠 (2024) 合成 Q&A ＋ Critique ＋ RAFT |
| 05 | 335 | 3 | Yes | OK | Layer 2：吳承光 (2024) ZS-DRCoT ＋ 異質共享記憶 |
| 06 | 364 | 3 | Yes | OK | Layer 3：戚得郁 (2025) WC-SBERT vs. 本地量化 LLM |
| 07 | 128 | 0 | Yes | OK | Layer 4：陳冠錞 (2025) 語意快取與效益反轉點 |
| 08 | 343 | 0 | Yes | OK | 跨論文法則一：低成本的異質多模型互補紅利 |
| 09 | 277 | 0 | Yes | OK | 跨論文法則二：結構化 Schema 與領域約束勝過黑箱自動 |
| 10 | 376 | 0 | Yes | OK | 批判性閱讀總複盤：四篇論文的陷阱與實驗盲區 |
| 11 | 120 | 0 | Yes | OK | 終極整合藍圖：四篇合體的混合 LLM 系統架構 |
| 12 | 399 | 7 | Yes | OK | 總結與討論：實戰選型清單與跨論文 Q&A |

---

## 備註與警示（Warnings）
- 靜態 QA 程式檢查：0 Errors、0 Warnings。
- 資料範疇備註：使用者歷次上傳之 5 份 PDF 經 SHA256 去重後為 4 篇獨立台大碩博論文，已於 H1 獲使用者核准涵蓋全館 4 篇論文製作統整簡報。
